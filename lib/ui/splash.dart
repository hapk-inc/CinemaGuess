import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final highest = size.longestSide;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Icon(
                Icons.movie,
                size: highest * 0.3,
              ),
            ),
            Flexible(
              child: Text(
                "CinemaGuess",
                style: GoogleFonts.poppins(
                  fontSize: highest * 0.05,
                  color: Colors.white54,
                  letterSpacing: 1,
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: highest * 0.02),
                //color: Colors.red,
                child: Text(
                  "Find the movie from movieFrames",
                  style: GoogleFonts.poppins(
                      color: Colors.grey, fontSize: highest * 0.02),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final Object e;
  final StackTrace trace;
  const ErrorPage({Key? key, required this.e, required this.trace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(trace.toString())));
  }
}
