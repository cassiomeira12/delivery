import '../../widgets/image_network_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/menu/product.dart';

class ProductWidget extends StatefulWidget {
  final dynamic item;
  final ValueChanged<Product> onPressed;

  const ProductWidget({
    this.item,
    this.onPressed,
  });

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  Product product;

  String imageProduct;

  @override
  void initState() {
    super.initState();
    product = widget.item as Product;
    imageProduct = product.images.isEmpty ? null : product.images[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),),
        color: true ? Theme.of(context).backgroundColor : Theme.of(context).primaryColorLight,
        child: Row(
          children: [
            ImageNetworkWidget(url: imageProduct, size: 72,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleTextWidget(product.name),
                  product.description == null ? Container() :
                  descriptionTextWidget(product.description),
                  product.cost > 0 ? costTextWidget(product.cost) : Container(),
                ],
              ),
            ),
            FaIcon(FontAwesomeIcons.angleRight, color: Theme.of(context).iconTheme.color,),
          ],
        ),
        onPressed: () {
          widget.onPressed(product);
        },
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
        "R\$ ${cost.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 20,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
