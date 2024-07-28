import 'dart:io';

import 'package:flutter/material.dart';
import 'package:indie_flow_test/Data/dataNotifier.dart';
import 'package:provider/provider.dart';

import 'CharacterDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        home: const MyHomePage(title: 'IndieFlow Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Selector<DataNotifier, ({List<dynamic> listOfData, bool fetchingData, bool failedToLoad})>(
          selector: (_, notifier) => (listOfData: notifier.rickAndMortyListOfData, fetchingData: notifier.fetchingData, failedToLoad: notifier.failedToLoad),
          builder: (_, dataList, __) {
            if (dataList.fetchingData) {
              return const Center(child: CircularProgressIndicator());
            } else if (dataList.failedToLoad) {
              return const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Failed To Load Characters From Api',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            return ListView.builder(
                itemCount: dataList.listOfData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          // fullscreenDialog: true,
                          //  settings: const RouteSettings(name: 'youTubePlayer'),
                            builder: (context) => CharacterDetails(
                              characterDetails: dataList.listOfData[index],
                            )),
                      );
                    },
                    child: Container(
                        height: 50,
                        margin: const EdgeInsetsDirectional.only(top: 8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.blueGrey, width: 1.5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [Text('Name: ${dataList.listOfData[index]['name']}'), Text('Species: ${dataList.listOfData[index]['species']}')],
                            ),
                            Image.network(dataList.listOfData[index]['image'])
                          ],
                        )),
                  );
                });
          }),
    );
  }
}
