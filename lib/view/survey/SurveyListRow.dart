import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';

class SurveyListRow extends StatefulWidget {

  _SurveyListRowWidget createState() => _SurveyListRowWidget();

}

class _SurveyListRowWidget extends State<SurveyListRow> {
  Survey survey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124.0,
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
      color: Color(0xFF3366FF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          )
        ]
      ),
    );
  }

}