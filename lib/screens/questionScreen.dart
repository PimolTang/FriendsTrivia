import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:circular_countdown/circular_countdown.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/answerButton.dart';
import 'package:progress_indicators/progress_indicators.dart';
// import 'package:vector_math/vector_math_64.dart';
import '../models/dbService.dart';
import '../resources/constances.dart';
import 'package:audioplayers/audio_cache.dart';

class QuestionScreen extends StatefulWidget {
  int secID, pageID;
  bool bookmarked;
  Function(int, int) onNextQ;
  QuestionScreen({@required this.secID, @required this.pageID, @required this.bookmarked, @required this.onNextQ});

  @override
  _QuestionScreenState createState() => _QuestionScreenState(secID: secID, pageID: pageID, onNextQuestion: onNextQ);
}

class _QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  int secID, pageID, secQuestionID;
  Function(int,int) onNextQuestion;
  _QuestionScreenState({@required this.secID, @required this.pageID, @required this.onNextQuestion});

  bool _alreadyAnswered = false;
  Text correctOrIncorrect = Text('');
  int pageScore;
  int newAdditionalScore;
  int _selectedAnswer = 0;

  final soundPlayer = AudioCache();

  List<Icon> _lstAnsIcons = [null,null,null,null];
  List<Color> _lstAnsColor = [null,null,null,null];
  List<bool> _lstAnsBlinkFlag = [false, false, false, false];

//    var _pd = MediaQuery.of(context).padding;
//    double _answersHeight = MediaQuery.of(context).size.height- _pd.top - _pd.bottom;
//    _answersHeight = _answersHeight - kMainHeaderHeight - kNoBannerHeightForNow - 150.0;
  double _answersHeight = 440.0; //TODO: need to be calculated.

  AnimationController controller;
  int get _timeLeft {
    Duration duration = controller.duration * controller.value;
    // case: timed out
    if(duration.inSeconds < 1) {
      // Play sound
      soundPlayer.play(kTimedOutSound);
      soundPlayer.clearCache();
      controller.stop(); // Stop Controller, so AnimatedBuilder won't do any more work.
      // Go to Score Summary Screen
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/scoresum');
      });
    }
    return duration.inSeconds;  // case: not timed out yet - to return Second(s) left
  }

