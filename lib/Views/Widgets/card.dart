import 'package:flutter/material.dart';
import 'package:myknott/Views/MapScreen.dart';
import 'package:myknott/Views/secondScreen.dart';

class Cards extends StatelessWidget {
  final String name;
  final String time;
  final String notaryId;
  final String orderId;
  const Cards({Key key, this.name, this.time, this.notaryId, this.orderId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 1,
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // SizedBox(
                //   width: 3,
                // ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  maxRadius: 20,
                  child: Image.asset('assets/avatar.webp'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 16.5, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 16.5, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.blue.shade900,
                  size: 35,
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 150,
              height: 0.4,
              child: Text(""),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.3), width: 0.4),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(fontSize: 15.5),
                    ),
                    Text(
                      "Arrived At appointment",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SecondScreen(
                          isPending: false,
                          notaryId: notaryId,
                          orderId: orderId,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "Update",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Status",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
