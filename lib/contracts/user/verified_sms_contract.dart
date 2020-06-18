
abstract class VerifiedSMSContractView {
  verificationCompleted();
  verificationFailed(String error);
  codeAutoRetrievalTimeout(String verificationId);
  codeSent(String verificationId);
}

abstract class VerifiedSMSContractPresenter extends VerifiedSMSContractView {
  dispose();
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> confirmSMSCode(String verificationId, String smsCode);

}

abstract class VerifiedSMSContractService {
  dispose();
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> confirmSMSCode(String verificationId, String smsCode);
}