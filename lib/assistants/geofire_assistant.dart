import 'package:rider_app/models/nearby_available_driver.dart';

class GeofireAssistant {
  static List<NearbyAvailableDriver> nearbyAvailableDrivers = [];

  static void removeFromNearbyAvailableDrivers(String key) {
    int index =
        nearbyAvailableDrivers.indexWhere((element) => element.key == key);
    nearbyAvailableDrivers.removeAt(index);
  }

  static void updateNearbyAvailableDriverLocation(
      NearbyAvailableDriver driver) {
    int index = nearbyAvailableDrivers
        .indexWhere((element) => element.key == driver.key);

    nearbyAvailableDrivers[index].latitude = driver.latitude;
    nearbyAvailableDrivers[index].longitude = driver.longitude;
    
  }
}
