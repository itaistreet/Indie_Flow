import 'dart:io';

import 'package:flutter/material.dart';
import 'package:indie_flow_test/Data/Constants.dart';
import 'package:indie_flow_test/Data/cache.dart';
import 'package:indie_flow_test/Data/dataNotifier.dart';
import 'package:provider/provider.dart';

import 'Presentation/CharacterDetails.dart';
import 'Presentation/CharctersList.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await CacheManger.getSharedPreferences();
    runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DataNotifier(),
      child: MaterialApp(
        title: 'IndieFlow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  CharctersList(title: 'IndieFlow Demo Home Page'),
      ),
    );
  }
}

