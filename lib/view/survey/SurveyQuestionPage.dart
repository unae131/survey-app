import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'SurveyAppBar.dart';
import 'SurveyFinishPage.dart';

/* 이전 질문 페이지로 돌아갈 때 응답 남을 수 있게 수정 필요
* */
class QuestionPage extends StatefulWidget {
  final Survey survey; // 무조건 한 문제 이상은 있음
  final List answer;

  QuestionPage(this.survey, this.answer);

  @override
  _QuestionPageState createState() =>
      _QuestionPageState(survey.get(), survey.get().link);
}

class _QuestionPageState extends State<QuestionPage> {
  final Question question;
  int linkTo;
  bool answer = false;

  int _radioValue = -1;
  List _checkValue;

  _QuestionPageState(this.question, this.linkTo);

  final questionTextStyle = TextStyle(
    fontFamily: 'DoHyeon',
    color: Color(0xFF333366),
    fontSize: 24.0,
  );

  final optionTextStyle = TextStyle(
    fontFamily: 'NotoSansKR',
    color: Color(0xFF333366),
    fontSize: 18.0,
  );

  @override
  Widget build(BuildContext context) {
    final questionContent = Container(
      alignment: Alignment.topLeft,
      //color: Colors.blue,
      child: Text(
        'Q. ${question.qStr}',
        style: questionTextStyle,
      ),
    );

    final wholeBody = Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          Container(height: 100),
          questionContent,
          Container(height: 36),
          question is Objective
              ? objective(question as Objective)
              : subjective(question as Subjective),
          Container(height: 48),
          buttons(),
          Container(height: 100),
          //nextPageButton()
        ],
      ),
    );

    if (question == null) {
      return FinishPage(widget.survey, widget.answer);
    } else {
      return Scaffold(
        body: Column(
          children: <Widget>[
            SurveyAppBar('${widget.survey.topic}'),
            Expanded(
              child: Container(
                //color: Colors.blueGrey,
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      sliver: SliverToBoxAdapter(
                        child: wholeBody,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget subjective(Subjective question) {
    return TextField();
  }

  Widget objective(Objective question) {
    var options;
    var i = -1;

    if (_checkValue == null) {
      _checkValue = List(question.options.length);
      _checkValue.fillRange(0, question.options.length, false);
    }

    options = question.options.map((option) {
      i++;
      return question.mul ? drawCheckBox(option, i) : drawRadio(option, i);
    }).toList();
    return Column(children: options);
  }

  Widget drawRadio(Option option, int i) {
    List row = <Widget>[
      Radio(
        value: i,
        groupValue: _radioValue,
        onChanged: (value) {
          setState(() {
            answer = true;
            _radioValue = value;
            linkTo = option.linkTo;
          });
        },
      ),
      Text(
        option.answer,
        style: optionTextStyle,
      )
    ];

    if (option.text) {
      row.add(Container(
        width: 16,
      ));
      row.add(Expanded(child: TextField()));
    }

    return Row(
      children: row,
    );
  }

  Widget drawCheckBox(Option option, int i) {
    List row = <Widget>[
      Checkbox(
        value: _checkValue[i],
        onChanged: (value) {
          setState(() {
            answer = true;
            _checkValue[i] = value;
          });
        },
      ),
      Text(
        option.answer,
        style: optionTextStyle,
      )
    ];

    if (option.text) {
      row.add(Container(
        width: 16,
      ));
      row.add(Expanded(child: TextField()));
    }
    return Row(
      children: row,
    );
  }

  Widget buttons() {
    final buttonTextStyle = TextStyle(
        fontFamily: "DoHyeon",
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w100);

    final lastButton = RaisedButton(
        color: Color(0xFF00CCFF),
        child: Text(
          '이전',
          style: buttonTextStyle,
        ),
        onPressed: () {
          writeAnswer();
          Navigator.pop(context);
        });

    final nextButton = RaisedButton(
        color: Color(0xFF00CCFF),
        child: Text(
          '다음',
          style: buttonTextStyle,
        ),
        onPressed: () {
          //if (answer) {
          writeAnswer();
          widget.survey.next(linkTo);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionPage(widget.survey, widget.answer)));
          //}
        });

    return Container(
        //color: Colors.black,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[lastButton, Container(width: 32), nextButton],
        ));
  }

  void writeAnswer() {
    if (question is Subjective) {
    } else if (question is Objective && (question as Objective).mul) {
      List mulChecked = List();
      _checkValue.forEach((e) {
        if (e == true) answer = true;
        //기록
      });
    } else {}
  }
}
