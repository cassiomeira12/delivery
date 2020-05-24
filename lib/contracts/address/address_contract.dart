import '../../models/address/address.dart';
import '../../contracts/crud.dart';

abstract class AddressContractView {
  onFailure(String error);
  onSuccess(Address result);
}

abstract class AddressContractPresenter extends Crud<Address> {

}

abstract class AddressContractService extends Crud<Address> {

}