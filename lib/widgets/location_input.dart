import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/helper/location_helper.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  Function onSelectPlace;

  LocationInput({required this.onSelectPlace});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double long) {
    final staticMapUrl = LocationHelper.generateLocationPreviewImage(lat, long);
    setState(() {
      this._previewImageUrl = staticMapUrl;
    });
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      this._showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (ctx) => MapScreen(
                  isSelecting: true,
                )));
    if (selectedLocation == null) {
      return;
    }
    this._showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: this._previewImageUrl == null
              ? Text(
                  "No location choosen",
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  this._previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: this._getUserCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
                onPressed: this._selectOnMap,
                icon: Icon(Icons.map),
                label: Text("Select on Map"),
                textColor: Theme.of(context).primaryColor)
          ],
        )
      ],
    );
  }
}
