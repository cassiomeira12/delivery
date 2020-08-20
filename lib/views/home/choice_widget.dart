import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../models/menu/choice.dart';
import '../../models/menu/item.dart';

class ChoiceWidget extends StatefulWidget {
  Item _lastSelectedItem;
  List<Item> _selectedItems;

  final Choice choice;
  final ValueChanged<Item> onItemSelected;

  ChoiceWidget(this.choice, this.onItemSelected);

  bool isEmpty() {
    return getItemsSelected().isEmpty;
  }

  List<Item> getItemsSelected() {
    List<Item> result = List();
    for (Item item in _selectedItems) {
      if (item != null) {
        result.add(item);
      }
    }
    return result;
  }

  double getTotalChoicesSelected() {
    double total = 0;
    var items = getItemsSelected();
    for (var item in items) {
      total += item.cost;
    }
    return total;
  }

  @override
  _ChoiceWidgetState createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  int itemsSelected = 0;

  @override
  void initState() {
    super.initState();
    widget._selectedItems = List(widget.choice.itens.length);
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return StickyHeader(
      header: Container(
        color: Colors.grey[300],
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
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
                Expanded(
                  child: Text(
                    "$itemsSelected/${widget.choice.maxQuantity}",
                    style: TextStyle(
                      color: itemsSelected >= widget.choice.minQuantity ?
                        Colors.green
                          :
                        widget.choice.required ? Colors.red : Colors.black54,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            widget.choice.description != null ?
              Text(
                widget.choice.description,
                style: Theme.of(context).textTheme.body2,
              ) : Container(),
            widget.choice.required && itemsSelected < widget.choice.minQuantity?
              Text(
                "Escolha no mínimo ${widget.choice.minQuantity} ${widget.choice.minQuantity > 1 ? "itens." : "item."}",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16
                ),
              ) : Container(),
          ],
        ),
      ),
      content: Column(
        children: widget.choice.itens.map((e) {
          return e.visible ? Column(
            children: [
              choiceItemWidget(e, index++),
              Divider(color: Colors.grey, height: 0,),
            ],
          ) : Container();
        }).toList(),
      ),
    );
  }

  Widget choiceItemWidget(Item item, final int index) {
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
                groupValue: widget.choice.maxQuantity > 1 ? widget._selectedItems[index] : widget._lastSelectedItem,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) => selectItem(item, index),
              ),
            ],
          ),
        ],
      ),
      onPressed: () => selectItem(item, index),
    );
  }

  void selectItem(Item item, int index) {
    if (widget.choice.maxQuantity == 1) {
      if (widget._lastSelectedItem == null) { // Novo
        setState(() {
          itemsSelected++;
          widget._lastSelectedItem = item;
          widget._selectedItems[index] = item;
          returnAddValue(item);
        });
      } else if (widget._lastSelectedItem == item) { // Remove
        setState(() {
          itemsSelected--;
          index = widget._selectedItems.indexOf(widget._lastSelectedItem);
          widget._selectedItems[index] = null;
          widget._lastSelectedItem = null;
          returnRemoveValue(item);
        });
      } else { // Troca
        setState(() {
          int lastIndex = widget._selectedItems.indexOf(widget._lastSelectedItem);
          widget._selectedItems[lastIndex] = null;
          returnRemoveValue(widget._lastSelectedItem);
          widget._lastSelectedItem = item;
          widget._selectedItems[index] = item;
          returnAddValue(item);
        });
      }
    } else {
      if (widget._selectedItems[index] == null) {
        if (itemsSelected < widget.choice.maxQuantity) { // Adiciona
          setState(() {
            itemsSelected++;
            widget._lastSelectedItem = item;
            widget._selectedItems[index] = item;
            returnAddValue(item);
          });
        } else { // Troca
          setState(() {
            int lastIndex = widget._selectedItems.indexOf(widget._lastSelectedItem);
            widget._selectedItems[lastIndex] = null;
            returnRemoveValue(widget._lastSelectedItem);
            widget._lastSelectedItem = item;
            widget._selectedItems[index] = item;
            returnAddValue(item);
          });
        }
      } else { // Remove
        setState(() {
          itemsSelected--;
          widget._lastSelectedItem = null;
          widget._selectedItems[index] = null;
          returnRemoveValue(item);
        });
      }
    }
  }

  void returnAddValue(Item item) {
    widget.onItemSelected(item);
  }

  void returnRemoveValue(Item item) {
    var temp = Item.fromMap(item.toMap());
    temp.cost = -item.cost;
    widget.onItemSelected(temp);
  }

}
