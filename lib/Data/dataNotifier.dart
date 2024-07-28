import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'httpRequest.dart';

class DataNotifier extends ChangeNotifier {
  List<dynamic> rickAndMortyListOfData=[];
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
      _failedToLoad=true;
    }else {
      rickAndMortyListOfData = httpMapResponse['results'];
    }
    notifyListeners();
  }
}
