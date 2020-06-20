import 'package:parse_server_sdk/parse_server_sdk.dart';

abstract class BaseModel<T> extends ParseObject {
  String id;

  BaseModel(String className) : super(className);
  //update(BaseModel<T> item);
  Map<String, dynamic> toMap();
}