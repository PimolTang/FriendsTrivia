import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frideos/frideos.dart';
import 'package:friendstrivia/resources/constances.dart';

class AnswerButton extends StatefulWidget {
  Color color;
  String label;
  String text;
  Icon trailingIcon;
  bool blinkFlag;
  Function onPressed;
  AnswerButton({this.color, this.label, this.text, this.trailingIcon, this.blinkFlag, this.onPressed});

    @override
    _AnswerButtonState createState() => _AnswerButtonState();
  }

class _AnswerButtonState extends State<AnswerButton> with SingleTickerProviderStateMixin  {

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {

    if (widget.blinkFlag) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.forward(from: 1.0);
    }
    return FadeTransition(
          opacity: _animationController,
          child: GestureDetector(
          child: FadeInWidget(
            duration: 500,
            curve: Curves.linear,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
              decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: [BoxShadow(
                      color: kColorThemeGreen,
                      blurRadius: 3.0,
                      spreadRadius: 1.2),
                  ]),
              child: ListTile(
                title: Center (child: Text(widget.text, style: TextStyle(fontFamily: kDefaultFont, fontSize: 20.0))), //, style: kAnswerTextStyle,),
                trailing: widget.trailingIcon,
              ),
            ),
          ),
          onTap: widget.onPressed
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}