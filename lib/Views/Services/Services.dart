import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotaryServices {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  acceptNotary(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderId": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/acceptOrder",
        data: body);
    print(response.data);
  }

  declineNotary(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderIdToDecline": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/acceptOrder",
        data: body);
    print(response.data);
  }

  markDocumentsDownloaded(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderId": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/markDocumentsDownloaded",
        data: body);
    print(response.data);
  }

  markOrderInProgress(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderId": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/markOrderInProgress",
        data: body);
    print(response.data);
  }

  markSigningCompleted(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderId": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/markSigningCompleted",
        data: body);
    print(response.data);
  }

  markOrderAsConfirmed(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderId": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/markOrderAsConfirmed",
        data: body);
    print(response.data);
  }

  markOrderAsDelivered(String notaryId, String orderId) async {
    String jwt = await storage.read(key: 'jwt');
    Map body = {"orderId": orderId, "notaryId": notaryId};
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/markOrderAsDelivered",
        data: body);
    print(response.data);
  }

  getInProgressOrders(String notaryId) async {
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/getInProgressOrders",
        data: {"notaryId": notaryId, "PageNumber": "0"});
    return response.data;
  }

  getCompletedOrders(String notaryId) async {
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
        "https://my-notary-app.herokuapp.com/notary/getCompletedOrders",
        data: {"notaryId": notaryId, "PageNumber": "0"});
    return response.data;
  }

  getAppointments(DateTime dateTime, String notaryId) async {
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['auth_token'] = jwt;
    var response = await dio
        .post("https://my-notary-app.herokuapp.com/notary/getDashboard", data: {
      "notaryId": notaryId,
      "today12am": dateTime.year.toString() +
          "-" +
          dateTime.month.toString() +
          "-" +
          dateTime.day.toString() +
          " 00:00:00 GMT-0730"
    });
    return response.data;
  }

  getUserProfileInfo(String notaryId) async {
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['auth_token'] = jwt;
    var response = await dio.post(
      "https://my-notary-app.herokuapp.com/notary/getProfile",
      data: {"notaryId": notaryId, "PageNumber": "0"},
    );
    return response.data;
  }
}
