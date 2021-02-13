import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
        appBar: AppBar(title: Text('Friends Trivia - 2021', style: TextStyle(color: kColorWhite,
                                                            fontFamily: kDefaultFont,  fontWeight: FontWeight.w800),),
                      backgroundColor: kColorThemeTeal,
                      ),
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
//
//                      Container(alignment: Alignment.topLeft,
//                        child: ListTile(leading: Icon(Icons.delete_forever),
//                          title: InkWell (child: Text('Reset AusValue answers'),
//                              onTap: () { resetAusValueAnswersAlertDialog(context);
//                              }
//                          ),),
//                        color: kColorGrey,),
//
//                      Container(alignment: Alignment.topLeft,
//                        child: ListTile(leading: Icon(Icons.info_outline),
//                          title: InkWell(child: Text('About'),
//                              onTap: () { showActAboutDialog(context); }
//                          ),),
//                        color: kColorGrey,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        body: Center (
          child: Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //--> Section 1:
                kFriendsBanner,
              //--> Section 2:
              Container (
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 56.0, vertical: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: kColorThemeLightPurple,
                ),
                child: Center(
                    child: Text('\nHow Big Of \n A "Friends" Fan \nAre You Really?\n', textAlign: TextAlign.center,
                           style: TextStyle(color: kColorThemeTeal, fontFamily: kGabrielWFont, fontWeight: FontWeight.w200, fontSize: 28.0),),
                ),

              ),
              //--> Section 3:
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                              gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [kColorThemeRed, kColorThemeLightPurple])
                            ),
                child: RaisedButton(
                              child: Row (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 Text(' Get Started! ', style: TextStyle(color: kColorPureWhite,fontFamily: kDefaultFont, fontSize: 20.0),),
                                 kGoIcon,
                              ]
                              ),
                color: kColorThemeGreen,
                onPressed: () {
                   Navigator.pushNamed(context, '/mainmenu');
                  },
                ),
              )

            ]
          ),
        ),
      ),
    );
  }
}
