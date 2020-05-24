import 'package:delivery/contracts/company/company_contract.dart';
import 'package:delivery/models/company/company.dart';
import 'package:delivery/presenters/company/company_presenter.dart';
import 'package:delivery/views/home/company_widget.dart';
import 'package:delivery/widgets/empty_list_widget.dart';
import 'package:delivery/widgets/list_view_body.dart';
import 'package:delivery/widgets/logading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../strings.dart';
import '../../widgets/background_card.dart';

import '../page_router.dart';
import 'company_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements CompanyContractView {
  final _formKey = new GlobalKey<FormState>();

  CompanyContractPresenter presenter;

  List<Company> list;

  @override
  void initState() {
    super.initState();
    presenter = CompanyPresenter(this);
    presenter.list();
  }

  @override
  void dispose() {
    super.dispose();
    presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: Text(TAB1, style: TextStyle(color: Colors.white),),
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
                          BackgroundCard(height: 100,),
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
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Icon(Icons.search, color: Colors.grey,),
              SizedBox(width: 10,),
              Text(
                "Pesquise aqui",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                  //fontWeight: FontWeight.bold,
                )
              )
            ],
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
          },
        ),
      ),
    );
  }

  @override
  onFailure(String error) {
    // TODO: implement onFailure
    throw UnimplementedError();
  }

  @override
  onSuccess(Company result) {

  }

  @override
  listSuccess(List<Company> list) {
    setState(() {
      this.list = [];
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
      this.list.addAll(list);
    });
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
              message: "Nenhuma empresa foi encontrada",
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
        child: CompanyWidget(
          item: item,
          onPressed: (value) {
            PageRouter.push(context, CompanyPage(item));
          },
        ),
      ),
    );
  }

}