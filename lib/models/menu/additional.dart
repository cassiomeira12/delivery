import 'item.dart';

class Additional extends Item {
  int amount = 0;
  int maxQuantity;

  Additional();

  Additional.fromMap(Map<dynamic, dynamic>  map) {
    name = map["name"];
    description = map["description"];
    cost = (map["cost"] as num).toDouble();
    amount = map["amount"] == null ? 0 : (map["amount"] as num).toInt();
    maxQuantity = map["maxQuantity"] as int;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["cost"] = cost;
    map["amount"] = amount;
    map["maxQuantity"] = maxQuantity;
    return map;
  }

//  update(Additional item) {
//    name = item.name;
//    description = item.description;
//    cost = item.cost;
//  }

}