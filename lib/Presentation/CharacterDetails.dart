

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Data/Domain/Models/CharacterAppModel.dart';

class CharacterDetails extends StatelessWidget {
  late CharacterAppModel characterDetails;
  CharacterDetails({super.key,required this.characterDetails});




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(

        title:Text( characterDetails.name),
        leading:  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        },),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsetsDirectional.all(24),
          child: Text(
              textAlign: TextAlign.center,
              'This is ${characterDetails.name}, Gender type: ${characterDetails.gender}. Originally from ${characterDetails.origin['name']}\n  '),

        ),
      ),

    );
  }
}
