import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:tbo_the_best_one/utilities/shared_prefs.dart';

class OneTimeShowcase {
  static final menuIconDrawerKey = GlobalKey();
  static final currentLocationEditKey = GlobalKey();
  static final cartViewKey = GlobalKey();
  static final searchBarKey = GlobalKey();

  static bool _displayShowcase;

  static Future<void> initialize() async {
    _displayShowcase = SharedPrefs.getBool(SharedPrefs.displayShowcaseString);
    _displayShowcase ??= true;
    if (_displayShowcase)
      await SharedPrefs.setBool(SharedPrefs.displayShowcaseString, false);
  }

  static void handleShowcase(BuildContext context) {
    if (_displayShowcase) {
      _displayShowcase = false;
      ShowCaseWidget.of(context).startShowCase(
        [
          menuIconDrawerKey,
          currentLocationEditKey,
          cartViewKey,
          searchBarKey,
        ],
      );
    }
  }
}
