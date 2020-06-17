import 'package:flutter/material.dart';

class NiDocAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 60.0;

  NiDocAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight,
      ),
      height: statusBarHeight + barHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF333366),
            const Color(0xFF00CCFF),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.3, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp, // reuse last color if the stops don't fill the whole area
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 33.0,
          ),
        ),
      ),
    );
  }
}
