import 'package:flutter/material.dart';
import 'package:nidocapp/view/SurveyPage.dart';
import 'package:nidocapp/model/Survey.dart';

class MenuPage extends StatefulWidget {
  final Survey survey;

  MenuPage({this.survey});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('설문조사'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SurveyStartPage(survey: widget.survey)));
              },
            ),
            //Image.asset('src/nidoc_splash.png', height: 120, width: 120),
          ],
        ),
      ),
    );
  }
}
