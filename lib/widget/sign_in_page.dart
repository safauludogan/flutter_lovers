import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/providers/all_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/sign_in_with_email_password.dart';
import '../viewmodel/user_view_model.dart';
import '../common_widgets/login_buttons.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);


  _signInWithEmailPassword(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EmailAndPasswordLoginPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _userViewModelProvider = ref.watch<UserViewModel>(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Oturum aç"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'Oturum Açın',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 16,
              ),
              LoginButton(
                buttonText: "Google ile Giriş Yap",
                radius: 16,
                icon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                onPressed: () {
                  _userViewModelProvider.signInWithGoogle();
                },
              ),
              LoginButton(
                buttonText: "Email ve Şifre ile Giriş Yap",
                radius: 16,
                icon: const Icon(
                  Icons.quick_contacts_mail,
                  color: Colors.white,
                ),
                onPressed: () => _signInWithEmailPassword(context),
                buttonTextColor: Colors.white,
                buttonColor: Colors.purple,
              ),
              LoginButton(
                buttonText: "Misafir Girişi",
                radius: 16,
                icon: const Icon(
                  Icons.quick_contacts_mail,
                  color: Colors.black,
                ),
                onPressed: () {
                  _userViewModelProvider.signOut();
                },
                buttonTextColor: Colors.white,
                buttonColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
