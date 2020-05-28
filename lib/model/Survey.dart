class Survey {
  String _topic;
  List<Question> _questions;

  Survey(this._topic, this._questions);

  String get topic => _topic;

  factory Survey.fromJson(dynamic json) {
    List qs = List();

    if (json['questions'] != null) {
      var qObjsJson = json['questions'] as List;
      qs = qObjsJson
          .map((q) => q['answerType'] as String == 'subjective'
          ? Subjective.fromJson(q)
          : Objective.fromJson(q))
          .toList();
    }
    return Survey(json['topic'] as String, qs);
  }

  List get questions => _questions;
}

abstract class Question {
  int _no;
  int _linkTo;
  String _qStr;
  String _answerType;

  Question(this._no, this._linkTo, this._qStr, this._answerType);

  int get no => _no;
  int get linkTo => _linkTo;
  String get qStr => _qStr;
  String get answerType => _answerType;
}

class Subjective extends Question {
  Subjective(int no, int link, String str, String type)
      : super(no, link, str, type);

  factory Subjective.fromJson(dynamic json) {
    int linkTo = (json['no'] as int) + 1;

    if (json['linkTo'] != null) linkTo = json['linkTo'] as int;

    return Subjective(json['no'] as int, linkTo, json['question'] as String,
        json['answerType'] as String);
  }
}

class Objective extends Question {
  List<Option> _options;
  bool _mul;

  List<Option> get options => _options;
  bool get mul => _mul;

  Objective(int no, int link, String str, String type, this._options, this._mul)
      : super(no, link, str, type);

  factory Objective.fromJson(dynamic json) {
    int linkTo = (json['no'] as int) + 1;

    if (json['linkTo'] != null) linkTo = json['linkTo'] as int;

    bool mul = false;

    if (json['textAnswer'] != null) {
      mul = json['textAnswer'] as bool;
    }

    List options = List();

    if(json['options'] != null) {
      var optObjsJson = json['options'] as List;
      options = optObjsJson.map((op) => Option.fromJson(op)).toList();
    }

    return Objective(json['no'] as int, linkTo, json['question'] as String,
        json['answerType'] as String, options, mul);
  }
}

class Option {
  String _answer;
  bool _text;
  int _linkTo;

  String get answer => _answer;
  bool get text => _text;
  int get linkTo => _linkTo;

  Option(this._answer, this._text, this._linkTo);

  factory Option.fromJson(dynamic json) {
    bool text = false;
    int linkTo = -1;

    if (json['textAnswer'] != null) text = json['textAnswer'] as bool;

    if (json['linkTo'] != null) linkTo = json['linkTo'] as int;

    return Option(json['value'] as String, text, linkTo);
  }

  @override
  String toString() {
    return '(textType: $_text, link to + $_linkTo) $_answer';
  }
}