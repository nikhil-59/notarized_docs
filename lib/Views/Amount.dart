import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:myknott/VIews/secondScreen.dart';
import 'package:myknott/Views/Services/Services.dart';

class AmountScreen extends StatefulWidget {
  final String notaryId;

  const AmountScreen({Key key, this.notaryId}) : super(key: key);
  @override
  _AmountScreenState createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen>
    with AutomaticKeepAliveClientMixin<AmountScreen> {
  Map map = {};
  int i = 0;
  int totalpage = 0;
  bool hasMore = false;
  bool isloading = true;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    map.clear();
    setState(() {
      i = 0;
      isloading = true;
      hasMore = false;
    });
    map = await NotaryServices().getEarnings(widget.notaryId, i);
    if (i == map['pageNumber']) {
      hasMore = true;
      print("true");
    }
    print(map);
    i += 1;
    setState(() {
      totalpage = map['pageNumber'];
      isloading = false;
    });
  }

  getmoreData() async {
    var response = await NotaryServices().getEarnings(widget.notaryId, i);
    map['payouts'].addAll(response['payouts']);
    map['customers'].addAll(response['customers']);
    if (response['pageCount'] == response['pageNumber']) {
      hasMore = true;
      print("true");
    } else {
      i = i + 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Notary Pay",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: !isloading
          ? RefreshIndicator(
              onRefresh: () => getData(),
              child: LazyLoadScrollView(
                onEndOfPage: getmoreData,
                isLoading: hasMore,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: SafeArea(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 0.2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/wallet.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Earnings ",
                                            style: TextStyle(
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 42,
                                          ),
                                          Text(
                                            ":  \$ ${map['paidAmount']}",
                                            style: TextStyle(
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pending Earnings ",
                                            style: TextStyle(
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            ":  \$ ${map['dueAmount']}",
                                            style: TextStyle(
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: map["payoutCount"],
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SecondScreen(
                                      isPending: false,
                                      notaryId: widget.notaryId,
                                      orderId: map['payouts'][index]['order']
                                          ['_id'],
                                    ),
                                  ),
                                ),
                                child: Card(
                                  elevation: 0.1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: map['notary']['userImageURL'] !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: map['customers'][index]
                                                          ['userImageURL'] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          "${map['customers'][index]['userImageURL']}",
                                                      height: 45,
                                                      width: 45,
                                                    )
                                                  : Container(
                                                      height: 45,
                                                      width: 45,
                                                    ),
                                            )
                                          : Container(),
                                      title: Text(
                                        "Refinance of ${map['customers'][index]['firstName'] + " " + map['customers'][index]['lastName']}",
                                        style: TextStyle(
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "A short description of order with some short text",
                                              style: TextStyle(fontSize: 16.5),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$ ${map['payouts'][index]['amount']}",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.8),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                map['payouts'][index]['paid']
                                                    ? MaterialButton(
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        color: Colors
                                                            .blue.shade800,
                                                        onPressed: () {},
                                                        child: Container(
                                                          child: Text(
                                                            "Paid",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      )
                                                    : MaterialButton(
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        color: Colors
                                                            .yellow.shade800,
                                                        onPressed: () {},
                                                        child: Container(
                                                          child: Text(
                                                            "Pending",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
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
