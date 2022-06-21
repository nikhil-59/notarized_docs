import 'package:flutter/material.dart';
import 'package:myknott/Services/task_bloc.dart';
import 'package:myknott/models/lead.dart';

class TaskPage extends StatefulWidget {
  //TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final leadsBloc = LeadsBloc();
  @override
  void initState() {
    leadsBloc.eventSink.add(ViewAction.fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Page'),
      ),
      body: StreamBuilder<List<Lead>>(
        stream: leadsBloc.listStream,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    tileColor: Colors.grey.shade100,
                    leading: const Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    title: Text('Name: ${snapshot.data[index].name}'),
                    isThreeLine: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${snapshot.data[index].email}'),
                        Text(
                            'Phone Number: ${snapshot.data[index].phoneNumber}')
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
