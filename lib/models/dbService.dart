import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'questionBank.dart';
import 'package:friendstrivia/resources/constances.dart';

class DBService {
  // Parameters for database and two tables;
  static final _dbName = 'ft.db';
  static final _dbVersion = 1;
  static final _tableNameQuestionBank = 'QuestionBank';
  static final _tableNameScore = 'Score';

  static int currSectionID, currScore = 0, currBestScore = 0; // NOT SURE IF we need 'currBestScore'???
  static int currBasicScore = 0, currTimeBonus = 0, currCorrectQ = 0;
  static List<QuestionBank> currQBanks;

// Making it a singleton class (create an instance)
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  // Create private _database to use internally
  static Database _database;

  // Variable of 'database' with get function!
  Future<Database> get database async {
    if (_database != null) { return _database; }
    _database = await _initiateDB();
    return _database;
  }

  // 'Initial DB' with linked 'OnCreate' function
  _initiateDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    try {
      // NOTE: these three fields; inBonusSection, ausValueSelectedAnswer,
      //       ausValueIsCorrect will be removed in 2021.
      await db.execute(
          '''
               CREATE TABLE $_tableNameQuestionBank (
               sectionID INTEGER NOT NULL,
               questionID INTEGER NOT NULL,
               question TEXT,
               answer1 TEXT, answer2 TEXT,
               answer3 TEXT, answer4 TEXT,
               correctAnswer INTEGER,
               selectedAnswer INTEGER,
               isCorrect INTEGER,               
               gotSelected INTEGER,
               PRIMARY KEY (sectionID, questionID)
               );
          ''');

      await db.execute(
          '''
               CREATE TABLE $_tableNameScore (               
               score INTEGER NOT NULL PRIMARY KEY               
               );
          ''');
      // questionSet INTEGER NOT NULL PRIMARY KEY,
      // dateTime TEXT ??

        await db.execute('INSERT INTO $_tableNameScore (score) VALUES (0);');

//      await db.execute(
//          '''
//               CREATE TABLE $_tableNameStatus (
//               currQuestionSet INTEGER NOT NULL PRIMARY KEY,
//               currID INTEGER
//               );
//          ''');

//      // Initial Data - for Score and Status tables
//      for (int i = 1; i <= kNumberOfQuestionSet; i++) {
//        await db.execute('INSERT INTO $_tableNameScore (questionSet, score, dateTime, ausValueScore) VALUES ($i, -1, "", 0);');
//      }
//      // Initial Data for Status (currentQuestionSet and currID)
//      await db.execute('INSERT INTO $_tableNameStatus (currQuestionSet, currID) VALUES (1,0);');

    } catch (ex) {
      print( 'EXCEPTION: $ex');
    }

  }

  Future<int> countQuestionBank() async {
    Database db = await instance.database;
    List<Map<String,dynamic>> q = await db.rawQuery('Select questionID from $_tableNameQuestionBank');
    return q.length;
  }

  // Refresh Questions Bank according to SectionID
  Future<List<QuestionBank>> refreshQuestionBankRandomly (int secID) async {
    // CHECK FIRST: if Questions left is less than 20 questions;
    if(await DBService.instance.getQuestionNumberLeft(secID) < kNumberOfQuestionsPerSet ) {
      await resetGotSelected(secID);
    }

    String baseStmt = "SELECT * FROM $_tableNameQuestionBank where sectionID = $secID " +
                      "and gotSelected = 0 order by RANDOM() LIMIT $kNumberOfQuestionsPerSet";
    Database db  = await instance.database;
    List<Map> rs = await db.rawQuery(baseStmt);

    List<QuestionBank> qb = new List();
    for (int i = 0; i < rs.length; i++) {
      await qb.add(new QuestionBank(rs[i]["sectionID"], rs[i]["questionID"],
          rs[i]["question"], rs[i]["answer1"], rs[i]["answer2"],
          rs[i]["answer3"], rs[i]["answer4"],rs[i]["correctAnswer"],
          rs[i]["selectedAnswer"], rs[i]["isCorrect"],rs[i]["gotSelected"])
      );
    }
    return qb;
  }

  // Set currSectionID
  void setcurrSectionID(int secID) {
    currSectionID = secID;
  }

  Future updateGotSelected( int secID, qID, newValue)  async {
    Database db = await instance.database;
    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET gotSelected=? where sectionID =? and questionID=? ',
                        [newValue, secID, qID]);
  }

  Future<int> getQuestionNumberLeft (int secID) async {
    String baseStmt = "SELECT * FROM $_tableNameQuestionBank where sectionID = $secID and gotSelected = 0";
    Database db  = await instance.database;
    List<Map> rs = await db.rawQuery(baseStmt);
    print("QUESTIONS LEFT: ${rs.length}");
    return rs.length;
  }

  void resetGotSelected(int secID) async {
    Database db = await instance.database;
    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET gotSelected=? where sectionID =?', [0, secID]);
  }

  String getQuestionText(int pID) =>(DBService.currQBanks != null) ? DBService.currQBanks[pID].question : '';
  String getAnswer1Text(int pID) => (DBService.currQBanks != null) ? DBService.currQBanks[pID].answer1 : '';
  String getAnswer2Text(int pID) => (DBService.currQBanks != null) ? DBService.currQBanks[pID].answer2 : '';
  String getAnswer3Text(int pID) => (DBService.currQBanks != null) ? DBService.currQBanks[pID].answer3 : '';
  String getAnswer4Text(int pID) => (DBService.currQBanks != null) ? DBService.currQBanks[pID].answer4 : '';
  int getCorrectAnswer(int pID) => (DBService.currQBanks != null) ? DBService.currQBanks[pID].correctAnswer : 0;

  int getCurrScore() => (DBService.currScore != null) ? DBService.currScore : 0;
  void setCurrScore(int newValue) {
    if (DBService.currScore != null) DBService.currScore = newValue;
  }

  // TO DO
  Future<int> getBestScore() async {
    int retInt = 0;
    // prepare DB
    Database db  = await instance.database;
    List<Map> _scoreRecords = await db.rawQuery('Select score from $_tableNameScore');
    retInt = await _scoreRecords[0]["score"];
    return retInt;
  }

  void updateBestScore(int newValue) async {
    // prepare DB
    Database db  = await instance.database;
    // query baseScore
    if(newValue > await getBestScore()) {
       print('DEBUG: NewValue is more than BaseScore, attempting to change BaseScore');
       // update BaseScore to the new value
       await db.rawUpdate('UPDATE $_tableNameScore SET score = ?', [newValue]);
       currBestScore = newValue;
    }
  }

  void resetBestScore(int newValue) async {
    Database db = await instance.database;
    await db.rawUpdate('UPDATE $_tableNameScore SET score=?', [newValue]);
  }

