import 'package:delivery/views/home/company_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../strings.dart';

class ListViewBody<T> extends StatefulWidget {
  List<T> list;
  final RefreshCallback refreshCallback;

  final Function listWidget;

  final List<Widget> actions;
  final List<Widget> secondaryActions;

  ListViewBody({
    @required this.listWidget,
    @required this.refreshCallback,
    this.actions,
    this.secondaryActions,
  });

  setList(List<T> list) {
    page.setState(() {
      this.list = list;
    });
  }

  _ListViewBodyState<T> page;

  @override
  _ListViewBodyState createState() => page = _ListViewBodyState<T>();
}

class _ListViewBodyState<T> extends State<ListViewBody> {
  String noItensImage = "assets/notification.png";
  String noItens = "Vazio";

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: widget.refreshCallback,
      child: Center(
        child: widget.list == null ?
        loadingListWidget()
            :
        widget.list.isEmpty ?
        emptyListWidget()
            :
        widget.listWidget,
      ),
    );
  }

  Widget loadingListWidget() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget emptyListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          child: Image.asset(noItensImage),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Center(
            child: Text(
              noItens,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        )
      ],
    );
  }

}
