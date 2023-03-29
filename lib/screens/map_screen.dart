import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // for using coordinates
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/add_bird_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spot_the_bird/screens/bird_info_screen.dart';
import 'dart:io';

import '../models/bird_post_model.dart';

class MapScreen extends StatelessWidget {
  final MapController _mapController = MapController();

  Future<void> _pickImageAndCreatePost(
      {required LatLng latLng, required BuildContext context}) async {
    File? image;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40); // if you choose .camera it wouldn't work on emulator

    if (pickedFile != null) {
      image = File(pickedFile.path);

      //navigate to new screen
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddBirdScreen(latLng: latLng, image: image!)));
    } else {
      print("User didn't pick image");
    }
  }

  List<Marker> _buildMarkers(BuildContext context, List<BirdModel> birdPosts) {
    List<Marker> markers = [];

    birdPosts.forEach((post) {
      markers.add(
        Marker(
          height: 55,
          width: 55,
          point: LatLng(post.latitude, post.longitude),
          builder: (ctx) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BirdPostInfoScreen(birdModel: post)));
            },
            child: Container(
              child: Image.asset('assets/bird_icon.png'),
            ),
          ),
        ),
      );
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if (currentState is LocationLoaded) {
            _mapController.onReady.then((_) => _mapController.move(
                LatLng(currentState.latitude, currentState.longitude), 14));
          }

          if (currentState is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red.withOpacity(0.6),
              content: Text("Error! Unable to fetch location.."),
            )); // SnackBar
          }
        },
        child: BlocBuilder<BirdPostCubit, BirdPostState>(
          buildWhen: (prevState, currentState) =>
              (prevState.status != currentState.status),
          builder: (context, birdPostState) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onLongPress: (tapPosition, latLng) {
                  _pickImageAndCreatePost(latLng: latLng, context: context);
                },
                center: LatLng(0, 0),
                zoom: 5.3,
                maxZoom: 17,
                minZoom: 3.5,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayerOptions(
                  markers: _buildMarkers(context, birdPostState.birdPosts),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
