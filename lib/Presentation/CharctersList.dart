import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indie_flow_test/Data/CharacterPage/CharacterListTile.dart';
import 'package:provider/provider.dart';

import 'CharacterDetails.dart';
import '../Data/Constants.dart';
import '../Data/dataNotifier.dart';

class CharctersList extends StatefulWidget {
  CharctersList({super.key, required this.title});

  final String title;

  @override
  State<CharctersList> createState() => _CharctersListState();
}

class _CharctersListState extends State<CharctersList> {
  int selectedFilterIndex = 2;

  ScrollController scrollController = ScrollController();
  late DataNotifier dataNotifier;
  bool floatingActionVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(onScroll);
      //  scrollController.jumpTo(screenHeight / 2);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dataNotifier = Provider.of<DataNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          getFilterItems(context),
          Flexible(
            child: RefreshIndicator(
              onRefresh: () { return refreshData();},
              child: Selector<DataNotifier, ({List<dynamic> listOfData, bool fetchingData, bool failedToLoad})>(
                  selector: (_, notifier) => (listOfData: notifier.filteredAppModelList, fetchingData: notifier.fetchingData, failedToLoad: notifier.failedToLoad),
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
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          return CharacterListTile(
                              character: dataList.listOfData[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (context) => CharacterDetails(
                                            characterDetails: dataList.listOfData[index],
                                          )),
                                );
                              });
                        });
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: floatingActionVisible,
        child: FloatingActionButton.small(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.keyboard_double_arrow_up,
              color: Colors.black,
            ),
            onPressed: () {
              floatingActionVisible = false;
              scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.linear);
              setState(() {});
            }),
      ),
    );
  }


  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    dataNotifier.refreshData();
  }
  void onScroll() {
   bool tempFloatingActionVisibile=false;
    if (scrollController.offset > 0) {
      tempFloatingActionVisibile = true;
    } else {
      tempFloatingActionVisibile = false;
    }
    if(floatingActionVisible!= tempFloatingActionVisibile){
      floatingActionVisible=tempFloatingActionVisibile;
      setState(() {

      });
    }
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      dataNotifier.fetchMoreCharacters();
    }
  }


  void setNewFilterItem(int index){
    selectedFilterIndex=index;
    scrollController.jumpTo(0.0);
  }
  SizedBox getFilterItems(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setNewFilterItem(0);
                dataNotifier.filterListByType(Constants.GENDER_OF_CHARACTER_KEY, Constants.GENDER_FEMALE);
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
                setNewFilterItem(1);
                dataNotifier.filterListByType(Constants.GENDER_OF_CHARACTER_KEY, Constants.GENDER_MALE);
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
                setNewFilterItem(2);

                dataNotifier.filterListByType(Constants.ALL_CHARCTERS_KEY, '');
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
                setNewFilterItem(3);
                dataNotifier.filterListByType(Constants.STATUS_OF_CHARACTER_KEY, Constants.STATUS_DEAD);
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
                setNewFilterItem(4);
                dataNotifier.filterListByType(Constants.STATUS_OF_CHARACTER_KEY, Constants.STATUS_ALIVE);
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
