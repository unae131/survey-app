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
  final int curIdx;

  QuestionPage(this.survey, this.answer, this.curIdx);

  @override
  _QuestionPageState createState() => _QuestionPageState(
      survey.questions[curIdx], survey.questions[curIdx].link);
}

class _QuestionPageState extends State<QuestionPage> {
  final question;
  int linkTo;

  var tecs = Map<int, TextEditingController>();
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
          Container(/*color: Colors.amber, */ height: 100),
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
                constraints: BoxConstraints.expand(),
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
    return TextField(
      controller: tecs.putIfAbsent(
          0,
          () => widget.answer[widget.curIdx] != null
              ? TextEditingController(text: widget.answer[widget.curIdx][0])
              : TextEditingController()),
    );
  }

  Widget objective(Objective question) {
    var options;
    var i = -1;

    options = question.options.map((option) {
      i++;
      return question.mul
          ? drawCheckBox(question, option, i)
          : drawRadio(option, i);
    }).toList();
    return Column(children: options);
  }

  Widget drawRadio(Option option, int i) {
    if (_radioValue == -1 && widget.answer[widget.curIdx] != null)
      _radioValue =
          int.parse((widget.answer[widget.curIdx][0] as String).split(":")[0]);

    List row = <Widget>[
      Radio(
        value: i,
        groupValue: _radioValue,
        onChanged: (value) {
          setState(() {
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
      row.add(Expanded(
        child: TextField(
          controller: tecs.putIfAbsent(
              i,
              () => widget.answer[widget.curIdx] != null
                  ? TextEditingController(text: widget.answer[widget.curIdx][i])
                  : TextEditingController()),
        ),
      ));
    }

    return Row(
      children: row,
    );
  }

  Widget drawCheckBox(Objective question, Option option, int i) {
    if (_checkValue == null) {
      _checkValue = List(question.options.length);
      _checkValue.fillRange(0, question.options.length, false);
      if (widget.answer[widget.curIdx] != null) {
        int i = -1;
        widget.answer[widget.curIdx].forEach((answ) {
          i++;
          if (answ.split(":")[0] == "true") _checkValue[i] = true;
        });
      }
    }

    List row = <Widget>[
      Checkbox(
        value: _checkValue[i],
        onChanged: (value) {
          setState(() {
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
      row.add(Expanded(
        child: TextField(
          controller: tecs.putIfAbsent(
              i,
              () => widget.answer[widget.curIdx] != null && widget.answer[widget.curIdx][i].split(":").length >= 2
                  ? TextEditingController(text: widget.answer[widget.curIdx][i].split(":")[1])
                  : TextEditingController()),
        ),
      ));
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
          checkAnswered();
          Navigator.pop(context);
        });

    final nextButton = RaisedButton(
        color: Color(0xFF00CCFF),
        child: Text(
          '다음',
          style: buttonTextStyle,
        ),
        onPressed: () {
          if (checkAnswered()) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (linkTo >=
                                widget.survey.questions.length ||
                            linkTo == -1)
                        ? FinishPage(widget.survey, widget.answer)
                        : QuestionPage(widget.survey, widget.answer, linkTo)));
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "답을 입력해주세요!",
                    textAlign: TextAlign.center,
                    style: optionTextStyle,
                  ),
                );
              },
            );
          }
        });

    return Container(
        //color: Colors.black,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[lastButton, Container(width: 32), nextButton],
        ));
  }

  bool checkAnswered() {
    // 주관식 칸에 입력되어있나 확이
    if (question is Subjective &&
        tecs[0].text != null &&
        tecs[0].text.isNotEmpty) {
      widget.answer[widget.curIdx] = [tecs[0].text];
      return true;
    }
    // 객관식 다중선택 check 되어있는 것들 answer에 써주고 return true
    else if (question is Objective && (question as Objective).mul) {
      bool check = false;
      int i = -1;
      widget.answer[widget.curIdx] = List();
      _checkValue.forEach((e) {
        ++i;
        if (e == true) {
          check = true;
          widget.answer[widget.curIdx].add("true" +
              ((question as Objective).options[i].text
                  ? ":" + tecs[i].text
                  : ""));
        } else {
          widget.answer[widget.curIdx].add("false");
        }
      });
      if (check) return true;
    }
    // 객관식 하나만 선택된 것 answer에 써주고 return true
    else if (question is Objective) {
      if (_radioValue > -1) {
        widget.answer[widget.curIdx] = [
          "$_radioValue" +
              ((question as Objective).options[_radioValue].text
                  ? ":" + tecs[_radioValue].text
                  : "")
        ];
        return true;
      }
    }
    return false;
  }
}
