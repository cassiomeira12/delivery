import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../models/menu/choice.dart';
import '../../models/menu/item.dart';

class ChoiceWidget extends StatefulWidget {
  Item selectedItem;

  final Choice choice;
  final ValueChanged<Item> onItemSelected;

  ChoiceWidget(this.choice, this.onItemSelected);

  @override
  _ChoiceWidgetState createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "${widget.choice.name}",
                ),
                widget.choice.required ?
                Text(
                  "*",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ) : Container(),
              ],
            ),
            widget.choice.description != null ?
            Text(
              widget.choice.description,
              style: Theme.of(context).textTheme.body2,
            ) : Container(),
          ],
        ),
      ),
      content: Column(
        children: widget.choice.itens.map((e) {
          return Column(
            children: [
              choiceItemWidget(e),
              Divider(color: Colors.grey, height: 0,),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget choiceItemWidget(Item item) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(10, 2.5, 0, 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.body1,
                ),
                item.description != null ?
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.body2,
                ) : Container(),
              ],
            ),
          ),
          Row(
            children: [
              item.cost != null && item.cost != 0 ?
              Text(
                "R\$ ${item.cost.toStringAsFixed(2)}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ) : Container(),
              Radio(
                value: item,
                groupValue: widget.selectedItem,
                activeColor: Theme.of(context).primaryColor,
                toggleable: true,
                onChanged: (value) {
                  if (widget.selectedItem != null && widget.selectedItem == item) {
                    setState(() {
                      widget.selectedItem = null;
                      var temp = Item();
                      temp.cost = -item.cost;
                      widget.onItemSelected(temp);
                    });
                  } else {
                    if (widget.selectedItem != null) {
                      var temp = Item();
                      temp.cost = -widget.selectedItem.cost;
                      widget.onItemSelected(temp);
                    }
                    setState(() {
                      widget.selectedItem = item;
                      widget.onItemSelected(item);
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      onPressed: () {
        if (widget.selectedItem != null && widget.selectedItem == item) {
          setState(() {
            widget.selectedItem = null;
            var temp = Item();
            temp.cost = -item.cost;
            widget.onItemSelected(temp);
          });
        } else {
          if (widget.selectedItem != null) {
            var temp = Item();
            temp.cost = -widget.selectedItem.cost;
            widget.onItemSelected(temp);
          }
          setState(() {
            widget.selectedItem = item;
            widget.onItemSelected(item);
          });
        }
      },
    );
  }

}
