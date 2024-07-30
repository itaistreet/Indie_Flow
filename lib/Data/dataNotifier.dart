import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:indie_flow_test/Data/Constants.dart';
import 'package:indie_flow_test/Data/Domain/Models/CharacterAppModel.dart';
import 'package:indie_flow_test/Data/Domain/Models/LocationLinkModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache.dart';
import 'httpRequest.dart';

class DataNotifier extends ChangeNotifier {
  List<dynamic> rickAndMortyCompleteListOfData=[];
   List<CharacterAppModel> _completeCharacterAppModelList=[];
  List<CharacterAppModel> _filteredCharacterAppModelList=[];
  bool _failedToLoad=false;
  bool _fetchingData=true;

  List<CharacterAppModel> get filteredAppModelList=>_filteredCharacterAppModelList;
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
        rickAndMortyCompleteListOfData=mapDecoded[Constants.HTTP_RESULTS_KEY];
      }else {
        _failedToLoad=true;
      }
    }else {
      rickAndMortyCompleteListOfData=httpMapResponse[Constants.HTTP_RESULTS_KEY];
    }
    for (var item in rickAndMortyCompleteListOfData){
       Map? origin= item['origin'];
       Map? url= item['location'];
       if(origin==null){
         origin={};
         origin['name']='Unknown';
         origin['url']='Unknown';
       }if(url==null){
         url={};
         url['name']='Unknown';
         url['url']='Unknown';
       }
   CharacterAppModel characterAppModel= CharacterAppModel(id: item['id']??'Unknown' , name: item['name']??'Unknown', species: item['species']??'Unknown', status: item['status']??'Unknown', gender: item['gender']??'Unknown', image: item['image']??'Unknown', origin: LocationLinkModel(name: origin['name']??'Unknown', url: origin['url']??'Unknown'), location: LocationLinkModel(name: url['name']??'Unknown', url: url['url']??'Unknown'));
   _completeCharacterAppModelList.add(characterAppModel);
   _filteredCharacterAppModelList.add(characterAppModel);
    }
    notifyListeners();
  }



  void filterListByUserRequest(String filterType, String filterValue) {
      List<CharacterAppModel> tempList=[];
      tempList = _completeCharacterAppModelList.where((character) {
        switch (filterType) {
          case 'all': return true;
          case 'name':
            return character.name == filterValue;
          case 'species':
            return character.species == filterValue;
          case 'status':
            return character.status == filterValue;
          case 'gender':
            return character.gender == filterValue;
          default:
            return false;
        }
      }).toList();
    _filteredCharacterAppModelList=tempList;
      notifyListeners();
  }
}