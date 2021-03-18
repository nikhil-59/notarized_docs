import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myknott/Views/Services/Services.dart';

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
                              child: CachedNetworkImage(
                                imageUrl: userInfo['notary']['userImageURL'],
                                height: 80,
                                width: 80,
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
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "A Short Description of ${userInfo['notary']["firstName"]}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
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
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              initialValue: userInfo['notary']
                                      ['phoneCountryCode'] +
                                  " " +
                                  userInfo['notary']['phoneNumber'],
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
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              initialValue: userInfo['notary']['email'],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                color: Colors.blue.shade800,
                                onPressed: () {},
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: Center(
                                    child: Text(
                                      "Update Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Note: To edit other details, Please log in from your webbrowser. visit www.notarizeddocs.com/notary",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.5),
                            ),
                            SizedBox(
                              height: 5,
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
              child: Text(
                "Please Wait ...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
