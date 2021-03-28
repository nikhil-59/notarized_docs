import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:myknott/Views/CalenderScreen.dart';
import 'package:myknott/Views/ProgessScreen.dart';
import 'package:myknott/Views/Services/auth.dart';
import 'package:myknott/Views/UserProfile.dart';
import 'package:myknott/Views/Widgets/card.dart';
import 'package:myknott/Views/Widgets/confirmCard.dart';
import 'package:myknott/Views/secondScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myknott/Views/Amount.dart';

import 'AuthScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Dio dio = Dio();
  final storage = FlutterSecureStorage();
  TabController tabController;
  List appointmentList = [];
  List pendingList = [];
  Map userInfo = {};
  List<bool> acceptLoader = [];
  List<bool> declineLoader = [];
  bool isloading = false;

  handleForegroundNotification(RemoteMessage message) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (message.data['type'] == 2 || message.data['type'] == "2") {
      {
        print("new order");
        pendingList.clear();
        String jwt = await storage.read(key: 'jwt');
        dio.options.headers['auth_token'] = jwt;
        Map data = {"notaryId": userInfo['notary']['_id'], "pageNumber": "0"};
        var response = await dio.post(
            "https://my-notary-app.herokuapp.com/notary/getInvites/",
            data: data);
        for (var item in response.data["orders"]) {
          pendingList.add(
            {
              "id": item["_id"],
              "amount": item["amount"],
              "name": item["appointment"]["signerFullName"],
              "address": item["appointment"]["propertyAddress"],
              "logo": item["appointment"]["userImageURL"]
            },
          );
        }
      }
      setState(() {});
    } else if (message.data['type'] == 1 || message.data['type'] == "1") {
      if (message.data['action'] == 'revoked') {
        await preferences.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AuthScreen(),
          ),
        );
      }
    }
  }

  handleNotificationClick(RemoteMessage message) async {
    // used to handle new order notification
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (message.data['type'] == 2 || message.data['type'] == "2") {
      String orderId = message.data['orderId'];
      String notaryId = message.data['notaryId'];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            isPending: true,
            notaryId: notaryId,
            orderId: orderId,
          ),
        ),
      );
    } else if (message.data['type'] == 0 || message.data['type'] == "0") {
      print("type 0 action is triggered");
      String orderId = message.data['orderId'];
      String notaryId = message.data['notaryId'];

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            isPending: false,
            notaryId: notaryId,
            orderId: orderId,
            messageTrigger: true,
          ),
        ),
      );
    } else if (message.data['type'] == 1 || message.data['type'] == "1") {
      if (message.data['action'] == 'revoked') {
        await preferences.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AuthScreen(),
          ),
        );
      }
    }
  }

  @override
  initState() {
    FirebaseMessaging.onMessageOpenedApp.any((element) {
      print("okky");
      handleNotificationClick(element);
      return false;
    });
    FirebaseMessaging.onMessage.any((element) {
      print("okky");
      handleForegroundNotification(element);
      return false;
    });
    tabController = TabController(length: 4, vsync: this);
    getUserInfo();
    getAppointment();
    getPending();
    super.initState();
  }

  getUserInfo() async {
    FirebaseMessaging.instance.onTokenRefresh
        .any((element) => AuthService().updateToken(element));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedUserinfo = prefs.getString("userInfo");
    userInfo = await jsonDecode(encodedUserinfo);
    setState(() {});
    // print(userInfo);
  }

  getAppointment() async {
    try {
      appointmentList.clear();
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['auth_token'] = jwt;
      var body = {
        "notaryId": userInfo['notary']['_id'],
        "today12am": DateTime.now().year.toString() +
            "-" +
            DateTime.now().month.toString() +
            "-" +
            DateTime.now().day.toString() +
            " 00:00:00 GMT+0530"

        // "${DateFormat("yyyy-MM-dd").format(DateTime.now())} 00:00:00 GMT+0530",
        // "today12am": "2021-03-17 00:00:00 GMT+0530"
      };
      var response = await dio.post(
          "https://my-notary-app.herokuapp.com/notary/getDashboard",
          data: body);
      for (var i in response.data['appointments']) {
        appointmentList.add({
          "id": i['appointment']['_id'],
          "date": i['appointment']['time'],
          "address": i['appointment']["propertyAddress"],
          "name": i['appointment']["signerFullName"],
          "phone": i['appointment']["signerPhoneNumber"],
          "orderId": i["orderId"],
          "logo": i['customer']['userImageURL']
        });
        setState(() {});
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          content: Text(
            "Something went wrong...",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }
  }

  getPending() async {
    try {
      acceptLoader.clear();
      declineLoader.clear();
      pendingList.clear();
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['auth_token'] = jwt;
      Map data = {"notaryId": userInfo['notary']['_id'], "pageNumber": "0"};
      var response = await dio.post(
          "https://my-notary-app.herokuapp.com/notary/getInvites/",
          data: data);
      for (var item in response.data["orders"]) {
        pendingList.add(
          {
            "id": item["_id"],
            "amount": item["amount"],
            "name": item["appointment"]["signerFullName"],
            "address": item["appointment"]["propertyAddress"],
            "logo": item["appointment"]["userImageURL"]
          },
        );
        declineLoader.add(false);
        acceptLoader.add(false);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          content: Text(
            "Something went wrong...",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    setState(() {
      isloading = true;
    });
    print(pendingList);
  }

  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Morning';
      }
      if (hour < 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Material(
        child: TabBar(
          enableFeedback: true,
          controller: tabController,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(),
          labelColor: Colors.blue.shade900,
          tabs: [
            Tab(
              icon: Icon(
                Icons.home,
                size: 28,
              ),
            ),
            Tab(
              icon: Icon(Icons.bookmark_sharp, size: 28),
            ),
            Tab(
              icon: Icon(Icons.monetization_on, size: 28),
            ),
            Tab(
                icon: Icon(
              Icons.person,
              size: 28,
            )),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          RefreshIndicator(
            color: Colors.black,
            onRefresh: () async {
              await getAppointment();
              await getPending();
            },
            child: SafeArea(
              child: (isloading)
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 70,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "Good " + greeting(),
                                style: TextStyle(fontSize: 17),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                userInfo['notary']['firstName'] +
                                    " " +
                                    userInfo['notary']['lastName'],
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today's  Appointment",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CalenderScreen(
                                              notaryId: userInfo['notary']
                                                  ['_id']),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View All",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              appointmentList.isNotEmpty
                                  ? AnimatedSize(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                      vsync: this,
                                      child: Container(
                                        height:
                                            appointmentList.isEmpty ? 0 : 150,
                                        child: (appointmentList.isEmpty)
                                            ? Container()
                                            : ListView.builder(
                                                itemBuilder: (context, index) {
                                                  return AnimatedOpacity(
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    opacity:
                                                        appointmentList.isEmpty
                                                            ? 0.0
                                                            : 1.0,
                                                    child: Cards(
                                                      notaryId:
                                                          userInfo['notary']
                                                              ['_id'],
                                                      orderId:
                                                          appointmentList[index]
                                                              ['orderId'],
                                                      name:
                                                          appointmentList[index]
                                                              ['name'],
                                                      time: DateFormat("h:mm a")
                                                          .format(
                                                        DateTime.parse(
                                                          appointmentList[index]
                                                              ['date'],
                                                        ),
                                                      ),
                                                      imageUrl:
                                                          appointmentList[index]
                                                              ["logo"],
                                                    ),
                                                  );
                                                },
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    appointmentList.length,
                                              ),
                                      ),
                                    )
                                  : Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          SvgPicture.asset(
                                            "assets/calendar.svg",
                                            height: 100,
                                            width: 100,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0),
                                            child: Text(
                                              "You don't have any appointments for today.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Pending Requests",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Accept the order as soon it comes. Order are assigned on first accepted basis.",
                                  style: TextStyle(
                                      fontSize: 15.5,
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              pendingList.isNotEmpty
                                  ? ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        for (var item in pendingList)
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (_) => SecondScreen(
                                                    notaryId: userInfo['notary']
                                                        ['_id'],
                                                    orderId: item["id"],
                                                    isPending: true,
                                                  ),
                                                ),
                                              )
                                                  .whenComplete(() async {
                                                print("---------------------");
                                                await getPending();
                                              });
                                            },
                                            child: ConfirmCards(
                                              address: item["address"],
                                              name: item["name"],
                                              price: item["amount"].toString(),
                                              notaryId: userInfo['notary']
                                                  ['_id'],
                                              orderId: item["id"],
                                              imageUrl: userInfo['notary']
                                                  ['userImageURL'],
                                              refresh: getPending,
                                            ),
                                          ),
                                      ],
                                    )
                                  : Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          SvgPicture.asset(
                                            "assets/checklist.svg",
                                            height: 100,
                                            width: 100,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text(
                                              "You don't have any pending requests",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            child: Text(
                                              "Tip: Accept Appointments as soon you receive message",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15.5,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  // : Center(
                  //     child: SpinKitWave(
                  //       color: Colors.grey,
                  //       size: 40,
                  //     ),
                  //   )
                  : Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Please Wait ...",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          ProgressScreen(
            notaryId: userInfo.isNotEmpty ? userInfo['notary']['_id'] : "",
          ),
          AmountScreen(
            notaryId: userInfo.isNotEmpty ? userInfo['notary']['_id'] : "",
          ),
          UserProfile(
            notaryId: userInfo.isNotEmpty ? userInfo['notary']['_id'] : "",
          )
        ],
      ),
    );
  }
}
