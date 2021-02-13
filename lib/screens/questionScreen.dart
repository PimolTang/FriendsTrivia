import 'dart:async';
import 'package:flutter/material.dart';
import  'package:circular_countdown/circular_countdown.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/answerButton.dart';
import 'package:progress_indicators/progress_indicators.dart';
// import 'package:vector_math/vector_math_64.dart';
import '../models/dbService.dart';
import '../resources/constances.dart';


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
  int _timeSec = 30;
  bool _timeStoppedFlag = false;

  int _selectedAnswer = 0;
  bool _previouslyAnswered;

  List<Icon> _lstAnsIcons = [null,null,null,null];
  List<Color> _lstAnsColor = [null,null,null,null];

//    var _pd = MediaQuery.of(context).padding;
//    double _answersHeight = MediaQuery.of(context).size.height- _pd.top - _pd.bottom;
//    _answersHeight = _answersHeight - kMainHeaderHeight - kNoBannerHeightForNow - 150.0;
      double _answersHeight = 440.0; //TODO: need to be calculated.
//
//    secQuestionID = DBService.currQBanks[pageID].secQuestionID;
//    _previouslyAnswered = (DBService.currQBanks[pageID].selectedAnswer != 0) ? true: false;
//
// =========================
//
//  // 'globalKey' to be used in Scaffold's key for SnackBar
//  final _globalKey = GlobalKey<ScaffoldState>();
//  Animation _animation;
//  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _lstAnsColor.fillRange(0, 4, kColorThemeTeal);
    _lstAnsIcons.fillRange(0, 4, null); //Icon(Icons.check, color: kColorThemeTeal,));

    // Image animation
