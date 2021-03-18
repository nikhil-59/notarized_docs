import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myknott/Views/Services/Services.dart';
import 'package:myknott/Views/secondScreen.dart';

class InProgressOrderScreen extends StatefulWidget {
  final String notaryId;

  const InProgressOrderScreen({Key key, this.notaryId}) : super(key: key);

  @override
  _InProgressOrderScreenState createState() => _InProgressOrderScreenState();
}

class _InProgressOrderScreenState extends State<InProgressOrderScreen>
    with AutomaticKeepAliveClientMixin<InProgressOrderScreen> {
  Map orders = {};
  getInProgressOrders() async {
    orders.clear();
    setState(() {});
    orders.addAll(await NotaryServices().getInProgressOrders(widget.notaryId));
    setState(() {});
    print(widget.notaryId);
  }

  @override
  void initState() {
    super.initState();
    getInProgressOrders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getInProgressOrders(),
      child: orders.isNotEmpty
          ? ListView.builder(
              shrinkWrap: false,
              // physics: BouncingScrollPhysics(),
              itemCount: orders["orderCount"],
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    ListTile(
                      tileColor: Colors.white,

                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SecondScreen(
                            isPending: false,
                            notaryId: widget.notaryId,
                            orderId: orders['orders'][index]['_id'],
                          ),
                        ),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: orders['orders'][index]["customer"]
                              ['userImageURL'],
                          height: 40,
                          width: 40,
                        ),
                      ),
                      // orders['orders'][index]["customer"]['userImageURL']),
                      title: Text(
                        orders['orders'][index]["customer"]['firstName'] +
                            " " +
                            orders['orders'][index]["customer"]['lastName'],
                        style: TextStyle(fontSize: 16.5),
                      ),
                      subtitle: Text(
                        "Order Placed at ${DateFormat('MMM, d, y hh:mm a').format(DateTime.parse(orders['orders'][index]['createdAt']))} ",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                );
              },
            )
          : Container(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
