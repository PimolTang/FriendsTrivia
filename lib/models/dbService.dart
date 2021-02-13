import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'questionBank.dart';
import 'package:friendstrivia/resources/constances.dart';

class DBService {
  // Parameters for database and three tables;
  static final _dbName = 'ft.db';
  static final _dbVersion = 1;
  static final _tableNameQuestionBank = 'QuestionBank';
  // static final _tableNameScore = 'Score';
  //static final _tableNameStatus = 'Status';

  static int currID, currScore;
  static List<QuestionBank> currQBanks;

//  static List<QuestionBank> currTempQBanks;
// static int currAusValueScore, nextUnansweredAusValueQuestion = -1;

//  // Making it a singleton class (create an instance)
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  // Create private _database to use internally
  static Database _database;

  // Variable of 'database' with get function!
  Future<Database> get database async {
    if (_database != null ) { return _database; }
    _database = await _initiateDB();
    return _database;
  }

  // 'Initial DB' with linked 'OnCreate' function
  _initiateDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName); // print ('PATH + DBNAME = $path');
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

//      await db.execute(
//          '''
//               CREATE TABLE $_tableNameScore (
//               questionSet INTEGER NOT NULL PRIMARY KEY,
//               score INTEGER,
//               ausValueScore INTEGER,
//               dateTime TEXT
//               );
//          ''');
//
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

  void refreshQuestionBankRandomly (int secID) async {
    // selectedAnswer	isCorrect	correctAnswer	isBookmarked
    String baseStmt = "SELECT * FROM $_tableNameQuestionBank where sectionID = $secID " +
                      "and gotSelected = 0 order by RANDOM() LIMIT $kNumberOfQuestionsPerSet";

    Database db  = await instance.database;
    String readyStmt = baseStmt; // and ($unansweredFlagClause $correctFlagClause $incorrectFlagClause $bookmarkedFlagClause)';
    List<Map> rs = await db.rawQuery(readyStmt);

    List<QuestionBank> qb = new List();
    for (int i = 0; i < rs.length; i++) {
      await qb.add(new QuestionBank(rs[i]["sectionID"], rs[i]["questionID"],
          rs[i]["question"], rs[i]["answer1"], rs[i]["answer2"],
          rs[i]["answer3"], rs[i]["answer4"],rs[i]["correctAnswer"],
          rs[i]["selectedAnswer"], rs[i]["isCorrect"],rs[i]["gotSelected"])
      );
    }
    currQBanks = await qb;
  }


//
//  Future<int> refreshCurrentScoreByQuestionSet(int qSet) async {
//    Database db = await instance.database;
//    List<Map<String,dynamic>> q = await db.rawQuery('Select questionID from $_tableNameQuestionBank where questionSet = $qSet and isCorrect = 1');
//    currScore = q.length;
//    List<Map<String,dynamic>> avQ = await db.rawQuery('Select questionID from $_tableNameQuestionBank where questionSet=$qSet and isCorrect=1 and section=4');
//    currAusValueScore = avQ.length;
//    return q.length;
//  }
//
//  Future<int> refreshCurrentScoreForAusValueSection() async {
//    Database db = await instance.database;
//    List<Map<String,dynamic>> q = await db.rawQuery('Select questionID from $_tableNameQuestionBank where inBonusSection = 1 and ausValueIsCorrect = 1');
//    currAusValueScore = q.length;
//    return q.length;
//  }
//
//  // ==========================================
//  Future updateStatus(int currQSet, int currID ) async {
//    Database db = await instance.database;
//    await db.rawUpdate('UPDATE $_tableNameStatus SET currQuestionSet = ?,  '
//        'currID = ?', [currQSet, currID]);
//  }
//
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
//
//  // ----------------------------------------------------
//  // Load AusValue Question Data into QuestionBank Model
//  // ----------------------------------------------------
//  void refreshAusValueQuestionBank() async {
//    Database db  = await instance.database;
//    List<Map> recSet = await db.rawQuery('SELECT * FROM $_tableNameQuestionBank where inBonusSection=1');
//    List<QuestionBank> fqb = new List();
//    for (int i = 0; i < recSet.length; i++) {
//      fqb.add(new QuestionBank(recSet[i]["questionSet"], recSet[i]["questionID"],
//          recSet[i]["section"], recSet[i]["question"],
//          recSet[i]["answer1"], recSet[i]["answer2"],
//          recSet[i]["answer3"], recSet[i]["answer4"],
//          recSet[i]["correctAnswer"], recSet[i]["AusValueSelectedAnswer"],
//          recSet[i]["AusValueIsCorrect"], recSet[i]["skipReview"],
//          recSet[i]["inBonusSection"], recSet[i]["ausValueSelectedAnswer"],
//          recSet[i]["ausValueIsCorrect"])
//      );
//      // Update the 'nextUnansweredAusValueQuestion'
//      if (nextUnansweredAusValueQuestion == -1) {
//        if (recSet[i]["ausValueSelectedAnswer"] == 0) {
//          nextUnansweredAusValueQuestion = i;
//        }
//      }
//    }
//    currTempQBanks = fqb;
//  }
//
  // INSERT
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableNameQuestionBank, row);
  }
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
//
//  // UPDATE -- To remove later
//  void updateAusValueSelectedAnswer(int qSet, int qID, int newValue) async {
//    Database db  = await instance.database;
//    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET ausValueSelectedAnswer = ? '
//        'WHERE questionSet = ? AND questionID = ?', [newValue, qSet, qID]);
//  }
//  // UPDATE -- To remove later
//  void updateAusValueIsCorrect(int qSet, int qID, int newValue) async {
//    Database db  = await instance.database;
//    await db.rawUpdate('UPDATE $_tableNameQuestionBank SET ausValueIsCorrect = ? '
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