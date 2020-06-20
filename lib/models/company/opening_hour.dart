import '../base_model.dart';

class OpeningHour extends BaseModel<OpeningHour> {
  int weekDay;
  int openHour, openMinute;
  int closeHour, closeMinute;

  OpeningHour() : super('OpeningHour');

  OpeningHour.fromMap(Map<dynamic, dynamic>  map) : super('OpeningHour') {
    //id = map["id"];
    weekDay = (map["weekDay"] as num).toInt();
    openHour = (map["openHour"] as num).toInt();
    openMinute = (map["openMinute"] as num).toInt();
    closeHour = (map["closeHour"] as num).toInt();
    closeMinute = (map["closeMinute"] as num).toInt();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //map["id"] = id;
    map["weekDay"] = weekDay;
    map["openHour"] = openHour;
    map["openMinute"] = openMinute;
    map["closeHour"] = closeHour;
    map["closeMinute"] = closeMinute;
    return map;
  }

//  @override
//  update(OpeningHour item) {
//    //id = item.id;
//    weekDay = item.weekDay;
//    openHour = item.openHour;
//    openMinute = item.openMinute;
//    closeHour = item.closeHour;
//    closeMinute = item.closeMinute;
//  }

}