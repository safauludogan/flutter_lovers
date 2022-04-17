import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/app/talk.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/all_providers.dart';
import '../viewmodel/user_view_model.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _userViewModelProvider =
        ref.watch<UserViewModel>(userViewModelProvider);
    _userViewModelProvider.getAllUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar"),
      ),
      body: FutureBuilder<List<MyUser>>(
        future: _userViewModelProvider.getAllUsers(),
        builder: (context, result) {
          if (result.hasData) {
            var allUsers = result.data;

            return ListView.builder(
              itemCount: allUsers!.length,
              itemBuilder: (context, index) {
                var currentUser = result.data![index];
                if (currentUser.userID != _userViewModelProvider.user!.userID) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => TalkPage(currentUser: _userViewModelProvider.user!,chattedUser: currentUser,),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(currentUser.userName.toString()),
                      subtitle: Text(currentUser.email),
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(currentUser.profileUrl!)),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
