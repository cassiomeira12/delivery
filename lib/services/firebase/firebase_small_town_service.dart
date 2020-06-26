//import 'package:cloud_firestore/cloud_firestore.dart';
//import '../../contracts/address/small_town_contract.dart';
//import '../../models/address/small_town.dart';
//import '../../utils/log_util.dart';
//import 'base_firebase_service.dart';
//
//class FirebaseSmallTownService implements SmallTownContractService {
//  CollectionReference _collection;
//  BaseFirebaseService _firebaseCrud;
//
//  FirebaseSmallTownService(String path) {
//    _firebaseCrud = BaseFirebaseService(path);
//    _collection = _firebaseCrud.collection;
//  }
//
//  @override
//  Future<SmallTown> create(SmallTown item) async {
//    return _firebaseCrud.create(item).then((response) {
//      return SmallTown.fromMap(response);
//    });
//  }
//
//  @override
//  Future<SmallTown> read(SmallTown item) {
//    return _firebaseCrud.read(item).then((response) {
//      return SmallTown.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<SmallTown> update(SmallTown item) {
//    return _firebaseCrud.update(item).then((response) {
//      return SmallTown.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<SmallTown> delete(SmallTown item) {
//    return _firebaseCrud.delete(item).then((response) {
//      return SmallTown.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<List<SmallTown>> findBy(String field, value) async {
//    return _firebaseCrud.findBy(field, value).then((response) {
//      return response.map<SmallTown>((item) => SmallTown.fromMap(item)).toList();
//    });
//  }
//
//  @override
//  Future<List<SmallTown>> list() {
//    return _firebaseCrud.list().then((response) {
//      return response.map<SmallTown>((item) => SmallTown.fromMap(item)).toList();
//    });
//  }
//
//}