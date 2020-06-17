import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'SurveyQuestionPage.dart';

class SurveyStartPage extends StatelessWidget {
  // json 파일이 제대로 읽혔는지 이전에 확인되어 있어야함
  // 후에 다양한 테스트가 가능하게 될 경우를 생각
  SurveyStartPage({Key key, this.survey}) : super(key: key);

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontFamily: 'DoHyeon').copyWith(
      color: Color(0xFF333366),
      fontSize: 22.0,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: (survey == null ||
                  survey.questions == null ||
                  survey.questions.length == 0)
              ? <Widget>[
                  Text('설문조사 정보를 읽을 수 없습니다.'),
                ]
              : <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(16, 32, 16, 32),
                      child: Hero(
                        tag: "survey-topic-${survey.topic}",
                        child: Text('${survey.topic} 시작합니다', style: textStyle),
                      )),
                  RaisedButton(
                    color: Colors.cyan,
                    textColor: Colors.white,
                    child: Text('시작'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => QuestionPage(
                            survey, 0, List<List>(survey.questions.length)),
                      ));
                    },
                  ),
                ],
        ),
      ),
    );
  }
}
