import '../base_model.dart';

class OrderStatus extends BaseModel<OrderStatus> {
  Status current;
  List<Status> values = List();

  OrderStatus() : super('OrderStatus');

  OrderStatus.fromMap(Map<dynamic, dynamic>  map) : super('OrderStatus') {
    objectId = map["objectId"];
    current = map["current"] == null ? null : Status.fromMap(map["current"]);
    values = map["values"] == null ?
    null :
    List.from(map["values"]).map<Status>((e) => Status.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = objectId;
    map["current"] = current == null ? null : current.toMap();
    map["values"] = values == null ? null : values.map((e) => e.toMap()).toList();
    return map;
  }

  bool isFirst() {
    return current.name == values.first.name;
  }

  bool isLast() {
    return current.name == values.last.name;
  }

}

class Status extends BaseModel<Status> {
  String name;
  DateTime date;

  Status(this.name) : super('Status');

  Status.fromMap(Map<dynamic, dynamic>  map) : super('Status') {
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