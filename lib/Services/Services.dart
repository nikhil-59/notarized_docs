import 'dart:io';
// import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';
import 'package:http/src/response.dart' as rsp;
import 'package:myknott/Views/homePage.dart';
import 'package:myknott/Views/newAppointment.dart';
import 'dart:io';
// import 'package:amazon_s3_cognito/aws_region.dart';
import '../library/amazon_s3_congnito.dart';
import '../library/aws_region.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

//Api

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
    this.platform,
    this.pushToken,
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
  String platform;
  String pushToken;

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
        platform: json["platform "],
        pushToken: json["pushToken"],
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
        "platform ": platform,
        "pushToken": pushToken,
      };
}

//Notary Service class Below

class NotaryServices {
  final String baseUrl = "https://notaryapi1.herokuapp.com/";
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  // Calling Our Api
  // Future<dynamic> getpost() async {
  //   final response = await http.get(Uri.parse('$baseUrl/1'));
  //   print(" line 94 :" + response.body);
  //   return requestToApiFromJson(response.body);
  // }

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
      Map body = {"orderId": "629f2d8c4769030016c4e178"};
      dio.options.headers['Authorization'] = jwt;
      var resp =
          await dio.post(baseUrl + "appointment/acceptAppointment", data: body);
      print("resp 114 service : $resp");
      return true;
    } catch (e) {
      print("Error on 116 : $e");
      return false;
    }
  }

  declineNotary(String apptID, String declineReason) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      Map body = {
        "apptID": "629f2d8c4769030016c4e178",
        "reason": declineReason
      };
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "appointment/rejectAppointment", data: body);
      print("response 129 decline : ${response.data}");
      return true;
    } catch (e) {
      print("Error on 128 service $e");
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
      var response = await dio.post(
          baseUrl + "appointment/getUpcomingAppointments",
          data: {"notaryId": notaryId, "pageNumber": pageNumber});
      print("193 service.dart ${response.data} ");
      return response.data;
    } catch (e) {
      print("Erro on 187 service");
      print(e);
      return {};
    }
  }

  getCompletedOrders(String notaryId, int pageNumber) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "appointment/getPastAppointments", data: {
        "notaryId": notaryId,
        // "pageNumber": pageNumber
      });
      print(" 196 service getCO : ${response.data}\n");
      return response.data;
    } catch (e) {
      print("Error on 202 service.dart getCO : $e");
      return {};
    }
  }

  createNewAppointment(String notaryIdd, String dat, String tim) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response =
          await dio.post(baseUrl + "appointment/createAppointment", data: {
        "notaryId": notaryIdd,
        "endCustomerInfo": {
          "firstName": "test0",
          "lastName": "abc",
          "email": "test@gmail.com",
          "phoneNumber": 9475983454,
          "countryCode": "3wefre",
          "defaultTZ": "e423rdf",
          "company": {
            "name": "company",
            "address": "ersdvfdegtrg",
            "lat": 234235345,
            "lon": 534456345,
            "zipcode": 343234,
            "streetAddress": "street 1",
            "area": "hisar",
            "city": "hisar",
            "state": "haryana",
            "country": "india",
            "phoneNumber": 5987348573,
            "email": "company@gmail.com"
          }
        },
        "isOnlineSigning": false,
        "appointmentInfo": {
          "date": "2022-06-16T18:30:00.000Z",
          "time": 53034,
          "durationofAppointment": 1,
          "place": {
            "completeAddress": "ewffverver",
            "lat": 234235345,
            "lon": 534456345,
            "zipcode": 343234,
            "area": "hisar",
            "city": "hisar",
            "state": "haryana",
            "streetAddress": "sgfergerg"
          }
        },
        "signingInfo": {
          "escrowNumber": "23ewfewr24",
          "signerInfo": {
            "firsttName": "signer",
            "lastName": "abcde",
            "email": "signer1@gmail.com",
            "phoneNumber": 1234509876,
            "countryCode": "3wefre",
            "defaultTZ": "e423rdf"
          },
          "propertyAddress": "kjwehfnerifu",
          "extraInstructions": "kjfherfiuehrfiue"
        }
      });
      // print(response.forEach((key,value)=>print(" $key , $value")));
      print(response);
    } catch (e) {
      print("Error on 269 : $e\n");
      return {};
    }
  }

  deleteAppointment(String notryId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      // var response = await dio.post(baseUrl + "dashboard/getDashboard", data: {
      var response =
          await dio.post(baseUrl + "appointment/deleteAppointment", data: {
        "notaryId": notryId,
      });
    } catch (e) {
      print("284 Error $e");
    }
  }

  getAppointments(DateTime dateTime, String notaryId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      // var response = await dio.post(baseUrl + "dashboard/getDashboard", data: {
      var response =
          await dio.post(baseUrl + "appointment/getAppointments", data: {
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
      print("Error  305 service : $e \n------- ");
      return {};
    }
  }

  getUserProfileInfo(String notaryId) async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var response = await dio.post(
        baseUrl + "customer/getProfile",
        data: {"notaryId": notaryId, "PageNumber": "0"},
      );
      return response.data;
    } catch (e) {
      print("Error on 320 service.dart ");
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> getLeads(String notaryId, int pageNumber) async {
    String jwt = await storage.read(key: 'jwt');
    dio.options.headers['Authorization'] = jwt;

    print("pagenumber   :" + pageNumber.toString());
    final response = await dio.post(
      baseUrl + "lead/getLeads",
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
