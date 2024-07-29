import 'LocationLinkModel.dart';

class CharacterAppModel {
  // (name, species, status, gender, origin, location)

  final int id;
  final String name;
  final String species;
  final String status;
  final String gender;
  final String image;

  final Map origin;
  final Map location;



  CharacterAppModel({required this.id, required this.name, required this.species, required this.status, required this.gender, required this.image, required this.origin, required this.location});
}