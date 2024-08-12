import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:indie_flow_test/Data/Constants.dart';
import 'package:indie_flow_test/Data/cache.dart';



class ApiRequest {
  String pUrl='';
  Function httpCallback;
  ApiRequest(this.pUrl,this.httpCallback){
    makeHttpGetRequest(pUrl).then((value){
      httpCallback(value);
    });
  }

  Future<Map<String, dynamic>?> makeHttpGetRequest(String pApiBaseUrl) async {
    try {
      final url = Uri.parse(pApiBaseUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}');
        } // Error response code
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      } // Handle exceptions
    }
  }

}