//    _animationController = new AnimationController(vsync: this, duration: Duration(microseconds: 100));
//    _animation = Tween(begin: 1.0, end: 1.8).animate((CurvedAnimation(parent: _animationController,curve: Curves.easeInOut))..addListener(() {
//      setState(() { });
//    }));
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea (
          child: Scaffold(
          backgroundColor: kColorThemeLightPurple,// kColorGrey,
          appBar: AppBar(
              leading: GestureDetector(
                        child: Row(children: <Widget>[ //Icon(Icons.reply, color: kColorWhite),
                                                        SizedBox(child: Icon(Icons.settings, color: kColorBlack,),
                                                                 width: 50.0),
                                                      ])
                        , onTap: () { pauseAlertDialog(context);  }
                        ),
              iconTheme: IconThemeData(color: kColorThemeGreen),
              backgroundColor: kColorThemeTeal,
              title: Column (
                mainAxisAlignment: MainAxisAlignment.center, // .start,
                children:
                <Widget>[
                  Text(kSection1Name, style: kDefaultTS), //, style: kDefaultBlackTextStyle),
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
                                    Icon(Icons.favorite, size: 22, color: kColorThemeRed,),
                                    Text(' 200',
                                      style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),
                                    ),
                                  ],),

                                  Row (children: <Widget> [ // Icon(Icons.timer, color: kColorPureBlack,),
                                                            SizedBox (
                                                              width: 28.0,
                                                              height: 28.0,
                                                              child: TimeCircularCountdown(
                                                                unit: CountdownUnit.second,
                                                                countdownTotal: kTimeSecPerQuestion,
                                                                onUpdated: (unit, remainingTime) {
                                                                              // _timeStoppedFlag is to stop time when already answered!
                                                                              if (_timeStoppedFlag == false) {
                                                                                  setState(() {
                                                                                    _timeSec = remainingTime;
                                                                                  });
                                                                              }
                                                                            },
                                                                onFinished: () {
                                                                  setState(() {
                                                                     _timeSec = 0;
                                                                     onNextQuestion(pageID, 1);
                                                                  });
                                                                },
                                                                onCanceled: null,
                                                                countdownRemainingColor: (_timeSec < 6) ? kColorRed : kColorYellow

                                                              ),
                                                            ),

                                                           Text(' $_timeSec', style: TextStyle(fontSize: 20.0, fontFamily: kDefaultFont,
                                                                              color: (_timeSec < 6) ? kColorThemeRed : kColorWhite,
                                                                              fontWeight: FontWeight.w600),)]
                                  ),

                                 Text('${pageID+1}/$kNumberOfQuestionsPerSet', style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),), ],

                      ),
                    ),

                    //--> Question in Body
                    Container (
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 14.0,vertical: 18.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Flexible(child: Text('${DBService.currQBanks[pageID].question}',
                                                             style: TextStyle(fontSize: 26.0, color: kColorPureWhite, fontFamily: kDefaultFont,)),
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
                            AnswerButton(color: _lstAnsColor[0], label: "A", text: '${DBService.currQBanks[pageID].answer1}',
                              trailingIcon: _lstAnsIcons[0], onPressed: () { _answerEntered(context, 0); },),
                            AnswerButton(color: _lstAnsColor[1], label: "B", text: '${DBService.currQBanks[pageID].answer2}',
                              trailingIcon: _lstAnsIcons[1], onPressed: () { _answerEntered(context, 1); },),
                            AnswerButton(color: _lstAnsColor[2], label: "C", text: '${DBService.currQBanks[pageID].answer3}',
                              trailingIcon: _lstAnsIcons[2], onPressed: () { _answerEntered(context, 2); },),
                            AnswerButton(color: _lstAnsColor[3], label: "D", text: '${DBService.currQBanks[pageID].answer4}',
                              trailingIcon: _lstAnsIcons[3], onPressed: () { _answerEntered(context, 3); },),
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

  // -------------------
  //  F U N C T I O N S
  // -------------------
//  void _toggleBookmark (int sID, int sQuestID) {
//    DBService.instance.updateBookmark(sID, sQuestID, (widget.bookmarked) ? 0 : 1);
//    setState(() {
//      widget.bookmarked = !widget.bookmarked;
//    });
//  }
//
//  Color getColorforAnswer(int i) {
//    // LOGIC:
//    // 1.1 If 'previouslyAnswer' = true and this answer is correct --> Green
//    // 1.2 If 'previouslyAnswer' = true and this Answer Selected and this answer incorrect --> Red
//    // 1.3 If 'previouslyAnswer' = true and this Answer NOT Selected --> White
//    // 2.0 If 'previouslyAnswer' = false --> Go with normal flow.
//
//    if (_previouslyAnswered) {
//      if (_isAnsCorrect(i)) {
//        // 1.1 previously answered mode and CORRECT
//        _lstAnsIcons[i-1] = kCorrectIcon;
//        return kColorGreen; // kColorLightGreen;
//      } else {
//        if (DBService.currQBanks[pageID].selectedAnswer == i) {
//          // 1.2: previously answered mode and NOT Correct.
//          _lstAnsIcons[i - 1] = kIncorrectIcon;
//          // _boolNextQuesBtnVisibility = true;
//          return kColorLightRed; // 'the incorrect answer' got selected.
//        } else {
//          // 1.3: previously answered mode and NOT EVEN SELECTED.
//          // _lstAnsIcons[i-1] = kCorrectIcon;  // TO CHANGE to nothing ICON
//          return kColorWhite;
//        }
//      }
//
//    } else {
//      // 2
//      return ((_hasAnswered)
//          ? (_answerCorrectAndSelectedOrNot(i))
//          : kColorWhite);
//    }
//
//  }
//
//  // NOTE: This method will be triggered when 'hasAnswered' parameter has changed.
//  Color _answerCorrectAndSelectedOrNot(int i) {
//    // Case: When 'the correct answer', ('selected' or 'not') --> give Green to that button
//    if (_isAnsCorrect(i)) {
//      _lstAnsIcons[i-1] = kCorrectIcon;
//      return kColorGreen; // kColorLightGreen;
//    } else {
//      // Case: When 'the incorrect answer':
//      if (_selectedAnswer == i) {
//        _lstAnsIcons[i-1] = kIncorrectIcon;
//        // _boolNextQuesBtnVisibility = true;
//        return kColorLightRed; // 'the incorrect answer' got selected.
//      } else {
//        return kColorWhite; // 'the incorrect answer' & NOT selected.
//      }
//    }
//  }
//
//  void _answerEntered(BuildContext context, int i) async {
//    if ((_hasAnswered == false) && (_previouslyAnswered == false)) {
//      setState(() {
//        _previouslyAnswered = true;
//        _hasAnswered = true;
//        _selectedAnswer = i;
//      });
//      // case: the selected answer is CORRECT, then AutoNextQuestion is on
//      if (_isAnsCorrect(_selectedAnswer)) {
//        // Save Answer into Database ('isCorrect'); 1 is CORRECT; 0 is INCORRECT
//        await DBService.instance.updateStudysIsCorrect(secID, secQuestionID, 1);
//        // Show Snackbar to say 'it's correct!'
//        _globalKey.currentState.showSnackBar(kSnackBarCorrectAnswer);
//
//        // Auto Next
//        onNextQuestion(secID, secQuestionID);
//        // -----------------------------------------------
//      } else { // Case: the selected answer is INCORRECT!
//        await DBService.instance.updateStudysIsCorrect(secID, secQuestionID, 0);
//      }
//      // Save Answer into Database ('selectedAnswer')
//      await DBService.instance.updateStudysSelectedAnswer(secID, secQuestionID, _selectedAnswer);
//    }
//  }
//
//  bool _isAnsCorrect(int i) {
//    return (DBService.currQBanks[pageID].correctAnswer == i) ? true : false;
//  }
//
//  FontWeight bigFontIfNoImage(int pID) {
//    return (DBService.currQBanks[pID].image != 'n') ? FontWeight.w600 : FontWeight.w800;
//  }
//
//  Widget getImage(int pID) {
//    if(DBService.currQBanks[pID].image != 'n') {
//      return GestureDetector (
//        onTap: () {
//          if (_animationController.isCompleted) { _animationController.reverse(); }
//          else { _animationController.forward(); }
//        },
//        child: Transform (
//          alignment: Alignment.center,
//          transform: Matrix4.diagonal3(Vector3(_animation.value, _animation.value, _animation.value)),
//          child: Image.asset('assets/images/${DBService.currQBanks[pageID].image}',
//              height: kMainHeaderHeight - 150,  // 275-150 = 125
//              fit: BoxFit.fitHeight),
//        ),
//      );
//    } else
//      return SizedBox(height: 10.0,);
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _animationController.dispose();
//  }

// -------------------------------
// Functions in Stateful Widgets!
// -------------------------------

  void _answerEntered(BuildContext context, int selAns) async {
    if (!_alreadyAnswered) {
      _alreadyAnswered = true;
      int correctAns = DBService.currQBanks[pageID].correctAnswer;

      print("Correct Answer is: $correctAns");
      print("Selected Answer Answer is: $selAns");

      _lstAnsIcons.fillRange(0, 4, null);
      _lstAnsColor.fillRange(0, 4, kColorThemeTeal);
      _selectedAnswer = selAns + 1; // Then it will trigger 'Answer Button's BackgroundColor' as well

      // Case: C O R R E C T
      if (DBService.currQBanks[pageID].correctAnswer == selAns) {
        setState(() {
          _timeStoppedFlag = true;
          _lstAnsIcons[selAns] = kCorrectIcon;
          _lstAnsColor[selAns] = kCorrectColor;
          correctOrIncorrect = Text(' Correct! ', style: kDefaultTS.copyWith(fontSize: 18.0,color: kColorPureWhite),);
        });
      } else {
        // Case: I N C O R R E C T (need to set Correct one and the Selected one)
        setState(() {
          _timeStoppedFlag = true;
          _lstAnsIcons[correctAns] = kCorrectIcon;
          _lstAnsColor[correctAns] = kCorrectColor;
          _lstAnsIcons[selAns] = kIncorrectIcon;
          _lstAnsColor[selAns] = kIncorrectColor;
          correctOrIncorrect = Text(' Incorrect! ', style: kDefaultTS.copyWith(fontSize: 18.0,color: kColorThemeRed),);
        });
      }

      // Save Answer into Database ('testSelectedAnswer')
      //    await DBService.instance.updateTestsSelectedAnswer(
      //          testID, testQuestionID, _testSelectedAnswer);

      // Goto the next question
      onNextQuestion(pageID, 2000);
    }
  }
}

// -----------------------
// Independence Functions!
// -----------------------

void pauseAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Resume", style: kDefaultTS.copyWith(color: kColorBlack),),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("End Now", style: kDefaultTS.copyWith(color: kColorBlack),),
    onPressed: () {
      Navigator.of(context).pop();
      Timer(Duration(milliseconds: 100), () {
        Navigator.of(context).pop();
        // TODO: Go to Summary page (To be created later!!)
        Navigator.of(context).pushNamed('/scoresum');
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

