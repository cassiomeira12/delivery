import '../../models/address/address.dart';
import '../../models/company/opening_hour.dart';
import '../../models/company/type_payment.dart';
import '../base_model.dart';
import 'delivery.dart';

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
  Delivery delivery;

  Company() {
    openHours = List();
    typePayments = List();
  }

  Company.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    topic = map["topic"];
    name = map["name"];
    cnpj = map["cnpj"];
    logoURL = map["logoURL"];
    bannerURL = map["bannerURL"];
    openHours = map["openHours"] == null ?
      List() :
      List.from(map["openHours"]).map<OpeningHour>((e) => OpeningHour.fromMap(e)).toList();
    address = Address.fromMap(map["address"]);
    idMenu = map["idMenu"];
    typePayments = map["typePayments"] == null ?
      List() :
      List.from(map["typePayments"]).map<TypePayment>((e) => TypePayment.fromMap(e)).toList();
    delivery = map["delivery"] == null ? null : Delivery.fromMap(map["delivery"]);
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
    map["openHours"] = openHours.map<Map>((e) => e.toMap()).toList();
    map["address"] = address.toMap();
    map["idMenu"] = idMenu;
    map["typePayments"] = typePayments.map<Map>((e) => e.toMap()).toList();
    map["delivery"] = delivery == null ? null : delivery.toMap();
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
    openHours = item.openHours;
    address = item.address;
    idMenu = item.idMenu;
    typePayments = item.typePayments;
    delivery = item.delivery;
  }

  String getOpenTime(int weekDay) {
    OpeningHour openingHourToday;
    openHours.forEach((element) {
      if (element.weekDay == weekDay) {
        openingHourToday = element;
        return;
      }
    });
    if (openingHourToday == null) {
      return "Fechado";
    }
    String hora = openingHourToday.openHour < 10 ? "0${openingHourToday.openHour}" : openingHourToday.openHour.toString();
    String minutos = openingHourToday.openMinute < 10 ? "0${openingHourToday.openMinute}" : openingHourToday.openMinute.toString();
    return "Abre às $hora:$minutos";
  }

}