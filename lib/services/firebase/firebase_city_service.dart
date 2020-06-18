import 'package:cloud_firestore/cloud_firestore.dart';
import '../../contracts/address/city_contract.dart';
import '../../models/address/city.dart';
import '../../utils/log_util.dart';
import 'base_firebase_service.dart';

class FirebaseCityService implements CityContractService {
  CollectionReference _collection;
  BaseFirebaseService _firebaseCrud;

  FirebaseCityService(String path) {
    _firebaseCrud = BaseFirebaseService(path);
    _collection = _firebaseCrud.collection;
  }

  @override
  Future<City> create(City item) async {
    return _firebaseCrud.create(item).then((response) {
      return City.fromMap(response);
    });
  }

  @override
  Future<City> read(City item) {
    return _firebaseCrud.read(item).then((response) {
      return City.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<City> update(City item) {
    return _firebaseCrud.update(item).then((response) {
      return City.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<City> delete(City item) {
    return _firebaseCrud.delete(item).then((response) {
      return City.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<List<City>> findBy(String field, value) async {
    return _firebaseCrud.findBy(field, value).then((response) {
      return response.map<City>((item) => City.fromMap(item)).toList();
    });
  }

  @override
  Future<List<City>> list() {
    return _firebaseCrud.list().then((response) {
      return response.map<City>((item) => City.fromMap(item)).toList();
    });
  }

}