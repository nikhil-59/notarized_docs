import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myknott/Services/Services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myknott/Views/AuthScreen.dart';
import 'package:myknott/Views/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final storage = FlutterSecureStorage();
  final Dio dio = Dio();

  Future<Map> signWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // userCredential has an error message "auth/user-record-not-found" 
      await NotaryServices().getToken();
      return await getUserInfo(userCredential.user.uid,
          userCredential.user.email, userCredential.user.providerData.first);
    } catch (e) {
      EasyLoading.dismiss();
      print("e at 34");
      print(e);
      if (e.toString().contains("password")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            content: Text(
              "Invalid Password",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
      if (e.toString().contains("identifier")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            content: Text(
              "The user doesn't exist..",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
      return {"status": 10, "isloggedSuccessful": false};
    }
  }

  Future<Map> getUserInfo(String uid, String email, UserInfo user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = await storage.read(key: "jwt");
    dio.options.headers['Authorization'] = jwt;
    try {
      var response = await dio.post(
        NotaryServices().baseUrl + 'customer/login/',
        data: {
          "uid": uid,
          "email": email,
          "emailVerified": false,
          "photoURL": user.photoURL.toString(),
          "displayName": user.displayName,
          "phoneNumber": user.phoneNumber.toString(),
          "loginThroughMobile": "hgckgvVKUGDVUVlhbvishfbvkihfbkusf",
          "pushToken": await firebaseMessaging.getToken(),
          "pushTokenDeviceType": "android",
          "platform": "mobile"
        },
      );
      //printing response
      print(" response---------\n " + response.data.toString());

      EasyLoading.dismiss();
      if (response.data['status'] == 1 && 
          // String notaryId = await storage.read(key: "_id");
        // status: 1> Dont do 
        // status: 2 > save customer object and _id to store and proceed to Dashboard Page 
        // status- 3> Redirect to Another Page 
        // status: 0> Error Occured, parse error message and show as Toast 
  }

  Future<bool> check() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("isloggedIn")) {
      if (preferences.getBool("isloggedIn") == true) {
        return true;
      } else
        return false;
    } else {
      return false;
    }
  }

  handleAuth() {
    return FutureBuilder(
      future: check(),
      builder: (context, snapshot) {
        {
          if (snapshot.data == true)
            return HomePage();
          else
            return AuthScreen();
          // return HomePage();
        }
      },
    );
  }

  updateToken(token) async {
    String jwt = await storage.read(key: "jwt");
    dio.options.headers['Authorization'] = jwt;
    try {
      var response =
          await dio.post(NotaryServices().baseUrl + 'customer/login/', data: {
        "uid": FirebaseAuth.instance.currentUser.uid,
        "email": FirebaseAuth.instance.currentUser.email,
        "loginThroughMobile": "hgckgvVKUGDVUVlhbvishfbvkihfbkusf",
        "pushToken": token,
        "pushTokenDeviceType": "android"
      });
    } catch (e) {}
  }

  Future<Map> signInWithGmail(context) async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await NotaryServices().getToken();
      return await getUserInfo(userCredential.user.uid,
          userCredential.user.email, userCredential.user.providerData.first);
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            content: Text(
              "User already Register with different sign-in credentials",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
        return {"status": 10, "isloggedSuccessful": false};
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            content: Text(
              "Some went wrong..",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
        return {"status": 10, "isloggedSuccessful": false};
      }
    }
  }

  Future<Map> signInWithFacebook(context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      await NotaryServices().getToken();
      if (userCredential.user.email == null) {
        await userCredential.user.updateEmail(
            userCredential.user.displayName.replaceAll(" ", "") +
                "@facebook.com");
      }
      return await getUserInfo(
          userCredential.user.uid,
          userCredential.user.providerData.first.email ??
              userCredential.user.displayName.replaceAll(" ", "") +
                  "@facebook.com",
          userCredential.user.providerData.first);
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            content: Text(
              "User already Register with different sign-in credentials",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
        return {"status": 10, "isloggedSuccessful": false};
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            content: Text(
              "Some went wrong..",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
        return {"status": 10, "isloggedSuccessful": false};
      }
    }
  }
}
