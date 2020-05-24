import 'package:carousel_slider/carousel_slider.dart';
import 'package:delivery/views/home/item_widget.dart';
import 'package:delivery/widgets/area_input_field.dart';
import 'package:delivery/widgets/count_widget.dart';
import 'package:delivery/widgets/empty_list_widget.dart';
import 'package:delivery/widgets/logading_widget.dart';
import 'package:delivery/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/company/company.dart';
import '../../models/singleton/singleton_user.dart';
import 'package:flutter/material.dart';
import '../../widgets/background_card.dart';

class ItemPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final _formKey = new GlobalKey<FormState>();

  String title = "Hamburguer";
  String logoURL;
  String bannerURL;
  bool favotito = false;

  var menu = ['Remover'];

  List list = [1,2,3];

  double cost = 18;
  int count = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                          BackgroundCard(height: 200,),
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
                          slidesImages(),
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
      body: SingleChildScrollView(
        child: body(),
      ),
    );
  }

  Widget slidesImages() {
    var list = [
      "logo_app",
      "email",
      "error",
      "google_logo",
      "notification",
      "sucesso",
      "user_default_img_white",
    ];
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 250,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          //pauseAutoPlayOnTouch: true,
          //onPageChanged: () {},
        ),
        items: list.map((e) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset("assets/$e.png"),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget("Hamburguer"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CountWidget(
                changedCount: (value) {
                  setState(() {
                    count = value;
                  });
                },
              ),
              titleCostWidget(cost),
            ],
          ),
          descriptionTextWidget("Generosa camadas de creme suíço, creme de chocolate e creme de ninho recheado com redações de Kitkat."),
          tempoPreparo("asdf"),
          SizedBox(height: 30,),
          AreaInputField(
            labelText: "Observação"
          ),
          PrimaryButton(
            text: "Adicionar pedido",
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }

  Widget titleTextWidget(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 20),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 30,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget titleCostWidget(double cost) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
      child: Text(
        "R\$ ${(count * cost)}",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 30,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget descriptionTextWidget(String description) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Text(
        description,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget tempoPreparo(String tempo) {
    return Row(
      children: [
        Text(
          "Tempo de preparo: ",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black54,
          ),
        ),
        Text(
          "20 - 30 min",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

}