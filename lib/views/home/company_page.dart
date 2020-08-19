import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/singleton/singletons.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../contracts/menu/menu_contract.dart';
import '../../models/menu/product.dart';
import '../../models/menu/menu.dart';
import '../../presenters/menu/menu_presenter.dart';
import '../../views/home/order_slidding_widget.dart';
import '../../views/home/product_widget.dart';
import '../../widgets/empty_list_widget.dart';
import '../../widgets/image_network_widget.dart';
import '../../widgets/loading_shimmer_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../models/company/company.dart';
import 'package:flutter/material.dart';
import '../../strings.dart';
import '../../widgets/background_card.dart';
import '../page_router.dart';
import 'product_page.dart';

class CompanyPage extends StatefulWidget {
  final VoidCallback loginCallback;
  final VoidCallback orderCallback;
  Company company;

  CompanyPage({
    @required this.loginCallback,
    @required this.orderCallback,
    @required this.company,
  });

  @override
  State<StatefulWidget> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> implements MenuContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MenuContractPresenter menuPresenter;

  Menu menu;

  String logoURL;
  String bannerURL;
  bool favotito = false;

  String openTime;

  List<Product> list;

  PanelController _pc = PanelController();

  bool orderSelected = false;
  int orderItens = 0;

  OrderSliddingWidget sliddingPage;

  @override
  void initState() {
    super.initState();
    logoURL = widget.company.logoURL;
    bannerURL = widget.company.bannerURL;
    setOpenTime();
    sliddingPage = OrderSliddingWidget(orderCallback: widget.orderCallback, updateOrders: updateOrders,);
    menuPresenter = MenuPresenter(this);
    menu = Singletons.menus()[widget.company.id];
    if (menu == null) {
      menuPresenter.findBy("company", widget.company.toPointer());
    } else {
      onSuccess(menu);
    }
    updateOrders();
  }

  void setOpenTime() {
    setState(() {
      openTime = widget.company.getOpenTime(DateTime.now()) != null ? CLOSED : widget.company.getOpenTime(DateTime.now());
    });
  }

  void updateOrders() async {
    setState(() {
      orderSelected = Singletons.order().id != null;
    });
    if (orderSelected) {
      Singletons.order().company = widget.company;
      Singletons.order().companyName = widget.company.name;
      Singletons.order().company = widget.company;
      sliddingPage.listItens();
    }
    orderItens = 0;
    Singletons.order().items.forEach((element) {
      orderItens += element.amount;
    });
  }

  @override
  void dispose() {
    super.dispose();
    menuPresenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.company.name),
        ),
        body: orderSelected ? bodySliding() : nestedScrollView(),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    if (orderSelected && _pc.isPanelOpen) {
      _pc.close();
    } else {
      if (Singletons.order().items.isEmpty) {
        PageRouter.pop(context);
      } else {
        showDialog();
      }
    }
  }

  Widget bodySliding() {
    return SlidingUpPanel(
      controller: _pc,
      backdropEnabled: true,
      maxHeight: MediaQuery.of(context).size.height / 1.4,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      panel: sliddingPage,
      collapsed: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: GestureDetector(
          child: Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.shoppingCart, color: Theme.of(context).backgroundColor),
                      SizedBox(width: 10,),
                      Flexible(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              "Pedidos",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "selecionados",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                notificationCount(orderItens),
              ],
            ),
          ),
          onTap: () {
            _pc.open();
          },
        ),
      ),
      body: Center(
        child: nestedScrollView(),
      ),
    );
  }

  Widget notificationCount(int notifications) {
    return notifications > 0 ?
    Align(
      //alignment: Alignment.topCenter,
      child: ClipOval(
        child: Container(
          height: 40, width: 40,
          color: Colors.white,
          alignment: Alignment.center,
          child: Text(
            notifications.toString(),
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ) : Container();
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
                          Column(
                            children: [
                              BackgroundCard(height: 100,),
                              infoCompanyWidget(),
                            ],
                          ),
                          bannerURL == null ?
                            Container()
                              :
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(bannerURL),
                                ),
                              ),
                            ),
                          imageUser(logoURL),
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

  Widget body() {
    final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        setState(() {
          list = null;
        });
        Singletons.menus()[widget.company.id] = null;
        return menuPresenter.findBy("company", widget.company.toPointer());
      },
      child: Center(
        child: list == null ?
          LoadingShimmerList()
            :
          list.isEmpty ?
            Stack(
              children: [
                EmptyListWidget(
                  message: NO_ITEM_FOUND,
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
      padding: EdgeInsets.fromLTRB(0, 0, 0, orderSelected ? 180 : 0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
                list.map<Widget>((item) {
                  return item.visible ? listItem(item) : Container();
                }).toList()
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ProductWidget(
          item: item,
          onPressed: (value) async {
            var result = await PageRouter.push(context, ProductPage(
              loginCallback: widget.loginCallback,
              item: item,
              company: widget.company,
            ));
            if (result != null) {
              updateOrders();
            }
            setOpenTime();
          },
        ),
      ),
    );
  }

  @override
  listSuccess(List<Menu> list) {
    if (list.isEmpty) {
      setState(() {
        this.list = [];
      });
    } else {
      var menu = list[0];
      Singletons.menus()[widget.company.id] = menu;
      onSuccess(menu);
    }
  }

  @override
  onFailure(String error)  {
    setState(() {
      list = [];
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(Menu menu) {
    List<Product> temp = List();
    menu.categories.forEach((product) {
      temp.addAll(product.products);
    });
    setState(() {
      menu = menu;
      list = temp;
    });
  }

  Widget infoCompanyWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: widget.company.openHours != null ? openingCompanyWidget() : Container(),
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          Flexible(
            flex: 3,
            child: deliveryCostCompanyWidget(),
          ),
        ],
      ),
    );
  }

  Widget openingCompanyWidget() {
    return Container(
      alignment: Alignment.center,
      child: AutoSizeText(
        openTime == null ? OPEN : openTime,
        maxLines: 1,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: openTime == null ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget deliveryCostCompanyWidget() {
    return Container(
      //color: Colors.green,
      alignment: Alignment.center,
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 5,
        spacing: 5,
        children: <Widget>[
          widget.company.delivery == null || widget.company.delivery.pickup ?
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: FaIcon(FontAwesomeIcons.running, size: 16, color: Theme.of(context).errorColor,),
            ) : Container(),
          widget.company.delivery != null ?
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20),),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.motorcycle, size: 16, color: Theme.of(context).errorColor,),
                  SizedBox(width: 5,),
                  Text(
                    widget.company.delivery.cost == 0 ? FREE : "R\$ ${(widget.company.delivery.cost/100).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ],
              ),
            ) : Container(),
        ],
      ),
    );
  }

  Widget imageUser(String url) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 40, bottom: 10),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Theme.of(context).hintColor,
            ),
          ),
          child: url == null ?
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Image.asset("assets/logo_app.png"),
          )
              :
          Container(),
        ),
        url == null ? Container() : imageNetworkURL(url),
      ],
    );
  }

  Widget imageNetworkURL(String url) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: ImageNetworkWidget(url: url, size: 98,),
    );
  }

  void showDialog() async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: YOU_HAVE_ORDERS_SELECTED,
      okLabel: CLEAR,
      cancelLabel: CANCELAR,
      message: "Deseja realmente limpar os pedidos selecionados de ${widget.company.name} ?",
    );
    switch(result) {
      case OkCancelResult.ok:
        Singletons.order().clear();
        PageRouter.pop(context);
        break;
      case OkCancelResult.cancel:
        break;
    }
  }

}