import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:survey/model/Survey.dart';
import 'package:survey/view/SurveyPage.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 필요한 json 파일 로드
    Future<String> objFuture = rootBundle.loadString('src/nidoc_survey1.json');

    return FutureBuilder<String>(
        future: objFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                      title: 'Ni Doc',
                      survey: Survey.fromJson(
                          objFuture.then((value) => jsonDecode(value))))),
            );
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              Image(image: AssetImage('src/nidoc_splash.png'))
            ];
          }
          return Scaffold(
            backgroundColor: Color(0xff2196f3),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          );
        });
  }

  Widget splashPage() {}

  Survey readSurveyData() {
    final future = rootBundle.loadString('src/nidoc_survey1.json');
    future.then((news) => print(news));
    //Future<String> objFuture = rootBundle.loadString('src/nidoc_survey1.json');
    //String objText; //= '{"topic": "Health Survey1","questions": [{"no": 1,"question": "name?","answerType": "subjective"},{"no": 2,"question": "age?","answerType": "objective","options": [{"value": "10 ~ 19","linkTo": 7},{"value": "20 ~ 29"},{"value": "30 ~ 39","linkTo": 7},{"value": "40 ~ 49","linkTo": 7},{"value": "under 10 or over 50","linkTo": 4}]},{"no": 3,"question": "sex?","answerType": "selectable","options": [{"value": "M"},{"value": "W"}]},{"no": 4,"question": "hurt point?","answerType": "objective","mulAnswer" : true,"options": [{"value": "eye"},{"value": "neck/waist"},{"value": "wrist/knee"},{"value": "stomach"},{"value": "other","textAnswer": true},{"value": "nowhere","linkTo": 7}]},{"no": 5,"question": "What would you do when you feel uncomfortable of your body?","answerType": "objective","options": [{"value": "search"},{"value": "go to hospital"},{"value": "ask to non-expert"},{"value": "leave it out"},{"value": "guitar","textAnswer": true}]}]}';

    /*objFuture.then((data) {
      objText = data;
    }, onError: (e) {
      print(e);
    });*/

    //return Survey.fromJson(jsonDecode(objText));
  }
}
