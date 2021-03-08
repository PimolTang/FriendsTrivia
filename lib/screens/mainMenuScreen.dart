import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendstrivia/models/argParameters.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/RoundedMenuButton.dart';
import '../models/dbService.dart';
import '../resources/constances.dart';
import '../resources/util.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int baseScore = 0;
  @override
  Widget build(BuildContext context) {

    DBService.instance.getBestScore().then((value) {
      // then (above) is kind of a force-to-wait mechanism!
      setState(() {
        baseScore = value;
      });
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: kColorThemeTeal),
          child: Align(alignment: Alignment.topLeft,
            child: ClipRRect( borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
              child: Container (
                width: 224,
                height: 180,
                child:
                Drawer(
                  child:
                  ListView(
                    children: <Widget>[
                      Container(alignment: Alignment.topLeft,
                        child: ListTile(leading: Icon(Icons.menu),
                          title: InkWell (child: Text('< Menu', style: kDefaultTS,),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),),
                        color: kColorThemeGreen ,),
                      Container(alignment: Alignment.topLeft,
                                child: ListTile(leading: Icon(Icons.info_outline),
                                title: InkWell (child: Text('Game Info',style: kDefaultTS),
                                onTap: () {
                                         showGameInfoDialog(context);
                                        }                                                                                     ),),
                                color: kColorThemeTeal,),
                      Container(alignment: Alignment.topLeft,
                                child: ListTile(leading: Icon(Icons.delete_forever),
                                title: InkWell (child: Text('Reset Your Best Score',style: kDefaultTS),
                                onTap: () {
                                         resetBestScoreAlertDialog(context);
                                        }                                                                                     ),),
                               color: kColorThemeTeal,),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        appBar: AppBar(title: Text('Friends Trivia - 2021',
                       style: TextStyle(color: kColorWhite, fontFamily: kDefaultFont, fontWeight: FontWeight.w800),),
                       backgroundColor: kColorThemeTeal,
        ),
        body: Center (
          child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //--> Section 1: BANNER
                kFriendsBanner,

                Row( mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget> [kBestIcon,
                                         Text (' Best: ' + addComma(baseScore), style: TextStyle(color: kColorWhite,
                                                                    fontSize: 30.0, fontFamily: kDefaultFont,
                                                                    fontWeight: FontWeight.w800),),
                                         ],),
                //--> Section 2: MENU
                // TODO: put SizedBox() here with the calculatedHeights
                SingleChildScrollView (
                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                            //--> Section 2.1:
                            RoundedMenuButton(bgColor: kColorThemeTeal,iconColor: kColorThemePurple,
                                menuIcon: Icons.weekend_outlined,
                                text: Text(kSection1Name, style: kDefaultTS.copyWith(color: kColorWhite),),
                                onPressed: () async {
                                        // Set SectionID = 1
                                        await DBService.instance.setcurrSectionID(1);
                                        await loadQuestionsForSecID(1);
                                        Navigator.pushNamed(context, '/questions', arguments: ArgParameters(1,0));
                                      },
                                ),
                            //--> Section 2.2:
                            RoundedMenuButton(bgColor: kColorThemeTeal,iconColor: kColorThemePurple,
                              menuIcon: Icons.camera,
                                text: Text(kSection2Name, style: kDefaultTS.copyWith(color: kColorWhite)),
                                onPressed: () async {
                                        // Set SectionID = 2
                                        await DBService.instance.setcurrSectionID(2);
                                        await loadQuestionsForSecID(2);
                                        Navigator.pushNamed(context, '/questions', arguments: ArgParameters(2,0)); //, arguments: currStatus);
                                      },
                            ),
                          ],

                  ),
                ),

//                - TO - BE - USED - IN - VERSION 1.1.0 -
//                Padding (
//                  padding: EdgeInsets.symmetric(horizontal: 20.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget> [
//                      Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget> [
//                                   SizedBox(height: 10.0,),
//                                   Text (' Write to Us', style: TextStyle(color: kColorWhite, fontFamily: kDefaultFont,
//                                                                fontSize: 18.0, fontWeight: FontWeight.w600)),
//                                  ],)
//                    ],
//                  ),
//                )

              ]

          ),
        ),
      ),
    );
  }

  // Functions:
  loadQuestionsForSecID(int _secID) async {
    await DBService.instance.refreshQuestionBankRandomly(_secID).then((value) {
      DBService.currQBanks = value;
    });
    Timer (Duration(milliseconds: 500), () { DBService.instance.setcurrSectionID(_secID); });
  }

}

// -----------------------
// Independence Functions!
// -----------------------
void resetBestScoreAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel", style: kDefaultTS.copyWith(color: kColorBlack),),
    onPressed: () => Navigator.of(context).pop()
  );
  Widget continueButton = FlatButton(
    child: Text("Reset", style: kDefaultTS.copyWith(color: kColorBlack),),
    onPressed: () {
      Navigator.of(context).pop();
      Timer(Duration(milliseconds: 100), () {
        DBService.instance.resetBestScore(0);
        Navigator.of(context).pop();
      });
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: kColorThemeGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
    title: Text("Reset your Best Score?", style: kDefaultTS.copyWith(color: kColorPureBlack)),
    content: Text("Do you wish to set your Best Score to zero?", style: kDefaultTS.copyWith(color: kColorWhite)),
    actions: [cancelButton, continueButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showGameInfoDialog(BuildContext context) {
  // set up the buttons
  Widget continueButton = FlatButton(
    child: Text("Okay...", style: kDefaultTS.copyWith(color: kColorBlack),),
    onPressed: () => Navigator.of(context).pop()
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: kColorThemeGreen,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
    scrollable: true,
    title: Text("Game Information", style: kDefaultTS),
    content: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Text('In this game, the player can choose either A) "In TV Series Friends Trivia" or B) "Who said this? Trivia",',style: kDefaultWhiteTS),
               Text('\n* 20 of questions each game',style: kDefaultWhiteTS, textAlign: TextAlign.center,),
               Text('\n* You will have 20 seconds for each question.', style: kDefaultWhiteTS, textAlign: TextAlign.center,),
               Text('\n* Four possible answers are given.',style: kDefaultWhiteTS, textAlign: TextAlign.center),
               Text('\n* You will receive scores for every correct answer. ',style: kDefaultWhiteTS, textAlign: TextAlign.center),
        //     You'll also be given an ability to share your score with your Facebook friends.
        //     These features require Internet access.
               Text('\nThe game ends once you answer any question incorrectly, the time is up or if you answer ALL questions correctly!',style: kDefaultWhiteTS),

               ]),

    actions: [
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
