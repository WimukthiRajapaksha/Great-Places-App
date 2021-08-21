import 'dart:convert';

import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = "AIzaSyDvGUr2VWOxHSCWI9ynGuuh9UtYikYJlOI";

class LocationHelper {
  static String generateLocationPreviewImage(
      double latitude, double longitude) {
    // return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
    return "https://maps.googleapis.com/maps/api/staticmap?center=Williamsburg,Brooklyn,NY&zoom=13&scale=1&size=400x400&markers=sdgaags&key=$GOOGLE_API_KEY";
  }

  static Future<String> getLocationAddress(double lat, double long) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY";
    final response = await http.get(Uri.parse(url));
    return json.decode(response.body)["results"][0]["formatted_address"];
  }
}
