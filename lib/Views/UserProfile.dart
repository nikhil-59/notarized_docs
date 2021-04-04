import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myknott/Services/Services.dart';

class UserProfile extends StatefulWidget {
  final String notaryId;

  const UserProfile({Key key, this.notaryId}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin<UserProfile> {
  Map userInfo = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    userInfo = await NotaryServices().getUserProfileInfo(widget.notaryId);
    setState(() {});
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: userInfo.isNotEmpty
          ? SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: userInfo['notary']['userImageURL'] != null
                                  ? CachedNetworkImage(
                                      imageUrl: userInfo['notary']
                                          ['userImageURL'],
                                      height: 80,
                                      width: 80,
                                    )
                                  : Container(
                                      color: Colors.blue,
                                      height: 80,
                                      width: 80,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.blue.shade700,
                                        child: Text(
                                          userInfo['notary']["firstName"][0]
                                                      .toUpperCase() +
                                                  " " +
                                                  userInfo['notary']["lastName"]
                                                      [0] ??
                                              "".toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              userInfo['notary']["firstName"] +
                                  " " +
                                  userInfo['notary']["lastName"],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   "A Short Description of ${userInfo['notary']["firstName"]}",
                            //   style: TextStyle(
                            //       fontSize: 17,
                            //       color: Colors.black.withOpacity(0.8)),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "First Name",
                              style: TextStyle(fontSize: 16.5),
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none),
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              initialValue: userInfo['notary']['firstName'],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Last Name",
                              style: TextStyle(fontSize: 16.5),
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none),
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              initialValue: userInfo['notary']['lastName'],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Phone Number",
                              style: TextStyle(fontSize: 16.5),
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none),
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              initialValue: userInfo['notary']['phoneNumber'],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Email",
                              style: TextStyle(fontSize: 16.5),
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: InputDecoration(
                                  disabledBorder: InputBorder.none),
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              initialValue: userInfo['notary']['email'],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Note: To edit other details, Please log in from your webbrowser. visit www.notarizeddocs.com/notary",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.5),
                            ),
                          ],
                        ),
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
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Please Wait ...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
