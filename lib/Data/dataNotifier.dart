import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache.dart';
import 'httpRequest.dart';

class DataNotifier extends ChangeNotifier {
  List<dynamic> rickAndMortyFilteredListOfData=[];
  List<dynamic> rickAndMortyCompleteListOfData=[];

  bool _failedToLoad=false;
  bool _fetchingData=true;

  bool  get failedToLoad=>_failedToLoad;
  bool get fetchingData=>_fetchingData;

  DataNotifier() {

    ApiRequest("https://rickandmortyapi.com/api/character", onGetHttpResponse);
  }
  void onGetHttpResponse(Map<String, dynamic>? httpMapResponse) {
    _fetchingData=false;
    if(httpMapResponse==null){
     String? dataFromCache= CacheManger.localStorageGetString('data',null);
      if(dataFromCache!=null){
        Map<String, dynamic> mapDecoded= jsonDecode(dataFromCache);
        rickAndMortyFilteredListOfData=mapDecoded['results'];
        rickAndMortyCompleteListOfData=mapDecoded['results'];
      }else {
        _failedToLoad=true;
      }
    }else {
      rickAndMortyFilteredListOfData = httpMapResponse['results'];
      rickAndMortyCompleteListOfData=httpMapResponse['results'];
    }

    notifyListeners();
  }



  void filterListByUserRequest(String filterType, String filter) {
      List tempList=[];
      for (Map item in rickAndMortyCompleteListOfData){
        if (item[filterType]!=null && item[filterType]==filter){
          tempList.add(item);
        }
      }
    rickAndMortyFilteredListOfData=tempList;
      notifyListeners();
  }

   void resetFilteredList(){
     rickAndMortyFilteredListOfData=rickAndMortyCompleteListOfData;
     notifyListeners();
   }
}
