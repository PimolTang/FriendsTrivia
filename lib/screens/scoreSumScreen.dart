import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';

// Your Score: xxxx
// Best: xxxx
//
// ICON of ticket: 20
//
// Play Again button
// Share button - to Facebook ???
// Main Menu button

class ScoreSumScreen extends StatefulWidget {
  @override
  _ScoreSumScreenState createState() => _ScoreSumScreenState();
}

class _ScoreSumScreenState extends State<ScoreSumScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
        appBar: AppBar(title: Text('Score Summary', style: TextStyle(fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w800),),
          backgroundColor: kColorThemeTeal,
        ),        
        body: Center (
          child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                        Image.network('https://image.shutterstock.com/image-illustration/award-golden-cup-game-medal-600w-1335539501.jpg',
                        scale: 2.4,
                        fit: BoxFit.fitWidth,),

                Text('You are the Biggest Fan!!', style: kDefaultTS.copyWith(fontSize: 24.0, color: kColorPureWhite),),
                //--> Line 3
                Container(
                  margin: EdgeInsets.all(10.0),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kColorThemeGreen,
                    border: Border.all(color: kColorBlack, width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Center (child: Text('Score: 450', textAlign: TextAlign.center,
                    style: TextStyle(color: kColorWhite, fontWeight: FontWeight.w800, fontSize: 16.0),)),
                ),
                //--> Line 4:

                Text('Best: 1200', style: kDefaultTS.copyWith(fontSize: 26.0, color: kColorPureWhite),),

                //--> Line 5:
                Container (
                  margin: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  <Widget> [

                        RaisedButton (
                          child: Text(' Play Again ', style: TextStyle(color: kColorBlack, fontSize: 20.0),),
                          color: kColorThemeGreen,
                          onPressed: () {
                            try {
                              int count = 0;
                              Navigator.of(context).popUntil((_) => count++ >= 2);
                              Navigator.pushNamed(context, '/questions'); // TODO: GO TO QUESTION FOR NOW
                            } catch (ex){
                              print('Exception: $ex');
                            }
                          },
                        ),

                        RaisedButton (
                          child: Text(' Share ', style: TextStyle(color: kColorBlack, fontSize: 20.0),),
                          color: kColorThemeGreen,
                          onPressed: () {
                            // Navigator.pushNamed(context, '/mainmenu');
                          },
                        ),

                        RaisedButton (
                          child: Text(' Go Main Menu ', style: TextStyle(color: kColorBlack, fontSize: 20.0),),
                          color: kColorThemeGreen,
                          onPressed: () {
                            try {
                              int count = 0;
                              Navigator.of(context).popUntil((_) => count++ >= 2);
                            } catch (ex){
                              print('Exception: $ex');
                            }
                          },
                        ),

                        ]

                  ),
                )

              ]
          ),
        ),
      ),
    );
  }
}

