import '../../models/menu/menu.dart';
import '../../contracts/crud.dart';
import '../base_result_contract.dart';

abstract class MenuContractView extends BaseResultContract<Menu> {

}

abstract class MenuContractPresenter extends Crud<Menu> {
  dispose();
}

abstract class MenuContractService extends Crud<Menu> {

}