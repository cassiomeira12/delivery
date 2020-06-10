import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/version_app.dart';
import '../../utils/log_util.dart';

class FirebaseVersionsAppService {
  CollectionReference _collection = Firestore.instance.collection("versions");

  Future<VersionApp> checkCurrentVersion(String packageName) {
    return _collection.document(packageName).get(source: Source.serverAndCache).timeout(Duration(seconds: 5)).then((result) {
      if (!result.exists) {
        print("Version App [$packageName] existe false");
        return null;
      }
      return VersionApp.fromMap(result.data);
    }).catchError((error) {
      Log.e(error);
      return null;
    });
  }

}