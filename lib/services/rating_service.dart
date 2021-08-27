import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/utilities/shared_prefs.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingService {
  static void handleRating(BuildContext context) {
    if (_askForRating) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset("assets/lottie/rating.json", height: 100),
                  SizedBox(height: 10),
                  MyButton(
                    text: "RATE US",
                    width: double.infinity,
                    onTap: () async {
                      SharedPrefs.setBool(SharedPrefs.ratingString, false);
                      Navigator.pop(context);
                      if (await canLaunch(kPlayStoreLink))
                        await launch(kPlayStoreLink);
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextButton(
                          child: Text("Don't ask me again"),
                          onPressed: () {
                            SharedPrefs.setBool(
                                SharedPrefs.ratingString, false);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          child: Text("Remind me later"),
                          onPressed: () {
                            SharedPrefs.setBool(SharedPrefs.ratingString, true);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static bool get _askForRating =>
      SharedPrefs.getBool(SharedPrefs.ratingString) ?? true;
}
