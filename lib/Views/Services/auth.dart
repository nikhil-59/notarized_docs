import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myknott/Views/AuthScreen.dart';
import 'package:myknott/Views/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();
  final Dio dio = Dio();
  Future<Map> signWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      return await getUserInfo(
          userCredential.user.uid, userCredential.user.email);
    } catch (e) {
      print(e);
      return {"status": 10, "isloggedSuccessful": false};
    }
  }

  Future<Map> getUserInfo(String uid, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = await storage.read(key: "jwt");
    dio.options.headers['auth_token'] = jwt;
    try {
      var response = await dio.post(
          'https://my-notary-app.herokuapp.com/notary/login/',
          data: {"uid": uid, "email": email});
      if (response.data['status'] == 1) {
        String userInfo = jsonEncode(response.data);
        await prefs.setString("userInfo", userInfo);
        await prefs.setBool("isloggedIn", true);
        return {"status": 1, "isloggedSuccessful": true};
      } else
        return {"status": response.data['status'], "isloggedSuccessful": true};
    } catch (e) {
      print(e);
      return {"status": 10, "isloggedSuccessful": false};
    }
  }

  Future<bool> check() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("isloggedIn")) {
      if (preferences.getBool("isloggedIn") == true)
        return true;
      else
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
}
