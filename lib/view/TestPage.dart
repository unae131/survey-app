import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '테스트 페이지 입니다.',
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
        ],
      ),
    );
  }

}