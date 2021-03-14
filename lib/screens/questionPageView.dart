import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/screens/questionScreen.dart';
import '../resources/constances.dart';
import '../resources/util.dart';

class QuestionPageView extends StatefulWidget {
   @override
  _QuestionPageViewState createState() => _QuestionPageViewState();
}

class _QuestionPageViewState extends State<QuestionPageView> {

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Reset current Basic Score and current Time bonus score
    DBService.currBasicScore = 0;
    DBService.currTimeBonus = 0;
    DBService.currCorrectQ = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: PageView.builder(
              controller: (_pageController = PageController(initialPage: 0)),
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),  //TODO NeverScrollableScrollPhysics()
              itemCount: kNumberOfQuestionsPerSet,
              itemBuilder: (context, index) {
                            return QuestionScreen(secID: DBService.currSectionID,
                                                  pageID: index,
                                                  onNextQ: _callBackNextQuestion,
                                                 );
              },
              onPageChanged: (index) async {
                // Check if Current Score is higher than current Best Score or not - if so, update CurrentBaseScore
                await DBService.instance.ensureBestScore(DBService.instance.getCurrScore());
              }
          ),
        )
    );
  }

  // Functions
  void _callBackNextQuestion(int qID, waitMilliSec) async {
    if (qID < (kNumberOfQuestionsPerSet-1)) {
      Timer(Duration(milliseconds: waitMilliSec), () {
          _pageController.jumpToPage(qID + 1);
      });
    }  else {
      // Play sound when all questions answered
      Timer(Duration(milliseconds: 1500), () {
        playFinishSound();
      });

      // In case of after 'kNumberOfQuestionsPerSet', to ensure Best Score,
      // since after page #kNumberOfQuestionsPerSet, onPageChanged() won't  be called
      await DBService.instance.ensureBestScore(DBService.instance.getCurrScore());
      // Go to Score Sum page
      Timer(Duration(milliseconds: (waitMilliSec/2).round()), () {
          Navigator.pushReplacementNamed(context, '/scoresum');
      });
    }
  }

}
