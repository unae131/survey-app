import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'NiDocAppBar.dart';
import 'survey/SurveyListPage.dart';
import 'TestPage.dart';

class MenuPage extends StatefulWidget {
  final Survey survey;

  MenuPage({this.survey});

  @override
  _MenuPageState createState() =>
      _MenuPageState([SurveyListPage(survey: survey), TestPage(), TestPage()]);
}

class _MenuPageState extends State<MenuPage> {
  int _currentIndex = 0;
  final List<Widget> _children;

  _MenuPageState(this._children);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(
        children: <Widget>[
          NiDocAppBar("Ni Doc"),
          _children[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // this will be set when a new tab is tapped
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('홈'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('설문조사'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('프로필'))
        ],
      ),
    );
  }
}
