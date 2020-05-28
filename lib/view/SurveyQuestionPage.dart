import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'MenuPage.dart';
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
  int linkTo = -1;

  _QuestionPageState(this.question);

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
    }
    else {
      linkTo = question.linkTo;

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.survey.topic),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('No${question.no}. ${question.qStr}'),
              answerBody(),
              nextPageButton()
            ],
          ),
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
      onEditingComplete: () {
        if (widget.answer[widget.qIdx] == null)
          widget.answer[widget.qIdx] = List();

        widget.answer[widget.qIdx].add(myController.text);
      },
    );
    // 제출 기능 추가 구현 필요, 객관식에서도 쓰인 것 주의
  }

  Widget answerObj() {
    Objective question = this.question as Objective;
    int i = 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: question.options
          .map((o) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: drawOption(o, i++, question.mul),
              ))
          .toList(),
    );
  }

  List<Widget> drawOption(Option o, int i, bool mul) {
    var _groupValue = -1;
    List children = <Widget>[
      Radio(
        value: i,
        groupValue: mul ? i : _groupValue,
        onChanged: (newValue) {
          if (!mul) {
            // 다중 선택의 경우 선택지 각각에 링크 부여 불가능
            linkTo = o.linkTo;
          }
          widget.answer[widget.qIdx] = [i.toString()];
          _groupValue = newValue;
        },
      ),
      Text(o.answer)
    ];
    if (o.text) {
      children.add(answerSub());
    }

    return children;
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
      child: Text(
        str,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      ),
    );
  }
}
