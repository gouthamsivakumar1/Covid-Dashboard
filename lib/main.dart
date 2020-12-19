import 'package:covid_dashboard/redux/store.dart';
import 'package:covid_dashboard/screen/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

Future<void> main() async {
  await Redux.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Covid Dashbard',
      debugShowCheckedModeBanner: false,
      home:  StoreProvider<AppState>(
        store: Redux.store,
        child: MyHomePage(title: 'Flutter Covid Dashboard'),
    ));
  }
}



