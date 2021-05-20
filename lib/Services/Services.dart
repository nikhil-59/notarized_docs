import 'dart:io';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotaryServices {
  final String baseUrl = "https://api.notarizeddocs.com/";
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  acceptNotary(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/acceptOrder", data: body);
      print(response.data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  declineNotary(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderIdToDecline": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "notary/declineOrder", data: body);
      print(response.data);
      return true;
    } catch (e) {
      return false;
    }
  }

  markDocumentsDownloaded(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/markDocumentsDownloaded",
          data: body);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  markOrderInProgress(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "notary/markOrderInProgress", data: body);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  markSigningCompleted(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "notary/markSigningCompleted", data: body);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  markOrderAsConfirmed(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "notary/markOrderAsConfirmed", data: body);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  markOrderAsDelivered(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "notary/markOrderAsDelivered", data: body);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  getInProgressOrders(String notaryId, int pageNumber) async {
    try {
      print(pageNumber);
      String jwt = await storage.read(key: 'jwt');
      print(jwt);
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/getInProgressOrders",
          data: {"notaryId": notaryId, "pageNumber": pageNumber});
      return response.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  getCompletedOrders(String notaryId, int pageNumber) async {
    try {
      print(pageNumber);
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/getCompletedOrders",
          data: {"notaryId": notaryId, "pageNumber": pageNumber});
      return response.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  getAppointments(DateTime dateTime, String notaryId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      print(jwt);
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/getDashboard", data: {
        "notaryId": notaryId,
        "today12am": dateTime.year.toString() +
            "-" +
            dateTime.month.toString() +
            "-" +
            dateTime.day.toString() +
            " 00:00:00 GMT+0530"
      });
      return response.data;
    } catch (e) {
      print(e);
      return {};
    }
  }

  getUserProfileInfo(String notaryId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(
        baseUrl + "notary/getProfile",
        data: {"notaryId": notaryId, "PageNumber": "0"},
      );
      return response.data;
    } catch (e) {
      return {};
    }
  }

  getEarnings(String notaryId, int pageNumber) async {
    print("current page Number $pageNumber");
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['Authorization'] = jwt;
    var response = await dio.post(
      baseUrl + "notary/getEarnings",
      data: {"notaryId": notaryId, "pageNumber": pageNumber},
    );
    return response.data;
  }

  getAllMessages(String notaryId, int pageNumber, String chatRoom) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(
        baseUrl + "notary/listMessages",
        data: {
          "notaryId": notaryId,
          "chatroomId": chatRoom,
          "pageNumber": pageNumber,
        },
      );
      return response.data;
    } catch (e) {
      return {};
    }
  }

  sendMessage({String message, String notaryId, String chatRoom}) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      await dio.post(
        baseUrl + "notary/sendMessage/",
        data: {
          "notaryId": notaryId,
          "chatroomId": chatRoom,
          "chatMessage": "$message"
        },
      );
    } catch (e) {}
  }

  getToken() async {
    final storage = new FlutterSecureStorage();
    String token = await FirebaseAuth.instance.currentUser.getIdToken();
    storage.write(key: "jwt", value: "Bearer " + token);
  }

  uploadImageToAPI(File _image, String notaryId, String orderId) async {
    String fileName = _image.path.split('/').last;
    String name = "n/$notaryId/o/$orderId/$fileName";
    print(name);
    String uploadedImageUrl = await AmazonS3Cognito.upload(
        _image.path,
        "notarized-docs-2",
        "us-east-2:4cc2ed4b-4322-48b1-9261-44a8b2b9f2b3",
        name,
        AwsRegion.US_EAST_2,
        AwsRegion.US_EAST_2);
    Map body = {
      "documentArray": [
        {
          "documentName": fileName,
          "documentURL": uploadedImageUrl,
        }
      ],
      "orderId": orderId,
      "notaryId": notaryId
    };
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['Authorization'] = jwt;
    var response = await dio
        .post(baseUrl + "notary/uploadMultipleDocumentsForOrder", data: body);
  }
}
