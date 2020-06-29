import '../../models/base_user.dart';
import '../../models/menu/product.dart';
import '../../models/phone_number.dart';
import '../../models/company/company.dart';
import '../../models/order/order_item.dart';
import '../../models/address/address.dart';
import '../../models/company/type_payment.dart';
import '../../models/order/evaluation.dart';
import '../base_model.dart';
import 'order_status.dart';

class Order extends BaseModel<Order> {
  BaseUser user;
  String userName;
  Company company;
  String companyName;
  String note;
  Evaluation evaluation;
  Address deliveryAddress;
  TypePayment typePayment;
  List<OrderItem> items;
  OrderStatus status;
  String changeMoney;
  bool delivery;
  double deliveryCost;
  DeliveryForecast deliveryForecast;
  PreparationTime preparationTime;
  PhoneNumber companyPhoneNumber;
  PhoneNumber userPhoneNumber;
  bool canceled;

  Order() : super('Order') {
    items = List();
  }

  Order.fromMap(Map<dynamic, dynamic>  map) : super('Order') {
    objectId = map["objectId"];
    id = objectId;
    user = map["user"] == null ? null : BaseUser.fromMap(map["user"]);
    userName = map["userName"];
    company = map["company"] == null ? null : Company.fromMap(map["company"]);
    companyName = map["companyName"];
    createdAt = map["createdAt"] == null ? null : DateTime.parse(map["createdAt"]);
    updatedAt = map["updatedAt"] == null ? null : DateTime.parse(map["updatedAt"]);
    note = map["note"];
    evaluation = map["evaluation"] == null ? null : Evaluation.fromMap(map["evaluation"]);
    deliveryAddress = map["deliveryAddress"] == null ? null : Address.fromMap(map["deliveryAddress"]);
    deliveryCost = (map["deliveryCost"] as num).toDouble();
    typePayment = map["typePayment"] == null ? null : TypePayment.fromMap(map["typePayment"]);
    items = List.from(map["items"]).map<OrderItem>((e) => OrderItem.fromMap(e)).toList();
    status = OrderStatus.fromMap(map["status"]);
    changeMoney = map["changeMoney"];
    delivery = map["delivery"] == null ? deliveryCost != 0 : map["delivery"] as bool;
    deliveryForecast = map["deliveryForecast"] == null ? null : DeliveryForecast.fromMap(map["deliveryForecast"]);
    preparationTime = map["preparationTime"] == null ? null : PreparationTime.fromMap(map["preparationTime"]);
    companyPhoneNumber = map["companyPhoneNumber"] == null ? null : PhoneNumber.fromMap(map["companyPhoneNumber"]);
    userPhoneNumber = map["userPhoneNumber"] == null ? null : PhoneNumber.fromMap(map["userPhoneNumber"]);
    canceled = map["canceled"] == null ? false : map["canceled"] as bool;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["user"] = user == null ? null : user.toPointer();
    map["userName"] = userName;
    map["company"] = company == null ? null : company.toPointer();
    map["companyName"] = companyName;
    map["createdAt"] = createdAt == null ? null : createdAt.toString();
    map["updatedAt"] = updatedAt == null ? null : updatedAt.toString();
    map["note"] = note;
    map["evaluation"] = evaluation == null ? null : evaluation.toMap();
    map["deliveryAddress"] = deliveryAddress == null ? null : deliveryAddress.toMap();
    map["deliveryCost"] = deliveryCost;
    map["typePayment"] = typePayment == null ? null : typePayment.toMap();
    map["items"] = items.map<Map>((e) => e.toMap()).toList();
    map["status"] = status.toMap();
    map["changeMoney"] = changeMoney;
    map["delivery"] = delivery == null ? deliveryCost != 0 : delivery;
    map["deliveryForecast"] = deliveryForecast == null ? null : deliveryForecast.toMap();
    map["preparationTime"] = preparationTime == null ? null : preparationTime.toMap();
    map["companyPhoneNumber"] = companyPhoneNumber == null ? null : companyPhoneNumber.toMap();
    map["userPhoneNumber"] = userPhoneNumber == null ? null : userPhoneNumber.toMap();
    map["canceled"] = canceled == null ? false : canceled;
    return map;
  }

  updateData(Order item) {
    id = item.id;
    objectId = item.objectId;
    user = item.user;
    userName = item.userName;
    company = item.company;
    companyName = item.companyName;
    createdAt = item.createdAt;
    updatedAt = item.updatedAt;
    note = item.note;
    evaluation = item.evaluation;
    deliveryAddress = item.deliveryAddress;
    deliveryCost = item.deliveryCost;
    typePayment = item.typePayment;
    items = item.items;
    status = item.status;
    changeMoney = item.changeMoney;
    deliveryCost = item.deliveryCost;
    deliveryForecast = item.deliveryForecast;
    preparationTime = item.preparationTime;
    companyPhoneNumber = item.companyPhoneNumber;
    userPhoneNumber = item.userPhoneNumber;
    canceled = item.canceled;
  }

  clear() {
    id = null;
    user = null;
    userName = null;
    company = null;
    companyName = null;
    createdAt = null;
    updatedAt = null;
    note = null;
    evaluation = null;
    deliveryAddress = null;
    deliveryCost = 0;
    typePayment = null;
    items = List();
    status = OrderStatus();
    changeMoney = null;
    delivery = deliveryCost != 0;
    deliveryForecast = null;
    preparationTime = null;
    companyPhoneNumber = null;
    userPhoneNumber = null;
    canceled = false;
  }

}

class DeliveryForecast extends BaseModel<DeliveryForecast> {
  int hour, minute;

  DeliveryForecast() : super('DeliveryForecast');

  DeliveryForecast.fromMap(Map<dynamic, dynamic>  map) : super('DeliveryForecast') {
    hour = map["hour"];
    minute = map["minute"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["hour"] = hour;
    map["minute"] = minute;
    return map;
  }

//  @override
//  update(DeliveryForecast item) {
//    hour = item.hour;
//    minute = item.minute;
//  }

  @override
  String toString() {
    return "${hour}:${minute}h";
  }

}