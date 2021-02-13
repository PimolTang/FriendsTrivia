import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:friendstrivia/resources/constances.dart';
import '../models/dbService.dart';
import '../models/questionBank.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {

  @override
  void initState() {
    super.initState();
    ensureAllQuestionsLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorThemePurple,
        appBar: AppBar(title: Center( child: Text('F r i e n d s - T r i v i a - 2 0 2 1', style: TextStyle(color: kColorWhite,
                                                            fontFamily: kDefaultFont, fontWeight: FontWeight.w900),)),
                       backgroundColor: kColorThemeTeal,
                      ),
        body: Center (
          child: Column (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //--> Section 1:
                kFriendsBanner,
              //--> Section 2:
              Container (
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 52.0, vertical: 10.0),
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

  //
  // Functions: ensure..., load..., add ...
  //
  Future ensureAllQuestionsLoaded() async {
    int numberOfQuestions = await DBService.instance.countQuestionBank();
    if (numberOfQuestions <= 0) {
      await _loadCSVintoSQFLite(); // Read all questions from CSV to database
    }
    // need to set studyScores[*].totalQuestion
    //await DBService.instance.refreshTotalQuestionFromQuestionBank();
    return await DBService.instance.countQuestionBank();
  }
  // Read Questions from CSV file to SQL Lite database
  _loadCSVintoSQFLite() async {
    String _rawCSV = await DefaultAssetBundle.of(context).loadString('assets/rawQuestions.csv');
    _rawCSV = _rawCSV.replaceAll('%quote%', '\'');

    List<List<dynamic>> _csv = CsvToListConverter().convert(_rawCSV);
    // Skip i = 0 -- it's a header
    for (int i = 1; i < _csv.length; i++  ) {
      // 1 Add to QuestionBank object
      QuestionBank q = QuestionBank(_csv[i][0],_csv[i][1], _csv[i][2].toString(),
                       _csv[i][3].toString(), _csv[i][4].toString(),
                       _csv[i][5].toString(), _csv[i][6].toString(),
                       _csv[i][7],_csv[i][8],_csv[i][9],_csv[i][10]);
      // 2 Use addARecord function to add into Database.
      _addARecordFromObject(q);
      print('INSERTED : $i ');
    }
  }

  // Add a record of QuestionBanks into SQL Lite database
  void _addARecordFromObject(QuestionBank qb) async {
    try {
      await DBService.instance.insert({
        'sectionID': qb.sectionID, 'questionID': qb.questionID,
        'question': qb.question.replaceAll('%comma%', ','),
        'answer1': qb.answer1.replaceAll('%comma%', ','),
        'answer2': qb.answer2.replaceAll('%comma%', ','),
        'answer3': qb.answer3.replaceAll('%comma%', ','),
        'answer4': qb.answer4.replaceAll('%comma%', ','),
        'isCorrect': qb.isCorrect,
        'correctAnswer': qb.correctAnswer,
        'selectedAnswer': qb.selectedAnswer,
        'gotSelected': qb.gotSelected
      });
    } catch (ex) {
      print('Exception: $ex');
    }
  }

}