//  //'globalKey' to be used in Scaffold's key for SnackBar
//  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _lstAnsColor.fillRange(0, 4, kColorThemeTeal);
    _lstAnsIcons.fillRange(0, 4, null); //Icon(Icons.check, color: kColorThemeTeal,));
    _lstAnsBlinkFlag.fillRange(0, 4, false);
    pageScore = DBService.instance.getCurrScore();

    // Countdown Controller
    controller = AnimationController(vsync: this, duration: Duration(seconds: 21));
    // Start countdown.
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  Widget build(BuildContext context) {
    // DEBUG:
    print('CORRECT ANSWER: Answer ${DBService.instance.getCorrectAnswer(pageID)+1} ');

    return SafeArea (
          child: Scaffold(
          backgroundColor: kColorThemeLightPurple,// kColorGrey,
          appBar: AppBar(
              leading: GestureDetector(
                        child: Row(children: <Widget>[ //Icon(Icons.reply, color: kColorWhite),
                                                        SizedBox(child: Icon(Icons.settings, color: kColorBlack,),
                                                                 width: 50.0),
                                                      ]),
                        onTap: () {
                          controller.stop();
                          pauseAlertDialog(context);
                        }
                        ),
              iconTheme: IconThemeData(color: kColorThemeGreen),
              backgroundColor: kColorThemeTeal,
              title: Column (
                mainAxisAlignment: MainAxisAlignment.center, // .start,
                children:
                <Widget>[
                  Text(kSectionNames[secID-1], style: kDefaultTS), //, style: kDefaultBlackTextStyle),
                ],
              )),

            //--> SECTION: BODY
            body: Column( children: <Widget>[
                    // Header in Body
                    Padding ( padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                                  Row(children: <Widget>[
                                    kFavoriteScoreIcon,
                                    Text(addComma(DBService.instance.getCurrScore()),
                                         style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),
                                    ),
                                  ],),
                                  Row (children: <Widget> [  kTimerIcon,
                                                             AnimatedBuilder(animation: controller, builder: (context, child) {
                                                               return Text(' $_timeLeft',style: TextStyle(fontSize: 22.0, fontFamily: kDefaultFont,
                                                                                         color: (_timeLeft > 11) ? kColorWhite : (_timeLeft < 6) ? kColorThemeRed : kColorYellow,
                                                                                         fontWeight: FontWeight.w800));
                                                             })
                                                            ]
                                  ),
                                 Text('${pageID+1}/$kNumberOfQuestionsPerSet', style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),), ],
                      ),
                    ),
                    //--> Question in Body
                    // TODO: BUG HERE, WHEN QUESTION TEXT IS TOO LONG, IT will push Answer box out of the screen!!
                    Container (
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 14.0,vertical: 18.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Flexible(child: Text(DBService.instance.getQuestionText(pageID),
                                                                  style: TextStyle(fontSize: 24.0,
                                                                  color: kColorWhite, fontFamily: kDefaultFont,)),
                          )]),
                    ),

                    //--> Answers in Body
                    SizedBox(
                      height: _answersHeight,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            AnswerButton(color: _lstAnsColor[0], label: "A",
                                         text: DBService.instance.getAnswer1Text(pageID),
                                         trailingIcon: _lstAnsIcons[0], blinkFlag: _lstAnsBlinkFlag[0],
                                         onPressed: () { _answerEntered(context, 0); },),
                            AnswerButton(color: _lstAnsColor[1], label: "B",
                                         text: DBService.instance.getAnswer2Text(pageID),
                                         trailingIcon: _lstAnsIcons[1], blinkFlag: _lstAnsBlinkFlag[1],
                                         onPressed: () { _answerEntered(context, 1); },),
                            AnswerButton(color: _lstAnsColor[2], label: "C",
                                         text: DBService.instance.getAnswer3Text(pageID),
                                         trailingIcon: _lstAnsIcons[2], blinkFlag: _lstAnsBlinkFlag[2],
                                         onPressed: () { _answerEntered(context, 2); },),
                            AnswerButton(color: _lstAnsColor[3], label: "D",
                                         text: DBService.instance.getAnswer4Text(pageID),
                                         trailingIcon: _lstAnsIcons[3], blinkFlag: _lstAnsBlinkFlag[3],
                                         onPressed: () { _answerEntered(context, 3); },),
                            SizedBox(height: 12.0,),
                            Visibility (
                              visible: _alreadyAnswered,
                              child: HeartbeatProgressIndicator(
                                startScale: 0.8, endScale: 2.2,
                                duration: Duration(seconds: 1),
                                child: correctOrIncorrect,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
            )

      ),
        );

//      // *** END TOP LEVEL COLUMN ***
//
//      bottomNavigationBar: SizedBox(height: kNoBannerHeightForNow,), // Dummy area for Admob
//
//      floatingActionButton: FloatingActionButton.extended(
//        backgroundColor: kColorWhite, //Color(0xfff4b890),// kColorYellow,
//        icon: ((widget.bookmarked) ? kBookmarkedIcon: kUnbookmarkedIcon),
//        label: Text(((widget.bookmarked) ? "Bookmarked" : "To bookmark"),
//            style: kDefaultBlackTextStyle.copyWith(fontSize: 12.0, color: kStudySectionColor, fontWeight: FontWeight.w900)),
//        onPressed: () { _toggleBookmark(secID, secQuestionID); },
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

