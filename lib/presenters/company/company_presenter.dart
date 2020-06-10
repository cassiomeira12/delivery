import '../../services/firebase/firebase_company_service.dart';
import '../../contracts/company/company_contract.dart';
import '../../models/company/company.dart';

class CompanyPresenter implements CompanyContractPresenter {
  final CompanyContractView _view;

  CompanyPresenter(this._view);

  CompanyContractService service = FirebaseCompanyService("companies");

  @override
  dispose() {
    service = null;
  }

  @override
  Future<Company> create(Company item) async {
    return await service.create(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Company> read(Company item) async {
    return await service.read(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Company> update(Company item) async {
    return await service.update(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Company> delete(Company item) async {
    return await service.create(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<Company>> findBy(String field, value) async {
    return await service.findBy(field, value).then((value) {
      _view.listSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<List<Company>> list() async {
    return await service.list().then((value) {
      _view.listSuccess(value);
      return value;
    }).catchError((error) {
      print(error);
      _view.onFailure(error);
      return null;
    });
  }

}