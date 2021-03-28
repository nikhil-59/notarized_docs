import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myknott/Views/NoInternetScreen.dart';
import 'package:myknott/Views/Services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['type'] == 1 || message.data['type'] == '1') {
    if (message.data['action'] == 'revoked') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }
  }
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //       channelKey: 'notaryMessage',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: Color(0xFF9D50DD),
  //       ledColor: Colors.white)
  // ]);
  // AwesomeNotifications().createNotification(
  //   content: NotificationContent(
  //     id: 1,
  //     channelKey: "notaryMessage",
  //     backgroundColor: Colors.blue.shade800,
  //     title: message.data['title'],
  //     body: message.data['body'],
  //   ),
  //   actionButtons: [
  //     NotificationActionButton(label: "Accept", enabled: true, key: "123"),
  //     NotificationActionButton(label: "Decline", enabled: true, key: "321")
  //   ],
  // );
  return Future<void>.value();
}

// handleNotificationClick(StreamSubscription<RemoteMessage> message) async {
//   message.onData((data) {
//     print("new message");
//     String orderId = data.data['orderId'];
//     String notaryId = data.data['notaryId'];
//     navigatorKey.currentState.push(
//       MaterialPageRoute(
//         builder: (context) => SecondScreen(
//           isPending: false,
//           notaryId: notaryId,
//           orderId: orderId,
//         ),
//       ),
//     );
//   });
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isInternet = true;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    print("internet is off");

    isInternet = false;
  } else {
    await Firebase.initializeApp();
    await getToken();
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // FirebaseMessaging.onMessageOpenedApp.asBroadcastStream(
  //     onListen: (message) => handleNotificationClick(message));
  runApp(MyApp(
    isInternet: isInternet,
  ));
}

getToken() async {
  final storage = new FlutterSecureStorage();
  var response = await Dio().post(
      "https://my-notary-app.herokuapp.com/admin/common/dba/login",
      data: {"username": "iamsuperadmin", "password": "iHaveAllPass@1234"});
  print(response.data["jwt"]);
  storage.write(key: "jwt", value: response.data['jwt']);
}

class MyApp extends StatelessWidget {
  final bool isInternet;

  const MyApp({Key key, @required this.isInternet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Notary App',
      theme: ThemeData(
          accentColor: Colors.black,
          primarySwatch: MaterialColor(0xFF1565C0, {
            0: Color(0xFF1565C0),
            50: Color(0xFF1565C0),
            100: Color(0xFF1565C0),
            200: Color(0xFF1565C0),
            300: Color(0xFF1565C0),
            400: Color(0xFF1565C0),
            500: Color(0xFF1565C0),
            600: Color(0xFF1565C0),
            700: Color(0xFF1565C0),
            800: Color(0xFF1565C0),
            900: Color(0xFF1565C0),
          }),
          fontFamily: "Whitney"),
      home: isInternet ? AuthService().handleAuth() : NoInternetScreen(),
      builder: EasyLoading.init(),
      // home: WaitingScreen(),
    );
  }
}
