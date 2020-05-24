import '../../models/order/order.dart';
import '../../contracts/crud.dart';

abstract class OrderContractView {
  onFailure(String error);
  onSuccess(Order result);
}

abstract class OrderContractPresenter extends Crud<Order> {

}

abstract class OrderContractService extends Crud<Order> {

}