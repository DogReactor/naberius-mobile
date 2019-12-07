import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naberius_mobile/models/favourite.dart';
import 'package:english_words/english_words.dart';

class Favourites extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    var favourites = Provider.of<FavouriteModel>(context);
    final Iterable<ListTile> tiles = favourites.saved.map(
      (WordPair pair) {
        return ListTile(
            title: Text(pair.asPascalCase, style: _biggerFont),
            trailing: Icon(
              Icons.delete,
              // color: Colors.red,
            ),
            onTap: () {
              favourites.toggleWord(pair);
            });
      },
    );
    final List<Widget> divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();
    return Scaffold(
      appBar: AppBar(title: Text('Saved Suggestions')),
      body: ListView(children: divided),
    );
  }
}
