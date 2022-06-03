
import 'package:flutter/material.dart';

class NoUserExist extends StatefulWidget {

  @override
  State<NoUserExist> createState() => _NoUserExistState();
}

class _NoUserExistState extends State<NoUserExist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("user not exist : refer tp this url "),
      ),
    );
  }
}
