import '../base_model.dart';

class OpeningHour extends BaseModel<OpeningHour> {
  int weekDay;
  int openHour, openMinute;
  int closeHour, closeMinute;

  OpeningHour();

  OpeningHour.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    weekDay = map["weekDay"] as int;
    openHour = map["openHour"] as int;
    openMinute = map["openMinute"] as int;
    closeHour = map["closeHour"] as int;
    closeMinute = map["closeMinute"] as int;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["weekDay"] = weekDay;
    map["openHour"] = openHour;
    map["openMinute"] = openMinute;
    map["closeHour"] = closeHour;
    map["closeMinute"] = closeMinute;
    return map;
  }

  @override
  update(OpeningHour item) {
    id = item.id;
    weekDay = item.weekDay;
    openHour = item.openHour;
    openMinute = item.openMinute;
    closeHour = item.closeHour;
    closeMinute = item.closeMinute;
  }

}