import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/RoundedMenuButton.dart';
import '../models/dbService.dart';
import '../resources/constances.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
        drawer: Theme (
          data: Theme.of(context).copyWith(canvasColor: kColorWhite),
          child: Align(alignment: Alignment.topLeft,
            child: ClipRRect( borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
              child: Container (
                width: 222,
                height: 240, //180,
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
                        child: ListTile(leading: Icon(Icons.delete_forever),
                          title: InkWell (child: Text('Reset Scores',style: kDefaultTS),
                              onTap: () {
                                // resetPracticeAnswersAlertDialog(context);
                              }                                                                                     ),),
                        color: kColorThemeTeal,),

//                      Container(alignment: Alignment.topLeft,
//                        child: ListTile(leading: Icon(Icons.delete_forever),
//                          title: InkWell (child: Text('Reset AusValue answers'),
//                              onTap: () { resetAusValueAnswersAlertDialog(context);
//                              }
//                          ),),
//                        color: kColorGrey,),
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
                     children: <Widget> [Icon(Icons.assistant_photo, color: Colors.orange, size: 30.0,),
                                         Text (' Best: 200', style: TextStyle(color: kColorPureWhite,
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
                                text: Text(kSection1Name, style: kDefaultTS.copyWith(color: kColorPureWhite),),
                                onPressed: () async {
                                       // Load Questions
                                        await DBService.instance.refreshQuestionBankRandomly(1);
                                        Navigator.pushNamed(context, '/questions'); //, arguments: currStatus);
                                      },
                                ),
                            //--> Section 2.2:
                            RoundedMenuButton(bgColor: kColorThemeTeal,iconColor: kColorThemePurple,
                              menuIcon: Icons.camera,
                                text: Text(kSection2Name, style: kDefaultTS.copyWith(color: kColorPureWhite)),
                                onPressed: () async {
                                        // Load Questions
                                        await DBService.instance.refreshQuestionBankRandomly(2);
                                        Navigator.pushNamed(context, '/questions'); //, arguments: currStatus);
                                      },
                            ),
                          ],

                  ),
                ),

                Padding (
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget> [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                                   SizedBox(height: 10.0,),
                                   Text (' Write to Us', style: TextStyle(color: kColorWhite, fontFamily: kDefaultFont,
                                                                fontSize: 18.0, fontWeight: FontWeight.w600)),
                                  ],)
                    ],
                  ),
                )

              ]

          ),
        ),
      ),
    );
  }

}
