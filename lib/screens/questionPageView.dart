import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/screens/questionScreen.dart';

class QuestionPageView extends StatefulWidget {
  @override
  _QuestionPageViewState createState() => _QuestionPageViewState();
}

class _QuestionPageViewState extends State<QuestionPageView> {

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: PageView.builder(
              controller: (pageController = PageController(initialPage: 0)),
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(), // NeverScrollableScrollPhysics(),
              itemCount: kTotalQuestionNum,
              itemBuilder: (context, index) {
                return QuestionScreen(
                          secID: 1,
                          pageID: index,
                          bookmarked: true,
                          onNextQ: null,
                       );
              },
              onPageChanged: (index) {}
          ),
        )
    );
  }
}
