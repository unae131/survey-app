import 'package:flutter/material.dart';
import 'package:nidocapp/model/Survey.dart';
import 'package:nidocapp/view/survey/SurveyListRow.dart';

class SurveyListPage extends StatefulWidget {
  final List<Survey> surveys; // 후에 리스트로 받기

  SurveyListPage({this.surveys});

  @override
  _SurveyListPage createState() => _SurveyListPage();
}

class _SurveyListPage extends State<SurveyListPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        //color: Color(0xFF736AB7),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              sliver: SliverFixedExtentList(
                itemExtent: 152.0,
                delegate: SliverChildBuilderDelegate(
                  (context, index) => SurveyListRow(widget.surveys[index]),
                  childCount: widget.surveys.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
