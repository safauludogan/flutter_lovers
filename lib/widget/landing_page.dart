import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/app/home_page.dart';
import 'package:flutter_lovers_app/widget/sign_in_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/all_providers.dart';
import '../viewmodel/user_view_model.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _userViewModelProvider =
        ref.watch<UserViewModel>(userViewModelProvider);

    if (_userViewModelProvider.viewState == ViewState.IDLE) {
      if (_userViewModelProvider.myUser == null) {
        return const SignInPage();
      } else {
        return HomePage(myUser: _userViewModelProvider.myUser!);
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
