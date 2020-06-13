import 'dart:io';
import '../contracts/order/order_contract.dart';
import '../models/singleton/order_singleton.dart';
import '../presenters/order/order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/tabs.dart';
import '../views/comanda/comanda_page.dart';
import '../views/historico/historic_page.dart';
import '../views/home/home_page.dart';
import '../views/notifications/notifications_page.dart';
import '../views/settings/settings_page.dart';

class TabsPage extends StatefulWidget {
  TabsPage({this.logoutCallback});

  final VoidCallback logoutCallback;

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final PageStorageBucket bucket = PageStorageBucket();

  TabsView tabsView;

  int currentTab = 0;
  List<Widget> screens;

  int orderCount = 0;
  OrderContractPresenter presenter;

  @override
  void initState() {
    super.initState();
    screens = [
      HomePage(orderCallback: orderCallback,),
      NotificationsPage(),
      ComandaPage(),
      HistoricPage(),
      SettingsPage(logoutCallback: widget.logoutCallback,),
    ];
    tabsView = TabsView(currentTab: currentTab, screens: screens,);
    presenter = OrdersPresenter(null);
    listOrders();
  }

  void listOrders() async {
    var result = await presenter.listUserOrders();
    var temp = 0;
    result.forEach((element) {
      if (!element.status.isLast()) {
        temp++;
      }
    });
    setState(() {
      orderCount = temp;
    });
  }

  void orderCallback() {
    setState(() {
      currentTab = 3;
      tabsView.setPage(currentTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: tabsView,
        bottomNavigationBar: customBottomNavigationBar(),
      )
    );
  }

  Future<bool> _onBackPressed() {
    if (currentTab == 0) {
      exit(0);
    } else {
      setState(() {
        currentTab = 0;
        tabsView.setPage(currentTab);
      });
    }
  }

  Widget customBottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: MaterialButton(
                  color: currentTab == 0 ? Theme.of(context).primaryColorLight : Theme.of(context).backgroundColor,
                  elevation: 0,
                  shape: StadiumBorder(),
                  splashColor: Theme.of(context).backgroundColor,
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    setState(() {
                      currentTab = 0;
                      tabsView.setPage(currentTab);
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      FaIcon(FontAwesomeIcons.home, color: currentTab == 0 ? Theme.of(context).backgroundColor : Colors.grey,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: notificationCount(0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
                child: Stack(
                  children: <Widget>[
                    MaterialButton(
                      color: currentTab == 1 ? Theme.of(context).primaryColorLight : Theme.of(context).backgroundColor,
                      elevation: 0,
                      height: double.maxFinite,
                      shape: StadiumBorder(),
                      splashColor: Theme.of(context).backgroundColor,
                      clipBehavior: Clip.hardEdge,
                      onPressed: () {
                        setState(() {
                          currentTab = 1;
                          tabsView.setPage(currentTab);
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.solidBell, color: currentTab == 1 ? Theme.of(context).backgroundColor : Colors.grey,),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: notificationCount(0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

//            Expanded(
//              flex: 1,
//              child: Container(),
//            ),

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: MaterialButton(
                  color: currentTab == 3 ? Theme.of(context).primaryColorLight : Theme.of(context).backgroundColor,
                  elevation: 0,
                  shape: StadiumBorder(),
                  splashColor: Theme.of(context).backgroundColor,
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    setState(() {
                      currentTab = 3;
                      tabsView.setPage(currentTab);
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      FaIcon(FontAwesomeIcons.shoppingCart, color: currentTab == 3 ? Theme.of(context).backgroundColor : Colors.grey,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: notificationCount( OrderSingleton.instance.id == null ? orderCount : OrderSingleton.instance.items.length ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: MaterialButton(
                  color: currentTab == 4 ? Theme.of(context).primaryColorLight : Theme.of(context).backgroundColor,
                  elevation: 0,
                  shape: StadiumBorder(),
                  splashColor: Theme.of(context).backgroundColor,
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    setState(() {
                      currentTab = 4;
                      tabsView.setPage(currentTab);
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      FaIcon(FontAwesomeIcons.userCog, color: currentTab == 4 ? Theme.of(context).backgroundColor : Colors.grey,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: notificationCount(0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget notificationCount(int notifications) {
    return notifications > 0 ?
      Align(
        alignment: Alignment.topCenter,
        child: ClipOval(
          child: Container(
            height: 20, width: 20,
            color: Colors.red,
            alignment: Alignment.center,
            child: Text(notifications.toString(), style: TextStyle(color: Colors.white,),),
          ),
        ),
      ) : Container();
  }

}
