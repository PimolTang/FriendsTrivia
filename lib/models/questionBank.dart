class QuestionBank {
  // 11 Fields
  int sectionID;
  int questionID;
  String question;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  int correctAnswer;
  int selectedAnswer;
  int isCorrect;
  int gotSelected;
  QuestionBank(this.sectionID,this.questionID, this.question,this.answer1,this.answer2,
               this.answer3, this.answer4, this.correctAnswer,
               this.selectedAnswer, this.isCorrect, this.gotSelected);
}