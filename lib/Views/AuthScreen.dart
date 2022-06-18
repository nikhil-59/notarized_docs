import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myknott/Config/CustomColors.dart';
import 'package:myknott/Screens/ErrorScreen.dart';
import 'package:myknott/Screens/NoInternetScreen.dart';
import 'package:myknott/Services/Services.dart';
import 'package:myknott/Services/auth.dart';
import 'package:myknott/Screens/WaitingScreen.dart';
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
  Color backgroundColor = Colors.blue[900];
  // Color colors = Color(0xff143791);
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: backgroundColor,
            height: MediaQuery.of(context).size.height, // - 30,
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          // border: Border.all(width: 4, color: Colors.white),
                        ),
                        child: Image.asset(
                          "assets/logo.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome Notary Partner",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Access Portal",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       SizedBox(
                //         width: 5,
                //       ),
                //       MaterialButton(
                //         elevation: 0,
                //         hoverElevation: 0,
                //         highlightElevation: 0,
                //         hoverColor: Colors.transparent,
                //         focusColor: Colors.transparent,
                //         splashColor: Colors.transparent,
                //         highlightColor: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(7),
                //         ),
                //         color: Color(0xffFDE52C),
                //         onPressed: () async {
                //           // EasyLoading.instance.
                //           try {
                //             EasyLoading.show(
                //                 status: 'Please wait...',
                //                 dismissOnTap: false,
                //                 maskType: EasyLoadingMaskType.clear);
                //             Map result =
                //                 await authService.signInWithFacebook(context);
                //             if (result["status"] == 1 &&
                //                 result["isloggedSuccessful"] &&
                //                 result['isapproved'] &&
                //                 result['isregister']) {
                //               Navigator.of(context).pushReplacement(
                //                 PageRouteBuilder(
                //                   transitionDuration: Duration(seconds: 0),
                //                   pageBuilder: (_, __, ___) => HomePage(),
                //                 ),
                //               );
                //             } else if (!result['isregister'] &&
                //                 result["isloggedSuccessful"]) {
                //               Navigator.of(context).pushReplacement(
                //                 PageRouteBuilder(
                //                   transitionDuration: Duration(seconds: 0),
                //                   pageBuilder: (_, __, ___) => WaitingScreen(
                //                     isRegister: false,
                //                   ),
                //                 ),
                //               );
                //             } else if (!result['isapproved'] &&
                //                 result["isloggedSuccessful"]) {
                //               Navigator.of(context).pushReplacement(
                //                 PageRouteBuilder(
                //                   transitionDuration: Duration(seconds: 0),
                //                   pageBuilder: (_, __, ___) => WaitingScreen(
                //                     isRegister: true,
                //                   ),
                //                 ),
                //               );
                //             } else {
                //               EasyLoading.dismiss();

                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 SnackBar(
                //                   behavior: SnackBarBehavior.floating,
                //                   backgroundColor: Colors.black,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(7)),
                //                   content: Text(
                //                     "Something went wrong...",
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //               return;
                //             }
                //           } catch (e) {
                //             EasyLoading.dismiss();
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 behavior: SnackBarBehavior.floating,
                //                 backgroundColor: Colors.black,
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(7)),
                //                 content: Text(
                //                   "Something went wrong...",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                   ),
                //                 ),
                //               ),
                //             );
                //           }
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.all(10.0),
                //           child: Icon(
                //             FontAwesomeIcons.facebookF,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //       MaterialButton(
                //         elevation: 0,
                //         hoverElevation: 0,
                //         highlightElevation: 0,
                //         hoverColor: Colors.transparent,
                //         focusColor: Colors.transparent,
                //         splashColor: Colors.transparent,
                //         highlightColor: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(7)),
                //         color: Color(0xffFDE52C),
                //         onPressed: () async {
                //           // EasyLoading.instance.
                //           try {
                //             EasyLoading.show(
                //                 status: 'Please wait...',
                //                 dismissOnTap: false,
                //                 maskType: EasyLoadingMaskType.clear);
                //             Map result =
                //                 await authService.signInWithGmail(context);
                //             if (result["status"] == 1 &&
                //                 result["isloggedSuccessful"] &&
                //                 result['isapproved'] &&
                //                 result['isregister']) {
                //               Navigator.of(context).pushReplacement(
                //                 PageRouteBuilder(
                //                   transitionDuration: Duration(seconds: 0),
                //                   pageBuilder: (_, __, ___) => HomePage(),
                //                 ),
                //               );
                //             } else if (!result['isregister'] &&
                //                 result["isloggedSuccessful"]) {
                //               Navigator.of(context).pushReplacement(
                //                 PageRouteBuilder(
                //                   transitionDuration: Duration(seconds: 0),
                //                   pageBuilder: (_, __, ___) => WaitingScreen(
                //                     isRegister: false,
                //                   ),
                //                 ),
                //               );
                //             } else if (!result['isapproved'] &&
                //                 result["isloggedSuccessful"]) {
                //               Navigator.of(context).pushReplacement(
                //                 PageRouteBuilder(
                //                   transitionDuration: Duration(seconds: 0),
                //                   pageBuilder: (_, __, ___) => WaitingScreen(
                //                     isRegister: true,
                //                   ),
                //                 ),
                //               );
                //             } else {
                //               EasyLoading.dismiss();
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 SnackBar(
                //                   behavior: SnackBarBehavior.floating,
                //                   backgroundColor: Colors.black,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(7)),
                //                   content: Text(
                //                     "Something went wrong...",
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //               return;
                //             }
                //           } catch (e) {
                //             EasyLoading.dismiss();
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 behavior: SnackBarBehavior.floating,
                //                 backgroundColor: Colors.black,
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(7)),
                //                 content: Text(
                //                   "Something went wrong...",
                //                   style: TextStyle(
                //                     fontSize: 16,
                //                   ),
                //                 ),
                //               ),
                //             );
                //           }
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.all(10.0),
                //           child: Icon(
                //             FontAwesomeIcons.google,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: 5,
                //       ),
                //     ],
                //   ),
                // ),
                Text(
                  "Login with Email",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Email",
                      //   style: TextStyle(
                      //       fontSize: 18,
                      //       color: Colors.black.withOpacity(0.9),
                      //       fontWeight: FontWeight.w600),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            fillColor: backgroundColor,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 24,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: backgroundColor,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.mail,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                            filled: true,
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
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
                      // Text(
                      //   "Password",
                      //   style: TextStyle(
                      //       fontSize: 18,
                      //       color: Colors.black.withOpacity(0.9),
                      //       fontWeight: FontWeight.w600),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          obscureText: !showPassword,
                          controller: passwordController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            fillColor: backgroundColor,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 24,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: backgroundColor,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.lock,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            filled: true,
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  color: Color(0xffFDE52C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width - 75,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !isloading ? "Login" : "Please Wait",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: backgroundColor,
                            ),
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
                                          Colors.white12),
                                    ),
                                  ),
                                )
                              : Container(),
                          (isloading)
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    radius: 32,
                                    child: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Color(0xffFDE52C),
                                      child: Icon(
                                        Icons.done,
                                        size: 44,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  onPressed: () async {
                    // NotaryServices().getpost();
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
                    }
                    // else if (passwordController.text.isEmpty) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       behavior: SnackBarBehavior.floating,
                    //       backgroundColor: Colors.black,
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(7)),
                    //       content: Text(
                    //         "Enter Password",
                    //         style: TextStyle(fontSize: 16),
                    //       ),
                    //     ),
                    //   );
                    // }
                    else if (!RegExp(
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
                        // final result = await NotaryServices().getToken();
                        Map result = await authService.signWithEmail(
                            emailController.text,
                            passwordController.text,
                            context);

                        //printing result
                        print("\n---------------line 583 :\n------------" +
                            result.toString());

                        if (result["status"] == 2) {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              transitionDuration: Duration(seconds: 0),
                              pageBuilder: (_, __, ___) => HomePage(),
                            ),
                          );
                        } else if (result["status"] == 3) {
                          print("596 authscreeen.dqart error : " +
                              result['error']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ErrorScreens(
                                      "assets/noUserFound.png",
                                      "The User Does not Exist in our Database",
                                      "Please provide correct Information, Try checking Spelling Mistakes \nClick on back button to go on Login Page",
                                      false)));
                          //comment
                        } else if (result["status"] == 4) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoInternetScreen()));
                        } else if (result["status"] == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ErrorScreens(
                                      "assets/noUserFound.png",
                                      "Something went Wrong ....",
                                      "Some error : ",
                                      false)));
                        } else {
                          setState(() {
                            isloading = false;
                          });
                          print("605 status " + result["status"]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              content: Text(
                                "Something went wrong" + result["status"],
                                style: TextStyle(
                                  fontSize: 8,
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
                        print(" 646 Errrro ---:" +
                            e.toString() +
                            "----${emailController.text}--${passwordController.text}----");
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
