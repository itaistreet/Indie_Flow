import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class CacheManger {
 static SharedPreferences? sharedPreferences;
 static Future getSharedPreferences() async {
   sharedPreferences = await SharedPreferences.getInstance();
 }


 static String? localStorageGetString(String pKey, String? pDefaultValue) {
   try {
     var pRetVal = sharedPreferences!.getString(pKey);
     if (pRetVal != null) return pRetVal;
     return pDefaultValue;
   } catch (e) {
     return pDefaultValue;
   }
 }

 static Future<void> localStorageStoreString(String pKey, String? pValue) async {
   try {
     if (pValue != null) {
       await sharedPreferences!.setString(pKey, pValue);
     } else {
       await sharedPreferences!.remove(pKey);
     }
   } catch (e) {}
 }}