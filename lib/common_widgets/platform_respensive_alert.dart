import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lovers_app/common_widgets/platform_responsive_widget.dart';

class PlatformResponsiveAlertDialog extends PlatformResponsiveWidget {
  final String header;
  final String content;
  final String okButton;
  final String? cancelButton;

  PlatformResponsiveAlertDialog(
      {required this.header,
      required this.content,
      required this.okButton,
      this.cancelButton});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(header),
      content: Text(content),
      actions: _dialogButtons(context),
    );
    throw UnimplementedError();
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(header),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  List<Widget> _dialogButtons(BuildContext context) {
    final allButtons = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButton != null) {
        allButtons.add(CupertinoDialogAction(
          child: Text(cancelButton!),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ));
      }

      allButtons.add(
        CupertinoDialogAction(
          child: Text(okButton),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButton != null) {
        allButtons.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButton!),
          ),
        );
      }
      allButtons.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(okButton),
        ),
      );
    }

    return allButtons;
  }
}
