import 'package:flutter/material.dart';

import 'package:naberius_mobile/unit/unit_page.dart';
import 'package:naberius_mobile/client_provider.dart';

const String GRAPHQL_ENDPOINT = 'https://aigisapi.naberi.us/graphql';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: GRAPHQL_ENDPOINT,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => Scaffold(
                drawer: Drawer(child: Text('data')),
                body: UnitPage(),
              ),
        },
        title: 'Graphql Starwas Demo',
        theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.blue,
          primaryColorLight: Colors.blue[200],
        ),
      ),
    );
  }
}
