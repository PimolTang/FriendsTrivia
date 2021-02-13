import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frideos/frideos.dart';
import 'package:friendstrivia/resources/constances.dart';

class AnswerButton extends StatelessWidget {
  Color color;
  String questionOrder;
  String text;
  Icon trailingIcon;
  Function onPressed;
  AnswerButton({this.color, this.questionOrder, this.text, this.trailingIcon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: FadeInWidget(
          duration: 500,
          curve: Curves.linear,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: [BoxShadow(
                    color: kColorThemeGreen,
                    blurRadius: 3.0,
                    spreadRadius: 1.2),
                ]),
            child: ListTile(
//              leading: CircleAvatar(
//                  radius: 16.0,
//                  backgroundColor: kColorWhite,
//                  child: Text(
//                    questionOrder,
//                  )),
              title: Center (child: Text(text, style: TextStyle(fontFamily: kDefaultFont,))), //, style: kAnswerTextStyle,),
              trailing: trailingIcon,
            ),
          ),
        ),
        onTap: onPressed
    );
  }
}