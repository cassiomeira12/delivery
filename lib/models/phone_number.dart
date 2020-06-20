import '../models/base_model.dart';

class PhoneNumber extends BaseModel<PhoneNumber> {
  String countryCode;
  String ddd;
  String number;
  bool verified;

  PhoneNumber() : super('PhoneNumber');

  PhoneNumber.fromMap(Map<dynamic, dynamic>  map) : super('PhoneNumber') {
    id = map["objectId"];
    countryCode = map["countryCode"];
    ddd = map["ddd"];
    number = map["number"];
    verified = map["verified"] == null ? false : map["verified"] as bool;
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map["objectId"] = id;
    map["countryCode"] = countryCode;
    map["ddd"] = ddd;
    map["number"] = number;
    map["verified"] = verified == null ? false : verified;
    return map;
  }

  @override
  String toString() {
    return countryCode+" ("+ddd+") "+number;
  }

}