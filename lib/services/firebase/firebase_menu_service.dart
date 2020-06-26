//import 'package:cloud_firestore/cloud_firestore.dart';
//import '../../contracts/menu/menu_contract.dart';
//import '../../utils/log_util.dart';
//import '../../models/menu/menu.dart';
//
//import 'base_firebase_service.dart';
//
//class FirebaseMenuService implements MenuContractService {
//  CollectionReference _collection;
//  BaseFirebaseService _firebaseCrud;
//
//  FirebaseMenuService(String path) {
//    _firebaseCrud = BaseFirebaseService(path);
//    _collection = _firebaseCrud.collection;
//  }
//
//  @override
//  Future<Menu> create(Menu item) async {
//    return _firebaseCrud.create(item).then((response) {
//      return Menu.fromMap(response);
//    });
//  }
//
//  @override
//  Future<Menu> read(Menu item) {
//    return _firebaseCrud.read(item).then((response) {
//      return Menu.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<Menu> update(Menu item) {
//    return _firebaseCrud.update(item).then((response) {
//      return Menu.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<Menu> delete(Menu item) {
//    return _firebaseCrud.delete(item).then((response) {
//      return Menu.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<List<Menu>> findBy(String field, value) async {
//    return _firebaseCrud.findBy(field, value).then((response) {
//      return response.map<Menu>((item) => Menu.fromMap(item)).toList();
//    });
//  }
//
//  @override
//  Future<List<Menu>> list() {
//    return _firebaseCrud.list().then((response) {
//      return response.map<Menu>((item) => Menu.fromMap(item)).toList();
//    });
//  }
//
//}