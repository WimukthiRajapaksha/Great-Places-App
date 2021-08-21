import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places_app/helper/db_helper.dart';
import 'package:great_places_app/helper/location_helper.dart';
import 'package:great_places_app/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _list = [];

  List<Place> get places {
    return [...this._list];
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation placeLocation) async {
    final address = await LocationHelper.getLocationAddress(
        placeLocation.latitude, placeLocation.longitude);
    final newLocation = PlaceLocation(
        latitude: placeLocation.latitude,
        longitude: placeLocation.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: newLocation,
        image: image);
    this._list.add(newPlace);
    notifyListeners();
    DBHelper.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "image": newPlace.image.path,
      "loc_lat": newPlace.location!.latitude,
      "loc_long": newPlace.location!.longitude,
      "address": newPlace.location!.address!
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData("user_places");
    // dataList
    //     .map((item) => Place(
    //         id: item["id"],
    //         title: item["title"],
    //         location: null,
    //         image: File(item["image"]),
    //         location:
    //         ),)
    //     .toList();
    // notifyListeners();
    dataList.map((item) => Place(
        id: item["id"],
        title: item["title"],
        location: PlaceLocation(
            latitude: item["loc_lat"],
            longitude: item["loc_lng"],
            address: item["address"]),
        image: item["image"]));
  }

  Place findById(String id) {
    return _list.firstWhere((element) => element.id == id);
  }
}
