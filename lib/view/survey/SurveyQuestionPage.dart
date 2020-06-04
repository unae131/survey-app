import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import '../HomePage.dart';
import 'SurveyFinishPage.dart';

/* 이전 질문 페이지로 돌아갈 때 응답 남을 수 있게 수정 필요
* */
class QuestionPage extends StatefulWidget {
  final Survey survey; // 무조건 하나 이상은 있음
  final int qIdx;
  final List answer;

  QuestionPage(this.survey, this.qIdx, this.answer);

  @override
  _QuestionPageState createState() =>
      _QuestionPageState(survey.questions[qIdx]);
}

class _QuestionPageState extends State<QuestionPage> {
  final myController = TextEditingController();
  Question question;
  int linkTo;
  var _groupValue = 0;
  List<bool> _isChecked;

  _QuestionPageState(this.question) {
    linkTo = question.linkTo;
  }

  @override
  Widget build(BuildContext context) {
    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.survey.topic),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('파일 오류 발생'),
              RaisedButton(
                child: Text(
                  '종료',
                ),
                onPressed: () => Navigator.push(
                  // flow 수정하기
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.survey.topic,
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            /*ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(30),
            children: <Widget>[*/
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${question.qStr}',
                  textScaleFactor: 1.5,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                answerBody(),
                nextPageButton()
              ],
            ),
          ),
          /*],
          ),*/
        ),
      );
    }
  }

  Widget answerBody() {
    if (question is Subjective)
      return answerSub();
    else
      return answerObj();
  }

  Widget answerSub() {
    return TextField(
      controller: myController,
    );
    // 제출 기능 추가 구현 필요, 객관식에서도 쓰인 것 주의
  }

  Widget answerObj() {
    Objective question = this.question as Objective;

    int i = 1;
    return Container(
      padding: EdgeInsets.fromLTRB(40, 30, 40, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: question.options
            .map((o) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: drawOption(o, i++, question.mul),
                ))
            .toList(),
      ),
    );
  }

  List<Widget> drawOption(Option o, int i, bool mul) {
    List children = <Widget>[
      !mul ? singOptions(o, i) : mulOptions(o, i),
      Text(o.answer)
    ];
    if (o.text) {
      children.add(SizedBox(
        width: 200,
        child: answerSub(),
      ));
    }
    return children;
  }

  Widget singOptions(Option o, int i) {
    return Radio(
      value: i,
      groupValue: _groupValue,
      onChanged: (newValue) => setState(() {
        if (o.linkTo != -1)
          linkTo = o.linkTo;
        else
          linkTo = question.linkTo;

        _groupValue = newValue;
        widget.answer[widget.qIdx] = [i.toString()];
      }),
    );
  }

  Widget mulOptions(Option o, int i) {
    if (_isChecked == null) {
      _isChecked = List((this.question as Objective).options.length);
      _isChecked.fillRange(0, _isChecked.length, false);
    }

    if (widget.answer[widget.qIdx] == null)
      widget.answer[widget.qIdx] = List(_isChecked.length);

    // 다중 선택의 경우 선택지 각각에 링크 부여 불가능
    return Checkbox(
      value: _isChecked[i - 1],
      onChanged: (newValue) => setState(() {
        _isChecked[i - 1] = newValue;
        if (newValue) {
          widget.answer[widget.qIdx][i - 1] = 'true';
        } else {
          widget.answer[widget.qIdx][i - 1] = 'false';
        }
      }),
    );
  }

  Widget nextPageButton() {
    String str;
    var page;

    if (linkTo >= widget.answer.length || linkTo < 0) {
      str = '제출';
      page = FinishPage(widget.survey, widget.answer);
    } else {
      str = '다음';
      page = QuestionPage(widget.survey, linkTo, widget.answer);
    }

    return RaisedButton(
      color: Colors.cyan,
      child: Text(
        str,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (widget.answer[widget.qIdx] == null)
          widget.answer[widget.qIdx] = List();

        if (_isChecked == null)
          widget.answer[widget.qIdx].add(myController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
    );
  }
}
