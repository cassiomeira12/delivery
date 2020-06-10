import 'package:flutter/material.dart';

class StarsWidget extends StatefulWidget {
  int stars;
  final int maxStarts;
  final double size;

  StarsWidget({
    this.stars,
    this.maxStarts = 5,
    this.size = 20,
  });

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
      for (var i = 0; i < widget.maxStarts && i < widget.stars; i++) {
        //listaEstrelas.add(startItem(i));
        listaEstrelas.insert(i, startItem(i));
      }
      if (starBorder > 0) {
        for (var i = 0; i < starBorder; i++) {
          //listaEstrelas.add(startItem(i));
          listaEstrelas.insert(i, startItem(i));
        }
      }
    });
  }

  Widget startItem(int index) {
    return GestureDetector(
      child: Icon(
        widget.stars <= index ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: widget.size,
      ),
      onTap: () {
        setState(() {
          print(index);
          widget.stars = index;
          buildStarList();
        });
      },
    );
  }

}
