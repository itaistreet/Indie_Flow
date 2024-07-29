import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:indie_flow_test/Data/Constants.dart';
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

    ApiRequest(Constants.RICK_AND_MORTY_API, onGetHttpResponse);
  }
  void onGetHttpResponse(Map<String, dynamic>? httpMapResponse) {
    _fetchingData=false;
    if(httpMapResponse==null){
     String? dataFromCache= CacheManger.localStorageGetString(Constants.RICK_AND_MORTY_DATA_KEY,null);
      if(dataFromCache!=null){
        Map<String, dynamic> mapDecoded= jsonDecode(dataFromCache);
        rickAndMortyFilteredListOfData=mapDecoded[Constants.HTTP_RESULTS_KEY];
        rickAndMortyCompleteListOfData=mapDecoded[Constants.HTTP_RESULTS_KEY];
      }else {
        _failedToLoad=true;
      }
    }else {
      rickAndMortyFilteredListOfData = httpMapResponse[Constants.HTTP_RESULTS_KEY];
      rickAndMortyCompleteListOfData=httpMapResponse[Constants.HTTP_RESULTS_KEY];
    }

    notifyListeners();
  }



  void filterListByUserRequest(String filterType, String filterValue) {
      List tempList=[];
      for (Map item in rickAndMortyCompleteListOfData){
        if (item[filterType]!=null && item[filterType]==filterValue){
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
