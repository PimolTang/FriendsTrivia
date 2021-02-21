import 'package:flutter/material.dart';

//--> C O L O R S
// From Canva: https://www.canva.com/colors/color-wheel/
// Picked Color: #511CBF
// #BF1C38, #8ABF1C and #1CBFA3
const kColorThemePurple = Color(0xff511CBF);
const kColorThemeLightPurple = Color(0xff511CDF); // Not sure if we need LightPurple.
const kColorThemeRed = Color(0xffBF1C38);
const kColorThemeGreen =  Color(0xff8ABF1C);
const kColorThemeTeal =  Color(0xff1CBFA3);

//const kColorWhite = Colors.white70;
const kColorBlack = Colors.black87;
const kColorPureBlack = Colors.black;
const kColorWhite = Colors.white;

const kColorYellow = Colors.yellowAccent;
const kColorRed = Colors.redAccent;

const kCorrectColor = Colors.lightGreenAccent;
const kIncorrectColor = Colors.pinkAccent;
const kShowAnswerColor = Colors.yellowAccent;

//--> F O N T S
const kDefaultFont = 'TitilliumWeb';
const kGabrielWFont = 'GabrielW';

//--> T E X T - S T Y L E S
const kDefaultTS = TextStyle(fontFamily: kDefaultFont);

//--> I C O N S
const Icon kCorrectIcon = Icon(Icons.check, color: Colors.black87,);
const Icon kIncorrectIcon = Icon(Icons.clear, color: Colors.white,);

const Icon kGoIcon = Icon(Icons.forward, color: Colors.white,);
const Icon kHomeIcon = Icon(Icons.home, color: Colors.white,);
const Icon kFavoriteScoreIcon = Icon(Icons.favorite, size: 22, color: kColorThemeRed);
const Icon kFavoriteScoreBigIcon = Icon(Icons.favorite, size: 34, color: kColorThemeRed);
// NOTE:
const Icon kBestIcon = Icon( Icons.grade, size: 30, color: kColorThemeRed);

//--> S O U N D S
const String kCorrectSound = 'sounds/Correct-answer.mp3';
const String kInCorrectSound = 'sounds/Incorrect-answer.mp3';
const String kTimedOutSound = 'sounds/Finish-answer.mp3';

// --> Constants
const int kNumberOfQuestionsPerSet = 20;
const int kTimeSecPerQuestion = 20;
const int kDelayBetweenQuestionMilliSec = 3000; // 3000;
const String kSection1Name = "In TV Series Trivia";
const String kSection2Name = "\'Who said this?\' Trivia";

const String kFanLevel1  = "Wow! You are the Biggest Fan!!";
const String kFanLevel2  = "Not bad! Joey would be quite impressed with you.";
const String kFanLevel3  = "Nobody likes a show-off, so everybody must like you!";
const String kFanLevel4  = "On the bright side, you can only go up from here!";

// TODO: TO BE USED
const List<String> kSectionNames = [kSection1Name, kSection2Name];

// --> Friends Banner
Widget kFriendsBanner = Container(
                          margin: EdgeInsets.all(20.0),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft,
                                        colors: [kColorThemeTeal, kColorThemeGreen]
                                      ),
                            color: kColorThemeGreen,
                            border: Border.all(color: kColorBlack, width: 3),
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          child: Center (child: Text('F r i e n d s \n T r i v i a', textAlign: TextAlign.center,
                                                style: TextStyle(color: kColorWhite, fontWeight: FontWeight.w800,
                                                       fontFamily: kGabrielWFont, fontSize: 30.0,
                                                       fontStyle: FontStyle.normal),),),
                        );

// -------------------

// Fan Levels: 4
// 1. Gold Level: Biggest Fan
// 2. Silver Level: Just a Real True Fan
// 3. Bronze Level: Just a Normal Fan
// 4. Basic Level: Not-into-it Fan

// BUGS:
// 1. Disable Back button on ScoreSumScreen
// 2. Put sounds; 3 cases!!
// 3. Implement the new Countdown timer; https://pub.dev/packages/circular_countdown_timer!!


