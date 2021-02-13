import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/answerButton.dart';
import 'package:vector_math/vector_math_64.dart';

class QuestionScreen extends StatefulWidget {
  int secID, pageID;
  bool bookmarked;
  Function(int, int) onNextQ;
  QuestionScreen({@required this.secID, @required this.pageID, @required this.bookmarked, @required this.onNextQ});

  @override
  _QuestionScreenState createState() => _QuestionScreenState(secID: secID, pageID: pageID, onNextQuestion: onNextQ);
}

class _QuestionScreenState extends State<QuestionScreen> with SingleTickerProviderStateMixin {
  _QuestionScreenState({@required this.secID, @required this.pageID, @required this.onNextQuestion});
  int secID, pageID, secQuestionID;
  Function(int, int) onNextQuestion;
  bool _previouslyAnswered;
  bool _hasAnswered = false;
  int _selectedAnswer = 0;

  double _answersHeight = 400.0; //TODO: need to be calculated.

//  List<Icon> _lstAnsIcons= [null,null,null];
//
//  // 'globalKey' to be used in Scaffold's key for SnackBar
//  final _globalKey = GlobalKey<ScaffoldState>();
//  Animation _animation;
//  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
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

                  child:
                Row(children: <Widget>[ //Icon(Icons.reply, color: kColorWhite),
                                       SizedBox(child: Icon(Icons.settings, color: kColorBlack,),
                                                width: 50.0),
                                      ])
                  ,onTap: () {

                     pauseAlertDialog(context);

                   // Navigator.of(context).pop();

                  }

                  ),


              iconTheme: IconThemeData(color: kColorThemeGreen),
              backgroundColor: kColorThemeTeal,
              title: Column (
                mainAxisAlignment: MainAxisAlignment.center, // .start,
                children:
                <Widget>[
                  Text('In Movie Trivia', style: kDefaultTS), //, style: kDefaultBlackTextStyle),
                ],
              )),
            //--> SECTION: BODY
            body: Column( children: <Widget>[
                    // Header in Body
                    Padding ( padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[

                                Row(children: <Widget>[
                                  Icon(Icons.favorite, size: 22, color: kColorThemeRed,),
                                  Text(' 200',
                                    style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),
                                  ),
                                ],),

                                 Row (
                                   children: <Widget> [Icon(Icons.timer, color: kColorPureBlack,),
                                                       // TODO: If less than 5, Text Color changed to 'kColorThemeRed'
                                                       Text(' 155', style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),)]
                                 ),

                                 Text('${pageID+1}/$kTotalQuestionNum', style: TextStyle(fontSize: 18.0, fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w600),), ],

                      ),
                    ),

                    // Question in Body
                    SizedBox(height: 30.0,),
                    Text(kQuestionText[pageID], style: TextStyle(fontSize: 30.0, color: kColorPureWhite, fontFamily: kDefaultFont,),),
                    SizedBox(height: 20.0),
                    SizedBox (
                      height: _answersHeight,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            AnswerButton(color: kColorThemeTeal, questionOrder: "A", text: kAns1Text[pageID],
                              trailingIcon: kIncorrectIcon, onPressed: null,),
                            AnswerButton(color: kColorThemeTeal, questionOrder: "B", text: kAns2Text[pageID],
                              trailingIcon: kCorrectIcon, onPressed: null,),
                            AnswerButton(color: kColorThemeTeal, questionOrder: "C", text: kAns3Text[pageID],
                              trailingIcon: kCorrectIcon, onPressed: null,),
                            AnswerButton(color: kColorThemeTeal, questionOrder: "D", text: kAns4Text[pageID],
                              trailingIcon: kCorrectIcon, onPressed: null,),
                          ],
                        ),
                      ),
                    ),



            ],

            )



      ),
        );

    // TEMP:




//    var _pd = MediaQuery.of(context).padding;
//    double _answersHeight = MediaQuery.of(context).size.height- _pd.top - _pd.bottom;
//    _answersHeight = _answersHeight - kMainHeaderHeight - kNoBannerHeightForNow - 150.0;
//
//    secQuestionID = DBService.currQBanks[pageID].secQuestionID;
//    _previouslyAnswered = (DBService.currQBanks[pageID].selectedAnswer != 0) ? true: false;
//
//    return Scaffold(
//      key: _globalKey,
//      backgroundColor: kThemeColorGrey,// kColorGrey,
//      appBar: AppBar(
//          leading: GestureDetector(child: Row(children: <Widget>[Icon(Icons.reply, color: kStudySectionColor),
//            Icon(Icons.home, color: kStudySectionColor,)])
//              ,onTap: () { Navigator.of(context).pop(); }),
//          iconTheme: IconThemeData(color: kColorDarkGreen),
//          backgroundColor: kColorGrey,
//          title: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children:
//            <Widget>[
//              Text('${kSectionText[secID]}: #${pageID+1}/${DBService.currQBanks.length} ', style: kDefaultBlackTextStyle),
//            ],
//          )),
//      body:
//
//      // *** TOP LEVEL COLUMN; containing Header, Body,  ***
//      Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//
//            // ** Header **
//            Container(
//              child:
//              Center(child:
//              Padding (
//                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
//                child:
//                Column (
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Text('${DBService.currQBanks[pageID].question}',
//                        style: kQuestionTextStyle.copyWith(fontWeight: bigFontIfNoImage(pageID) ),),
//                      getImage(pageID),
//                    ]
//                ),
//              ),
//              ),
//              height: kMainHeaderHeight,
//              decoration: BoxDecoration(
//                color: kStudySectionColor,
//                boxShadow: [BoxShadow(blurRadius: 6.0)],
//                borderRadius: BorderRadius.vertical(
//                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 12.0)),
//              ),
//            ),
//
//            SizedBox(height: 10.0),
//
//            // ** Body **
//            // (1) Sized this Box/Area with 'a set height' and put a child with
//            // (2) 'Scrollview' of scrollDirection of vertical and put child with
//            // (3) Column of AnswerButtons
//            SizedBox (
//              height: _answersHeight,
//              child: SingleChildScrollView (
//                padding: EdgeInsets.symmetric(horizontal: 16.0),
//                scrollDirection: Axis.vertical,
//                child: Column (
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  // mainAxisSize: MainAxisSize.max,
//                  children: <Widget>[
//                    AnswerButton(questionOrder: "A",
//                        text: '${DBService.currQBanks[pageID].answer1}', //, '${DBService.currQBanks[secID].answer1}',
//                        color: getColorforAnswer(1),
//                        trailingIcon: _lstAnsIcons[0],
//                        onPressed: () { _answerEntered(context, 1); }),
//                    AnswerButton(questionOrder: "B",
//                        text: '${DBService.currQBanks[pageID].answer2}',
//                        color: getColorforAnswer(2),
//                        trailingIcon: _lstAnsIcons[1],
//                        onPressed: () { _answerEntered(context, 2); }),
//                    AnswerButton(questionOrder: "C",
//                        text: '${DBService.currQBanks[pageID].answer3}',
//                        color: getColorforAnswer(3),
//                        trailingIcon: _lstAnsIcons[2],
//                        onPressed: () { _answerEntered(context, 3); }),
//                  ],
//                ),
//              ),
//            ),
//          ]
//      ),
//
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

}

// TEMP:

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

