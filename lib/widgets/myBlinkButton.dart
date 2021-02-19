import 'package:flutter/material.dart';

class MyBlinkingButton extends StatefulWidget {
  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    //_animationController.repeat(reverse: true);

    _animationController.forward();

    //_animationController.reverse();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: MaterialButton(
        onPressed: () {
            print(_animationController.status);
            if(_animationController.status == AnimationStatus.completed) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          },
        child: Text("Text button"),
        color: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}