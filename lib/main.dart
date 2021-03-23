import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myknott/Views/Services/auth.dart';
import 'package:myknott/Views/secondScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FirebaseMessaging.onMessageOpenedApp.any((element) {
    print("okky");
    if (element.data['type'] == 0 || element.data['type'] == "0") {
      String orderId = message.data['orderId'];
      String notaryId = message.data['notaryId'];
      navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            isPending: false,
            notaryId: notaryId,
            orderId: orderId,
          ),
        ),
      );
    }
    return false;
  });
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
  await Firebase.initializeApp();
  await getToken();
  FirebaseMessaging.instance.getToken().then((value) => print(value));
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessageOpenedApp.asBroadcastStream(
  //     onListen: (message) => handleNotificationClick(message));
  runApp(MyApp());
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Notary App',
      theme: ThemeData(
          accentColor: Colors.black,
          primarySwatch: Colors.blue,
          fontFamily: "Whitney"),
      home: AuthService().handleAuth(),
      // home: WaitingScreen(),
    );
  }
}
