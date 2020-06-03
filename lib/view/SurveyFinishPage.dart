import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';

class FinishPage extends StatelessWidget {
  FinishPage(this.survey, this.answer);

  final Survey survey;
  final List answer;

  @override
  Widget build(BuildContext context) {
    // answer 파일에 옮기고

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
                  for(int i = 0; i < survey.questions.length+2; i++)
                  Navigator.pop(
                      context);
                }),
          ],
        ),
      ),
    );
  }
}
