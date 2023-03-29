import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/bird_post_model.dart';

part 'bird_post_state.dart';

class BirdPostCubit extends Cubit<BirdPostState> {
  BirdPostCubit()
      : super(
          BirdPostState(
            birdPosts: [],
            status: BirdPostStatus.initial,
          ),
        );

  Future<void> loadPosts() async {
    emit(state.copywith(status: BirdPostStatus.loading));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<BirdModel> birdPosts = [];

    final List<String>? birdPostsJsonStringList =
        prefs.getStringList("birdPosts");

    if (birdPostsJsonStringList != null) {
      for (var postJsonData in birdPostsJsonStringList) {
        final Map<String, dynamic> data =
            await json.decode(postJsonData) as Map<String, dynamic>;

        final File imageFile = File(data["fILePath"] as String);
        final String name = data["name"] as String;
        final String birdDescription = data["birdDescription"] as String;
        final double latitude = data["latitude"] as double;
        final double longitude = data["longitude"] as double;

        birdPosts.add(BirdModel(
            image: imageFile,
            longitude: longitude,
            latitude: latitude,
            birdDescription: birdDescription,
            name: name));
      }
    }
    emit(state.copywith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> addBirdPost(BirdModel birdModel) async {
    emit(state.copywith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.add(birdModel);

    _saveToSharedPrefs(birdPosts);

    emit(state.copywith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  void removeBirdPost(BirdModel birdModel) {
    emit(state.copywith(status: BirdPostStatus.loading));

    List<BirdModel> birdPosts = state.birdPosts;

    birdPosts.removeWhere((element) => element == birdModel);

    _saveToSharedPrefs(birdPosts);

    emit(state.copywith(birdPosts: birdPosts, status: BirdPostStatus.loaded));
  }

  Future<void> _saveToSharedPrefs(List<BirdModel> posts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonDataList = posts
        .map((post) => json.encode({
              "name": post.name,
              "birdDescription": post.birdDescription,
              "longitude": post.longitude,
              "latitude": post.latitude,
              "filePath": post.image.path,
            }))
        .toList();

    prefs.setStringList("birdPosts", jsonDataList);
  }
}
