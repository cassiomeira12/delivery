import 'dart:io';
import '../models/version_app.dart';
import '../services/firebase/firebase_versions_app_service.dart';

class VersionAppPresenter {
  var service = FirebaseVersionsAppService();

  void dispose() {
    service = null;
  }

  Future<VersionApp> checkCurrentVersion(String packageName) {
    packageName = packageName + "-" + Platform.operatingSystem;
    return service.checkCurrentVersion(packageName);
  }
}