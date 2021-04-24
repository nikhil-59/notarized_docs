import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:myknott/Config.dart/CustomColors.dart';
import 'package:myknott/Services/auth.dart';
import 'package:myknott/Views/CalenderScreen.dart';
import 'package:myknott/Views/ProgessScreen.dart';
import 'package:myknott/Views/UserProfile.dart';
import 'package:myknott/Views/Widgets/card.dart';
import 'package:myknott/Views/Widgets/confirmCard.dart';
import 'package:myknott/Views/OrderScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myknott/Views/Amount.dart';
import 'AuthScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Dio dio = Dio();
  final Color blueColor = CustomColor().blueColor;
  final storage = FlutterSecureStorage();
  TabController tabController;
  int currentIndex = 0;
  int pageNumber = 0;
  bool hasData = false;
  List appointmentList = [];
  List pendingList = [];
  Map userInfo = {};
  bool isloading = false;
  String totalAppointment = "";
  String totalpending = "";

  updateAppointment(int order) {
    if (order == 0) {
      totalAppointment = "";
    } else
      totalAppointment = "($order)";
  }

  updatePending(int order) {
    if (order == 0) {
      totalpending = "";
    } else
      totalpending = "($order)";
    // setState(() {});
  }

  handleForegroundNotification(RemoteMessage message) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (message.data['type'] == 2 || message.data['type'] == "2") {
      //print("new order");
      pendingList.clear();
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
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
            "logo": item["customer"]["userImageURL"]
          },
        );
      }
      updatePending(pendingList.length);
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
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (message.data['type'] == 2 || message.data['type'] == "2") {
      String orderId = message.data['orderId'];
      String notaryId = message.data['notaryId'];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderScreen(
            isPending: true,
            notaryId: notaryId,
            orderId: orderId,
          ),
        ),
      );
    } else if (message.data['type'] == 0 || message.data['type'] == "0") {
      //print("type 0 action is triggered");
      String orderId = message.data['orderId'];
      String notaryId = message.data['notaryId'];

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderScreen(
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
    } else if (message.data['type'] == 4 || message.data['type'] == "4") {
      String orderId = message.data['orderId'];
      String notaryId = message.data['notaryId'];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OrderScreen(
            isPending: false,
            notaryId: notaryId,
            orderId: orderId,
          ),
        ),
      );
    }
  }

  @override
  initState() {
    FirebaseMessaging.onMessageOpenedApp.any((element) {
      handleNotificationClick(element);
      return false;
    });
    FirebaseMessaging.onMessage.any((element) {
      handleForegroundNotification(element);
      return false;
    });
    tabController = TabController(length: 4, vsync: this);
    getUserInfo();
    getAppointment();
    getPending();
    super.initState();
  }

  @override
  dispose() {
    tabController.dispose();
    super.dispose();
  }

  getUserInfo() async {
    FirebaseMessaging.instance.onTokenRefresh
        .any((element) => AuthService().updateToken(element));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedUserinfo = prefs.getString("userInfo");
    userInfo = await jsonDecode(encodedUserinfo);
    setState(() {});
  }

  getAppointment() async {
    try {
      appointmentList.clear();
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      var body = {
        "notaryId": userInfo['notary']['_id'],
        "today12am": DateTime.now().year.toString() +
            "-" +
            DateTime.now().month.toString() +
            "-" +
            DateTime.now().day.toString() +
            " 00:00:00 GMT+0530"
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
          "logo": i['customer']['userImageURL'],
          "place": i['appointment']['place']
        });
        updateAppointment(appointmentList.length);
        setState(() {});
      }
    } catch (e) {
      //print(e);
      Fluttertoast.showToast(
          msg: "Something went wrong..",
          backgroundColor: blueColor,
          fontSize: 16,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM);
    }
  }

  getPending() async {
    setState(() {
      pageNumber = 0;
      hasData = false;
    });
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      pendingList.clear();
      Map data = {
        "notaryId": userInfo['notary']['_id'],
        "pageNumber": pageNumber
      };
      var response = await dio.post(
          "https://my-notary-app.herokuapp.com/notary/getInvites/",
          data: data);
      if (response.data['pageNumber'] == response.data['pageCount']) {
        hasData = true;
      } else
        pageNumber += 1;
      for (var item in response.data["orders"]) {
        pendingList.add(
          {
            "id": item["_id"],
            "amount": item["amount"],
            "name": item["appointment"]["signerFullName"],
            "address": item["appointment"]["propertyAddress"],
            "logo": item["customer"]["userImageURL"]
          },
        );
        updatePending(response.data['inviteCount']);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong..",
          backgroundColor: blueColor,
          fontSize: 16,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM);
    }
    setState(() {
      isloading = true;
    });
    //print(pendingList);
  }

  fetchMoreData() async {
    try {
      String jwt = await storage.read(key: 'jwt');
      dio.options.headers['Authorization'] = jwt;
      Map data = {
        "notaryId": userInfo['notary']['_id'],
        "pageNumber": pageNumber
      };
      var response = await dio.post(
          "https://my-notary-app.herokuapp.com/notary/getInvites/",
          data: data);
      if (response.data['pageNumber'] == response.data['pageCount']) {
        hasData = true;
        //print("-------------------Page Ended--------------");
      } else
        pageNumber += 1;
      for (var item in response.data["orders"]) {
        pendingList.add(
          {
            "id": item["_id"],
            "amount": item["amount"],
            "name": item["appointment"]["signerFullName"],
            "address": item["appointment"]["propertyAddress"],
            "logo": item["customer"]["userImageURL"]
          },
        );
      }
    } catch (e) {
      //print(e);
    }
    setState(() {
      isloading = true;
    });
    //print(pendingList);
  }

  @override
  // ignore: must_call_super
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
        color: Colors.white,
        elevation: 10,
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          selectedItemColor: blueColor,
          unselectedItemColor: Colors.grey,
          onTap: (i) {
            tabController.animateTo(i);
            setState(() {
              currentIndex = i;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(
                Icons.home_filled,
                size: 26,
              ),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 14.5),
              ),
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.bookmark_sharp,
                size: 26,
              ),
              title: Text(
                "Orders",
                style: TextStyle(fontSize: 14.5),
              ),
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.monetization_on,
                size: 26,
              ),
              title: Text(
                "Notary Pay",
                style: TextStyle(fontSize: 14.5),
              ),
            ),
            SalomonBottomBarItem(
              icon: Icon(
                Icons.person,
                size: 26,
              ),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 14.5),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          LazyLoadScrollView(
            isLoading: hasData,
            onEndOfPage: () => fetchMoreData(),
            child: RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                await getAppointment();
                await getPending();
              },
              child: SafeArea(
                child: (isloading)
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
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
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w700),
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
                                      "Today's Appointment $totalAppointment",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(seconds: 0),
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                CalenderScreen(
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
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AnimatedOpacity(
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      opacity: appointmentList
                                                              .isEmpty
                                                          ? 0.0
                                                          : 1.0,
                                                      child: Cards(
                                                        // place: userInfo[],
                                                        notaryId:
                                                            userInfo['notary']
                                                                ['_id'],
                                                        orderId:
                                                            appointmentList[
                                                                    index]
                                                                ['orderId'],
                                                        name: appointmentList[
                                                            index]['name'],
                                                        place: appointmentList[
                                                            index]['place'],
                                                        time:
                                                            DateFormat("h:mm a")
                                                                .format(
                                                          DateTime.parse(
                                                            appointmentList[
                                                                index]['date'],
                                                          ).toLocal(),
                                                        ),
                                                        phone: appointmentList[
                                                            index]['phone'],
                                                        imageUrl:
                                                            appointmentList[
                                                                index]["logo"],
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
                                            Image.asset(
                                              "assets/appointment.png",
                                              height: 100,
                                              width: 100,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30.0),
                                              child: Text(
                                                "You don't have any appointments for today.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                                bool isDone =
                                                    await Navigator.of(context)
                                                        .push(
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        Duration(seconds: 0),
                                                    pageBuilder: (_, __, ___) =>
                                                        OrderScreen(
                                                      notaryId:
                                                          userInfo['notary']
                                                              ['_id'],
                                                      orderId: item["id"],
                                                      isPending: true,
                                                    ),
                                                  ),
                                                );
                                                print(isDone);
                                                try {
                                                  if (!isDone) {
                                                    pendingList.remove(item);
                                                    updatePending(
                                                        pendingList.length);
                                                    setState(() {});
                                                  }
                                                } catch (e) {}
                                              },
                                              child: ConfirmCards(
                                                address: item["address"],
                                                name: item["name"],
                                                price:
                                                    item["amount"].toString(),
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
                                            Image.asset(
                                              "assets/pendingorder.png",
                                              height: 100,
                                              width: 100,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Text(
                                                "You don't have any pending requests",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40.0),
                                              child: Text(
                                                "Tip: Accept Appointments as soon you receive message",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15.5,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
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

  @override
  bool get wantKeepAlive => true;
}
