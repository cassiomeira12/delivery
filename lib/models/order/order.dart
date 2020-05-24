import '../base_model.dart';

class Order extends BaseModel<Order> {
  String name;
  String idState;
  String nameState;
  String codeState;

  Order();

  Order.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    name = map["name"];
    idState = map["idState"];
    nameState = map["nameState"];
    codeState = map["codeState"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["idState"] = idState;
    map["nameState"] = nameState;
    map["codeState"] = codeState;
    return map;
  }

  @override
  update(Order item) {
    id = item.id;
    name = item.name;
    idState = item.idState;
    nameState = item.nameState;
    codeState = item.codeState;
  }

}