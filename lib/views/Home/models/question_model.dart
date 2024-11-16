class Question {
  String? question;
  Map<String, bool>? answers;

  Question({this.question, this.answers});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String?,
      answers: Map<String, bool>.from(json['answers'] as Map),
    );
  }
}
