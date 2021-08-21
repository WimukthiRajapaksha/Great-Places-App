import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation placeLocation;
  final bool isSelecting;

  MapScreen(
      {this.placeLocation =
          const PlaceLocation(latitude: 37.43, longitude: 70.542),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectPosition(LatLng position) {
    setState(() {
      this._pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Map"),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: this._pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(this._pickedLocation);
                      },
                icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.placeLocation.latitude, widget.placeLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? this._selectPosition : null,
        markers: (this._pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: MarkerId("m1"),
                  position: this._pickedLocation ??
                      LatLng(widget.placeLocation.latitude,
                          widget.placeLocation.longitude),
                ),
              },
      ),
    );
  }
}
