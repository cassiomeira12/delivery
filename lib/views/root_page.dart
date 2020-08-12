import '../contracts/user/user_contract.dart';
import '../models/singleton/singletons.dart';
import '../models/version_app.dart';
import '../presenters/user/user_presenter.dart';
import '../presenters/version_app_presenter.dart';
import '../strings.dart';
import '../themes/my_themes.dart';
import '../themes/custom_theme.dart';
import '../utils/preferences_util.dart';
import '../views/tabs_page.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'intro_page.dart';
import 'login/login_page.dart';
import 'login/verified_email_page.dart';
import '../widgets/background_card.dart';

enum AuthStatus {
  INTRO,
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  EMAIL_NOT_VERIFIED,
  LOGGED_IN,
  UPDATE_APP,
}

class RootPage extends StatefulWidget {
  _RootPageState _root;
  
  @override
  State<StatefulWidget> createState() => _root = _RootPageState();

  void init() {
    _root.currentUser();
  }
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  UserContractPresenter presenter;

  bool minimumUpdate = true;

  @override
  void initState() {
    super.initState();
    Singletons.init();
    presenter = UserPresenter(null);
    updateCurrentTheme();
    initPushNotification();
  }

  void initPushNotification() async {
    Singletons.pushNotification();
    await Singletons.pushNotification().init();
  }

  void currentUser() async {
    var result = await presenter.currentUser();
    if (result == null) {
      checkIntroDone();
    } else {
      Singletons.user().updateData(result);
      if (result.emailVerified) {
        setState(() {
          authStatus = AuthStatus.LOGGED_IN;
        });
        checkLastVersionApp();
        updateNotificationToken();
      } else {
        setState(() {
          authStatus = AuthStatus.EMAIL_NOT_VERIFIED;
        });
      }
    }
  }

  void updateCurrentTheme() async {
    String theme = await PreferencesUtil.getTheme();
    CustomTheme.instanceOf(context).changeTheme(MyThemes.geKey(theme));
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.INTRO:
        return IntroPage(introDoneCallback: introDoneCallback,);
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(loginCallback: loginCallback,);
      case AuthStatus.LOGGED_IN:
        return TabsPage(loginCallback: loginCallback, logoutCallback: logoutCallback,);
      case AuthStatus.EMAIL_NOT_VERIFIED:
        return VerifiedEmailPage(loginCallback: loginCallback, logoutCallback: logoutCallback,);
      case AuthStatus.UPDATE_APP:
        return updateAppScreen();
      default:
        return buildWaitingScreen();
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Hero(
                tag: APP_NAME,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    child: Image.asset("assets/logo_app.png"),
                  ),
                ),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void checkLastVersionApp() async {
    var last = await PreferencesUtil.getLastCheckUpdate();
    if (last == null) {//First check
      checkCurrentVersion();
    } else {
      var now = DateTime.now();
      var dif = now.difference(last);
//      if (dif.inDays > 3) {//Check update
//        checkCurrentVersion();
//      }
      checkCurrentVersion();
    }
  }

  void checkCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    int buildNumber = int.parse(packageInfo.buildNumber);
    var versionApp = await VersionAppPresenter().checkCurrentVersion(packageName);
    if (versionApp != null) {
      versionApp.installedCode = buildNumber;
      if (versionApp.currentCode > buildNumber) {
        setState(() => authStatus = AuthStatus.UPDATE_APP);
      }
      if (versionApp.minimumCode > buildNumber) {
        setState(() {
          minimumUpdate = false;
        });
      }
      Singletons.versionApp().updateData(versionApp);
    }
    PreferencesUtil.setLastCheckUpdate(DateTime.now());//Atualizando ultimo check de versao
  }

  Widget updateAppScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            children: <Widget>[
              BackgroundCard(height: 200,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 130,),
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                child: Icon(
                  Icons.system_update,
                  size: 100,
                  color: Colors.lightBlue,
                ),
              ),
            ],
          ),
          Text(
            UPDATE_APP,
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.center,
          ),
          minimumUpdate ?
          Container()
              :
          Text(
            VERSION_OLDER,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.center,
          ),
          Row(
            children: <Widget>[
              minimumUpdate ?
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SecondaryButton(
                    text: NOT_NOW,
                    onPressed: () => setState(() => authStatus = AuthStatus.LOGGED_IN),
                  ),
                ),
              )
                  :
              Container(),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: PrimaryButton(
                    text: UPDATE,
                    onPressed: () async {
                      bool valid = await canLaunch(Singletons.versionApp().storeUrl);
                      if (valid) {
                        launch(Singletons.versionApp().storeUrl);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void introDoneCallback() async {
    PreferencesUtil.setIntroDone(true);
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  void loginCallback() {
    if (Singletons.user().emailVerified) {
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
      checkCurrentVersion();
      updateNotificationToken();
    } else {
      setState(() {
        authStatus = AuthStatus.EMAIL_NOT_VERIFIED;
      });
    }
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  void checkIntroDone() async {
    var result = await PreferencesUtil.getIntroDone();
    if (result == null) {
      setState(() {
        authStatus = AuthStatus.INTRO;
      });
    } else {
      setState(() {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      });
    }
  }

  void updateNotificationToken() async {
    var notificationToken = await Singletons.pushNotification().updateNotificationToken();
    Singletons.user().notificationToken = notificationToken;
    PreferencesUtil.setUserData(Singletons.user().toMap());
    presenter.update(Singletons.user());
  }

}