import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

import 'package:spot_the_bird/models/bird_post_model.dart';

import '../bloc/bird_post_cubit.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;

  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  State<AddBirdScreen> createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {

  final _formKey = GlobalKey<FormState>();
  String? name;
  String? description;
  late final FocusNode _descriptionFocusNode;

  void _submit(BuildContext context) {

    if (!_formKey.currentState!.validate()) {
      // Invalid!!
      return ;
    }
    _formKey.currentState!.save();

    final BirdModel birdModel = BirdModel(
        image: widget.image,
        longitude: widget.latLng.longitude,
        latitude: widget.latLng.latitude,
        birdDescription: description,
        name: name);

    //Save to Cubit
    context.read<BirdPostCubit>().addBirdPost(birdModel);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bird'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, //width of any device screen
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(widget.image),
                        fit: BoxFit.cover,
                      )),
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  decoration: const InputDecoration(hintText: "Enter a bird name"),
                  onSaved: (value) {
                    name = value!.trim();
                  },

                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);

                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name...";
                    }
                    if (value.length < 2) {
                      return "Please enter a longer name...";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  decoration: const InputDecoration(hintText: "Enter a bird description"),

                  //Enter button on the phone
                  textInputAction: TextInputAction.done,

                  onSaved: (value) {
                    description = value!.trim();
                  },

                  onFieldSubmitted: (_) {
                    //Move focus

                    _submit(context);
                  },

                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a description...";
                    }
                    if (value.length < 2) {
                      return "Please enter a longer description...";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _submit(context);
        },
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
