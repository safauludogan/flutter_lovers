import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/common_widgets/platform_respensive_alert.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:flutter_lovers_app/utils/exception_utils.dart';
import 'package:flutter_lovers_app/common_widgets/login_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/all_providers.dart';
import '../viewmodel/user_view_model.dart';

enum LoginOption { register, login }

class EmailAndPasswordLoginPage extends ConsumerStatefulWidget {
  const EmailAndPasswordLoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _EmailAndPasswordLoginPageState();
}

class _EmailAndPasswordLoginPageState
    extends ConsumerState<EmailAndPasswordLoginPage> {
  String _email = "", _password = "";

  String appbarText = "Kayıt ol";
  String buttonText = "Kayıt";
  var loginOption = LoginOption.register;

  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState?.save();

    var _userViewModelProvider =
        ref.watch<UserViewModel>(userViewModelProvider);

    if (loginOption == LoginOption.register) {
      try {
        await _userViewModelProvider.createUserWithEmailPassword(
            _email, _password);
      } on FirebaseAuthException catch (e) {
        debugPrint(ExceptionUtils.showException(e.code));

        PlatformResponsiveAlertDialog(
                header: "Kullanıcı oluşturmada hata",
                content: ExceptionUtils.showException(e.code),
                okButton: "Tamam")
            .show(context);
      }
    } else {
      try {
        await _userViewModelProvider.signInWithEmailPassword(_email, _password);
      } on FirebaseAuthException catch (e) {
        debugPrint(ExceptionUtils.showException(e.code));

        PlatformResponsiveAlertDialog(
            header: "Giriş başarısız",
            content: ExceptionUtils.showException(e.code),
            okButton: "Tamam")
            .show(context);
      }
    }
  }

  _change() {
    setState(() {
      loginOption = loginOption == LoginOption.register
          ? LoginOption.login
          : LoginOption.register;

      buttonText = loginOption == LoginOption.login ? "Giriş yap" : "Kayıt";
      appbarText = loginOption == LoginOption.login ? "Giriş yap" : "Kayıt ol";
    });
  }

  @override
  Widget build(BuildContext context) {
    var _userViewModelProvider =
        ref.watch<UserViewModel>(userViewModelProvider);

    if (_userViewModelProvider.myUser != null) {
      Future.delayed(
          const Duration(seconds: 2), () => Navigator.of(context).pop());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appbarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _userViewModelProvider.myUser == null
            ? Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: "safa@gmail.com",
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        errorText: _userViewModelProvider.emailErrorMessage,
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Email',
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                      ),
                      onSaved: (enteredMailAdress) {
                        _email = enteredMailAdress!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: "123456",
                      obscureText: true,
                      decoration: InputDecoration(
                        errorText: _userViewModelProvider.passwordErrorMessage,
                        prefixIcon: const Icon(Icons.password_outlined),
                        hintText: 'Email',
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                      ),
                      onSaved: (enteredPassword) {
                        _password = enteredPassword!;
                      },
                    ),
                    const SizedBox(height: 16),
                    LoginButton(
                      buttonText: buttonText,
                      radius: 10,
                      buttonColor: Theme.of(context).primaryColor,
                      buttonTextColor: Colors.white,
                      onPressed: () => _formSubmit(),
                    ),
                    TextButton(
                      onPressed: () {
                        _change();
                      },
                      child: const Text("Giriş yap/Kayıt ol"),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
