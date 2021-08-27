import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/utilities/shared_prefs.dart';

class SearchController extends ChangeNotifier {
  List<String> _recentSearches;

  List<String> get recentSearches => _recentSearches ?? [];

  SearchController() {
    this.update();
  }

  void addRecentSearch(String text) {
    final _initialList =
        SharedPrefs.getStringList(SharedPrefs.recentSearchesString) ?? [];
    if (_initialList.contains(text)) _initialList.remove(text);
    List<String> _list = [text, ...(_initialList ?? [])];
    _list = _list.sublist(0, min(10, _list.length));

    _recentSearches = _list;
    notifyListeners();

    SharedPrefs.setStringList(SharedPrefs.recentSearchesString, _list);
  }

  void update([bool force = false]) {
    if (force || _recentSearches == null) {
      _recentSearches =
          SharedPrefs.getStringList(SharedPrefs.recentSearchesString);
      notifyListeners();
    }
  }
}
