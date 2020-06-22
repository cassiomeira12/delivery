import 'package:delivery/utils/log_util.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import '../../models/base_model.dart';

class BaseParseService {
  String className;
  ParseObject object;

  BaseParseService(String path) {
    this.className = path;
    this.object = ParseObject(path);
  }

  Future<Map<String, dynamic>> create(BaseModel item) async {
    item.toMap().forEach((key, value) {
      object.set(key, value);
    });
    return await object.create().then((value) {
      return value.success ? value.result.toJson() : throw value.error;
    });
  }

  Future<Map<String, dynamic>> read(BaseModel item) async {
    return await object.getObject(item.id).then((value) {
      return value.success ? value.result.toJson() : throw value.error;
    });
  }

  Future<Map<String, dynamic>> update(BaseModel item) async {
    object.objectId = item.id;
    item.toMap().forEach((key, value) {
      object.set(key, value);
    });
    return await object.update().then((value) {
      return value.success ? value.result.toJson() : throw value.error;
    });
  }

  Future<Map<String, dynamic>> delete(BaseModel item) async {
    return await object.delete(id: item.id, path: '').then((value) {
      return value.success ? item.toMap() : throw value.error;
    });
  }

  Future<List<Map<String, dynamic>>> findBy(String field, value) async {
    var queryBuilder = QueryBuilder(object);
    queryBuilder.whereEqualTo(field, value);
    return await queryBuilder.query().then((value) {
      if (value.success) {
        if (value.result == null) {
          return List();
        } else {
          List<ParseObject> list = value.result;
          return list.map<Map<String, dynamic>>((e) => e.toJson()).toList();
        }
      } else {
        return throw value.error;
      }
    });
  }

  Future<List<Map<String, dynamic>>> list() async {
    return await object.getAll().then((value) {
      if (value.success) {
        if (value.result == null) {
          return List();
        } else {
          List<ParseObject> list = value.result;
          return list.map<Map<String, dynamic>>((e) => e.toJson()).toList();
        }
      } else {
        return throw value.error;
      }
    });
  }

}