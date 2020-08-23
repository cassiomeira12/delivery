import '../../models/order/cupon.dart';
import '../../contracts/crud.dart';
import '../base_result_contract.dart';

abstract class CuponContractView extends BaseResultContract<Cupon> {

}

abstract class CuponContractPresenter extends Crud<Cupon> {
  dispose();
}

abstract class CuponContractService extends Crud<Cupon> {

}