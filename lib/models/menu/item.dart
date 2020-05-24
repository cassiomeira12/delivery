import '../base_model.dart';

class Item extends BaseModel<Item> {
  String name;
  String description;
  int cost;
  int discount;
  List<String> images;
  List<Size> sizes;
  List<Ingredient> ingredientes;

  Item();

  Item.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    name = map["name"];
    description = map["description"];
    cost = map["cost"] as int;
    discount = map["discount"] as int;
    //images
    //sizes
    //ingredites
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    map["cost"] = cost;
    map["discount"] = discount;
    //images
    //sizes
    //ingredientes
    return map;
  }

  @override
  update(Item item) {
    id = item.id;
    name = item.name;
    description = item.description;
    cost = item.cost;
    discount = item.discount;
    //images
    //zies
    //inggre
  }

}

class Size {
  String name;
  String description;

  Size();

  Size.fromMap(Map<dynamic, dynamic>  map) {
    name = map["name"];
    description = map["description"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    return map;
  }

}

class Ingredient {
  String name;
  String description;
  double cost;

  Ingredient.fromMap(Map<dynamic, dynamic>  map) {
    name = map["name"];
    description = map["description"];
    cost = map["description"] as double;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["description"] = description;
    map["cost"] = cost;
    return map;
  }

}