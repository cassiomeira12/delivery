import 'package:flutter_slidable/flutter_slidable.dart';

import '../../contracts/address/address_contract.dart';
import '../../models/address/address.dart';
import '../../models/company/type_payment.dart';
import '../../presenters/address/address_presenter.dart';
import '../../strings.dart';
import '../../views/home/new_address_page.dart';
import '../../widgets/empty_list_widget.dart';
import '../../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../page_router.dart';

class DeliveryAddressPage extends StatefulWidget {
  final Address address;

  DeliveryAddressPage({this.address});

  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> implements AddressContractView {

  List<Address> addressList;

  AddressContractPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = AddressPresenter(this);
    presenter.listUsersAddress();
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
        title: Text("Endereços", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: nestedScrollView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () async {
          var result = await PageRouter.push(context,
            NewAddressPage(
              city: widget.address.city,
              smallTown: widget.address.smallTown,
            ),
          );
          if (result != null) {
            setState(() {
              addressList.add(result);
            });
          }
        },
      ),
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
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // gpsLocationWidget(),
                      textTitleWidget(),
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
      onRefresh: () => presenter.listUsersAddress(),
      child: Center(
        child: listView(),
      ),
    );
  }

  Widget gpsLocationWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
        elevation: 2,
        child: FlatButton(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.searchLocation,
                  size: 30,
                ),
                SizedBox(width: 10,),
                Text(
                  "Usar minha localização atual",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }

  Widget textTitleWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        "Escolha um endereço",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget listView() {
    return Center(
        child: addressList == null ?
        LoadingWidget()
            :
        addressList.isEmpty ?
        EmptyListWidget(
          message: "Você ainda não tem endereços cadastrados",
          //assetsImage: "assets/notification.png",
        )
            :
        CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                addressList.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: listItem(e),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
    );
  }

  Widget listItem(Address address) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: addressListItem(address),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: DELETAR,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            var result = await presenter.delete(address);
            if (result != null) {
              setState(() {
                addressList.remove(address);
              });
            }
          },
        ),
      ],
    );
  }

  Widget addressListItem(Address address) {
    return Card(
      margin: EdgeInsets.all(0),
      child: FlatButton(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: FaIcon(FontAwesomeIcons.home, color: Colors.grey,),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//                    Text(
//                      "Minha casa",
//                      style: TextStyle(
//                        fontSize: 20,
//                        color: Colors.black54,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                    SizedBox(height: 5,),
                    Text(
                      address.city.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black45,
                      ),
                    ),
                    address.smallTown != null ?
                      Text(
                        address.smallTown.toString(),
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black38,
                        ),
                      ) : Container(),
                    SizedBox(height: 5,),
                    address.street != null ?
                      Text(
                        "${address.street}" + (address.number == null ? "" : ", ${address.number}"),
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black45,
                        ),
                      ) : Container(),
                    address.neighborhood != null ?
                      Text(
                        address.neighborhood,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black45,
                        ),
                      ) : Container(),
                    address.reference != null ?
                      Text(
                        address.reference,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black38,
                        ),
                      ) : Container(),
                  ],
                ),
              ),
              Container(
                child: Checkbox(
                  value: false,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          PageRouter.pop(context, address);
        },
      ),
    );
  }

  IconData findIcon(Type type) {
    IconData icon;
    switch(type) {
      case Type.MONEY:
        icon = FontAwesomeIcons.moneyBill;
        break;
      case Type.CARD:
        icon = FontAwesomeIcons.creditCard;
        break;
      case Type.APP_PAYMENT:
        icon = FontAwesomeIcons.mobileAlt;
        break;
      case Type.CASHBACK:
        icon = FontAwesomeIcons.handHoldingUsd;
        break;
    }
    return icon;
  }

  @override
  listSuccess(List<Address> list) async {
    setState(() {
      addressList = list;
    });
    if (addressList.isEmpty) {
      await Future.delayed(Duration(milliseconds: 300));
      var result = await PageRouter.push(context,
        NewAddressPage(
          city: widget.address.city,
          smallTown: widget.address.smallTown,
        ),
      );
      if (result != null) {
        setState(() {
          addressList.add(result);
        });
      }
    }
  }

  @override
  onFailure(String error)  {

  }

  @override
  onSuccess(Address result) {

  }

}
