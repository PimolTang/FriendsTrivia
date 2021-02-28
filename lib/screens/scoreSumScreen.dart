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
  void initState() {
    DBService.instance.updateBestScore(DBService.instance.getCurrScore());
    DBService.instance.getBestScore().then((value) {
      setState(() {
        // Read the new 'value' from database, in case .updateBestScore(n) has changed the BestScore!
        baseScore = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
//        appBar: AppBar(title: Center (
//                                child: Text('Score Summary', textAlign: TextAlign.center,
//                                style: TextStyle(fontFamily: kDefaultFont, color: kColorWhite,fontWeight: FontWeight.w800),),
//                              ),
//                       backgroundColor: kColorThemeTeal,
//                       automaticallyImplyLeading: false
//                       ),
        body: Center (
          child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                         Image.network('https://image.shutterstock.com/image-illustration/award-golden-cup-game-medal-600w-1335539501.jpg',
                         scale: 4.4, fit: BoxFit.fitWidth,),

                        //--> Main Box Container
                        Container(
                            margin: EdgeInsets.all(20.0),
                            alignment: Alignment.center,
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kColorWhite, //kColorYellow,
                              border: Border.all(color: Colors.blue, width: 3),
                              borderRadius: BorderRadius.all(Radius.circular(18)),

                            ),
                            child: Column (
                                   children: [ Text('Game Completed', style: TextStyle(fontFamily: kDefaultFont, color: kColorBlack,
                                                                      fontSize: 30.0, fontWeight: FontWeight.w600)),
                                               Row(mainAxisAlignment: MainAxisAlignment.center,
                                               children: <Widget>[Text('\n Basic Score: ${DBService.currBasicScore}',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(color: kColorBlack, //kColorWhite,
                                                                        fontSize: 24.0),),
                                                                  ]),
                                               Text('Time Bonus:   ${DBService.currTimeBonus}',style: TextStyle(color: kColorBlack, //kColorWhite,
                                                                 fontSize: 24.0),),
                                               Text('Final Score:  ${DBService.currScore}',style: TextStyle(color: kColorBlack, //kColorWhite,
                                                                  fontSize: 34.0),),
                                               Text('Best: $baseScore', style: kDefaultTS.copyWith(fontSize: 26.0, color: kColorBlack ),),
                                               Text(getFanMessage(), textAlign: TextAlign.center,
                                                    style: kDefaultTS.copyWith(fontSize: 25.0, color: kColorBlack),),
                                          ],
                                        )
                                        ),
                //--> Line 4:

                //--> Line 5:
                Container (
                  margin: EdgeInsets.all(20.0),
                  //height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kColorThemePurple, //kColorYellow,
                    //border: Border.all(color: kColorBlack, width: 3),
                    //borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  <Widget> [
                        RaisedButton (
                          child: Text(' Play Again ', style: TextStyle(color: kColorBlack, fontSize: 20.0),),
                          color: kColorThemeGreen,
                          onPressed: () async {
                            // Reset CurrScore
                            await DBService.instance.setCurrScore(0);
                            try {
                              // Go to the same Section ID
                              Navigator.pushNamed(context, '/questions', arguments: ArgParameters(DBService.currSectionID, 0));
                            } catch (ex){
                              print('Exception: $ex');
                            }
                          },
                        ),

                        RaisedButton (
                          child: Text('Main Menu ', style: TextStyle(color: kColorBlack, fontSize: 20.0),),
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
  String getFanMessage() {
    String retStr = kFanLevel4;
    if (DBService.currCorrectQ > 15) { retStr = kFanLevel1; }
    else {
      if (DBService.currCorrectQ > 10) { retStr = kFanLevel2; } else {
        if (DBService.currCorrectQ > 5) { retStr = kFanLevel3; }
      }
    }
    return retStr;
  }
}