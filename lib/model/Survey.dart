class Survey {
  String _topic;
  List<Question> _questions;

  Survey(this._topic, this._questions);

  String get topic => _topic;
  List get questions => _questions;

  factory Survey.fromJson(dynamic json) {
    List qs = List();

    if (json['questions'] != null) {
      var qObjsJson = json['questions'] as List;
      qs = qObjsJson
          .map((q) => q['type'] as String == 'subjective'
              ? Subjective.fromJson(q)
              : Objective.fromJson(q))
          .toList();
    }
    return Survey(json['topic'] as String, qs);
  }
}

abstract class Question {
  int _no;
  String _qStr;
  int _link;

  Question(this._no, this._qStr, this._link);

  int get no => _no;
  String get qStr => _qStr;
  int get link => _link;
}

class Subjective extends Question {

  Subjective(int no, String str, int link)
      : super(no, str, link);

  factory Subjective.fromJson(dynamic json) {
    int linkTo = (json['no'] as int) + 1; // default

    if (json['link'] != null) linkTo = json['link'] as int;

    return Subjective(json['no'] as int, json['question'] as String, linkTo);
  }
}

class Objective extends Question {
  List<Option> _options;
  bool _mul;

  Objective(int no, String str, int link, this._options, this._mul)
      : super(no, str, link);

  List<Option> get options => _options;
  bool get mul => _mul;

  factory Objective.fromJson(dynamic json) {
    bool mul = false;
    List options = List();
    int linkTo = (json['no'] as int) + 1; // default

    if (json['link'] != null) linkTo = json['link'] as int;

    if (json['multi'] != null) {
      mul = json['multi'] as bool;
    }

    if (json['options'] != null) {
      var optObjsJson = json['options'] as List;
      options = optObjsJson.map((op) => Option.fromJson(op, json['no'] as int)).toList();
    }

    return Objective(json['no'] as int, json['question'] as String, linkTo, options, mul);
  }
}

class Option {
  String _answer;
  bool _text;
  int _linkTo;

  Option(this._answer, this._text, this._linkTo);

  String get answer => _answer;
  bool get text => _text;
  int get linkTo => _linkTo;

  factory Option.fromJson(dynamic json, int qNum) {
    bool text = false;
    int linkTo = qNum + 1;

    if (json['input'] != null) text = json['input'] as bool;

    if (json['link'] != null) linkTo = json['link'] as int;

    return Option(json['value'] as String, text, linkTo);
  }
}