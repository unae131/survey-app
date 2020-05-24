import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ni Doc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Ni Doc', survey: readSurveyData()),
    );
  }

  Survey readSurveyData() {
    Future<String> objFuture = rootBundle.loadString('test/nidoc_survey1.json');
    String objText;// = '{"topic": "Health Survey1","questions": [{"no": 1,"question": "name?","answerType": "subjective"},{"no": 2,"question": "age?","answerType": "objective","options": [{"value": "10 ~ 19","linkTo": 7},{"value": "20 ~ 29"},{"value": "30 ~ 39","linkTo": 7},{"value": "40 ~ 49","linkTo": 7},{"value": "under 10 or over 50","linkTo": 4}]},{"no": 3,"question": "sex?","answerType": "selectable","options": [{"value": "M"},{"value": "W"}]},{"no": 4,"question": "hurt point?","answerType": "objective","mulAnswer" : true,"options": [{"value": "eye"},{"value": "neck/waist"},{"value": "wrist/knee"},{"value": "stomach"},{"value": "other","textAnswer": true},{"value": "nowhere","linkTo": 7}]},{"no": 5,"question": "What would you do when you feel uncomfortable of your body?","answerType": "objective","options": [{"value": "search"},{"value": "go to hospital"},{"value": "ask to non-expert"},{"value": "leave it out"},{"value": "guitar","textAnswer": true}]}]}';

    objFuture.then((data) {
      objText = data;
    }, onError: (e) {
      print(e);
    });

    return Survey.fromJson(jsonDecode(objText));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.survey}) : super(key: key);

  final String title;
  final Survey survey;

  @override
  _MyHomePageState createState() => _MyHomePageState(this.survey);
}

class _MyHomePageState extends State<MyHomePage> {
  Survey _survey;

  _MyHomePageState(Survey survey) {
    _survey = survey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _survey.topic,
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ButtonTheme(
                minWidth: 300,
                height: 40,
                buttonColor: Colors.lightBlue,
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                        child: Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyPage(_survey, 1)),
                          );
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyPage extends StatefulWidget {
  final Survey survey;
  final int nextQ;

  SurveyPage(this.survey, this.nextQ);

  @override
  _SurveyPageState createState() => _SurveyPageState(this.survey, this.nextQ);
}

class _SurveyPageState extends State<SurveyPage> {
  Survey _survey;
  Question _question;
  int _nextQ;

  final myController = TextEditingController();

  _SurveyPageState(Survey survey, int nextQ) {
    if (survey != null) {
      _survey = survey;
      _nextQ = nextQ;
      _question = nextQ <= _survey.questions.length
          ? _survey.questions[nextQ - 1]
          : null;
    }
  }

  void response(Option option) {
    // 파일에 응답 저장
    /*...*/

    // test
    print(option.answer);

    // 다음걸로 페이지 넘겨주기
    if (option.linkTo != -1)
      _nextQ = option.linkTo;
    else
      _nextQ++;
  }

  void submit() {
    // 답변 저장

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FinishPage()),
    );
  }

  List<Widget> _buildButtonList(BuildContext context) {
    List<Widget> ret;
    if (_question is Objective) {
      ret =
          (_question as Objective).options.map((e) => _buildButton(e)).toList();
    } else {
      if ((_question as Subjective).linkTo != -1)
        _nextQ = (_question as Subjective).linkTo;
      else
        _nextQ++;
      ret = [TextField(controller: myController)];
    }
    ret.add(_nextButton(context));
    return ret;
  }

  Widget _buildButton(Option option) {
    // multi obj 일 경우 radio button으로 바꾸기
    return RaisedButton(
      child: Text(
        option.answer,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () => response(option),
    );
  }

  Widget _nextButton(BuildContext context) {
    if (_nextQ > _survey.questions.length)
      return RaisedButton(
        child: Text(
          '제출',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: () => submit(),
      );
    else
      return RaisedButton(
          child: Text(
            '다음',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SurveyPage(_survey, _nextQ)),
              ));
  }

  @override
  Widget build(BuildContext context) {
    if (_question == null)
      return Scaffold(
          appBar: AppBar(title: Text('Question $_question.no')),
          body: Center(child: Text('No Data')));
    else
      return Scaffold(
        appBar: AppBar(title: Text('Question $_question.no')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _question.qStr,
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ButtonTheme(
                  minWidth: 300,
                  height: 40,
                  buttonColor: Colors.lightBlue,
                  child: Column(children: _buildButtonList(context)),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class FinishPage extends StatefulWidget {
  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ni Doc')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '수고하셨습니다.',
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}

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
          .map((q) => {
                json['answerType'] as String == 'subjective'
                    ? Subjective.fromJson(q)
                    : Objective.fromJson(q)
              })
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
  String _qStr;
  String _answerType;

  Question(this._no, this._qStr, this._answerType);

  int get no => _no;

  String get qStr => _qStr;

  String get answerType => _answerType;
}

class Subjective extends Question {
  int _linkTo;

  int get linkTo => _linkTo;

  Subjective(int no, String str, String type, this._linkTo)
      : super(no, str, type);

  factory Subjective.fromJson(dynamic json) {
    int linkTo = -1;

    if (json['linkTo'] != null) linkTo = json['linkTo'] as int;

    return Subjective(json['no'] as int, json['question'] as String,
        json['answerType'] as String, linkTo);
  }
}

class Objective extends Question {
  List<Option> _options;
  bool _mul;

  List<Option> get options => _options;

  bool get mul => _mul;

  Objective(int no, String str, String type, this._options, this._mul)
      : super(no, str, type);

  factory Objective.fromJson(dynamic json) {
    bool mul = false;

    if (json['textAnswer'] != null) {
      mul = json['textAnswer'] as bool;
    }

    List options = List();

    if(json['options'] != null) {
      var optObjsJson = json['options'] as List;
      options = optObjsJson.map((op) => Option.fromJson(op)).toList();
    }

    return Objective(json['no'] as int, json['question'] as String,
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
