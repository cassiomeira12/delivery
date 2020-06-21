import 'base_model.dart';

class UserNotification extends BaseModel<UserNotification> {
  String title;
  String message;
  String observacao;
  bool read = false;
  DateTime createAt = DateTime.now();
  String avatarURL;
  String paymentType;

  UserNotification() : super('UserNotification');

  UserNotification.fromMap(Map map) : super('UserNotification') {
    id = map["objectId"];
    title = map["title"];
    message = map["message"];
    observacao = map["observacao"];
    read = map["read"] == null ? true : map["read"] as bool;
    createAt = map["createAt"] == null ? null : DateTime.parse(map["createAt"]);
    avatarURL = map["avatarURL"];
    paymentType = map["type"];
  }

  updateData(UserNotification item) {
    id = item.id;
    title = item.title;
    message = item.message;
    observacao = item.observacao;
    read = item.read;
    createAt = item.createAt;
    avatarURL = item.avatarURL;
    paymentType = item.paymentType;
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map["objectId"] = id;
    map["title"] = title;
    map["message"] = message;
    map["observacao"] = observacao;
    map["read"] = read;
    map["createAt"] = createAt == null ? null : createAt.toString();
    map["date"] = createAt == null ? null : createAt.millisecondsSinceEpoch;
    map["avatarURL"] = avatarURL;
    map["type"] = paymentType;
    return map;
  }

}