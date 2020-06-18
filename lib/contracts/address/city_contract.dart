import '../../models/address/city.dart';
import '../../contracts/base_result_contract.dart';
import '../../contracts/crud.dart';

abstract class CityContractView extends BaseResultContract<City> {
}

abstract class CityContractPresenter extends Crud<City> {
  dispose();
}

abstract class CityContractService extends Crud<City> {

}