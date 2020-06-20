import '../base_model.dart';

class Item extends BaseModel<Item> {
  String name;
  String description;
  double cost;

  Item() : super('Item');

  Item.fromMap(Map<dynamic, dynamic>  map) : super('Item') {
    name = map["name"];
    description = map["description"];
    cost = map["cost"] == null ? null : (map["cost"] as num).toDouble();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["cost"] = cost;
    return map;
  }

//  @override
//  update(Item item) {
//    name = item.name;
//    description = item.description;
//    cost = item.cost;
//  }

  @override
  String toString() {
    return name + (description == null ? "" : " $description") + (cost == null ? "" : " R\$ ${cost.toStringAsFixed(2)}");
  }

}