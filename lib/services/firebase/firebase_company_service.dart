import 'package:cloud_firestore/cloud_firestore.dart';
import '../../contracts/company/company_contract.dart';
import '../../utils/log_util.dart';
import '../../models/company/company.dart';

import 'base_firebase_service.dart';

class FirebaseCompanyService implements CompanyContractService {
  CollectionReference _collection;
  BaseFirebaseService _firebaseCrud;

  FirebaseCompanyService(String path) {
    _firebaseCrud = BaseFirebaseService(path);
    _collection = _firebaseCrud.collection;
  }

  @override
  Future<Company> create(Company item) async {
    return _firebaseCrud.create(item).then((response) {
      return Company.fromMap(response);
    });
  }

  @override
  Future<Company> read(Company item) {
    return _firebaseCrud.read(item).then((response) {
      return Company.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<Company> update(Company item) {
    return _firebaseCrud.update(item).then((response) {
      return Company.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<Company> delete(Company item) {
    return _firebaseCrud.delete(item).then((response) {
      return Company.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<List<Company>> findBy(String field, value) async {
    return _firebaseCrud.findBy(field, value).then((response) {
      return response.map<Company>((item) => Company.fromMap(item)).toList();
    });
  }

  @override
  Future<List<Company>> list() {
    return _firebaseCrud.list().then((response) {
      return response.map<Company>((item) => Company.fromMap(item)).toList();
    });
  }

  @override
  listFromCity(String id) {
    // TODO: implement listFromCity
    throw UnimplementedError();
  }

  @override
  listFromSmallTown(String id) {
    // TODO: implement listSmallTown
    throw UnimplementedError();
  }

}