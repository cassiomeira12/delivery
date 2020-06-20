import '../base_model.dart';
import 'item.dart';

class Choice extends BaseModel<Choice> {
  String name;
  String description;
  bool required;
  int maxQuantity;
  int minQuantity;
  List<Item> itens;

  Choice() : super('Choice');

  Choice.fromMap(Map<dynamic, dynamic>  map) : super('Choice') {
    name = map["name"];
    description = map["description"];
    required = map["required"] == true;
    maxQuantity = map["maxQuantity"] as int;
    minQuantity = map["minQuantity"] as int;
    itens = List.from(map["itens"]).map<Item>((e) => Item.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["required"] = required;
    map["maxQuantity"] = maxQuantity;
    map["minQuantity"] = minQuantity;
    map["itens"] = itens.map<Map>((e) => e.toMap()).toList();
    return map;
  }

//  @override
//  update(Choice item) {
//    name = item.name;
//    description = item.description;
//    required = item.required;
//    maxQuantity = item.maxQuantity;
//    minQuantity = item.minQuantity;
//    itens = item.itens;
//  }

}