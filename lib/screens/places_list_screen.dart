import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/add_place_screen.dart';
import 'package:great_places_app/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (BuildContext context, AsyncSnapshot snapshot) =>
            (snapshot.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<GreatPlaces>(
                    child: Center(
                      child: Text("No places yet!"),
                    ),
                    builder: (ctx, places, chi) {
                      if (places.places.length > 0) {
                        return ListView.builder(
                            itemCount: places.places.length,
                            itemBuilder: (ctx, i) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        FileImage(places.places[i].image),
                                  ),
                                  title: Text(places.places[i].title),
                                  subtitle:
                                      Text(places.places[i].location!.address!),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        PlaceDetailsScreen.routeName,
                                        arguments: places.places[i].id);
                                  },
                                ));
                      } else {
                        return chi!;
                      }
                    },
                  ),
      ),
      // Center(
      //   child: CircularProgressIndicator(),
      // ),
    );
  }
}
