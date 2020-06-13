import '../base_model.dart';

class Evaluation extends BaseModel<Evaluation> {
  int stars;
  String comment;

  Evaluation();

  Evaluation.fromMap(Map<dynamic, dynamic>  map) {
    stars = map["stars"] as int;
    comment = map["comment"];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["stars"] = stars;
    map["comment"] = comment;
    return map;
  }

  @override
  update(Evaluation item) {
    id = item.id;
    stars = item.stars;
    comment = item.comment;
  }

}