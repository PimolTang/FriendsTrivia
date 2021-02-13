import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import 'package:friendstrivia/widgets/RoundedMenuButton.dart';

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
                          RoundedMenuButton(bgColor: kColorThemeTeal,iconColor: kColorWhite, menuIcon: Icons.weekend_outlined,
                              text: Text("In Movie Trivia", style: kDefaultTS,),
                              onPressed: () async {
                                      // Load Fails Question Bank for failsScreen('fails') pages
                                      Navigator.pushNamed(context, '/questions'); //, arguments: currStatus);
                                    }
                              ),
                          //--> Section 2.2:
                          RoundedMenuButton(bgColor: kColorThemeTeal,iconColor: kColorWhite, menuIcon: Icons.camera,
                              text: Text("Behind The Screen Trivia", style: kDefaultTS),
                              onPressed: null,

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
