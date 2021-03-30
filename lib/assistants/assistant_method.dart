import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/assistants/request_assistance.dart';
import 'package:rider_app/configMap.dart';
import 'package:rider_app/data_handler/app_data.dart';
import 'package:rider_app/models/address.dart';
import 'package:rider_app/models/allUser.dart';
import 'package:rider_app/models/direction_detail.dart';

class AssistantMethod {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickUpAddress = Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetail> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey';

    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }

    DirectionDetail directionDetail = DirectionDetail();

    directionDetail.encodedPoints =
        res['routes'][0]['overview_polyline']['points'];
    directionDetail.distanceText =
        res['routes'][0]['legs'][0]['distance']['text'];
    directionDetail.distanceValue =
        res['routes'][0]['legs'][0]['distance']['value'];

    directionDetail.durationText =
        res['routes'][0]['legs'][0]['duration']['text'];
    directionDetail.durationValue =
        res['routes'][0]['legs'][0]['duration']['value'];

    return directionDetail;
  }

  static int calculateFares(DirectionDetail directionDetail) {
    //in term of USD
    double timeTraveledFare = (directionDetail.durationValue / 60) * 0.20;
    double distanceTraveledFare = (directionDetail.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //1$ - 160 RS
    double totalLocalAmount = totalFareAmount * 160;

    return totalFareAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser;

    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        userCurrentInfo = AllUser.fromSnapshot(dataSnapshot);
      }
    });
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }
}
