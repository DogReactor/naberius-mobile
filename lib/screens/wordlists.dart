import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naberius_mobile/models/words.dart';
import 'package:naberius_mobile/models/favourite.dart';
import 'package:english_words/english_words.dart';

class WordList extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Widget _buildRow(FavouriteModel favourited, WordPair pair) {
    final bool alreadySaved = favourited.saved.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        favourited.toggleWord(pair);
      },
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    var words = Provider.of<WordsModel>(context);
    var favourited = Provider.of<FavouriteModel>(context);
    if (words.list.length == 0) {
      words.addWords();
      return Center(
        child: Text('么得文字', style: Theme.of(context).textTheme.display2),
      );
    }
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: words.list.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= words.list.length - 1) {
            words.addWords();
          }
          return _buildRow(favourited, words.list[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.pushNamed(context, '/favourite'),
          )
        ],
      ),
      body: _buildSuggestions(context),
    );
  }
}
