import 'dart:io';
import '../services/parse/parse_version_app_service.dart';
import '../models/version_app.dart';
import '../services/firebase/firebase_versions_app_service.dart';

class VersionAppPresenter {
  //var service = FirebaseVersionsAppService();
  var service = ParseVersionAppService();

  void dispose() {
    service = null;
  }

  Future<VersionApp> checkCurrentVersion(String packageName) {
    packageName = packageName + "-" + Platform.operatingSystem;
    return service.checkCurrentVersion(packageName);
  }
}