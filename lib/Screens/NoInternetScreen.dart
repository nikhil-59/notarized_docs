import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myknott/Services/Services.dart';
import 'package:myknott/Services/auth.dart';
import 'package:myknott/main.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool loading = false;
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  func() async {
    await Firebase.initializeApp();
    setState(() {
      loading = true;
    });
    try {
      await NotaryServices().getToken();
    } catch (e) {}
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (_, __, ___) => AuthService().handleAuth(),
      ),
    );
  }

  @override
  void initState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (ConnectivityResult.none.index != result.index) {
        func();
      }
    });
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/404.svg",
              // width: 120,
              // height: 120,
            ),
            
            SizedBox(
              height: 15,
            ),
            Text(
              "No Internet Connection",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.8)),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.5,
                    // fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.red.shade800),
                      strokeWidth: 2.5,
                    ),
                  )
                : Container(
                    height: 30,
                    width: 30,
                  )
          ],
        ),
      )),
    );
  }
}
