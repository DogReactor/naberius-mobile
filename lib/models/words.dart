import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart';
import 'dart:async';

class WordsModel extends ChangeNotifier {
  final _list = List<WordPair>();

  List<WordPair> get list => _list;

  void addWords() {
    if (_list.length == 0) {
      new Timer(const Duration(milliseconds: 1500), () {
        _list.addAll(generateWordPairs().take(10));
        notifyListeners();
      });
    } else {
      print('addWords ${_list.length}');
      new Timer(const Duration(milliseconds: 1000), () {
        _list.addAll(generateWordPairs().take(10));
        notifyListeners();
      });
    }
  }
}
