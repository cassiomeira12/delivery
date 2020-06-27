import '../strings.dart';
import '../widgets/light_button.dart';
import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  String assetsImage;
  final String message;
  final VoidCallback onPressed;

  EmptyListWidget({
    @required this.message,
    this.assetsImage,
    this.onPressed,
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
        ),
        onPressed != null ?
          Padding(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: Center(
              child: LightButton(
                  text: TRY_AGAIN,
                  onPressed: onPressed
              ),
            ),
          ) : Container(),
      ],
    );
  }
}
