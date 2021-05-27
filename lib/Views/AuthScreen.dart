import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myknott/Config/CustomColors.dart';
import 'package:myknott/Services/auth.dart';
import 'package:myknott/Views/WaitingScreen.dart';
import 'package:myknott/Views/homePage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showPassword = false;
  bool isloading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );
    EasyLoading.instance
      ..indicatorColor = Colors.white
      ..fontSize = 17
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.chasingDots
      ..backgroundColor = Colors.black;

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height - 30,
            // color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Image.asset(
                        "assets/logo.png",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Access account",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      MaterialButton(
                        elevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        color: Colors.grey.shade200,
                        onPressed: () async {
                          // EasyLoading.instance.
                          try {
                            EasyLoading.show(
                                status: 'Please wait...',
                                dismissOnTap: false,
                                maskType: EasyLoadingMaskType.clear);
                            Map result =
                                await authService.signInWithFacebook(context);
                            if (result["status"] == 1 &&
                                result["isloggedSuccessful"] &&
                                result['isapproved'] &&
                                result['isregister']) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (_, __, ___) => HomePage(),
                                ),
                              );
                            } else if (!result['isregister'] &&
                                result["isloggedSuccessful"]) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (_, __, ___) => WaitingScreen(
                                    isRegister: false,
                                  ),
                                ),
                              );
                            } else if (!result['isapproved'] &&
                                result["isloggedSuccessful"]) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (_, __, ___) => WaitingScreen(
                                    isRegister: true,
                                  ),
                                ),
                              );
                            } else {
                              EasyLoading.dismiss();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  content: Text(
                                    "Something went wrong...",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                content: Text(
                                  "Something went wrong...",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      MaterialButton(
                        elevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        color: Colors.grey.shade200,
                        onPressed: () async {
                          // EasyLoading.instance.
                          try {
                            EasyLoading.show(
                                status: 'Please wait...',
                                dismissOnTap: false,
                                maskType: EasyLoadingMaskType.clear);
                            Map result =
                                await authService.signInWithGmail(context);
                            if (result["status"] == 1 &&
                                result["isloggedSuccessful"] &&
                                result['isapproved'] &&
                                result['isregister']) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (_, __, ___) => HomePage(),
                                ),
                              );
                            } else if (!result['isregister'] &&
                                result["isloggedSuccessful"]) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (_, __, ___) => WaitingScreen(
                                    isRegister: false,
                                  ),
                                ),
                              );
                            } else if (!result['isapproved'] &&
                                result["isloggedSuccessful"]) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 0),
                                  pageBuilder: (_, __, ___) => WaitingScreen(
                                    isRegister: true,
                                  ),
                                ),
                              );
                            } else {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  content: Text(
                                    "Something went wrong...",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                content: Text(
                                  "Something went wrong...",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Text(
                  "or Login with Email",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        cursorColor: Colors.black,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 16.5, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade50,
                          filled: true,
                          hintText: "Enter email Id",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        style: TextStyle(
                            fontSize: 16.5, fontWeight: FontWeight.w700),
                        obscureText: !showPassword,
                        controller: passwordController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade50,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.white,
                                width: 50,
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  child: Text(
                                    "?",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          filled: true,
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  color: CustomColor().loginColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !isloading ? "Sign in" : "Please Wait",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          (isloading) ? SizedBox(width: 10) : Container(),
                          (isloading)
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          content: Text(
                            "Enter Email Id",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      );
                    } else if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          content: Text(
                            "Enter Password",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(emailController.text.trim())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          content: Text(
                            "Enter Valid Email Address",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                      return;
                    } else {
                      setState(() {
                        isloading = true;
                      });
                      try {
                        Map result = await authService.signWithEmail(
                            emailController.text,
                            passwordController.text,
                            context);
                        if (result["status"] == 1 &&
                            result["isloggedSuccessful"] &&
                            result['isapproved'] &&
                            result['isregister']) {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: Duration(seconds: 0),
                              pageBuilder: (_, __, ___) => HomePage(),
                            ),
                          );
                        } else if (!result['isregister'] &&
                            result["isloggedSuccessful"]) {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: Duration(seconds: 0),
                              pageBuilder: (_, __, ___) => WaitingScreen(
                                isRegister: false,
                              ),
                            ),
                          );
                        } else if (!result['isapproved'] &&
                            result["isloggedSuccessful"]) {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: Duration(seconds: 0),
                              pageBuilder: (_, __, ___) => WaitingScreen(
                                isRegister: true,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            isloading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              content: Text(
                                "Something went wrong...",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                          return;
                        }
                      } catch (e) {
                        setState(() {
                          isloading = false;
                        });
                      }
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
