import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  String assetsImage;
  final String message;

  EmptyListWidget({
    @required this.message,
    this.assetsImage,
  }) : assert(message != null);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        assetsImage != null ?
        Container(
          width: 80,
          height: 80,
          child: Image.asset(assetsImage),
        ) : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        )
      ],
    );
  }
}
