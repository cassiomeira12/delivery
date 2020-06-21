import 'dart:io';

import '../../models/phone_number.dart';
import '../../utils/date_util.dart';
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
  PhoneNumber phoneNumber;

  Company() : super('Company') {
    openHours = List();
    typePayments = List();
  }

  Company.fromMap(Map<dynamic, dynamic>  map) : super('Company') {
    id = map["objectId"];
    //topic = map["topic"];
    name = map["name"];
    cnpj = map["cnpj"];
    logoURL = map["logo"] == null ? null : (map["logo"] as dynamic)["url"];
    bannerURL = map["banner"] == null ? null : (map["logo"] as dynamic)["url"];
    openHours = map["openHours"] == null ?
      List() :
      List.from(map["openHours"]).map<OpeningHour>((e) => OpeningHour.fromMap(e)).toList();
    address = Address.fromMap(map["address"]);
//    idMenu = map["idMenu"];
    typePayments = map["typePayments"] == null ?
      List() :
      List.from(map["typePayments"]).map<TypePayment>((e) => TypePayment.fromMap(e)).toList();
    delivery = map["delivery"] == null ? null : Delivery.fromMap(map["delivery"]);
    phoneNumber = map["phoneNumber"] == null ? null : PhoneNumber.fromMap(map["phoneNumber"]);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
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
    map["phoneNumber"] = phoneNumber == null ? null : phoneNumber.toMap();
    return map;
  }

//  @override
//  update(Company item) {
//    id = item.id;
//    topic = item.topic;
//    name = item.name;
//    cnpj = item.cnpj;
//    logoURL = item.logoURL;
//    bannerURL = item.bannerURL;
//    openHours = item.openHours;
//    address = item.address;
//    idMenu = item.idMenu;
//    typePayments = item.typePayments;
//    delivery = item.delivery;
//    phoneNumber = item.phoneNumber;
//  }

  bool isTodayOpen() {
    OpeningHour openingHourToday;
    openHours.forEach((element) {
      if (element.weekDay == DateTime.now().weekday) {
        openingHourToday = element;
        return;
      }
    });
    return openingHourToday != null;
  }

  String openTime() {
    OpeningHour openingHourToday;
    openHours.forEach((element) {
      if (element.weekDay == DateTime.now().weekday) {
        openingHourToday = element;
        return;
      }
    });
    if (openingHourToday == null) {// Nao abre no dia
      return "Fechado";
    }
    var open = DateUtil.todayTime(openingHourToday.openHour, openingHourToday.openMinute);
    String hour = open.hour < 10 ? "0${open.hour}" : open.hour.toString();
    String minutes = open.minute < 10 ? "0${open.minute}" : open.minute.toString();
    return "${hour}:${minutes}h";
  }

  String closeTime() {
    OpeningHour openingHourToday;
    openHours.forEach((element) {
      if (element.weekDay == DateTime.now().weekday) {
        openingHourToday = element;
        return;
      }
    });
    if (openingHourToday == null) {// Nao abre no dia
      return "Fechado";
    }
    var close = DateUtil.todayTime(openingHourToday.closeHour, openingHourToday.closeMinute);
    String hour = close.hour < 10 ? "0${close.hour}" : close.hour.toString();
    String minutes = close.minute < 10 ? "0${close.minute}" : close.minute.toString();
    return "${hour}:${minutes}h";
  }

  String getOpenTime(DateTime date) {
    OpeningHour openingHourToday;
    openHours.forEach((element) {
      if (element.weekDay == date.weekday) {
        openingHourToday = element;
        return;
      }
    });
    if (openingHourToday == null) {// Nao abre no dia
      return "Fechado";
    }

    var open = DateUtil.todayTime(openingHourToday.openHour, openingHourToday.openMinute);
    var close = DateUtil.todayTime(openingHourToday.closeHour, openingHourToday.closeMinute);
    if (close.isBefore(open)) {
      close = close.add(Duration(days: 1));
    }

    if (date.isBefore(open)) {
      print("fechado");
    } else {
      if (date.isBefore(close)) {
        print("aberto");
        return null;
      } else {
        print("fechadp");
      }
    }

    String hora = open.hour < 10 ? "0${open.hour}" : open.hour.toString();
    String minutos = open.minute < 10 ? "0${open.minute}" : open.minute.toString();
    return "Abre às ${hora}:${minutos}h";
  }

}