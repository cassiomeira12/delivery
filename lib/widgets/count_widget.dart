import 'package:flutter/material.dart';

class CountWidget extends StatefulWidget {
  final ValueChanged<int> changedCount;

  const CountWidget({this.changedCount});

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {

  int count = 1;
  double size = 40;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        botaoMenos(),
        quantidade(),
        botaoMais(),
      ],
    );
  }

  Widget botaoMenos(){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: GestureDetector(
        child: Center(
          child: Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        onTap: () {
          setState(() {
            count--;
          });
          widget.changedCount(count);
        }
      ),
    );
  }

  Widget quantidade(){
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text(
        count.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget botaoMais(){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: GestureDetector(
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onTap: () {
          setState(() {
            count++;
          });
          widget.changedCount(count);
        },
      ),
    );
  }

}
