import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myknott/Views/Services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getToken();
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
