import 'package:delivery/contracts/company/company_contract.dart';
import 'package:delivery/models/company/company.dart';
import 'package:delivery/models/company/opening_hour.dart';
import 'package:delivery/models/company/type_payment.dart';
import 'package:delivery/presenters/company/company_presenter.dart';
import 'package:delivery/views/home/company_widget.dart';
import 'package:delivery/widgets/empty_list_widget.dart';
import 'package:delivery/widgets/list_view_body.dart';
import 'package:delivery/widgets/loading_shimmer_list.dart';
import 'package:delivery/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import '../../strings.dart';
import '../../widgets/background_card.dart';

import '../page_router.dart';
import 'company_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback orderCallback;

  HomePage({
    @required this.orderCallback
  });

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
    print(error);
  }

  @override
  onSuccess(Company result) {

  }

  @override
  listSuccess(List<Company> list) {
    setState(() {
      this.list = [];
      this.list.addAll(list);
    });


//    TypePayment p = TypePayment();
//    p.name = "Dinheiro";
//    p.type = Type.MONEY;
//
//    list[0].typePayments.add(p);
//    for (int i=0; i<7; i++) {
//      OpeningHour h = OpeningHour();
//      h.weekDay = i;
//      h.openHour = 18;
//      h.openMinute = 0;
//      h.closeHour = 0;
//      h.closeMinute = 0;
//      list[0].openHours.add(h);
//    }

    //presenter.update(list[0]);
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
          LoadingShimmerList()
            :
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
      padding: EdgeInsets.only(bottom: 10),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: CompanyWidget(
          item: item,
          onPressed: (value) {
            PageRouter.push(context, CompanyPage(company: item, orderCallback: widget.orderCallback,));
          },
        ),
      ),
    );
  }

}