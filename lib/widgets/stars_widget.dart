import 'package:flutter/material.dart';

class StarsWidget extends StatefulWidget {
  int stars;
  final int maxStarts;
  final double size;
  final bool press;

  StarsWidget({
    this.stars,
    this.maxStarts = 5,
    this.size = 20,
    this.press = false,
  }) : assert(stars <= maxStarts);

  @override
  _StarsWidgetState createState() => _StarsWidgetState();
}

class _StarsWidgetState extends State<StarsWidget> {
  int starBorder;
  List<Widget> listaEstrelas = List();

  @override
  void initState() {
    super.initState();
    buildStarList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listaEstrelas,
    );
  }

  void buildStarList() {
    starBorder = widget.maxStarts - widget.stars;
    listaEstrelas.clear();
    setState(() {
      for (int i = 1; i <= widget.maxStarts; i++) {
        listaEstrelas.add(startItem(i));
      }
    });
  }

  Widget startItem(int index) {
    return GestureDetector(
      child: Icon(
        index <= widget.stars ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: widget.size,
      ),
      onTap: () {
        if (widget.press) {
          setState(() {
            print(index);
            widget.stars = index;
            buildStarList();
          });
        }
      },
    );
  }

}
