import 'package:flutter/material.dart';
import '../../models/menu/item.dart';

class ItemWidget extends StatefulWidget {
  final dynamic item;
  final ValueChanged<Item> onPressed;

  const ItemWidget({
    this.item,
    this.onPressed,
  });

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {

  Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item as Item;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),),
        color: true ? Theme.of(context).backgroundColor : Theme.of(context).primaryColorLight,
        child: Row(
          children: [
            imageNetworkURL("https://lh3.googleusercontent.com/a-/AOh14GinABYyLb06MGSzuEsE2tuNDmgyMSuFsWjE7DITKg=s96-c"),
            Expanded(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleTextWidget("Hamburguer"),
                  descriptionTextWidget("Generosa camadas de creme suíço, creme de chocolate e creme de ninho creme de chocolate e creme de ninho"),
                  costTextWidget(13.0),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          widget.onPressed(item);
        }
      ),
    );
  }

  Widget imageNetworkURL(String url) {
    return Container(
      width: 72,
      height: 72,
      margin: EdgeInsets.only(top: 2, right: 4),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Theme.of(context).hintColor,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }

  Widget titleTextWidget(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget descriptionTextWidget(String description) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        description,
        textAlign: TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget costTextWidget(double cost) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        "R\$ ${cost}",
        style: TextStyle(
          fontSize: 20,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
