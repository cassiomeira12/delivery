import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
