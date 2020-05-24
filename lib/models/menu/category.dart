import '../base_model.dart';
import 'item.dart';

class Category extends BaseModel<Category> {
  String name;
  List<Item> itens;

  Category();

  Category.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    name = map["name"];
    itens = List.from(map["itens"]).map<Item>((e) => Item.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["itens"] = itens.map<Map>((e) => e.toMap()).toList();
    return map;
  }

  @override
  update(Category item) {
    id = item.id;
    name = item.name;
    itens = item.itens;
  }

}