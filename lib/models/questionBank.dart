class QuestionBank {
  int questionSet;
  int questionID;
  int section;
  String question;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  int correctAnswer;
  int selectedAnswer;
  int isCorrect;
  int skipReview;
  int inBonusSection;
  int ausValueSelectedAnswer;
  int ausValueIsCorrect;
  QuestionBank(this.questionSet, this.questionID, this.section, this.question,
      this.answer1, this.answer2, this.answer3, this.answer4,
      this.correctAnswer, this.selectedAnswer, this.isCorrect, this.skipReview,
      this.inBonusSection, this.ausValueSelectedAnswer, this.ausValueIsCorrect);
}