//  Future<List<Map<String, dynamic>>> getQuestionSetFromStatusTable() async {
//    Database db  = await instance.database;
//    return await db.rawQuery('Select currQuestionSet, currID from $_tableNameStatus');
//  }
//
//  void updateCurrQuestionSetID_from_StatusTable () async {
//    // Get CurrentSetID from 'Status' table and set it to 'currQuestionSet' parameter.
//    List<Map<String, dynamic>> currQSet_statusTable = await DBService.instance.getQuestionSetFromStatusTable();
//    currQuestionSet = currQSet_statusTable[0]['currQuestionSet'];
//    currID = currQSet_statusTable[0]['currID'];
//  }
//
//  // QUERY
//  Future <List<Map<String, dynamic>>> queryCurrentScore() async {
//    Database db  = await instance.database;
//    return await db.rawQuery('Select score from $_tableNameScore Where QuestionSet = ?', [currQuestionSet]);
//  }
//
//  // QUERY
//  Future <List<Map<String, dynamic>>> queryAllScoresDateTime() async {
//    Database db  = await instance.database;
//    return await db.rawQuery('Select dateTime, score, ausValueScore from $_tableNameScore');
//  }
//
//  Future <List<Map<String, dynamic>>> queryAdhoc() async {
//    Database db  = await instance.database;
//    return await db.rawQuery('Select questionID, isCorrect from $_tableNameQuestionBank WHERE questionSet = 10');
//  }
//
//  // ------------------------------------------------
//  // Load Question Data into QuestionBank Model
//  // ------------------------------------------------
//  void refreshQuestionBankByQSet (int qSet) async {
//    Database db  = await instance.database;
//    List<Map> recSet = await db.rawQuery('SELECT * FROM $_tableNameQuestionBank where questionSet = $qSet');
//    List<QuestionBank> qb = new List();
//    for (int i = 0; i < recSet.length; i++) {
//      qb.add(new QuestionBank(recSet[i]["questionSet"], recSet[i]["questionID"],
//          recSet[i]["section"], recSet[i]["question"],
//          recSet[i]["answer1"], recSet[i]["answer2"],
//          recSet[i]["answer3"], recSet[i]["answer4"],
//          recSet[i]["correctAnswer"], recSet[i]["selectedAnswer"],
//          recSet[i]["isCorrect"], recSet[i]["skipReview"],
//          recSet[i]["inBonusSection"], recSet[i]["ausValueSelectedAnswer"],
//          recSet[i]["ausValueIsCorrect"])
//      );
//    }
//    currQBanks = qb;
//  }
//
//  // -------------------------------------------------
//  // Load Question Data into FailsQuestionBank Model
//  // -------------------------------------------------
//  void refreshFailsQuestionBank() async {
//    Database db  = await instance.database;
//    List<Map> recSet = await db.rawQuery('SELECT * FROM $_tableNameQuestionBank where selectedAnswer !=0 and isCorrect = "0" and skipReview = "0" ');
//    List<QuestionBank> fqb = new List();
//    for (int i = 0; i < recSet.length; i++) {
//      fqb.add(new QuestionBank(recSet[i]["questionSet"], recSet[i]["questionID"],
//          recSet[i]["section"], recSet[i]["question"],
//          recSet[i]["answer1"], recSet[i]["answer2"],
//          recSet[i]["answer3"], recSet[i]["answer4"],
//          recSet[i]["correctAnswer"], recSet[i]["selectedAnswer"],
//          recSet[i]["isCorrect"], recSet[i]["skipReview"],
//          recSet[i]["inBonusSection"], recSet[i]["ausValueSelectedAnswer"],
//          recSet[i]["ausValueIsCorrect"])
//      );
//    }
//    currTempQBanks = fqb;
//  }

    // INSERT
    Future<int> insert(Map<String, dynamic> row) async {
      Database db = await instance.database;
      return await db.insert(_tableNameQuestionBank, row);
    }
  //}
