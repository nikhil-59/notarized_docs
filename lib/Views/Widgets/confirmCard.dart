import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myknott/Views/Services/Services.dart';

class ConfirmCards extends StatefulWidget {
  final Function refresh;
  final String notaryId;
  final String orderId;
  final String name;
  final String price;
  final String address;
  const ConfirmCards(
      {Key key,
      this.name,
      this.price,
      this.address,
      this.notaryId,
      this.orderId,
      this.refresh})
      : super(key: key);

  @override
  _ConfirmCardsState createState() => _ConfirmCardsState();
}

class _ConfirmCardsState extends State<ConfirmCards> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      // elevation: 3,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                maxRadius: 20,
                child: CachedNetworkImage(
                    imageUrl:
                        'https://cdn0.iconfinder.com/data/icons/avatar-78/128/12-512.png'),
              ),
              title: Text(
                widget.name,
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "\$ ${widget.price}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // visualDensity: VisualDensity.compact,
              // minVerticalPadding: 10,
              subtitle: Text(
                widget.address,
                style: TextStyle(fontSize: 15.5),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 120,
            height: 0.8,
            child: Text(""),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Colors.black.withOpacity(0.3), width: 0.8),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () async {
                  NotaryServices()
                      .declineNotary(widget.notaryId, widget.orderId);
                  await widget.refresh();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.yellow,
                child: Text(
                  "Decline",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  NotaryServices()
                      .acceptNotary(widget.notaryId, widget.orderId);
                  await widget.refresh();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.blue.shade900,
                child: Text(
                  "Accept",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
