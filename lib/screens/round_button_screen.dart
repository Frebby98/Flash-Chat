import 'package:flutter/material.dart';

import 'login_screen.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {@required this.buttonText,
      @required this.buttonColor,
      @required this.onPressed});

  final Function onPressed;
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
