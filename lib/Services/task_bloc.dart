import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myknott/models/lead.dart';

enum ViewAction { fetch }

class LeadsBloc {
  final _stateStreamController = StreamController<List<Lead>>();
  StreamSink<List<Lead>> get _listSink => _stateStreamController.sink;
  Stream<List<Lead>> get listStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<ViewAction>();
  StreamSink<ViewAction> get eventSink => _eventStreamController.sink;
  Stream<ViewAction> get _eventStream => _eventStreamController.stream;

  LeadsBloc() {
    _eventStream.listen((event) async {
      if (event == ViewAction.fetch) {
        try {
          var list = await RemoteService().getLeads();
          _listSink.add(list);
        } on Exception catch (_) {
          _listSink.addError("Something went wrong");
        }
      }
    });
  }
}

class RemoteService {
  Future<List<Lead>> getLeads() async {
    var response = await http.post(
        Uri.https('notaryapi1.herokuapp.com', 'lead/getLeads'),
        body: {"notaryId": "62421089c913294914a8a35f"});
    var jsonData = jsonDecode(response.body);
    List<Lead> leads = [];
    for (var l in jsonData['leads']) {
      Lead lead = Lead(
          name: l['name'], email: l['email'], phoneNumber: l['PhoneNumber']);
      leads.add(lead);
    }
    return leads;
  }
}
