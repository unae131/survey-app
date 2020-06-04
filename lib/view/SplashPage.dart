import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nidocapp/model/Survey.dart';
import 'package:nidocapp/view/HomePage.dart';

Future<String> readJson() {
  return Future.delayed(Duration(seconds: 2),
      () => rootBundle.loadString('src/nidoc_survey1.json'));
}

Future<Survey> parseSurvey() async {
  final surveySrc = await readJson();
  return Survey.fromJson(jsonDecode(surveySrc));
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Survey>(
          future: parseSurvey(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? MenuPage(survey: snapshot.data)
                : Center(
                    child: Image.asset('src/nidoc_splash.png',
                        height: 120, width: 120));
          }),
    );
  }
}
