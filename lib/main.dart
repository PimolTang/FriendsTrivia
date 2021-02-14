import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/screens/getStartedScreen.dart';
import 'package:friendstrivia/screens/mainMenuScreen.dart';
import 'package:friendstrivia/screens/questionPageView.dart';
import 'package:friendstrivia/screens/scoreSumScreen.dart';

void main() {
  runApp(FriendsTriviaApp());
}

class FriendsTriviaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      color: kColorThemePurple,
      routes: {
        '/': (context) => GetStartedScreen(),       // #1
        '/mainmenu': (context) => MainMenuScreen(), // #2
        '/questions': (context) => QuestionPageView(), // #3
        '/scoresum' : (context) => ScoreSumScreen(), // #4
      },
      debugShowCheckedModeBanner: false,
    );
  }

}