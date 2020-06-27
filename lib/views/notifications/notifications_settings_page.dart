import '../../models/singleton/singletons.dart';
import '../../utils/preferences_util.dart';
import '../../widgets/scaffold_snackbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../contracts/user/user_contract.dart';
import '../../models/base_user.dart';
import '../../presenters/user/user_presenter.dart';
import '../../strings.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettingsPage> implements UserContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool notifications = Singletons.user().notificationToken.active;
  bool _loading = false;
  UserContractPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = UserPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(TAB2, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
          child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(),),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    notificacoesButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  onFailure(String error) {
    setState(() {
      notifications = !notifications;
      Singletons.user().notificationToken.active = notifications;
      _loading = false;
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(BaseUser user) {
    setState(() {
      _loading = false;
    });
    PreferencesUtil.setUserData(user.toMap());
    ScaffoldSnackBar.success(context, _scaffoldKey, SUCCESS_UPDATE_DATA);
  }

  Widget notificacoesButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            //side: BorderSide(color: Colors.black26),
          ),
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  RECEBER_NOTIFICACOES,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: Switch(
                  value: notifications,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (value) {
                    setState(() {
                      notifications = value;
                    });
                  },
                ),
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              notifications = !notifications;
              Singletons.user().notificationToken.active = notifications;
              _loading = true;
            });
            presenter.update(Singletons.user());
          },
        ),
      ),
    );
  }

}