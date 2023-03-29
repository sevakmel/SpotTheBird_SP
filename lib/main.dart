import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spot_the_bird/bloc/bird_post_cubit.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';
import 'package:spot_the_bird/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationCubit>(
            create: (context) => LocationCubit()..getLocation()),
        BlocProvider<BirdPostCubit>(
            create: (context) => BirdPostCubit()..loadPosts),
      ],
      child: MaterialApp(
        theme: ThemeData(
          //App bar color
          primaryColor: Color(0xFF408E91),
          colorScheme: ColorScheme.light().copyWith(
            //text field color
            primary: Color(0xFFAEC2B6),
            //floating button color
            secondary: Color(0xFF0E8388),
          ),
        ),
        home: MapScreen(),
      ),
    );
  }
}
