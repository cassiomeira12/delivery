import 'package:flutter/material.dart';

class CountWidget extends StatefulWidget {
  final ValueChanged<int> changedCount;
  final double size;

  int initialValue, minValue, maxValue;

  CountWidget({
    @required this.changedCount,
    this.size = 35,
    this.initialValue = 1,
    this.minValue,
    this.maxValue,
  }): assert(size >= 25);

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  int _count;
  
  @override
  void initState() {
    super.initState();
    _count = widget.initialValue;
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

  void increment() {
    if (widget.maxValue != null) {
      if (_count < widget.maxValue) {
        setState(() {
          _count++;
          widget.changedCount(_count);
        });
      }
    }
  }

  void decrement() {
    if (widget.minValue != null) {
      if (_count > widget.minValue) {
        setState(() {
          _count--;
          widget.changedCount(_count);
        });
      }
    }
  }

  Widget botaoMenos() {
    return Container(
      width: widget.size,
      height: widget.size,
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
        onTap: decrement,
      ),
    );
  }

  Widget quantidade() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        _count.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget botaoMais() {
    return Container(
      width: widget.size,
      height: widget.size,
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
        onTap: increment,
      ),
    );
  }

}
