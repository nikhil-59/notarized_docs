import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:myknott/Services/Services.dart';
import 'package:myknott/Views/OrderScreen.dart';

class InProgressOrderScreen extends StatefulWidget {
  final String notaryId;
  final Function updateTotal;

  const InProgressOrderScreen({Key key, this.notaryId, this.updateTotal})
      : super(key: key);

  @override
  _InProgressOrderScreenState createState() => _InProgressOrderScreenState();
}

class _InProgressOrderScreenState extends State<InProgressOrderScreen>
    with AutomaticKeepAliveClientMixin<InProgressOrderScreen> {
  Map orders = {};
  bool hasData = false;
  int pageNumber = 0;
  getInProgressOrders() async {
    setState(() {
      pageNumber = 0;
      hasData = false;
    });
    try {
      orders.clear();
      var response = await NotaryServices()
          .getInProgressOrders(widget.notaryId, pageNumber);
      orders.addAll(response);
      widget.updateTotal(response['appointments'].length);
      if (response['pageNumber'] == response['pageCount']) {
        hasData = true;
      } else
        pageNumber += 1;
    } catch (e) {
      print("Error on 40 inProgressOrderscreen.dart $e \n");
    }
    setState(() {});
  }

  getMoreData() async {
    try {
      var response = await NotaryServices()
          .getInProgressOrders(widget.notaryId, pageNumber);
      print("47 inProgressOrders");
      print(response['appointmentCount']);
      orders['orders'].addAll(response['orders']);
      if (response['pageNumber'] == response['pageCount']) {
        hasData = true;
      } else {
        pageNumber += 1;
      }
    } catch (e) {
      print("Error line 58 On Getmore Data inprogressOS.dart \n $e\n ");
    }
    setState(() {});
  }

  @override
  void initState() {
    NotaryServices().getToken();
    super.initState();
    getInProgressOrders();
  }

  @override
  Widget build(BuildContext context) {
    return orders.isNotEmpty
        ? Scaffold(
            backgroundColor: Colors.grey.shade50,
            body: LazyLoadScrollView(
              onEndOfPage: getMoreData,
              isLoading: hasData,
              child: RefreshIndicator(
                color: Colors.black,
                onRefresh: () => getInProgressOrders(),
                child: ListView.builder(
                  itemCount: orders['appointmentCount'] != 0
                      ? orders['appointmentCount']
                      : 1,
                  itemBuilder: (BuildContext context, int index) {
                    // orders.forEach((k, v) => print("upComing order $k :$v"));
                    return orders['appointments'].isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 2,
                                    ),
                                    ListTile(
                                      tileColor: Colors.white,
                                      onTap: () => Navigator.of(context).push(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(seconds: 0),
                                          pageBuilder: (_, __, ___) =>
                                              OrderScreen(
                                            isPending: false,
                                            notaryId: widget.notaryId,
                                            orderId: orders['appointments']
                                                [index]['_id'],
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "#" +
                                                orders['appointments'][index]
                                                            ['signingInfo']
                                                        ['escrowNumber']
                                                    .toString(),
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                orders['appointments'][index]
                                                                ["signingInfo"]
                                                            ['signerInfo']
                                                        ['fisrtName'] +
                                                    " " +
                                                    orders['appointments']
                                                                    [index]
                                                                ["signingInfo"]
                                                            ['signerInfo']
                                                        ['lastName'],
                                                style: TextStyle(
                                                    fontSize: 16.5,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.call,
                                                    size: 25,
                                                    color: Colors.blueAccent,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Property Address",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            orders['appointments'][index]
                                                    ['signingInfo']
                                                ['propertyAddress'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          ListTile(
                                            horizontalTitleGap: 10,
                                            leading: Image.asset(
                                              "assets/location.png",
                                              height: 40,
                                            ),
                                            contentPadding: EdgeInsets.all(0),
                                            title: Text(
                                              orders['appointments'][index]
                                                      ['appointmentInfo']
                                                  ['place']['completeAddress'],

                                              // widget.place,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Appointment Date & Time : " +
                                                      DateFormat("MM/dd/yyyy")
                                                          .format(
                                                              DateTime.parse(
                                                        orders['appointments']
                                                                    [index][
                                                                'appointmentInfo']
                                                            ['date'],
                                                      ).toLocal()) +
                                                      getTime(orders['appointments']
                                                                  [index][
                                                              'appointmentInfo']
                                                          ['time']),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
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
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                AppBar().preferredSize.height -
                                200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/appointment1.png",
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Text(
                                    "You don't have any  Upcoming Appointments",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black.withOpacity(0.8),
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          );
                  },
                ),
              ),
            ),
          )
        : Container(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

getTime(int ss) {
  String hh, mm;
  var s = ss.toString();
  if (s.length % 2 == 0) {
    hh = s[0] + s[1];
    mm = s[2] + s[3];
  } else {
    hh = '0' + s[0];
    mm = s[1] + s[2];
  }

  // hh = (ss / 10000).toStringAsFixed(0);
  // // hh=
  // int.parse(hh) / 10 < 1 ? hh = '0' + hh : hh = hh;
  // mm = (ss / 100).toString();

  return " @ $hh : $mm";
}
