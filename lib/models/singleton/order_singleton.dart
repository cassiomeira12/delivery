import '../../models/order/order.dart';

class OrderSingleton {

  static final Order _instance = Order();

  static Order get instance => _instance;

}