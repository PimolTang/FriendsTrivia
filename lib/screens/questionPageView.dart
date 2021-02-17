import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendstrivia/models/argParameters.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/screens/questionScreen.dart';
import '../resources/constances.dart';

class QuestionPageView extends StatefulWidget {
  ArgParameters _arg;
  @override
  _QuestionPageViewState createState() => _QuestionPageViewState();
}

class _QuestionPageViewState extends State<QuestionPageView> {

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    int _secID;
    // Set RouteSetting to tap into 'Widget' passed from Parent
    RouteSettings settings = ModalRoute.of(context).settings;
    widget._arg = settings.arguments;
//TODO:    _secID = widget._arg.secId;
    // ----------------------------------------------------

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: PageView.builder(
              controller: (_pageController = PageController(initialPage: 0)),
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(), //AlwaysScrollableScrollPhysics(),
              itemCount: kNumberOfQuestionsPerSet,
              itemBuilder: (context, index) {
                //Load Questions by SectionID
                loadQuestionsForSecID(DBService.currSectionID);
                return QuestionScreen(secID: DBService.currSectionID,
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

  loadQuestionsForSecID(int _secID) async {
    await DBService.instance.refreshQuestionBankRandomly(_secID);
    Timer (Duration(milliseconds: 500), () { DBService.instance.setcurrSectionID(_secID); });
  }

  void _callBackNextQuestion(int qID, waitMilliSec) async {
    if (qID < (kNumberOfQuestionsPerSet-1)) {
      Timer(Duration(milliseconds: waitMilliSec), () {
          _pageController.jumpToPage(qID + 1);
      });
    }  else {
      Timer(Duration(milliseconds: (waitMilliSec/2).round()), () {
          Navigator.pushNamed(context, '/scoresum');
      });
    }
  }

}
