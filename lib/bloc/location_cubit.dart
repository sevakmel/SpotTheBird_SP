import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> getLocation() async {
    //using static method allows us to not initialize class Geolocator and to not create an object
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever) {
      emit(LocationLoading());

      try {
        //also static method --- without initializing class and object
        Position position = await Geolocator.getCurrentPosition( //static meth
          desiredAccuracy: LocationAccuracy.high,
        );

        emit(LocationLoaded(
            latitude: position.latitude, longitude: position.longitude));
      } catch (error) {
        print(error.toString());
        emit(LocationError());
      }
    }
  }
}
