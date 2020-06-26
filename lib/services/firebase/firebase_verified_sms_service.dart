//import 'package:firebase_auth/firebase_auth.dart';
//import '../../contracts/user/verified_sms_contract.dart';
//
//class FirebaseVerifiedSMSService extends VerifiedSMSContractService {
//  VerifiedSMSContractPresenter presenter;
//
//  FirebaseVerifiedSMSService(this.presenter);
//
//  @override
//  dispose() {
//    presenter = null;
//  }
//
//  @override
//  Future<void> verifyPhoneNumber(String phoneNumber) async {
//    await FirebaseAuth.instance.verifyPhoneNumber(
//        phoneNumber: phoneNumber,
//        timeout: Duration(seconds: 5),
//
//        verificationCompleted: (credential) async {
//          FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//          await currentUser.updatePhoneNumberCredential(credential).then((value) {
//            if (presenter != null) presenter.verificationCompleted();
//          }).catchError((error) {
//            if (presenter != null) presenter.verificationFailed(error.message);
//          });
//        },
//
//        verificationFailed: (authException) {
//          if (presenter != null) presenter.verificationFailed(authException.message);
//        },
//
//        codeAutoRetrievalTimeout: (verificationId) {
//          if (presenter != null) presenter.codeAutoRetrievalTimeout(verificationId);
//        },
//
//        codeSent: (verificationId, [code]) {
//          if (presenter != null) presenter.codeSent(verificationId);
//        }
//    );
//  }
//
//  @override
//  Future<void> confirmSMSCode(String verificationId, String smsCode) async {
//    var credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
//    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//    await currentUser.updatePhoneNumberCredential(credential).then((value) {
//      if (presenter != null) presenter.verificationCompleted();
//    }).catchError((error) {
//      if (presenter != null) presenter.verificationFailed(error.message);
//    });
//  }
//
//}