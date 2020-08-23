import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../contracts/order/order_contract.dart';
import '../models/singleton/singletons.dart';
import '../presenters/order/order_presenter.dart';
import '../views/historico/historic_page.dart';
import '../views/home/home_page.dart';
import '../views/notifications/notifications_page.dart';
import '../views/settings/settings_page.dart';
import '../widgets/tabs.dart';

class TabsPage extends StatefulWidget {
  final VoidCallback loginCallback;
  final VoidCallback logoutCallback;

  TabsPage({this.loginCallback, this.logoutCallback});

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  TabsView tabsView;

  int currentTab = 0;
  List<Widget> screens;

  int orderCount = 0;
  OrderContractPresenter orderPresenter;

  @override
  void initState() {
    super.initState();
    screens = [
      HomePage(
        loginCallback: widget.loginCallback,
        orderCallback: orderCallback,
      ),
      NotificationsPage(),
      HistoricPage(),
      SettingsPage(
        logoutCallback: widget.logoutCallback,
      ),
    ];
    tabsView = TabsView(
      currentTab: currentTab,
      screens: screens,
    );
    orderPresenter = OrdersPresenter(null);
    listOrders();
  }

  @override
  void dispose() {
    super.dispose();
    orderPresenter.dispose();
  }

  void listOrders() async {
    var result =
        await orderPresenter.findBy("user", Singletons.user().toPointer());
    if (result != null) {
      Singletons.orders().clear();
      Singletons.orders().addAll(result);
      calculateOrdersItens();
    }
  }

  void calculateOrdersItens() {
    var temp = 0;
    Singletons.orders().forEach((element) {
      if ((!element.status.isLast() || element.evaluation == null) &&
          !element.canceled) {
        temp++;
      }
    });
    setState(() {
      orderCount = temp;
    });
  }

  void orderCallback() {
    calculateOrdersItens();
    setState(() {
      currentTab = 2;
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
        ));
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
                  color: currentTab == 0
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).backgroundColor,
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
                      FaIcon(
                        FontAwesomeIcons.home,
                        color: currentTab == 0
                            ? Theme.of(context).backgroundColor
                            : Colors.grey,
                      ),
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
                      color: currentTab == 1
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).backgroundColor,
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
                          FaIcon(
                            FontAwesomeIcons.solidBell,
                            color: currentTab == 1
                                ? Theme.of(context).backgroundColor
                                : Colors.grey,
                          ),
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
                  color: currentTab == 2
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).backgroundColor,
                  elevation: 0,
                  shape: StadiumBorder(),
                  splashColor: Theme.of(context).backgroundColor,
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    setState(() {
                      currentTab = 2;
                      tabsView.setPage(currentTab);
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.shoppingCart,
                        color: currentTab == 2
                            ? Theme.of(context).backgroundColor
                            : Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: notificationCount(orderCount),
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
                  color: currentTab == 3
                      ? Theme.of(context).primaryColorLight
                      : Theme.of(context).backgroundColor,
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
                      FaIcon(
                        FontAwesomeIcons.userCog,
                        color: currentTab == 3
                            ? Theme.of(context).backgroundColor
                            : Colors.grey,
                      ),
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
    return notifications > 0
        ? Align(
            alignment: Alignment.topCenter,
            child: ClipOval(
              child: Container(
                height: 20,
                width: 20,
                color: Colors.red,
                alignment: Alignment.center,
                child: Text(
                  notifications.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
