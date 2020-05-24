import '../base_model.dart';

enum Type {
  CARD, MONEY, APP_PAYMENT, CASHBACK
}

class TypePayment extends BaseModel<TypePayment> {
  String name;
  Type type;
  double taxa;// 0.0 - 1.0
  int maxInstallments;//Max prestação

  TypePayment();

  TypePayment.fromMap(Map<dynamic, dynamic>  map) {
    id = map["id"];
    name = map["name"];
    //type = map["idState"];
    taxa = map["taxa"] as double;
    maxInstallments = map["maxInstallments"] as int;
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    //map["type"] = type;
    map["taxa"] = taxa;
    map["maxInstallments"] = maxInstallments;
    return map;
  }

  @override
  update(TypePayment item) {
    id = item.id;
    name = item.name;
    //type = item.type;
    taxa = item.taxa;
    maxInstallments = item.maxInstallments;
  }

  static String getType(Type type) {
    switch (type) {
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
