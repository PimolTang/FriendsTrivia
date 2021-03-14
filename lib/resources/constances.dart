import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//--> C O L O R S
// From Canva: https://www.canva.com/colors/color-wheel/
// Picked Color: #511CBF
// #BF1C38, #8ABF1C and #1CBFA3
const kColorThemePurple = Color(0xff511CBF);
const kColorThemeLightPurple = Color(0xff511CDF); // Not sure if we need LightPurple.
const kColorThemeRed = Color(0xffBF1C38);
const kColorThemeGreen =  Color(0xff8ABF1C);
const kColorThemeTeal =  Color(0xff1CBFA3);

const kColorBlack = Colors.black87;
const kColorPureBlack = Colors.black;
const kColorGrey = Colors.grey;
const kColorWhite = Colors.white;

const kColorYellow = Colors.yellowAccent;
const kColorRed = Colors.redAccent;
const kCorrectColor = Colors.lightGreenAccent;
const kIncorrectColor = Colors.pinkAccent;
const kShowAnswerColor = Colors.yellowAccent;

const kBlueAccentColor = Colors.blueAccent;
const kBlueLightColor = Colors.lightBlue;

//--> F O N T S
const kDefaultFont = 'TitilliumWeb';
const kGabrielWFont = 'GabrielW';

//--> T E X T - S T Y L E S
const kDefaultTS = TextStyle(fontFamily: kDefaultFont);
const kDefaultWhiteTS = TextStyle(fontFamily: kDefaultFont, color: kColorWhite, fontSize: 18.0);

//--> I C O N S
const IconData kIconSection1 = Icons.weekend_outlined;
const IconData kIconSection2 = Icons.question_answer_rounded;

const Icon kCorrectIcon = Icon(Icons.check, color: Colors.black87,);
const Icon kIncorrectIcon = Icon(Icons.clear, color: Colors.white,);

const Icon kGoIcon = Icon(Icons.forward, color: Colors.white,);
const Icon kHomeIcon = Icon(Icons.home, color: Colors.white,);
const Icon kFavoriteScoreIcon = Icon(Icons.favorite, size: 22, color: kColorThemeRed);
const Icon kFavoriteScoreBigIcon = Icon(Icons.favorite, size: 34, color: kColorThemeRed);
const Icon kTimerIcon = Icon(Icons.timer, size: 24, color: kColorYellow);
const Icon kBestIcon = Icon( Icons.grade, size: 30, color: kColorThemeRed);

//--> S O U N D S
const String kCorrectSound1 = 'sounds/Correct-answer.mp3';
const String kCorrectSound3 = 'sounds/Correct-Chime.mp3';
const String kCorrectSound2 = 'sounds/Correct-MaleVoice.mp3';
const String kInCorrectSound = 'sounds/Incorrect-answer.mp3';
const String kTimedOutSound = 'sounds/Finish-answer.mp3';

// --> C o n s t a n t - V a l u e s
const int kNumberOfQuestionsPerSet = 5; // 191; // 20;  //Section 1 and 2: 191 and 75
const int kTimeSecPerQuestion = 20; //TODO CHANGE BACK to 20;
const int kDelayBetweenQuestionMilliSec = 3000;
const String kSection1Name = "In TV Series Trivia";
const String kSection2Name = "\'Who said this?\' Trivia";
const List<String> kSectionNames = [kSection1Name, kSection2Name];

const String kFanMsgLevel1  = "WOW!! You are the Biggest Fan!!";
const String kFanMsgLevel2  = "Not bad! :) Joey would be quite impressed with you.";
const String kFanMsgLevel3  = "Hmm..., You\'ve probably only caught this show whenever it was on TV.";
const String kFanMsgLevel4  = "Oh Dear... We have a problem! ";

// --> Friends Banner
Widget kFriendsBanner = Container(
                          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                          height: 110,
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

const double kQuestionHeight = 156;
const double kNoBannerHeightForNow = 0; //50; // NoBanner for Now!

// -------------------
// TODO: version 1.1
// 1. A Feature to Share
// 2. Silent Mode
// 3. Admob
// 4. Ticket system??
// -------------------