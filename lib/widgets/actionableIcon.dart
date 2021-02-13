import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';

class ActionableIcon extends StatefulWidget {
  IconData icon;
  Function onPressed;
  ActionableIcon({@required this.icon, @required this.onPressed});

  @override
  _ActionableIconState createState() => _ActionableIconState();
}

class _ActionableIconState extends State<ActionableIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(widget.icon, size: 22, color: kColorWhite,),
      onTap: widget.onPressed,
    );
  }
}