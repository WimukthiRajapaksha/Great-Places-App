import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/models/place.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/widgets/image_input.dart';
import 'package:great_places_app/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add-place";

  AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  void _selectImage(File pickedImage) {
    this._pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double long) {
    this._pickedLocation = PlaceLocation(latitude: lat, longitude: long);
  }

  void _savePlace() {
    if (this._titleController.text.isEmpty ||
        this._pickedImage == null ||
        this._pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
        this._titleController.text, this._pickedImage!, this._pickedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Place"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      controller: this._titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(this._selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(
                      onSelectPlace: this._selectPlace,
                    )
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            onPressed: this._savePlace,
            icon: Icon(Icons.add),
            label: Text("Add Place"),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
