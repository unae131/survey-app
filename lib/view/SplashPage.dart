import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nidocapp/model/Survey.dart';
import 'package:nidocapp/view/HomePage.dart';

Future<String> readJson(String fileName) {
  return rootBundle.loadString(fileName);
}

Future<List<Survey>> parseSurvey() async {
  const List surveyData = [
    'assets/surveyData/nidoc_survey1.json',
    'assets/surveyData/nidoc_survey2.json',
    'assets/surveyData/nidoc_survey3.json',
    'assets/surveyData/nidoc_survey4.json',
    'assets/surveyData/nidoc_survey5.json'
  ];

  List<Survey> surveys = List();
  for (int i = 0; i < surveyData.length; i++) {
    final surveySrc = await readJson(surveyData[i]);
    surveys.add(Survey.fromJson(jsonDecode(surveySrc)));
  }

  return surveys;
}

Future<List<Survey>> parseSurveyList() {
  return Future.delayed(
      Duration(seconds: 2), () => parseSurvey());
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Survey>>(
          future: parseSurveyList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? MenuPage(surveys: snapshot.data)
                : Center(
                    child: Image.asset('assets/images/nidoc_splash.png',
                        height: 120, width: 120));
          }),
    );
  }
}
