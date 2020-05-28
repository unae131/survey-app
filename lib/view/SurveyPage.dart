import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';

class SurveyStartPage extends StatelessWidget {
  // json 파일이 제대로 읽혔는지 이전에 확인되어 있어야함
  // 후에 다양한 테스트가 가능하게 될 경우를 생각
  SurveyStartPage({Key key, this.survey}) : super(key: key);

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    if (survey == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('설문조사 정보를 읽을 수 없습니다.'),
              RaisedButton(
                  child: Text('돌아가기'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  child: Text(
                    '시작',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SurveyPage(survey, 1)));
                  }),
            ],
          ),
        ),
      );
    }
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
                    builder: (context) => FinishPage(survey:_survey))//SurveyPage(_survey, _nextQ)),
              ));
  }

  @override
  Widget build(BuildContext context) {
    if (_question == null)
      return Scaffold(
          appBar: AppBar(title: Text('Ni Doc')),
          body: Center(child: Text('No ${_nextQ - 1}.')));
    else
      return Scaffold(
        appBar: AppBar(title: Text('No ${_nextQ - 1}.')),
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

class FinishPage extends StatelessWidget {
  FinishPage({Key key, this.survey}) : super(key: key);

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(survey.topic)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '수고하셨습니다.',
              style: Theme.of(context).textTheme.headline6,
            ),
            RaisedButton(
                child: Text('종료'),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/surveyStart'));
                }),
          ],
        ),
      ),
    );
  }
}
