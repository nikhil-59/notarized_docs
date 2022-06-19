import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:myknott/Config/CustomColors.dart';
import 'package:myknott/Views/OrderScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Cards extends StatelessWidget {
  final String name;
  final String time;
  final String phone;
  final String notaryId;
  final String orderId;
  // final String imageUrl;
  final String place;
  final String notaryName;
  const Cards(
      {Key key,
      this.name,
      @required this.place,
      this.time,
      this.notaryId,
      this.orderId,
        this.notaryName,
      // @required this.imageUrl,
      this.phone})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color blueColor = CustomColor().blueColor;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 0),
            pageBuilder: (context, a, b) => OrderScreen(
              isPending: false,
              notaryId: notaryId,
              orderId: orderId,
              messageTrigger: false,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        elevation: 3,
        child: Container(
          width: MediaQuery.of(context).size.width - 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await launch("tel:$phone");
                        },
                        child: Image.asset(
                          "assets/caller.png",
                          height: 36,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () async {

                          String body =
                              "Hello signer $name,\n\nMy name is $notaryName. I have been assigned as your signing agent for your upcoming closing.\n\nSigning Date:  $time \n\nSigning Location : $place \n\nPlease remember to have two valid forms of identification.\n\nPlease Reply Back to Confirm, or Call 702.530.2495\n\nThank you have a great day";
                          await launch('sms:$phone?body=$body');
                        },
                        child: Image.asset(
                          'assets/chat.png',
                          height: 36,
                        ),
                      )
                    ],
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        place ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15.5, color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        time ?? "",
                        style: TextStyle(fontSize: 15.5, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
                child: Container(
                  color: blueColor,
                  height: 45,
                  child: Center(
                      child: Text(
                    "Update Status",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
