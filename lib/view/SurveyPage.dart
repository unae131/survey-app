import 'package:flutter/material.dart';
import 'package:survey/model/Survey.dart';

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
          appBar: AppBar(title: Text('Ni Doc')),
          body: Center(child: Text('No ${_nextQ-1}.')));
    else
      return Scaffold(
        appBar: AppBar(title: Text('No ${_nextQ-1}.')),
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