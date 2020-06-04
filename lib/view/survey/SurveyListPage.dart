import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'SurveyStartPage.dart';

class SurveyListPage extends StatefulWidget {
  final Survey survey;

  SurveyListPage({this.survey});

  @override
  _SurveyListPage createState() => _SurveyListPage();
}

class _SurveyListPage extends State<SurveyListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.cyan,
              textColor: Colors.white,
              child: Text('설문조사'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(name: '/surveyStart'),
                    builder: (BuildContext context) =>
                        SurveyStartPage(survey: widget.survey)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
