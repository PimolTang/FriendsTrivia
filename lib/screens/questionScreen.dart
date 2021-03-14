import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/answerButton.dart';
// import 'package:vector_math/vector_math_64.dart';
import '../models/dbService.dart';
import '../resources/constances.dart';
import '../resources/util.dart';
import 'package:progress_indicators/progress_indicators.dart';

class QuestionScreen extends StatefulWidget {
  int secID, pageID;
  Function(int, int) onNextQ;
  QuestionScreen({@required this.secID, @required this.pageID, @required this.onNextQ});

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
  double _answersHeight; // = 440.0;

  List<Icon> _lstAnsIcons = [null,null,null,null];
  List<Color> _lstAnsColor = [null,null,null,null];
  List<bool> _lstAnsBlinkFlag = [false, false, false, false];

  AnimationController controller;

  int get _timeLeft {
    Duration duration = controller.duration * controller.value;
    // case: timed out
    if(duration.inSeconds < 1) {
      // Play the finish sound
      playFinishSound();
      controller.stop(); // Stop Controller, so AnimatedBuilder won't do any more work.
      // Go to Score Summary Screen
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/scoresum');
      });
    }
    return duration.inSeconds;  // case: not timed out yet - to return Second(s) left
  }

  @override
  void initState() {
    super.initState();
    _lstAnsColor.fillRange(0, 4, kColorThemeTeal);
    _lstAnsIcons.fillRange(0, 4, null);
    _lstAnsBlinkFlag.fillRange(0, 4, false);
    pageScore = DBService.instance.getCurrScore();

    // Countdown Controller
    controller = AnimationController(vsync: this, duration: Duration(seconds: kTimeSecPerQuestion + 1));
    // Start countdown.
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  @override
  Widget build(BuildContext context) {

    var _pd = MediaQuery.of(context).padding;
    _answersHeight = MediaQuery.of(context).size.height- _pd.top - _pd.bottom;
    _answersHeight = _answersHeight - AppBar().preferredSize.height - kQuestionHeight - 28
                     - kNoBannerHeightForNow - 58 - 66;
    // DEBUG:
    print('CORRECT ANSWER: Answer ${DBService.instance.getCorrectAnswer(pageID)+1} -> ${DBService.currQBanks[pageID].correctAnswer + 1} <- ');

    return SafeArea (
          child: Scaffold(
          backgroundColor: kColorThemeLightPurple,// kColorGrey,
          appBar: AppBar(
              leading: GestureDetector(
                        child: Row(children: <Widget>[SizedBox(child: Icon(Icons.settings, color: kColorBlack,),
                                                               width: 50.0),]),
                        onTap: () {
                          controller.stop();
                          pauseAlertDialog(context);
                        }
                        ),
              iconTheme: IconThemeData(color: kColorThemeGreen),
              backgroundColor: kColorThemeTeal,
              title: Padding(padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // .start,
                          children:
                          <Widget>[
                            Text(kSectionNames[secID-1] , style: kDefaultTS),
                            getIconSection(),//, style: kDefaultBlackTextStyle),
                          ],
                        ),
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
                                    Text("  " + addComma(DBService.instance.getCurrScore()),
                                         style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),
                                    ),
                                  ],),
                                  Row (children: <Widget> [kTimerIcon,
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
                    Container (
                      alignment: Alignment.center,
                      height: kQuestionHeight,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[Flexible(child: Text(DBService.instance.getQuestionText(pageID),
                                                                         textAlign: TextAlign.center,
                                                                         style: TextStyle(fontSize: 24.0, color: kColorWhite,
                                                                                fontFamily: kDefaultFont,)),
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
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: _alreadyAnswered,
                              child: HeartbeatProgressIndicator(
                                startScale: 0.7, endScale: 2.0,
                                duration: Duration(seconds: 1),
                                child: correctOrIncorrect,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
            ),

//      // *** END TOP LEVEL COLUMN ***
            bottomNavigationBar: SizedBox(height: kNoBannerHeightForNow,
                                 child: Container(color: kColorWhite, child: Text('TEST ME'),)), // Dummy area for Admob
    ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        // Sound - CORRECT SOUNDS
        playCorrectSound(pageID);

        // Scores: timeBonus, basicScore, correctQuestion
        //
        // BasicScore = 50/question --> 100
        // TimeBonus = Time>18 --> +50, Time>10 --> +20, Time<10 --> +10
        //
        // For Summary Screen
        DBService.currCorrectQ += 1;
        DBService.currTimeBonus += (_timeLeft > 17) ? 50 : ((_timeLeft > 9) ? 20 : 10);
        DBService.currBasicScore += 100;

        // Page's score
        newAdditionalScore = (_timeLeft > 17) ? 150 : ((_timeLeft > 9) ? 120 : 110);

        //print('DEBUG: TIME REMAINING = $_timeLeft' );
        //print('DEBUG: ADDITIONAL SCORE: $newAdditionalScore');
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
        // Sound - INCORRECT SOUND and FINISH SOUND
        playInCorrectSound();
        Timer(Duration(milliseconds: 2500), () {
          playFinishSound();
        });

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
        // Play Finish Sound
        playFinishSound();
        // Go to ScoreSum screen
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getIconSection() {
      return (secID == 1)? Icon(kIconSection1, color: Colors.white70,): Icon(kIconSection2, color: Colors.white70,);
  }
}
