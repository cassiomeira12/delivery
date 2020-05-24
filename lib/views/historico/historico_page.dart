import 'package:delivery/widgets/empty_list_widget.dart';

import '../../strings.dart';
import '../../widgets/primary_button.dart';
import 'package:flutter/material.dart';

class HistoricoPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(TAB3, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: EmptyListWidget(
        message: "Você ainda não fez pedidos",
        //assetsImage: "assets/notification.png",
      ),
    );
  }

}