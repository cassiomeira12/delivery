import 'package:delivery/widgets/list_view_body.dart';

import '../../models/company/company.dart';
import '../../utils/date_util.dart';
import 'package:flutter/material.dart';

class CompanyWidget extends StatefulWidget {
  final dynamic item;
  final ValueChanged<Company> onPressed;

  const CompanyWidget({
    this.item,
    this.onPressed,
  });

  @override
  _CompanyWidgetState createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  
  Color _colorButton, _colorTextButton;
  
  Company company;

  @override
  void initState() {
    super.initState();
    company = widget.item as Company;
    _colorTextButton = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),),
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            imageNetworkURL(company.logoURL),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleTextWidget("Point Luca"),
                  messageTextWidget("Abre às 18h"),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          widget.onPressed(company);
        }
      ),
    );
  }

  Widget titleTextWidget(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget messageTextWidget(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget buttonAction() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 28,
        child: RaisedButton(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: _colorButton == null ? Theme.of(context).buttonColor : _colorButton,
          child: Text(
            "Action",
            style: TextStyle(
              color: _colorTextButton,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            setState(() {
              _colorButton = Colors.white;
              _colorTextButton = Colors.grey;
            });
          },
        ),
      ),
    );
  }

  Widget imageNetworkURL(String url) {
    return Container(
      width: 68,
      height: 68,
      margin: EdgeInsets.only(top: 2, right: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Theme.of(context).hintColor,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(url),
        ),
      ),
    );
  }

}

