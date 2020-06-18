import '../../models/address/small_town.dart';
import '../../contracts/base_result_contract.dart';
import '../../contracts/crud.dart';

abstract class SmallTownContractView extends BaseResultContract<SmallTown> {
}

abstract class SmallTownContractPresenter extends Crud<SmallTown> {
  dispose();
}

abstract class SmallTownContractService extends Crud<SmallTown> {
  
}