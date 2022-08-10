import 'package:flutter/material.dart';

import '../logic/caps.dart';
import '../logic/models/language.dart';

class ChooseLang extends StatelessWidget {
  const ChooseLang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(size.shortestSide * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Choose language",
                  style: TextStyle(
                    fontSize: size.longestSide * 0.03,
                    color: Colors.black54,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: Lang.values
                      .map((e) => SizedBox(
                            width: size.shortestSide,
                            height: size.longestSide * 0.1,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                e.name.capitalize,
                                style: TextStyle(
                                  fontSize: size.shortestSide * 0.07,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
