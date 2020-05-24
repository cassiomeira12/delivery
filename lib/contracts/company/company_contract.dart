import '../../contracts/base_result_contract.dart';
import '../../models/company/company.dart';
import '../../contracts/crud.dart';

abstract class CompanyContractView extends BaseResultContract<Company> {

}

abstract class CompanyContractPresenter extends Crud<Company> {
  dispose();
}

abstract class CompanyContractService extends Crud<Company> {

}