import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kideliver/strings.dart';

import '../../models/company/company.dart';
import '../../widgets/image_network_widget.dart';

class CompanyWidget extends StatefulWidget {
  final dynamic item;
  final DateTime dateTime;
  final ValueChanged<Company> onPressed;

  const CompanyWidget({
    this.item,
    this.dateTime,
    this.onPressed,
  });

  @override
  _CompanyWidgetState createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  Color _colorButton, _colorTextButton;

  DateTime timeNow;
  Company company;

  String openingHourMessage = "";

  @override
  void initState() {
    super.initState();
    timeNow = widget.dateTime == null ? DateTime.now() : widget.dateTime;
    company = widget.item as Company;
    _colorTextButton = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        color: Theme.of(context).backgroundColor,
        disabledColor: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            ImageNetworkWidget(
              url: company.logoURL,
              size: 68,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleTextWidget(company.name),
                  company.initiated
                      ? openingHourMessageTextWidget()
                      : textNotInitialized(),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.angleRight,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        onPressed: company.initiated ? () => widget.onPressed(company) : null,
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

  Widget openingHourMessageTextWidget() {
    bool openToday = company.isTodayOpen();
    String openText, closeText, tomorowText;
    if (openToday) {
      closeText = company.getOpenTime(timeNow);
      if (closeText == null) {
        openText = "Aberto até ${company.closeTime()}";
      }
    } else {
      if (company.isTomorowOpen()) {
        tomorowText = "Abre amanhã";
      }
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Text(
        openToday
            ? closeText == null ? openText : closeText
            : tomorowText == null ? CLOSED : tomorowText,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
          color: openToday
              ? closeText == null ? Colors.green : Colors.red
              : tomorowText == null ? Colors.red : Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget textNotInitialized() {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Text(
        "Disponível em breve",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,
          fontWeight: FontWeight.bold,
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
          color: _colorButton == null
              ? Theme.of(context).buttonColor
              : _colorButton,
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
}
