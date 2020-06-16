import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'package:nidocapp/view/survey/SurveyListRow.dart';

class SurveyListPage extends StatefulWidget {
  final Survey survey; // 후에 리스트로 받기

  SurveyListPage({this.survey});

  @override
  _SurveyListPage createState() => _SurveyListPage();
}

class _SurveyListPage extends State<SurveyListPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SurveyListRow(widget.survey),
          SurveyListRow(widget.survey),
        ],
      ),
    );
  }
}
