import 'package:flutter/material.dart';
import 'package:myknott/Config/CustomColors.dart';
import 'package:myknott/Views/CompletedOrderScreen.dart';
import 'package:myknott/Views/InProgressOrderScreen.dart';

class ProgressScreen extends StatefulWidget {
  final String notaryId;

  const ProgressScreen({Key key, this.notaryId}) : super(key: key);
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  TabController tabController;
  String totalInProgress = "";
  String totalComplete = "";

  updatTotalInProgress(int order) {
    if (order == 0) {
      setState(() {
        totalInProgress = "";
      });
    } else
      setState(() {
        totalInProgress = "($order)";
      });
  }

  updatTotalComplete(int order) {
    if (order == 0) {
      setState(() {
        totalComplete = "";
      });
    } else
      setState(() {
        totalComplete = "($order)";
      });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: TabBar(
            physics: BouncingScrollPhysics(),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black.withOpacity(0.8),
            controller: tabController,
            indicatorColor: CustomColor().blueColor,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.tab,
            enableFeedback: true,
            labelStyle: TextStyle(fontSize: 17),
            unselectedLabelStyle: TextStyle(fontSize: 17),
            tabs: [
              Tab(
                child: Text(
                  "In Progress $totalInProgress",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "Completed $totalComplete",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        physics: BouncingScrollPhysics(),
        controller: tabController,
        children: [
          InProgressOrderScreen(
            notaryId: widget.notaryId,
            updateTotal: updatTotalInProgress,
          ),
          CompletedOrderScreen(
            notaryId: widget.notaryId,
            updateCompleted: updatTotalComplete,
          ),
        ],
      ),
    );
  }
}
