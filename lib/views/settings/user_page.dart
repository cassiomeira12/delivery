import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:delivery/utils/log_util.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../models/singleton/singletons.dart';
import '../../utils/preferences_util.dart';
import '../../widgets/image_network_widget.dart';
import '../../contracts/user/user_contract.dart';
import '../../models/base_user.dart';
import '../../presenters/user/user_presenter.dart';
import '../../strings.dart';
import '../../widgets/background_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/scaffold_snackbar.dart';
import '../../widgets/shape_round.dart';
import '../image_view_page.dart';
import '../page_router.dart';
import 'change_password_page.dart';
import 'phone_number_page.dart';
import 'user_name_page.dart';

class UserPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UserState();
}

class _UserState extends State<UserPage> implements UserContractView {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String userName, userEmail, userPhoneNumber , userPhoto;

  bool _loading = false;
  UserContractPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = UserPresenter(this);
    if (Singletons.user() != null) {
      userName = Singletons.user().name;
      userEmail = Singletons.user().email;
      userPhoneNumber = Singletons.user().phoneNumber == null ? NUMERO_CELULAR : Singletons.user().phoneNumber.toString();
      userPhoto = Singletons.user().avatarURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(PERFIL, style: TextStyle(color: Colors.white),),
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
              BackgroundCard(),
              SingleChildScrollView(
                child: ShapeRound(
                    _showForm()
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
      _loading = false;
    });
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(BaseUser user) async {
    setState(() {
      userPhoto = Singletons.user().avatarURL;
      _loading = false;
    });
    ScaffoldSnackBar.success(context, _scaffoldKey, SUCCESS_UPDATE_DATA);
  }

  Widget _showForm() {
    return  Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            user(),
            txtChangePhoto(),
            nameUser(),
            emailUser(),
            phoneNumberUser(),
            changePasswordButton(),
          ],
        ),
      ),
    );
  }

  Widget user() {
    return Container(
      width: 180,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          imgUser(),
          Align(
            alignment: Alignment.bottomRight,
            child: RawMaterialButton(
              child: Icon(Icons.camera_alt, color: Colors.white,),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Theme.of(context).primaryColorDark,
              padding: const EdgeInsets.all(10),
              onPressed: () {
                changeImgUser();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget imgUser() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Center(
        child: Hero(
          tag: ImageViewPage.HERO_TAG,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  defaultImageUser(),
                  userPhoto == null ? Container() : imageUserURL(),
                  //_loading ? showLoadingProgress() : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showLoadingProgress() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: CircularProgressIndicator(),
    );
  }

  Widget defaultImageUser() {
    return Container(
      width: 160,
      height: 160,
      child: Image.asset("assets/user_default_img_white.png"),
    );
  }

  Widget imageUserURL() {
    return Container(
      child: GestureDetector(
        child: ImageNetworkWidget(url: userPhoto, size: 160,),
        onTap: () {
          PageRouter.push(context, ImageViewPage(networkImage: userPhoto,));
        },
      ),
    );
  }

//  Widget imageUserFile() {
//    return Container(
//      height: 160,
//      width: 160,
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: FileImage(pickedImage),
//          fit: BoxFit.cover,
//        ),
//      ),
//    );
//  }
//
//  Widget loadImage2() {
//    return (userPhoto == null || userPhoto.isEmpty) ?
//      pickedImage == null ?
//        defaultImageUser()
//          :
//        imageUserFile()
//        :
//      imageUserURL();
//  }

//  Widget loadImage() {
//    return (userPhoto == null || userPhoto.isEmpty) ?
//    CircleAvatar(
//      backgroundColor: Colors.transparent,
//      radius: 80,
//      child:
//      pickedImage == null ? Image.asset("assets/user_default_img_white.png")
//          :
//      Container(
//        //height: 160.0,
//        //width: 160.0,
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: FileImage(pickedImage),
//            fit: BoxFit.cover,
//          ),
//        ),
//      ),
//
//    )
//        :
//    Image.network(userPhoto,fit: BoxFit.cover, width: 150,
//      loadingBuilder:(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
//        if (loadingProgress == null) return child;
//        return Center(
//          child: CircularProgressIndicator(
//            value: loadingProgress.expectedTotalBytes != null ?
//            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
//                : null,
//          ),
//        );
//      },
//    );
//  }

  Widget txtChangePhoto() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Center(
        child: Text(
          TROCAR_FOTO,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  Widget nameUser() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.0),
      child: SizedBox(
        //width: double.infinity,
        height: 55,
        child: RaisedButton(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            //side: BorderSide(color: Colors.black12),
          ),
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  userName,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color,),
              ),
            ],
          ),
          onPressed: () async {
            await PageRouter.push(context, UserNamePage());
            setState(() {
              userName = Singletons.user().name;
            });
          },
        ),
      ),
    );
  }

  Widget emailUser() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.0),
      child: SizedBox(
        //width: double.infinity,
        height: 55,
        child: RaisedButton(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            //side: BorderSide(color: Colors.black12),
          ),
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  userEmail,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color,),
              ),
            ],
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }

  Widget phoneNumberUser() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.0),
      child: SizedBox(
        //width: double.infinity,
        height: 55,
        child: RaisedButton(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            //side: BorderSide(color: Colors.black12),
          ),
          color: Theme.of(context).backgroundColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  userPhoneNumber,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                child: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color,),
              ),
            ],
          ),
          onPressed: () async {
            var result = await PageRouter.push(context, PhoneNumberPage(authenticate: false,));
            if (result != null) {
              Singletons.user().phoneNumber = result;
              PreferencesUtil.setUserData(Singletons.user().toMap());
              presenter.update(Singletons.user());
            }
            setState(() {
              userPhoneNumber = Singletons.user().phoneNumber == null ? NUMERO_CELULAR : Singletons.user().phoneNumber.toString();
            });
          },
        ),
      ),
    );
  }

  Widget changePasswordButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 16.0, 12, 0.0),
      child: PrimaryButton(
        text: ALTERAR_SENHA,
        onPressed: () {
          if (Singletons.user().socialProvider) {
            ScaffoldSnackBar.failure(context, _scaffoldKey, "Você está logado com o Google");
          } else {
            PageRouter.push(context, ChangePasswordPage());
          }
        },
      ),
    );
  }

  void changeImgUser() async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: SELECIONE_IMAGEM,
      okLabel: CAMERA,
      cancelLabel: GALERIA,
    );
    var imageSource;
    switch(result) {
      case OkCancelResult.ok:
        imageSource = ImageSource.camera;
        break;
      case OkCancelResult.cancel:
        imageSource = ImageSource.gallery;
        break;
    }
    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        var compressedFile = await FlutterNativeImage.compressImage(file.path, percentage: 50);
        setState(() {
          _loading = true;
        });
        await presenter.changeUserPhoto(compressedFile);
        compressedFile.deleteSync();
      }
    }
  }

}