import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';

import 'SurveyStartPage.dart';

class SurveyListRow extends StatelessWidget {
  final Survey survey;

  SurveyListRow(this.survey);

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = TextStyle(fontFamily: 'DoHyeon').copyWith(
      color: Color(0xFF333366),
      fontSize: 18.0,
    );
    final regularTextStyle = TextStyle(fontFamily: 'NotoSansKR').copyWith(
        color: Colors.blueGrey, fontSize: 11.0, fontWeight: FontWeight.w500);

    final surveyContent = Container(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: "survey-topic-${survey.topic}",
            child: Text(
              survey.topic,
              style: headerTextStyle,
            ),
          ),
          //Container(height: 0.0),
          Text(
            '이거 어떻게 자동으로 넘어가지,,,\n이거 오버플로우나면 어떡하지,,,,,,,,,,,,,,\n혜원아 사랑해',
            style: regularTextStyle,
          ),
        ],
      ),
    );

    final surveyCard = Container(
      //height: 124.0,
      decoration: BoxDecoration(
        color: Color(0xEEFEFEFE),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          )
        ],
      ),
      child: surveyContent,
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        settings: RouteSettings(name: '/surveyStart'),
        builder: (BuildContext context) => SurveyStartPage(survey: survey),
      )),
      child: Container(
        //color: Colors.black,
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: surveyCard,
      ),
    );
  }
}
