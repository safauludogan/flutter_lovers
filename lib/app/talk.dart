import 'package:flutter/material.dart';
import 'package:flutter_lovers_app/model/MyUser.dart';

class TalkPage extends StatefulWidget {
  final MyUser currentUser;
  final MyUser chattedUser;

  const TalkPage({Key? key, required this.currentUser, required this.chattedUser}) : super(key: key);

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Current user: " + widget.currentUser.userName!),
            Text("Sohbet edilen user: " + widget.chattedUser.userName!),
          ],
        ),
      ),
    );
  }
}
