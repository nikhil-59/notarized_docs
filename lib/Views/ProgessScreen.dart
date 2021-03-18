import 'package:flutter/material.dart';
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
            indicatorColor: Colors.blue.shade900,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.tab,
            enableFeedback: true,
            labelStyle: TextStyle(fontSize: 17),
            unselectedLabelStyle: TextStyle(fontSize: 17),
            tabs: [
              Tab(
                child: Text(
                  "In Progress",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
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
          ),
          CompletedOrderScreen(
            notaryId: widget.notaryId,
          ),
        ],
      ),
    );
  }
}
