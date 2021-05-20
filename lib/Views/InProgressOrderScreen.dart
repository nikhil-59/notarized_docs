import 'package:cached_network_image/cached_network_image.dart';
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
      widget.updateTotal(response['orderCount']);
      if (response['pageNumber'] == response['pageCount']) {
        hasData = true;
      } else
        pageNumber += 1;
    } catch (e) {}
    setState(() {});
  }

  getMoreData() async {
    try {
      var response = await NotaryServices()
          .getInProgressOrders(widget.notaryId, pageNumber);
      orders['orders'].addAll(response['orders']);
      if (response['pageNumber'] == response['pageCount']) {
        hasData = true;
      } else {
        pageNumber += 1;
      }
    } catch (e) {}
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
    print(orders);
    return orders.isNotEmpty
        ? LazyLoadScrollView(
            onEndOfPage: getMoreData,
            isLoading: hasData,
            child: RefreshIndicator(
              color: Colors.black,
              onRefresh: () => getInProgressOrders(),
              child: ListView.builder(
                itemCount:
                    orders['orders'].length != 0 ? orders['orders'].length : 1,
                itemBuilder: (BuildContext context, int index) {
                  return orders['orders'].isNotEmpty
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
                                          orderId: orders['orders'][index]
                                              ['_id'],
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
                                              orders['orders'][index]
                                                          ['appointment']
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
                                              orders['orders'][index]
                                                      ["appointment"]
                                                  ['signerFullName'],
                                              style: TextStyle(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "\$ " +
                                                  orders['orders'][index]
                                                          ['amount']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
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
                                          orders['orders'][index]['appointment']
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
                                            orders['orders'][index]
                                                ['appointment']['place'],

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
                                                    DateFormat(
                                                            "MM/dd/yyyy @ h a")
                                                        .format(
                                                      DateTime.parse(
                                                        orders['orders'][index]
                                                                ['appointment']
                                                            ['time'],
                                                      ).toLocal(),
                                                    ),
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
                                  "You don't have any In Progress orders",
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
