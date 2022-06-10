import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myknott/Config/CustomColors.dart';
import 'package:myknott/Views/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitingScreen extends StatefulWidget {
  final bool isRegister;

  const WaitingScreen({Key key, @required this.isRegister}) : super(key: key);
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final Color blueColor = CustomColor().blueColor;

  adjustStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  handleNotification(message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (message.data['type'] == 1 || message.data['type'] == '1') {
      if (message.data['action'] == 'approved') {
        await prefs.setBool("isloggedIn", true);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 0),
            pageBuilder: (context, _, __) => HomePage(),
          ),
        );
      }
    }
    if (message.data['action'] == 'revoked') {
      await prefs.clear();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 0),
          pageBuilder: (_, __, ___) => WaitingScreen(isRegister: true),
        ),
      );
    }
  }

  @override
  void initState() {
    adjustStatusBar();
    // used to handle new verification notification
    FirebaseMessaging.onMessage.any((element) {
      handleNotification(element);
      return false;
    });
    FirebaseMessaging.onMessageOpenedApp.any((element) {
      handleNotification(element);
      return false;
    });
    // FirebaseMessaging.onMessageOpenedApp.any(
    //   (element) {
    //     if (element.data['type'] == 1 || element.data['type'] == '1') {
    //       Navigator.of(context).pushReplacement(
    //         PageRouteBuilder(
    //           builder: (context) => HomePage(),
    //         ),
    //       );
    //     }
    //     return false;
    //   },
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "notarized",
                          style: TextStyle(
                              color: Colors.yellow.shade600,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "docs",
                          style: TextStyle(
                              color: blueColor,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        "Pays Attention to the smallest Details.",
                        style: TextStyle(
                            fontSize: 15,
                            color: blueColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: Image.asset(
                      "assets/quality.png",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.isRegister
                        ? "Pending Approval"
                        : "Pending Registation",
                    style: TextStyle(
                        fontSize: 16.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    widget.isRegister
                        ? "We will notify you once your account is live."
                        : "Please register your profile in NotarizedDocs website",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "In case of any query, please write to us.",
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                  Text(
                    "support@notarizeddocs.com",
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
