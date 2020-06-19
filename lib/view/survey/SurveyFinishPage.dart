import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'package:nidocapp/view/survey/SurveyAppBar.dart';

class FinishPage extends StatelessWidget {
  FinishPage(this.survey, this.answer);

  final Survey survey;
  final List answer;

  @override
  Widget build(BuildContext context) {
    // answer 파일에 옮기고
    for (int i = 0; i < answer.length; i++) {
      print('question $i');
      if (answer[i] != null)
        for (int j = 0; j < (answer[i] as List).length; j++) {
          print(answer[i][j]);
        }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          SurveyAppBar(survey.topic),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: Text('수고하셨습니다.',
                      style: TextStyle(fontFamily: 'DoHyeon').copyWith(
                        color: Color(0xFF333366),
                        fontSize: 22.0,
                      )),
                ),
                RaisedButton(
                    color: Colors.cyan,
                    textColor: Colors.white,
                    child: Text('제출'),
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/surveyStart'));
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
