import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../contracts/company/company_contract.dart';
import '../../models/address/city.dart';
import '../../models/address/small_town.dart';
import '../../models/company/company.dart';
import '../../models/singleton/singletons.dart';
import '../../presenters/company/company_presenter.dart';
import '../../strings.dart';
import '../../utils/preferences_util.dart';
import '../../views/home/company_widget.dart';
import '../../views/location/location_page.dart';
import '../../widgets/background_card.dart';
import '../../widgets/empty_list_widget.dart';
import '../../widgets/loading_shimmer_list.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../page_router.dart';
import 'company_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback loginCallback;
  final VoidCallback orderCallback;

  HomePage({@required this.loginCallback, @required this.orderCallback});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements CompanyContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _initedState = false;

  CompanyPresenter companyPresenter;

  City city;
  SmallTown smallTown;
  List<Company> list;

  DateTime dateNow;

  @override
  void initState() {
    super.initState();
    companyPresenter = CompanyPresenter(this);
    _initedState = true;
    checkState();
  }

  @override
  void dispose() {
    super.dispose();
    _initedState = false;
    companyPresenter.dispose();
  }

  void checkState() async {
    var stateData = await PreferencesUtil.getStateData();
    if (stateData != null) {
      // var state = States.fromMap(stateData);
      var townData = await PreferencesUtil.getSmallTownData();
      var cityData = await PreferencesUtil.getCityData();

      if (townData != null) {
        if (_initedState) {
          setState(() {
            smallTown = SmallTown.fromMap(townData);
            city = smallTown.city;
          });
        }
      } else {
        if (cityData != null) {
          if (_initedState) {
            setState(() {
              smallTown = null;
              city = City.fromMap(cityData);
            });
          }
        }
      }

      setState(() => dateNow = DateTime.now());
    }
    verifiedCityTown();
  }

  Future<void> verifiedCityTown() async {
    var townData = await PreferencesUtil.getSmallTownData();
    if (townData != null) {
      if (_initedState) {
        setState(() {
          smallTown = SmallTown.fromMap(townData);
          city = smallTown.city;
        });
      }
      findCompaniesBySmallTown();
    } else {
      var cityData = await PreferencesUtil.getCityData();
      if (cityData != null) {
        if (_initedState) {
          setState(() {
            smallTown = null;
            city = City.fromMap(cityData);
          });
        }
        findCompaniesByCity();
      } else {
        await PageRouter.push(context, LocationPage());
        verifiedCityTown();
      }
    }
  }

  void findCompaniesByCity() async {
    setState(() => list = null);
    if (Singletons.companies().isEmpty) {
      companyPresenter.listFromCity(city.id);
    } else {
      setState(() => list = Singletons.companies());
    }
  }

  void findCompaniesBySmallTown() async {
    setState(() => list = null);
    var temp = Singletons.companies();
    if (temp.isEmpty) {
      companyPresenter.listFromSmallTown(smallTown.id);
    } else {
      setState(() => list = temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          TAB1,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: nestedScrollView(),
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
                  Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          BackgroundCard(
                            height: 100,
                          ),
                          search(),
                        ],
                      ),
                    ],
                  ),
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
      padding: EdgeInsets.all(12),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          elevation: 5,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.searchLocation,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            city == null ? "" : city.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          smallTown != null
                              ? Text(
                                  smallTown.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FaIcon(
                FontAwesomeIcons.caretDown,
                color: Colors.grey[400],
              ),
            ],
          ),
          onPressed: () async {
            Singletons.companies().clear();
            await PageRouter.push(context, LocationPage());
            setState(() => dateNow = DateTime.now());
            verifiedCityTown();
          },
        ),
      ),
    );
  }

  @override
  onFailure(String error) {
    setState(() {
      this.list = [];
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(Company result) {}

  @override
  listSuccess(List<Company> list) {
    if (Singletons.versionApp().isAcceptVersion()) {
      Singletons.companies().addAll(list);
      setState(() => this.list = list);
    } else {
      setState(() => this.list = List());
    }
  }

  Widget body() {
    final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        setState(() => dateNow = DateTime.now());
        Singletons.companies().clear();
        return verifiedCityTown();
      },
      child: Center(
        child: list == null
            ? LoadingShimmerList()
            : Stack(
                children: [
                  listView(),
                  list.isEmpty
                      ? EmptyListWidget(
                          message: NO_COMPANY_FOUND,
                          //assetsImage: "assets/notification.png",
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget listView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(list.map<Widget>((item) {
            return listItem(item);
          }).toList()),
        ),
      ],
    );
  }

  Widget listItem(item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: CompanyWidget(
          item: item,
          dateTime: dateNow,
          onPressed: (value) async {
            await PageRouter.push(
                context,
                CompanyPage(
                  loginCallback: widget.loginCallback,
                  company: item,
                  orderCallback: widget.orderCallback,
                ));
            setState(() => dateNow = DateTime.now());
          },
        ),
      ),
    );
  }
}
