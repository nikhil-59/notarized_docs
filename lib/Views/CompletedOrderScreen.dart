import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:myknott/Views/Services/Services.dart';
import 'package:myknott/Views/secondScreen.dart';

class CompletedOrderScreen extends StatefulWidget {
  final String notaryId;

  const CompletedOrderScreen({Key key, this.notaryId}) : super(key: key);
  @override
  _CompletedOrderScreenState createState() => _CompletedOrderScreenState();
}

class _CompletedOrderScreenState extends State<CompletedOrderScreen>
    with AutomaticKeepAliveClientMixin<CompletedOrderScreen> {
  Map orders = {};
  int pageNumber = 0;
  bool hasData = false;
  String notaryId;
  getCompletedOrders() async {
    orders.clear();
    setState(() {
      pageNumber = 0;
      hasData = false;
    });
    var response =
        await NotaryServices().getCompletedOrders(widget.notaryId, pageNumber);
    orders.addAll(response);
    if (response['pageNumber'] == response['pageCount']) {
      hasData = true;
      print("-----------end of list----------");
    } else {
      pageNumber += 1;
    }
    setState(() {});
  }

  getMoreData() async {
    var response =
        await NotaryServices().getCompletedOrders(widget.notaryId, pageNumber);
    orders['orders'].addAll(response['orders']);
    print(response['orders']);
    if (response['pageNumber'] == response['pageCount']) {
      hasData = true;
      print("-----------end of list----------");
    } else {
      pageNumber += 1;
    }
    setState(() {});
  }

  List data = [];
  @override
  void initState() {
    getCompletedOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orders.isNotEmpty
        ? LazyLoadScrollView(
            isLoading: hasData,
            onEndOfPage: getMoreData,
            child: RefreshIndicator(
              onRefresh: () async {
                await getCompletedOrders();
              },
              child: ListView.builder(
                itemCount: orders["orderCount"],
                // physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 2,
                      ),
                      ListTile(
                        isThreeLine: true,
                        tileColor: Colors.white,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: orders['orders'][index]["customer"]
                                      ['userImageURL'] !=
                                  null
                              ? CachedNetworkImage(
                                  imageUrl: orders['orders'][index]["customer"]
                                      ['userImageURL'],
                                  height: 40,
                                  width: 40,
                                )
                              : Container(
                                  height: 40,
                                  width: 40,
                                ),
                        ),
                        // visualDensity: VisualDensity.comfortable,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SecondScreen(
                              isPending: false,
                              notaryId: widget.notaryId,
                              orderId: orders['orders'][index]['_id'],
                            ),
                          ),
                        ),
                        // orders['orders'][index]["customer"]['userImageURL']),
                        title: Text(
                          orders['orders'][index]["customer"]['firstName'] +
                              " " +
                              orders['orders'][index]["customer"]['lastName'],
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Order Placed at ${DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.parse(orders['orders'][index]['createdAt']))} ",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Delivered at ${DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.parse(orders['orders'][index]['deliveredAt']))} ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  );
                },
              ),
            ),
          )
        : Container();
  }

  @override
  bool get wantKeepAlive => true;
}
