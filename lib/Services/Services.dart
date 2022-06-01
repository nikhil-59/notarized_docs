import 'dart:io';
// import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
// import 'package:amazon_s3_cognito/aws_region.dart';
import '../library/amazon_s3_congnito.dart';
import '../library/aws_region.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

RequestToApi requestToApiFromJson(String str) =>
    RequestToApi.fromJson(json.decode(str));

String requestToApiToJson(RequestToApi data) => json.encode(data.toJson());

class RequestToApi {
  RequestToApi({
    this.firstName,
    this.lastName,
    this.username,
    this.uid,
    this.email,
    this.phoneNumber,
    this.phoneCountryCode,
    this.mailingAddress,
    this.mailingZipcode,
    this.identityProvider,
  });

  String firstName;
  String lastName;
  String username;
  String uid;
  String email;
  String phoneNumber;
  String phoneCountryCode;
  String mailingAddress;
  String mailingZipcode;
  String identityProvider;

  factory RequestToApi.fromJson(Map<String, dynamic> json) => RequestToApi(
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        uid: json["uid"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        phoneCountryCode: json["phoneCountryCode"],
        mailingAddress: json["mailingAddress"],
        mailingZipcode: json["mailingZipcode"],
        identityProvider: json["identityProvider"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "uid": uid,
        "email": email,
        "phoneNumber": phoneNumber,
        "phoneCountryCode": phoneCountryCode,
        "mailingAddress": mailingAddress,
        "mailingZipcode": mailingZipcode,
        "identityProvider": identityProvider,
      };
}

class NotaryServices {
  final String baseUrl = "https://api.notarizeddocs.com/";
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  static String getTimezoneOffsetString(DateTime date) {
    var duration = date.timeZoneOffset;
    if (duration.isNegative)
      return ("-${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    else
      return ("+${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }

  acceptNotary(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      await dio.post(baseUrl + "notary/acceptOrder", data: body);
      return true;
    } catch (e) {
      return false;
    }
  }

  declineNotary(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderIdToDecline": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      await dio.post(baseUrl + "notary/declineOrder", data: body);
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
      await dio.post(baseUrl + "notary/markDocumentsDownloaded", data: body);
    } catch (e) {}
  }

  markOrderInProgress(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      await dio.post(baseUrl + "notary/markOrderInProgress", data: body);
    } catch (e) {}
  }

  markSigningCompleted(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      await dio.post(baseUrl + "notary/markSigningCompleted", data: body);
    } catch (e) {}
  }

  markOrderAsConfirmed(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      await dio.post(baseUrl + "notary/markOrderAsConfirmed", data: body);
    } catch (e) {}
  }

  markOrderAsDelivered(String notaryId, String orderId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {"orderId": orderId, "notaryId": notaryId};
      dio.options.headers['Authorization'] = jwt;
      await dio.post(baseUrl + "notary/markOrderAsDelivered", data: body);
    } catch (e) {}
  }

  getInProgressOrders(String notaryId, int pageNumber) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/getInProgressOrders",
          data: {"notaryId": notaryId, "pageNumber": pageNumber});
      return response.data;
    } catch (e) {
      return {};
    }
  }

  getCompletedOrders(String notaryId, int pageNumber) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/getCompletedOrders",
          data: {"notaryId": notaryId, "pageNumber": pageNumber});
      return response.data;
    } catch (e) {
      return {};
    }
  }

  getAppointments(DateTime dateTime, String notaryId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(baseUrl + "notary/getDashboard", data: {
        "notaryId": notaryId,
        "today12am": dateTime.year.toString() +
            "-" +
            dateTime.month.toString() +
            "-" +
            dateTime.day.toString() +
            " 00:00:00 GMT${getTimezoneOffsetString(DateTime.now())}"
      });
      return response.data;
    } catch (e) {
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

  uploadImageToAPINew(File _image, String notaryId, String orderId) async {
    String fileName = _image.path.split('/').last;
    String name = "n/$notaryId/o/$orderId/$fileName";
    String uploadedImageUrl = '';
    try {
      final destination = 'docs/$orderId/notaryUploads/$fileName';
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(_image);
      uploadedImageUrl = await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      // your default error handling
      // NABHAN: please show Toast as Error in Uploading
    }

    if (uploadedImageUrl != null || uploadedImageUrl != '') {
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
    } else {
      // NABHAN: please show Toast as Error in Uploading
    }
  }
}