//
//  // UPDATE --
//  void updateSelectedAnswer(int qSet, int qID, int newValue) async {
//    Database db  = await instance.database;
//    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET selectedAnswer = ? '
//        'WHERE questionSet = ? AND questionID = ?', [newValue, qSet, qID]);
//  }
//  // UPDATE --
//  void updateIsCorrect(int qSet, int qID, int newValue) async {
//    Database db  = await instance.database;
//    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET isCorrect = ? '
//        'WHERE questionSet = ? AND questionID = ?', [newValue, qSet, qID]);
//  }

//  // GET AusValueSelectedAnswer -- to remove later
//  Future<int> getAusValueSelectedAnswer (int qSet, int qID) async {
//    Database db  = await instance.database;
//    List<Map> qb = await db.rawQuery("SELECT * FROM $_tableNameQuestionBank where questionSet = $qSet and questionID = $qID");
//    return await qb[0]["ausValueSelectedAnswer"];
//  }
//
//  // UPDATE --
//  void updateSkipReview(int qSet, int qID, int newValue) async {
//    Database db  = await instance.database;
//    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET skipReview = ? '
//        'WHERE questionSet = ? AND questionID = ?', [newValue, qSet, qID]);
//  }
//
//  // SAVE total SCORE TO SCORE Table
//  void saveScoreFromQuestionBank(int _score, int _aVScore) async {
//    // 1. Get Time
//    String currDateTime = DateFormat('d MMM y').add_jm().format(DateTime.now());
//    // 2. CREATE DB Object and Update Score
//    Database db  = await instance.database;
//    db.rawUpdate('''
//      UPDATE $_tableNameScore
//      SET score = ?, ausValueScore = ?, dateTime = ?
//      WHERE questionSet = ?
//      ''', [_score, _aVScore, currDateTime, currQuestionSet]
//    );
//  }
//
//  void clearAllAnswers() async {
//    Database db  = await instance.database;
//    try {
//      // Update QuestionBank
//      await db.rawUpdate('Update $_tableNameQuestionBank Set selectedAnswer = 0, isCorrect = 0, skipReview = 0');
//      // Update Score
//      await db.rawUpdate(
//          'Update $_tableNameScore Set score = -1, dateTime = "", ausValueScore = 0');
//      // Update Status
//      await db.rawUpdate(
//          'Update $_tableNameStatus Set currQuestionSet = 1, currID = 0');
//    } catch (ex) {
//      print("Exception: $ex");
//    }
//  }
//
//  void clearAusValueAnswers() async {
//    Database db = await instance.database;
//    try {
//      await db.rawUpdate('Update $_tableNameQuestionBank Set ausValueSelectedAnswer = 0, ausValueIsCorrect = 0');
//    } catch (ex) {
//      print("Exception: $ex");
//    }
//    // Clear AusValue Score and reset nextUnansweredAusValueQuestion (in memory)
//    currAusValueScore = 0;
//    nextUnansweredAusValueQuestion = -1;
//  }
}