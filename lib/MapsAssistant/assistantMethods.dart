import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_travel_planning_appli/MapsAssistant/ConfigMaps.dart';
import 'package:smart_travel_planning_appli/MapsAssistant/requestAssistant.dart';
import 'package:smart_travel_planning_appli/MapsDataHandler/appData.dart';
import 'package:smart_travel_planning_appli/models/mapAddress.dart';
import 'package:provider/provider.dart';
import 'package:smart_travel_planning_appli/models/mapDirectionDetails.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";
    String st1,st2,st3,st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBFvLlQ56zwid5GOWP7ZmEqsqq-id3ka4c";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      // placeAddress = response["results"][0]['formatted_address'];
      st1 = response["results"][0]['address_components'][0]['long_name'];
      st2 = response["results"][0]['address_components'][1]['long_name'];
      st3 = response["results"][0]['address_components'][5]['long_name'];
      st4 = response["results"][0]['address_components'][6]['long_name'];
      placeAddress = st1+ "," + st2 + "," + st3 + "," + st4;

      Address startingAddress = new Address();
      startingAddress.longitude = position.longitude;
      startingAddress.latitude = position.latitude;
      startingAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updateStartLocationAddress(startingAddress);

    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainDirectionDetails(LatLng initialPosition, LatLng finalPosition)async {
    String directionUrl = "https://maps.googleapis.com/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res= await RequestAssistant.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

  }
}
