// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myknott/Services/Services.dart';
import 'package:myknott/Views/InProgressOrderScreen.dart';
import 'package:myknott/Views/OrderScreen.dart';
import 'package:myknott/Views/Widgets/confirmCard.dart';
import 'package:myknott/Views/homePage.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NewAppointmentScreen extends StatefulWidget {
  var myPendingList;
  // Function updateTotalNewApp;
  var myUserInfo;
  NewAppointmentScreen(
      this.myPendingList, this.myUserInfo);

  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  Future<void> getData() async {
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "-----------------pendingList---------------------------\n ${widget.myPendingList} \n ----------");
    // widget.updateTotalNewApp(widget.myPendingList.length);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.purple,
        onRefresh: () async {
          await getData();
          initState();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              SizedBox(
                height: 30,
              ),
              Text("All Pending Appointments"),
              SizedBox(
                height: 20,
              ),
              widget.myPendingList != null
                  ? Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          // shrinkWrap: true,
                          itemCount: widget.myPendingList.length,
                          itemBuilder: (context, index) {
                            print(
                                " 64 newApp ${widget.myPendingList[index]['name']} ");
                            return Card(
                              elevation: 2,
                              child: Container(
                                // color: Colors.amberAccent,
                                height: 120,
                                // width: 16,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Image.asset(
                                          "assets/userr.png",
                                          width: 45,
                                          height: 40,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.myPendingList[index]
                                                  ['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              " by ----",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              getTime(
                                                  widget.myPendingList[index]
                                                      ['time']),
                                            ),
                                            // .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MaterialButton(
                                          splashColor: Colors.blue,
                                          shape: Border.all(),
                                          onPressed: () {},
                                          child: Center(
                                            child: Text(
                                              "Call Signer",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        MaterialButton(
                                            splashColor: Colors.blue,
                                            shape: Border.all(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text("View Details",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  : Center(
                      child: Text(
                      "List is empty",
                      style: TextStyle(fontSize: 56),
                    ))
            ]),
          ),
        ),
      ),
    )));
  }
}
