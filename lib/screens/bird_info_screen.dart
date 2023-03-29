import 'package:flutter/material.dart';
import 'package:spot_the_bird/models/bird_post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bird_post_cubit.dart';

class BirdPostInfoScreen extends StatelessWidget {
  final BirdModel birdModel;

  BirdPostInfoScreen({required this.birdModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(birdModel.name!),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context)
                  .size
                  .width, //width of any device screen
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: FileImage(birdModel.image),
                fit: BoxFit.cover,
              )),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(birdModel.name!,
                style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(birdModel.birdDescription!,
                style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
                onPressed: () {

                  context.read<BirdPostCubit>().removeBirdPost(birdModel);

                  Navigator.of(context).pop();

                },
                child: Text('DELETE')),
          ],
        ),
      ),
    );
  }
}
