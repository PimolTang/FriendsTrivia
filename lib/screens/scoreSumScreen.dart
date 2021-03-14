import 'package:flutter/material.dart';
import 'package:friendstrivia/models/dbService.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/resources/util.dart';

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
                        SizedBox(height: 16.0,),
                        getImage(),
                        //--> Main Box Container
                        Container(
                            margin: EdgeInsets.all(20.0),
                            alignment: Alignment.center,
                            height: 320, // 380
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kBlueLightColor,
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                            child: Column (
                                   children: [Container (padding: EdgeInsets.symmetric(vertical: 4.0),
                                                         child: Text('Game Complete', style: TextStyle(fontFamily: kDefaultFont, color: kColorWhite,
                                                                                                       fontSize: 28.0, fontWeight: FontWeight.w600)),
                                                        ),
                                              genDivider(),
                                              genScoreRow("Basic Score: (${DBService.currCorrectQ}/$kNumberOfQuestionsPerSet) ", DBService.currBasicScore, kBlueLightColor, 22.0),
                                              genScoreRow("Time Bonus: ", DBService.currTimeBonus, kBlueAccentColor, 22.0),
                                              genScoreRow("Final Score: ", DBService.currScore, kBlueLightColor, 26.0),
                                              genDivider(),
                                              genScoreRow("Best: ", DBService.currBestScore, kBlueAccentColor, 24.0),
                                              Expanded (
                                                child: Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    alignment: Alignment.centerRight,
                                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    color: kBlueLightColor,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [ Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [Flexible(child: Text(genFanMessage(), textAlign: TextAlign.center,
                                                                                                  style: kDefaultTS.copyWith(fontSize: 24.0, color: kColorWhite,
                                                                                                         fontStyle: FontStyle.italic),),
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
                  margin: EdgeInsets.fromLTRB(20.0,10.0,20.0,2.0),
                  //height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kColorThemePurple, //kColorYellow,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  <Widget> [
                        ElevatedButton (
                          child: Text(' Play Again ', style: TextStyle(color: kColorBlack, fontSize: 18.0),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(kColorThemeGreen),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                     RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(12)),)
                              )),

                          onPressed: () async {
                            // Reset CurrScore
                            await DBService.instance.setCurrScore(0);
                            await loadQuestionsForSecID(DBService.currSectionID);
                            try {
                              // Go to the same Section ID
                              Navigator.pushNamed(context, '/questions');
                            } catch (ex){
                              print('Exception: $ex');
                            }
                          },
                        ),
                        ElevatedButton (
                          child: Text(' Main Menu ', style: TextStyle(color: kColorBlack, fontSize: 18.0),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(kColorThemeGreen),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(12)),)
                              )),
                          onPressed: () async {
                            await DBService.instance.setCurrScore(0);
                            Navigator.pushReplacementNamed(context, '/mainmenu');
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

  // Functions:
  Widget genScoreRow(String lbl, int score, Color color, double fontSize) {
    String scoreWithComma = addComma(score);
    return Container (
           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0), color: color,
           child: Row(children: [
                       Expanded (
                        flex: 6,
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

  String genFanMessage() {
    String retStr = kFanMsgLevel4;
    if (DBService.currCorrectQ > 14) { retStr = kFanMsgLevel1; }
    else {
      if (DBService.currCorrectQ > 9) { retStr = kFanMsgLevel2; } else {
        if (DBService.currCorrectQ > 4) { retStr = kFanMsgLevel3; }
      }
    }
    return retStr;
  }
  
  Image getImage() {
    String lvl = "4";
    print('CorrectQ: ${DBService.currCorrectQ}');
    if (DBService.currCorrectQ > 14) { lvl = "1"; }
    else {
      if (DBService.currCorrectQ > 9) { lvl = "2"; } else {
        if (DBService.currCorrectQ > 4) { lvl = "3"; }
      }
    }
    return Image.asset('assets/images/Fan${lvl}.png', height: 174,
           fit: BoxFit.fitHeight, alignment: Alignment.bottomCenter,);
  }

}