import 'package:flutter/material.dart';
import 'package:friendstrivia/models/argParameters.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';

class ScoreSumScreen extends StatefulWidget {
  @override
  _ScoreSumScreenState createState() => _ScoreSumScreenState();
}

class _ScoreSumScreenState extends State<ScoreSumScreen> {
  int baseScore;

  @override
  Widget build(BuildContext context) {
    DBService.instance.updateBestScore(DBService.instance.getCurrScore());
    DBService.instance.getBestScore().then((value) {
      setState(() {
        // Read the new 'value' from database, in case .updateBestScore(n) has changed the BestScore!
        baseScore = value;
      });
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
        appBar: AppBar(title: Center (
                                child: Text('Score Summary', textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: kDefaultFont, color: kColorWhite, fontWeight: FontWeight.w800),),
        ),
                       backgroundColor: kColorThemeTeal,
                       automaticallyImplyLeading: false
                       ),
        body: Center (
          child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                        Image.network('https://image.shutterstock.com/image-illustration/award-golden-cup-game-medal-600w-1335539501.jpg',
                        scale: 2.4,
                        fit: BoxFit.fitWidth,),
                Text('You are the Biggest Fan!!', style: kDefaultTS.copyWith(fontSize: 24.0, color: kColorWhite),),
                //--> Line 3
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kColorThemePurple, //kColorYellow,
                    //border: Border.all(color: kColorBlack, width: 3),
                    //borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[kFavoriteScoreBigIcon,
                                                Text(' Score: ${DBService.instance.getCurrScore()}',
                                                     textAlign: TextAlign.center,
                                                     style: TextStyle(color: kColorBlack, //kColorWhite,
                                                            fontWeight: FontWeight.w800,
                                                            fontSize: 20.0),),
                                               ])
                ),
                //--> Line 4:

                Text('Best: $baseScore', style: kDefaultTS.copyWith(fontSize: 26.0, color: kColorWhite),),

                //--> Line 5:
                Container (
                  margin: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  <Widget> [
                        RaisedButton (
                          child: Text(' Play Again ', style: TextStyle(color: kColorBlack, fontSize: 20.0),),
                          color: kColorThemeGreen,
                          onPressed: () async {
                            // Reset CurrScore
                            await DBService.instance.setCurrScore(0);
                            try {
                              //int count = 0;
                              //// Go back to Main Menu
                              //Navigator.of(context).popUntil((_) => count++ >= 2);

                              // Go to the same Section ID
                              Navigator.pushNamed(context, '/questions', arguments: ArgParameters(DBService.currSectionID, 0));
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
                          onPressed: () async {
                            await DBService.instance.setCurrScore(0);
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

