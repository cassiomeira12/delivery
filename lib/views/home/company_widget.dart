import '../../models/company/opening_hour.dart';
import '../../widgets/image_network_widget.dart';
import '../../widgets/list_view_body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/company/company.dart';
import '../../utils/date_util.dart';
import 'package:flutter/material.dart';

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
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),),
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: [
            ImageNetworkWidget(url: company.logoURL, size: 68,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleTextWidget(company.name),
                  messageTextWidget(),
                ],
              ),
            ),
            FaIcon(FontAwesomeIcons.angleRight, color: Theme.of(context).iconTheme.color,),
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

  Widget messageTextWidget() {
    bool openToday = company.isTodayOpen();
    String openText, closeText;
    if (openToday) {
      closeText = company.getOpenTime(timeNow);
      if (closeText == null) {
        openText = "Aberto até ${company.closeTime()}";
      }
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Text(
        openToday ? closeText == null ? openText : closeText : "Fechado",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
          color: openToday ? closeText == null ? Colors.green : Colors.red : Colors.red,
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

}

