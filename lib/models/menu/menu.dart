import '../base_model.dart';
import 'category.dart';

class Menu extends BaseModel<Menu> {
  String idCompany;
  List<Category> categories;

  Menu();

  Menu.fromMap(Map<String, dynamic>  map) {
    id = map["id"];
    idCompany = map["idCompany"];
    categories = List.from(map["categories"]).map<Category>((e) => Category.fromMap(e)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["idCompany"] = idCompany;
    map["categories"] = categories.map<Map>((e) => e.toMap()).toList();
    return map;
  }

  @override
  update(Menu item) {
    id = item.id;
    idCompany = item.idCompany;
    categories = item.categories;
  }

}