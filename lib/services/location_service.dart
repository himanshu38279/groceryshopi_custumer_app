import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService extends ChangeNotifier {
  Position _currentPosition;
  String _currentLocation;

  String get currentLocation => _currentLocation;

  LatLng get coordinates {
    if (_currentPosition == null)
      return null;
    else
      return LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );
  }

  void setCurrentLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _getAddressFromLatLng();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );

      Placemark place = p.first;

      _currentLocation =
          "${place.street} ${place.locality}, ${place.subLocality}, ${place.postalCode}, ${place.country}";
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
