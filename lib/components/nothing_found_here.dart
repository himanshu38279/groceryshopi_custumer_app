import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NothingFoundHere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lottie/nothing-found-here.json"),
        Text(
          "Nothing can be found here ...",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
