import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorScreens extends StatelessWidget {
  String imageURL, errorTitle, errorsub;
  bool isUrL;
  ErrorScreens(this.imageURL, this.errorTitle, this.errorsub, this.isUrL);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: 500,
          // color: Colors.amberAccent,
          width: MediaQuery.of(context).size.width - 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isUrL
                  ? Image.network(
                      imageURL,
                      width: MediaQuery.of(context).size.width - 80,
                      height: 300,
                    )
                  : Image.asset(
                      imageURL,
                      width: MediaQuery.of(context).size.width - 80,
                      height: 300,
                    ),
              SizedBox(
                height: 15,
              ),
              Text(
                errorTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Linkify(
                onOpen: _onOpen,
                text: errorsub,
                options: LinkifyOptions(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _onOpen(LinkableElement link) async {
  if (await canLaunchUrl(Uri.parse(link.url))) {
    await launchUrl(Uri.parse(link.url));
  } else {
    print("Could not launch url 203 userProfile");
  }
}
