import '../../contracts/user/verified_sms_contract.dart';
import '../../services/firebase/firebase_verified_sms_service.dart';

class VerifiedSMSPresenter extends VerifiedSMSContractPresenter {
  VerifiedSMSContractView _view;
  VerifiedSMSContractService service;

  VerifiedSMSPresenter(this._view) {
    service = FirebaseVerifiedSMSService(this);
  }

  @override
  dispose() {
    service = null;
    _view = null;
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) {
    if (service != null) service.verifyPhoneNumber(phoneNumber);
  }

  @override
  Future<void> confirmSMSCode(String verificationId, String smsCode) {
    if (service != null) service.confirmSMSCode(verificationId, smsCode);
  }

  @override
  codeAutoRetrievalTimeout(String verificationId) {
    if (_view != null) _view.codeAutoRetrievalTimeout(verificationId);
  }

  @override
  codeSent(String verificationId) {
    if (_view != null) _view.codeSent(verificationId);
  }

  @override
  verificationCompleted() {
    if (_view != null) _view.verificationCompleted();
  }

  @override
  verificationFailed(String error) {
    if (_view != null) _view.verificationFailed(error);
  }

}