import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PageRouter {

  static pop(BuildContext context, [ dynamic result ]) {
    Navigator.pop(context, result);
  }

  static push(BuildContext context, Widget route) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return route;
        }
      ),
    );
  }

}