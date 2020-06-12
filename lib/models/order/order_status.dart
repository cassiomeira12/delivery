import '../base_model.dart';

class OrderStatus extends BaseModel<OrderStatus> {
  Status current;
  List<Status> values = List();

  OrderStatus() {
    values.add(Status("Pedido enviado"));
    values.add(Status("Pedido confirmado"));
    values.add(Status("Pedido em preparo"));
    values.add(Status("Pedido pronto"));
    values.add(Status("Pedido saiu pra entrega"));
    values.add(Status("Pedido entregue"));
    current = values[0];
  }

  OrderStatus.fromMap(Map<dynamic, dynamic>  map) {
    current = Status.fromMap(map["current"]);
    values = List.from(map["values"]).map<Status>((e) => Status.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["current"] = current.toMap();
    map["values"] = values.map((e) => e.toMap()).toList();
    return map;
  }

  @override
  update(OrderStatus item) {
    current = item.current;
    values = item.values;
  }

  bool isFirst() {
    return current.name == values.first.name;
  }

  bool isLast() {
    return current.name == values.last.name;
  }

}

class Status {
  String name;
  DateTime date;

  Status(this.name);

  Status.fromMap(Map<dynamic, dynamic>  map) {
    name = map["name"];
    date = map["date"] == null ? null : DateTime.parse(map["date"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["date"] = date == null ? null : date.toString();
    return map;
  }

}