import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart';

class FavouriteModel extends ChangeNotifier {
  final _saved = Set<WordPair>();
  Set<WordPair> get saved => _saved;
  void toggleWord(WordPair wp) {
    if (_saved.contains(wp)) {
      _saved.remove(wp);
    } else {
      _saved.add(wp);
    }
    notifyListeners();
  }

  bool has(WordPair wp) {
    return _saved.contains(wp);
  }
}
