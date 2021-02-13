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

const kColorWhite = Colors.white70;
const kColorBlack = Colors.black87;
const kColorPureBlack = Colors.black;

const kColorPureWhite = Colors.white;

//--> F O N T S
const kDefaultFont = 'TitilliumWeb';
const kGabrielWFont = 'GabrielW';

//--> T E X T - S T Y L E S
const kDefaultTS = TextStyle(fontFamily: kDefaultFont);

//--> I C O N S
const Icon kCorrectIcon = Icon(Icons.check, color: Colors.white,);
const Icon kIncorrectIcon = Icon(Icons.clear, color: Colors.white,);
const Icon kGoIcon = Icon(Icons.forward, color: Colors.white,);
const Icon kHomeIcon = Icon(Icons.home, color: Colors.white,);

// --> Constants
const int kTotalQuestionNum = 5;

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


//--> Dummy Data

const List<String> kQuestionText = ['Who says \'How you doing?\'','Who is the oldest one?','question1','question1','question1'];
const List<String> kAns1Text = ['Ross','Phoebe','Answer1','Answer1','Answer1'];
const List<String> kAns2Text = ['Rachel','Monica','Answer2','Answer2','Answer2'];
const List<String> kAns3Text = ['Joey','Chandler','Answer3','Answer3','Answer3'];
const List<String> kAns4Text = ['Nobody!','Gunther','Answer4','Answer4','Answer4'];
const List<int> kCorrectAns = [0,1,2,3,0];

// -------------------

// Fan Levels: 4
// 1. Gold Level: Biggest Fan
// 2. Silver Level: Just a Real True Fan
// 3. Bronze Level: Just a Normal Fan
// 4. Basic Level: Not-into-it Fan
