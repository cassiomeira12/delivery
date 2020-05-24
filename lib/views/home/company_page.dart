import 'package:delivery/contracts/menu/menu_contract.dart';
import 'package:delivery/models/menu/item.dart';
import 'package:delivery/models/menu/menu.dart';
import 'package:delivery/presenters/menu/menu_presenter.dart';
import 'package:delivery/views/home/item_widget.dart';
import 'package:delivery/widgets/empty_list_widget.dart';
import 'package:delivery/widgets/logading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/company/company.dart';
import '../../models/singleton/singleton_user.dart';
import 'package:flutter/material.dart';
import '../../widgets/background_card.dart';
import '../page_router.dart';
import 'item_page.dart';

class CompanyPage extends StatefulWidget {
  Company company;

  CompanyPage(this.company);

  @override
  State<StatefulWidget> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> implements MenuContractView {
  final _formKey = new GlobalKey<FormState>();

  MenuContractPresenter presenter;

  Menu menus;

  String logoURL;
  String bannerURL;
  bool favotito = false;

  var menu = ['Remover'];

  List<Item> list;

  @override
  void initState() {
    super.initState();
    presenter = MenuPresenter(this);
    menus = Menu()
      ..id = widget.company.idMenu;
    presenter.read(menus);
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company.name),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                //SingletonCompany.instance.clean();
              });
            },
            itemBuilder: (BuildContext context) {
              return menu.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
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
                          BackgroundCard(height: 100,),
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
                          imageUser(SingletonUser.instance.avatarURL),
                          infoCompanyWidget(),
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
        return presenter.list();
      },
      child: Center(
        child: list == null ?
        LoadingWidget() :
        list.isEmpty ?
        EmptyListWidget(
          message: "Nenhum item foi encontrado",
          //assetsImage: "assets/notification.png",
        )
          :
        listView(),
      ),
    );
  }

  Widget listView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
              list.map<Widget>((item) {
                return listItem(item);
              }).toList()
          ),
        ),
      ],
    );
  }

  Widget listItem(item) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ItemWidget(
          item: item,
          onPressed: (value) {
            PageRouter.push(context, ItemPage());
          },
        ),
      ),
    );
  }




















  Widget infoCompanyWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 105, 0, 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: openingCompanyWidget(),
          ),
          Expanded(
            child: avaliationCompanyWidget(),
          ),
        ],
      ),
    );
  }

  Widget openingCompanyWidget() {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Column(
        children: <Widget>[
          Text(
            "Fechado",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "abre às 17h",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget avaliationCompanyWidget() {
    return Container(
      //color: Colors.black12,
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Container(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 27,
                      height: 27,
                      child: Image.asset("assets/logo_app.png"),
                    ),
                    onTap: () {
                      print("1");
                    },
                  ),
                  GestureDetector(
                    child: favotito ?
                    Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 30,
                    ) :
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onTap: () {
                      setState(() {
                        favotito = !favotito;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 2,),
            estrelasWidget(5),
          ],
        ),
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
      width: 98,
      height: 98,
      margin: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }

  Widget estrelasWidget(int stars){
    final maxStars = 5;
    int starBorder = maxStars - stars;
    final listaEstrelas = <Widget>[];
    for (var i=0; i<maxStars && i<stars; i++) {
      listaEstrelas.add(Icon(Icons.star, color: Colors.amber,size: 20,));
    }
    if (starBorder > 0) {
      for (var i=0; i<starBorder; i++) {
        listaEstrelas.add(Icon(Icons.star_border, color: Colors.amber,size: 20,));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listaEstrelas,
    );
  }

  @override
  listSuccess(List<Menu> list) {
    list.forEach((element) {
      print(element.toMap());
    });
  }

  @override
  onFailure(String error)  {
    print(error);
  }

  @override
  onSuccess(Menu item) {
    List<Item> temp = List();

    item.categories.forEach((element) {
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
      temp.addAll(element.itens);
    });

    setState(() {
      menus = item;
      list = temp;
    });
  }

}