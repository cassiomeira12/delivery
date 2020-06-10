import 'package:flutter/material.dart';

class RoundedShape extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  const RoundedShape({
    this.padding,
    @required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding == null ? EdgeInsets.fromLTRB(0, 0, 0, 0) : padding,
      decoration: BoxDecoration(
        color: color == null ? Theme.of(context).backgroundColor : color,
        border: Border.all(
          width: 1,
          color: Theme.of(context).hintColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        )
      ),
      child: child,
    );
  }

}