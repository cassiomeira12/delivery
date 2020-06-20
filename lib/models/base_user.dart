import '../models/status.dart';
import 'base_model.dart';
import 'phone_number.dart';

class BaseUser extends BaseModel<BaseUser> {
  NotificationToken notificationToken;
  String avatarURL;
  Status status;
  String username;
  String name;
  String email;
  bool emailVerified;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  PhoneNumber phoneNumber;

  BaseUser() : super('_User');

  BaseUser.fromMap(Map<dynamic, dynamic>  map) : super('_User') {
    id = map["objectId"];
    notificationToken = map["notificationToken"] == null ? null : NotificationToken.fromMap(map["notificationToken"]);
    avatarURL = map["avatarURL"];
    username = map["username"];
    name = map["name"];
    email = map["email"];
    emailVerified = map["emailVerified"] == null ? false : map["emailVerified"] as bool;
    password = map["password"];
    createdAt = map["createdAt"] == null ? null : DateTime.parse(map["createdAt"]).toLocal();
    updatedAt = map["updatedAt"] == null ? null : DateTime.parse(map["updatedAt"]).toLocal();
    phoneNumber = map["phoneNumber"] == null ? null : PhoneNumber.fromMap(map["phoneNumber"]);
  }

  updateData(BaseUser user) {
    id = user.id;
    notificationToken = user.notificationToken;
    avatarURL = user.avatarURL;
    status = user.status;
    username = user.username;
    name = user.name;
    email = user.email;
    emailVerified = user.emailVerified;
    password = user.password;
    createdAt = user.createdAt;
    updatedAt = user.updatedAt;
    phoneNumber = user.phoneNumber;
  }

  toMap() {
    var map = Map<String, dynamic>();
    map["objectId"] = id;
    map["notificationToken"] = notificationToken == null ? null : notificationToken.toMap();
    map["avatarURL"] = avatarURL;
    map["username"] = username;
    map["name"] = name;
    map["email"] = email;
    map["emailVerified"] = emailVerified;
    map["password"] = password;
    map["createdAt"] = createdAt == null ? null : createdAt.toString();
    map["updatedAt"] = updatedAt == null ? null : updatedAt.toString();
    map["phoneNumber"] = phoneNumber == null ? null : phoneNumber.toMap();
    return map;
  }

}

class NotificationToken extends BaseModel<NotificationToken> {
  String token;
  bool active;
  List<String> topics;

  NotificationToken(this.token) : super('NotificationToken') {
    active = true;
  }

  NotificationToken.fromMap(Map<dynamic, dynamic> map) : super('NotificationToken') {
    id = map["objectId"];
    token = map["token"];
    active = map["active"] as bool;
    topics = map["topics"] == null ? List() : List.from(map["topics"]);
  }

  toMap() {
    var map = new Map<String, dynamic>();
    map["objectId"] = id;
    map["token"] = token;
    map["active"] = active;
    map["topics"] = topics == null ? List() : topics;
    return map;
  }
}