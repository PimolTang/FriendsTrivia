import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/screens/questionScreen.dart';
import '../resources/constances.dart';

class QuestionPageView extends StatefulWidget {
  @override
  _QuestionPageViewState createState() => _QuestionPageViewState();
}

class _QuestionPageViewState extends State<QuestionPageView> {

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: PageView.builder(
              controller: (_pageController = PageController(initialPage: 0)),
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(), // NeverScrollableScrollPhysics(),
              itemCount: kNumberOfQuestionsPerSet,
              itemBuilder: (context, index) {
                return QuestionScreen(
                          secID: 1,
                          pageID: index,
                          bookmarked: true,
                          onNextQ: _callBackNextQuestion,
                       );
              },
              onPageChanged: (index) {}
          ),
        )
    );
  }

  // Functions
  void _callBackNextQuestion(int qID, int waitMilliSec) async {
    if (qID < (kNumberOfQuestionsPerSet-1)) {
      Timer(Duration(milliseconds: waitMilliSec), () {
          _pageController.jumpToPage(qID + 1);
      });
    }  else {
      Timer(Duration(milliseconds: 2800), () {
          Navigator.pushNamed(context, '/scoresum');
      });
    }
  }

}
