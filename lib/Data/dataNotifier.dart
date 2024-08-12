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
  Map<String, dynamic> rickAndMortyCompleteListOfDataMap = {};
  List<CharacterAppModel> _completeCharacterAppModelList = [];
  List<CharacterAppModel> _filteredCharacterAppModelList = [];
  bool _failedToLoad = false;
  bool _fetchingInitialData = true;
  String nextPageUrl = '';
  String prevPageUrl = Constants.RICK_AND_MORTY_API;

  String currentFilterType = Constants.ALL_CHARCTERS_KEY;
  String currentFilterValue = '';

  List<CharacterAppModel> get filteredAppModelList => _filteredCharacterAppModelList;

  bool get failedToLoad => _failedToLoad;

  bool get fetchingData => _fetchingInitialData;

  DataNotifier() {
    ApiRequest(Constants.RICK_AND_MORTY_API, onGetHttpResponse);
  }

  void fetchMoreCharacters() {
    if (nextPageUrl != '') {
      ApiRequest(nextPageUrl, onGetHttpResponse);
    }
  }

  void refreshData() {
    if (prevPageUrl != '') {
      ApiRequest(prevPageUrl, onGetHttpResponse);
    }
  }

  Future<void> onGetHttpResponse(Map<String, dynamic>? httpMapResponse) async {
    _fetchingInitialData = false;
    if (httpMapResponse == null) {
      String? dataFromCache = CacheManger.localStorageGetString(Constants.RICK_AND_MORTY_DATA_KEY, null);
      if (dataFromCache != null) {
        Map<String, dynamic> dataDecoded = jsonDecode(dataFromCache);
        rickAndMortyCompleteListOfDataMap = dataDecoded;
      } else {
        _failedToLoad = true;
      }
    } else {
      nextPageUrl = httpMapResponse[Constants.HTTP_INFO_KEY]['next'] ?? '';
      if (httpMapResponse[Constants.HTTP_INFO_KEY]['prev'] != null && httpMapResponse[Constants.HTTP_INFO_KEY]['prev'] != '') {
        prevPageUrl = httpMapResponse[Constants.HTTP_INFO_KEY]['prev'];
      }
      rickAndMortyCompleteListOfDataMap[prevPageUrl] = httpMapResponse[Constants.HTTP_RESULTS_KEY];
      await CacheManger.localStorageStoreString(Constants.RICK_AND_MORTY_DATA_KEY, jsonEncode(rickAndMortyCompleteListOfDataMap));
    }
    _completeCharacterAppModelList = [];
    _filteredCharacterAppModelList = [];
    rickAndMortyCompleteListOfDataMap.forEach((key, value) {
      for (var item in value) {
        Map? origin = item['origin'];
        Map? url = item['location'];
        if (origin == null) {
          origin = {};
          origin['name'] = 'Unknown';
          origin['url'] = 'Unknown';
        }
        if (url == null) {
          url = {};
          url['name'] = 'Unknown';
          url['url'] = 'Unknown';
        }
        CharacterAppModel characterAppModel = CharacterAppModel(
            id: item['id'] ?? 0,
            name: item['name'] ?? 'Unknown',
            species: item['species'] ?? 'Unknown',
            status: item['status'] ?? 'Unknown',
            gender: item['gender'] ?? 'Unknown',
            image: item['image'] ?? 'Unknown',
            origin: LocationLinkModel(name: origin['name'] ?? 'Unknown', url: origin['url'] ?? 'Unknown'),
            location: LocationLinkModel(name: url['name'] ?? 'Unknown', url: url['url'] ?? 'Unknown'));
        _completeCharacterAppModelList.add(characterAppModel);
        _filteredCharacterAppModelList.add(characterAppModel);
      }
    });
    filterListByType(currentFilterType, currentFilterValue);
    notifyListeners();
  }

  void filterListByType(String filterType, String filterValue) {
    currentFilterType = filterType;
    currentFilterValue = filterValue;
    List<CharacterAppModel> tempList = [];
    tempList = _completeCharacterAppModelList.where((character) {
      switch (filterType) {
        case 'all':
          return true;
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
    _filteredCharacterAppModelList = tempList;
    notifyListeners();
  }
}
