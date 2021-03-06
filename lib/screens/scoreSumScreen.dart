import 'package:flutter/material.dart';
import 'package:friendstrivia/models/argParameters.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';

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
//        appBar: AppBar(title: Center (
//                                child: Text('Score Summary', textAlign: TextAlign.center,
//                                style: TextStyle(fontFamily: kDefaultFont, color: kColorWhite,fontWeight: FontWeight.w800),),
//                              ),
//                       backgroundColor: kColorThemeTeal,
//                       automaticallyImplyLeading: false ),
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
                            height: 380,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kBlueLightColor,
                              border: Border.all(color: Colors.blue, width: 3),
                              borderRadius: BorderRadius.all(Radius.circular(18)),

                            ),
                            child: Column (
                                   children: [Container (padding: EdgeInsets.symmetric(vertical: 6.0),
                                                         child: Text('Game Completed', style: TextStyle(fontFamily: kDefaultFont, color: kColorWhite,
                                                                                                  fontSize: 30.0, fontWeight: FontWeight.w600)),
                                                        ),

                                              genDivider(),
                                              genScoreRow("Basic Score:", DBService.currBasicScore, kBlueLightColor, 24.0),
                                              genScoreRow("Time Bonus: ", DBService.currTimeBonus, kBlueAccentColor, 24.0),
                                              genScoreRow("Final Score: ", DBService.currScore, kBlueLightColor, 30.0),
                                              genDivider(),
                                              genScoreRow("Best: ", DBService.currBestScore, kBlueAccentColor, 26.0),

                                              Expanded (
                                                child: Container(
                                                  margin: EdgeInsets.all(8.0),
                                                  alignment: Alignment.centerRight,
                                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                                  color: kBlueLightColor,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [ Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [Flexible (child:

                                                                                  Text(getFanMessage(), textAlign: TextAlign.center,
                                                                                  style: kDefaultTS.copyWith(fontSize: 25.0, color: kColorWhite),),

                                                                                ),
                                                                          ],
                                                      ),],
                                                  ),
                                                  ),
                                              ),
                                          ],
                                        )
                                        ),
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
                        Material (
                          color: kColorThemeGreen,
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 4.0,
                          child: RaisedButton (
                            child: Text(' Play Again ', style: TextStyle(color: kColorBlack, fontSize: 18.0),),
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
                        ),

                        Material (
                          color: kColorThemeGreen,
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 4.0,
                          child: RaisedButton (
                            child: Text('Main Menu ', style: TextStyle(color: kColorBlack, fontSize: 18.0),),
                            color: kColorThemeGreen,
                            onPressed: () async {
                              await DBService.instance.setCurrScore(0);
                              try {
                                int count = 0;
                                Navigator.of(context).popUntil((_) => count++ >= 1); //2
                              } catch (ex){
                                print('Exception: $ex');
                              }
                            },
                          ),
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

  Widget genScoreRow(String lbl, int score, Color color, double fontSize) {

    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    String scoreWithComma = '$score'.replaceAllMapped(reg, mathFunc);

    return Container (
           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0), color: color,
           child: Row(children: [
                       Expanded (
                        flex: 3,
                        child: Text(lbl,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: kColorBlack, //kColorWhite,
                                                     fontSize: fontSize),),
                        ),
                        Expanded (
                         flex: 2,
                         child: Text(scoreWithComma,
                                     textAlign: TextAlign.right,
                                     style: TextStyle(color: kColorBlack, //kColorWhite,
                                                      fontSize: fontSize),),
                        )]),
            );
  }

  Widget genDivider() {
      return Container(
          decoration: BoxDecoration(
          border: Border.all(color: kColorBlack)),
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