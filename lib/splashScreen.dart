import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/AppTheme.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var millis = DateTime.now().microsecondsSinceEpoch;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: DefaultTextStyle(
            style: GoogleFonts.montserrat(
              fontSize: 44,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 5
                ..color = AppThemes.getPrimaryColor(),
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                ScaleAnimatedText('EQ App',
                    duration: Duration(milliseconds: 3500)),
              ],
              onTap: () {},
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: Text(
            'EQ App',
            style: GoogleFonts.montserrat(
              fontSize: 36,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = AppThemes.getPrimaryColor(),
            ),
          ),
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage((millis.isEven)
              ? "assets/images/login_background2.jpeg"
              : "assets/images/login_background1.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
