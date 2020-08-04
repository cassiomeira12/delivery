import '../../models/base_user.dart';
import '../../contracts/base_result_contract.dart';
import '../../models/address/address.dart';
import '../../contracts/crud.dart';

abstract class AddressContractView extends BaseResultContract<Address> {
}

abstract class AddressContractPresenter extends Crud<Address> {
  dispose();
  listUsersAddress(Address address);
}

abstract class AddressContractService extends Crud<Address> {
  listUserAddress(BaseUser user, Address address);
}