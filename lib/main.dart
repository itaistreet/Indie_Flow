import 'dart:io';

import 'package:flutter/material.dart';
import 'package:indie_flow_test/Data/Constants.dart';
import 'package:indie_flow_test/Data/cache.dart';
import 'package:indie_flow_test/Data/dataNotifier.dart';
import 'package:provider/provider.dart';

import 'CharacterDetails.dart';

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
  void dispose(){
    super.dispose();
  }
  int selectedFilterIndex = 2;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          getFilterItems(),
          Expanded(
            child: Selector<DataNotifier, ({List<dynamic> listOfData, bool fetchingData, bool failedToLoad})>(
                selector: (_, notifier) => (listOfData: notifier.rickAndMortyFilteredListOfData, fetchingData: notifier.fetchingData, failedToLoad: notifier.failedToLoad),
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
                                    children: [Text('Name: ${dataList.listOfData[index][Constants.NAME_OF_CHARACTER_KEY] ??''}'), Text('Species: ${dataList.listOfData[index][Constants.SPECIES_OF_CHARACTER_KEY]??''}')],
                                  ),
                                  if(dataList.listOfData[index][Constants.IMAGE_OF_CHARACTER_KEY]!=null && dataList.listOfData[index][Constants.IMAGE_OF_CHARACTER_KEY]!='')
                                  Image.network(dataList.listOfData[index]['image'])
                                ],
                              )),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  SizedBox getFilterItems() {
    final data = Provider.of<DataNotifier>(context);
    return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                selectedFilterIndex = 0;
                data.filterListByUserRequest(Constants.GENDER_OF_CHARACTER_KEY,Constants.GENDER_FEMALE);
              },
              child: Container(
                padding: const EdgeInsetsDirectional.all(4),
                margin: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(5), color: getFilterButtonColor(0)),
                child: Text('Females', style: TextStyle(fontWeight: FontWeight.w500, color: getFilterTextColor(0)), textAlign: TextAlign.center),
              ),
            ),
            InkWell(
              onTap: () {
                selectedFilterIndex = 1;

                data.filterListByUserRequest(Constants.GENDER_OF_CHARACTER_KEY,Constants.GENDER_MALE);
              },
              child: Container(
                margin: const EdgeInsetsDirectional.all(4),
                padding: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(5), color: getFilterButtonColor(1)),
                child: Text('Men', style: TextStyle(fontWeight: FontWeight.w500, color: getFilterTextColor(1)), textAlign: TextAlign.center),
              ),
            ),
            InkWell(
              onTap: () {
                selectedFilterIndex = 2;
                data.resetFilteredList();
              },
              child: Container(
                margin: const EdgeInsetsDirectional.all(4),
                padding: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(5), color: getFilterButtonColor(2)),
                child: Text('All', style: TextStyle(fontWeight: FontWeight.w500, color: getFilterTextColor(2)), textAlign: TextAlign.center),
              ),
            ),
            InkWell(
              onTap: () {
                selectedFilterIndex = 3;

                data.filterListByUserRequest(Constants.STATUS_OF_CHARACTER_KEY,Constants.STATUS_DEAD);
              },
              child: Container(
                padding: const EdgeInsetsDirectional.all(4),
                margin: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(5), color: getFilterButtonColor(3)),
                child: Text('Dead', style: TextStyle(fontWeight: FontWeight.w500, color: getFilterTextColor(3)), textAlign: TextAlign.center),
              ),
            ),
            InkWell(
              onTap: () {
                selectedFilterIndex = 4;
                data.filterListByUserRequest(Constants.STATUS_OF_CHARACTER_KEY,Constants.STATUS_ALIVE);
              },
              child: Container(
                padding: const EdgeInsetsDirectional.all(4),
                margin: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500), borderRadius: BorderRadius.circular(5), color: getFilterButtonColor(4)),
                child: Text('Alive', style: TextStyle(fontWeight: FontWeight.w500, color: getFilterTextColor(4)), textAlign: TextAlign.center),
              ),
            ),
          ],
        ));
  }
  Color getFilterButtonColor(int index) {
    if (index == selectedFilterIndex) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  Color getFilterTextColor(int index) {
    if (index == selectedFilterIndex) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

}
