import '../../models/base_model.dart';
import 'item.dart';

class ChoiceSelected extends BaseModel<ChoiceSelected> {
  String name;
  String description;
  bool required;
  int maxQuantity;
  int minQuantity;
  List<Item> choiceSelected;

  ChoiceSelected() : super('ChoiceSelected') {
    choiceSelected = List();
  }

  ChoiceSelected.fromMap(Map<dynamic, dynamic>  map) : super('ChoiceSelected') {
    name = map["name"];
    description = map["description"];
    required = map["required"] as bool;
    maxQuantity = (map["maxQuantity"] as num).toInt();
    minQuantity = (map["minQuantity"] as num).toInt();
    choiceSelected = map["choiceSelected"] == null ? List() :
      List.from(map["choiceSelected"]).map<Item>((e) => Item.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["required"] = required;
    map["maxQuantity"] = maxQuantity;
    map["minQuantity"] = minQuantity;
    map["choiceSelected"] = choiceSelected.map<Map>((e) => e.toMap()).toList();
    return map;
  }

  @override
  String toString() {
    String result = "";
    for (var value in choiceSelected) {
      result += "${name} - ${value.name}";
      result += value.cost > 0 ? " R\$ ${value.cost.toStringAsFixed(2)}" : "";
    }
    return result;
  }

}