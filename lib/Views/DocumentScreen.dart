import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentScreen extends StatelessWidget {
  final List documents;

  const DocumentScreen({Key key, this.documents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            documents.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.file,
                          size: 30,
                          color: Colors.orange.shade700,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Documents",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  )
                : Container(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          "${index + 1}.",
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          documents[index]['documentName'],
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await launch(documents[index]['documentURL']);
                      },
                      child: Text(
                        "View",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.purple.shade800),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
