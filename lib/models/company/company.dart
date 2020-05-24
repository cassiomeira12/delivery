import 'package:delivery/models/address/address.dart';
import 'package:delivery/models/company/opening_hour.dart';
import 'package:delivery/models/company/type_payment.dart';

import '../base_model.dart';

class Company extends BaseModel<Company> {
  String topic;
  String name;
  String cnpj;
  String logoURL;
  String bannerURL;
  List<OpeningHour> openHours;
  Address address;
  String idMenu;
  List<TypePayment> typePayments;

  Company();

  Company.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    topic = map["topic"];
    name = map["name"];
    cnpj = map["cnpj"];
    logoURL = map["logoURL"];
    bannerURL = map["bannerURL"];
    //openHours = List.from(map["openHours"]).map<OpeningHour>((e) => OpeningHour.fromMap(e)).toList();
    address = Address.fromMap(map["address"]);
    idMenu = map["idMenu"];
    //typePayments = List.from(map["typePayments"]).map<TypePayment>((e) => TypePayment.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["topic"] = topic;
    map["name"] = name;
    map["cnpj"] = cnpj;
    map["logoURL"] = logoURL;
    map["bannerURL"] = bannerURL;
    //map["openHours"] = openHours.map<Map>((e) => e.toMap()).toList();
    map["address"] = address.toMap();
    map["idMenu"] = idMenu;
    //map["typePayments"] = typePayments.map<Map>((e) => e.toMap()).toList();
    return map;
  }

  @override
  update(Company item) {
    id = item.id;
    topic = item.topic;
    name = item.name;
    cnpj = item.cnpj;
    logoURL = item.logoURL;
    bannerURL = item.bannerURL;
    //openHours = item.openHours;
    //address = item.address;
    idMenu = item.idMenu;
    //typePayments = item.typePayments;
  }

}