import 'package:delivery/contracts/address/states_contract.dart';
import 'package:delivery/presenters/address/states_presenter.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../contracts/address/city_contract.dart';
import '../../contracts/address/small_town_contract.dart';
import '../../models/address/city.dart';
import '../../models/address/small_town.dart';
import '../../models/address/states.dart';
import '../../presenters/address/city_presenter.dart';
import '../../presenters/address/small_town_presenter.dart';
import '../../utils/preferences_util.dart';
import '../../widgets/empty_list_widget.dart';
import '../../widgets/loading_shimmer_list.dart';
import '../../strings.dart';
import '../../widgets/background_card.dart';
import '../page_router.dart';

class LocationPage extends StatefulWidget {

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  States state = States()
    ..id = "1bp6TfFPUE"
    ..name = "Bahia"
    ..code = "BA"
    ..idCountry = "AaBnNFM1U8l6isuYI1il"
    ..nameCountry = "Brasil"
    ..codeCountry = "BR"
    ..timeAPI = "http://worldtimeapi.org/api/timezone/america/bahia";

  List<City> cityList;
  List<SmallTown> smallTownList;
  List<Map> dialogList;

  bool _loading = false;

  StatesContractPresenter statePresenter;
  CityContractPresenter cityPresenter;
  SmallTownContractPresenter smallTownPresenter;

  @override
  void initState() {
    super.initState();
    statePresenter = StatesPresenter(null);
    cityPresenter = CityPresenter(null);
    smallTownPresenter = SmallTownPresenter(null);
    //checkState();
    listCities();
  }

  void checkState() async {
    var stateData = await PreferencesUtil.getStateData();
    if (stateData == null) {
      PreferencesUtil.setStateData(this.state.toMap());
    } else {
      this.state = States.fromMap(stateData);
    }
    listCities();
  }

  @override
  void dispose() {
    super.dispose();
    statePresenter.dispose();
    cityPresenter.dispose();
    smallTownPresenter.dispose();
  }

  Future<void> listCities() async {
    setState(() {
      cityList = null;
    });
    var value = {
      "__type": "Pointer",
      "className": "State",
      "objectId": "1bp6TfFPUE",
    };
    var result = await cityPresenter.findBy("state", value);
    if (result == null) {
      setState(() => cityList = List());
    } else {
      setState(() => cityList = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
          child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(),),
        ),
        child: nestedScrollView(),
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            BackgroundCard(height: 150,),
            Container(
              margin: EdgeInsets.all(12),
              child: Column(
                children: [
                  search(),
                  Text(
                    "Escolha uma cidade",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget nestedScrollView() {
    return NestedScrollView(
      controller: ScrollController(keepScrollOffset: true),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Stack(
                //alignment: Alignment.bottomCenter,
                children: <Widget>[
                  header(),
                ],
              ),
            ]),
          ),
        ];
      },
      body: body(),
    );
  }

  Widget search() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 15),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          color: Colors.white,
          disabledColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              FaIcon(FontAwesomeIcons.caretDown, color: Colors.grey[400],),
            ],
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }

  Widget body() {
    final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () => listCities(),
      child: Center(
        child: cityList == null ?
          LoadingShimmerList()
            :
          cityList.isEmpty ?
            Stack(
              children: [
                EmptyListWidget(
                  message: "Nenhum item foi encontrado",
                  //assetsImage: "assets/notification.png",
                ),
                listView(),
              ],
            )
              :
            listView(),
      ),
    );
  }

  Widget listView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
                cityList.map<Widget>((item) {
                  return listItem(item);
                }).toList()
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(City item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 5,
        child: FlatButton(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
          ),
          onPressed: () {
            listSmallTowns(item);
          },
        ),
      ),
    );
  }

  void listSmallTowns(City city) async {
    dialogList = List();
    setState(() => _loading = true);
    var value = {
      "__type": "Pointer",
      "className": "City",
      "objectId": city.id,
    };
    List<SmallTown> result = await smallTownPresenter.findBy("city", value);
    if (result == null || result.isEmpty) {
      PreferencesUtil.setSmallTownData(null);
      PreferencesUtil.setCityData(city.toMap());
      PageRouter.pop(context);
    } else {
      setState(() {
        _loading = false;
        smallTownList = result;
      });
      dialogList.add(city.toMap());
      smallTownList.forEach((element) {
        dialogList.add(element.toMap());
      });
      selectSmallTown(city);
    }
  }

  void selectSmallTown(City city) async {
    final result = await showConfirmationDialog<String>(
      context: context,
      title: "Escolha uma localidade",
      okLabel: "Ok",
      cancelLabel: CANCELAR,
      barrierDismissible: false,
      actions: dialogList.map((e) {
        return AlertDialogAction<String>(label: e["name"], key: e["objectId"]);
      }).toList(),
    );
    if (result == null || result == city.id) {
      print("cidade ${city.toMap()}");
      PreferencesUtil.setSmallTownData(null);
      PreferencesUtil.setCityData(city.toMap());
      PageRouter.pop(context);
    } else {
      var smallTown = smallTownList.singleWhere((element) => element.id == result, orElse: null);
      smallTown.city = city;
      print("povoado ${smallTown.toMap()}");
      PreferencesUtil.setCityData(null);
      PreferencesUtil.setSmallTownData(smallTown.toMap());
      PageRouter.pop(context);
    }
  }

}
