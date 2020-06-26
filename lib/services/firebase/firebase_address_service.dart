//import 'package:cloud_firestore/cloud_firestore.dart';
//import '../../contracts/address/address_contract.dart';
//import '../../models/address/address.dart';
//import '../../utils/log_util.dart';
//
//import 'base_firebase_service.dart';
//
//class FirebaseAddressService implements AddressContractService {
//  CollectionReference _collection;
//  BaseFirebaseService _firebaseCrud;
//
//  FirebaseAddressService(String path) {
//    _firebaseCrud = BaseFirebaseService(path);
//    _collection = _firebaseCrud.collection;
//  }
//
//  @override
//  Future<Address> create(Address item) async {
//    return _firebaseCrud.create(item).then((response) {
//      return Address.fromMap(response);
//    });
//  }
//
//  @override
//  Future<Address> read(Address item) {
//    return _firebaseCrud.read(item).then((response) {
//      return Address.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<Address> update(Address item) {
//    return _firebaseCrud.update(item).then((response) {
//      return Address.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<Address> delete(Address item) {
//    return _firebaseCrud.delete(item).then((response) {
//      return Address.fromMap(response);
//    }).catchError((error) {
//      Log.e("Document ${item.id} not found");
//    });
//  }
//
//  @override
//  Future<List<Address>> findBy(String field, value) async {
//    return _firebaseCrud.findBy(field, value).then((response) {
//      return response.map<Address>((item) => Address.fromMap(item)).toList();
//    });
//  }
//
//  @override
//  Future<List<Address>> list() {
//    return _firebaseCrud.list().then((response) {
//      return response.map<Address>((item) => Address.fromMap(item)).toList();
//    });
//  }
//
//}