import '../../models/address/states.dart';
import '../../contracts/base_result_contract.dart';
import '../../contracts/crud.dart';

abstract class StatesContractView extends BaseResultContract<States> {
  
}

abstract class StatesContractPresenter extends Crud<States> {
  dispose();
}

abstract class StatesContractService extends Crud<States> {

}