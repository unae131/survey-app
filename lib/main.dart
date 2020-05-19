import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Survey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key); ////?????

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _quest1 = "Where do you want to go?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Start Survey',
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ButtonTheme(
                minWidth: 300,
                height: 40,
                buttonColor: Colors.lightBlue,
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                        child: Text(
                          'I want to go to No.4',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyPage(1)),
                          );
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyPage extends StatefulWidget {
  int qNum;

  SurveyPage(int qNum) {
    this.qNum = qNum;
  }

  @override
  _SurveyPageState createState() =>
      _SurveyPageState(true, qNum, "test", ['이거 별로야?','별로야?']);
}

class _SurveyPageState extends State<SurveyPage> {
  int qNum;
  String question;
  List<String> answers;
  bool type;

  final myController = TextEditingController();

  _SurveyPageState(bool type, int qNum, String question, List<String> answer) {
    this.type = type;
    this.qNum = qNum;
    this.question = question;
    this.answers = answer;
  }

  void _test(String str) {
    print(str);
  }

  List<Widget> _buildButtonList(BuildContext context) {
    List<Widget> ret;
    if (!type)
      ret = answers.map((e) => _buildButton(context, e)).toList();
    else
      ret = [TextField(controller: myController)];
    ret.add(_buildSubmitButton());
    return ret;
  }

  Widget _buildButton(BuildContext context, String answer) {
    return RaisedButton(
      child: Text(
        answer,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () => _test(answer),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.all(30),
      child: RaisedButton(
        child: Text(
          'Next',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SurveyPage(qNum + 1)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Question $qNum')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$question',
              style: Theme.of(context).textTheme.headline6,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ButtonTheme(
                minWidth: 300,
                height: 40,
                buttonColor: Colors.lightBlue,
                child: Column(children: _buildButtonList(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
