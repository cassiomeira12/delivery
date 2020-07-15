import '../base_model.dart';

enum Type {
  CARD, MONEY, APP_PAYMENT, CASHBACK
}

class TypePayment extends BaseModel<TypePayment> {
  String name;
  Type paymentType;
  int taxa;// 0 - 100 - Taxa pelo uso do aplicativo
  int maxInstallments;//Max prestação

  TypePayment() : super('TypePayment') {
    taxa = 7;
    maxInstallments = 1;
  }

  TypePayment.fromMap(Map<dynamic, dynamic>  map) : super('TypePayment') {
    //id = map["id"];
    name = map["name"];
    var typeTemp = map["type"];
    Type.values.forEach((element) {
      if (element.toString().split('.').last == typeTemp) {
        paymentType = element;
        return;
      }
    });
    taxa = (map["taxa"] as num).toInt();
    maxInstallments = map["maxInstallments"] as int;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //map["id"] = id;
    map["name"] = name;
    map["type"] = paymentType.toString().split('.').last;
    map["taxa"] = taxa;
    map["maxInstallments"] = maxInstallments;
    return map;
  }

//  @override
//  update(TypePayment item) {
//    id = item.id;
//    name = item.name;
//    paymentType = item.paymentType;
//    taxa = item.taxa;
//    maxInstallments = item.maxInstallments;
//  }

  String getType() {
    switch (paymentType) {
      case Type.CARD:
        return "Cartão";
      case Type.MONEY:
        return "Dinheiro";
      case Type.APP_PAYMENT:
        return "Pagamento no Aplicativo";
      case Type.CASHBACK:
        return "Cashback";
      default:
        return "";
    }
  }

}
