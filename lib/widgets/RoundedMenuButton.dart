import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedMenuButton extends StatelessWidget {
  Color bgColor;
  IconData menuIcon;
  Color iconColor;
  Text text;
  Function onPressed;
  RoundedMenuButton({this.bgColor, this.menuIcon, this.iconColor=Colors.black54, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 11.0),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
          elevation: 5.0,
          child:
          MaterialButton (
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            onPressed: onPressed,
            height: 42.0,
            child: ListTile(
              leading: Icon(menuIcon, size: 30.0, color: iconColor,),
              title: text,
            ),
          ),
        )
    );
  }
}