// -------------------------------------------
//  F U N C T I O N S in Stateful Widgets!
// -------------------------------------------
  void _answerEntered(BuildContext context, int selAns) async {
    if (!_alreadyAnswered) {
      controller.stop();
      _alreadyAnswered = true;
      int correctAns = DBService.currQBanks[pageID].correctAnswer;

      _lstAnsIcons.fillRange(0, 4, null);
      _lstAnsColor.fillRange(0, 4, kColorThemeTeal);
      _selectedAnswer = selAns + 1; // Then it will trigger 'Answer Button's BackgroundColor' as well

      // Set 'gotSelected' flag into Database for that 'SectionID' and 'QuestionID'
      await DBService.instance.updateGotSelected(DBService.currSectionID, DBService.currQBanks[pageID].questionID, 1);

      // Case: C O R R E C T
      if (DBService.currQBanks[pageID].correctAnswer == selAns) {
        // Sound - CORRECT SOUND
        soundPlayer.play(kCorrectSound);
        // Score timeBonus, basicScore, correctQuestion
        DBService.currCorrectQ += 1;
        DBService.currTimeBonus += (_timeLeft > 10) ? 200 : ((_timeLeft > 5) ? 100 : 50);
        DBService.currBasicScore += 50;
        newAdditionalScore = (_timeLeft > 10) ? 250 : ((_timeLeft > 5) ? 150 : 100);

        print('DEBUG: TIME REMAINING = $_timeLeft' );
        print('DEBUG: ADDITIONAL SCORE: $newAdditionalScore');
        await DBService.instance.setCurrScore(pageScore + newAdditionalScore);

        setState(() {
          pageScore = DBService.instance.getCurrScore();
          _lstAnsIcons[selAns] = kCorrectIcon;
          _lstAnsColor[selAns] = kCorrectColor;
          correctOrIncorrect = Text(' Correct! +$newAdditionalScore', style: kDefaultTS.copyWith(fontSize: 18.0,color: kCorrectColor),);
        });

        // CASE: CORRECT --> CONTINUE To the next question
        // Goto the next question
        onNextQuestion(pageID, kDelayBetweenQuestionMilliSec);
      } else {
        // Case: I N C O R R E C T (need to set Correct one and the Selected one)
        // Sound - INCORRECT SOUND
        soundPlayer.play(kInCorrectSound);
        setState(() {
          _lstAnsIcons[correctAns] = kCorrectIcon;
          _lstAnsColor[correctAns] = kCorrectColor;
          _lstAnsIcons[selAns] = kIncorrectIcon;
          _lstAnsColor[selAns] = kIncorrectColor;
          correctOrIncorrect = Text(' Incorrect! ', style: kDefaultTS.copyWith(fontSize: 16.0,color: kColorRed),);
        });

        // CASE: INCORRECT
        // OPTION 1: --> GO TO scoresumscreen right away!
        Timer(Duration(milliseconds: kDelayBetweenQuestionMilliSec), () {
          Navigator.pushReplacementNamed(context, '/scoresum');
        });

        // ** OPTION 2: To go to next question (GOH: please uncomment below if you want to). **
        // onNextQuestion(pageID, kDelayBetweenQuestionMilliSec);
      }
    }
  }

  // Functions
  void pauseAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Resume", style: kDefaultTS.copyWith(color: kColorBlack),),
      onPressed: () {
        controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("End Now", style: kDefaultTS.copyWith(color: kColorBlack),),
      onPressed: () {
        Navigator.of(context).pop();
        Timer(Duration(milliseconds: 100), () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/scoresum');
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: kColorThemeGreen,
      title: Text("Finish Game?", style: kDefaultTS.copyWith(color: kColorPureBlack)),
      content: Text("Do you wish to end your game with \nthe current score?", style: kDefaultTS.copyWith(color: kColorWhite)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String addComma(int score) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    String scoreWithComma = '$score'.replaceAllMapped(reg, mathFunc);
    return scoreWithComma;
  }

}

