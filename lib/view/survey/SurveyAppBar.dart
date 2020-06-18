import 'package:flutter/material.dart';

class SurveyAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 55.0;

  SurveyAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight,
      ),
      height: statusBarHeight + barHeight,
      decoration: BoxDecoration(
        color: Color(0xFF00CCFF),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'DoHyeon',
            fontWeight: FontWeight.w400,
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}
