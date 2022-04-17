import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final double height;
  final double radius;
  final Color buttonTextColor;
  final VoidCallback onPressed;
  final Widget icon;

  LoginButton({
    required this.buttonText,
    this.buttonColor = Colors.white,
    this.height=50,
    this.radius = 16,
    this.buttonTextColor=Colors.black,
    required this.onPressed,
    this.icon = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            icon,
            Text(buttonText ,style: TextStyle(color: buttonTextColor),),
            const Opacity(opacity: 0)
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
      ),
    );
  }
}
