import 'dart:io';

class BirdModel {

   String? name;
  final double latitude;
  final double longitude;
   String? birdDescription;
  final File image;

  BirdModel({
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.birdDescription,
    required this.name,
  });
}