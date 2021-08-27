import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/models/ModelAddressList.dart';
import 'package:tbo_the_best_one/services/location_service.dart';
import 'package:tbo_the_best_one/utilities/api_keys.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  TextEditingController _searchController = new TextEditingController();
  Timer _throttle;
  List<AddressDetails> addressList;
  bool showLocal = true;

  AddressController addressController;

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {});
      return;
    }

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    // TODO Add session token

    String request =
        '$baseURL?input=$input&key=${ApiKeys.GOOGLE_MAPS_API_KEY}&location=28.4595,77.0266&radius=20000';
    print(request);
    var response = await Dio().get(request);
    print(response);

    final predictions = response.data['predictions'];

    List<AddressDetails> _displayResults = [];
    for (var i = 0; i < predictions.length; i++) {
      String id = predictions[i]['place_id'];
      String description = predictions[i]['description'];
      var address = AddressDetails();
      address.id = id;
      address.addressLine1 = description;
      _displayResults.add(address);
    }

    setState(() {
      addressList = _displayResults;
    });
  }

  @override
  void initState() {
    addressList = List();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();

    _throttle = Timer(const Duration(milliseconds: 500), () {
      getLocationResults(_searchController.text);
    });
  }

  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: ApiKeys.GOOGLE_MAPS_API_KEY);
  Future<LatLng> displayPrediction(String p) async {
    if (p != null) {
      var detail = await _places.getDetailsByPlaceId(p);
      print("Error: ${detail.errorMessage}");

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      return LatLng(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    addressController = Provider.of<AddressController>(context);
    final locationController = Provider.of<LocationService>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(74),
        child: Container(
          color: kAppBarColor,
          padding: EdgeInsets.fromLTRB(10, 24, 10, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //Navigator.pop(context);
                  }),
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  onChanged: (str) {
                    if (str.isEmpty)
                      showLocal = true;
                    else
                      showLocal = false;
                  },
                  decoration: new InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200])),
                      hintStyle: TextStyle(color: Colors.grey[100]),
                      hintText: "Search for nearby landmark, locality"),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  }),
            ],
          ),
        ),
      ),
      body: showLocal
          ? ListView.builder(
              itemCount: addressController.addresses.length + 2,
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return InkWell(
                    onTap: () {
                      Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high)
                          .then((value) {
                        placemarkFromCoordinates(
                                value.latitude, value.longitude)
                            .then((val) {
                          final first = val.first;
                          String address =
                              '${first.name}, ${first.locality}, ${first.administrativeArea},${first.subLocality}, ${first.subAdministrativeArea}';
                          locationController.setCurrentLocation(address);
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Icon(Icons.gps_fixed, color: kAppBarColor),
                          ),
                          Expanded(
                              child: Text("Use my location",
                                  style: TextStyle(fontSize: 16)))
                        ],
                      ),
                    ),
                  );
                } else if (index == 1) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Saved Addressed"),
                    ),
                  );
                } else {
                  // return ListTile(
                  //   title: Text(
                  //       "${addressController.addresses[index - 2].addressType}"),
                  //   subtitle: Text(
                  //       "${addressController.addresses[index - 2].mapAddress}"),
                  // );
                  return InkWell(
                    onTap: () {
                      locationController.setCurrentLocation(
                          addressController.addresses[index - 2].mapAddress);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.star_border_purple500_outlined),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${addressController.addresses[index - 2].addressType}"),
                                Text(
                                    "${addressController.addresses[index - 2].mapAddress}")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: 0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (ctx, index) {
                    return Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 0,
                    );
                  },
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: () async {
                          print(addressList.elementAt(index).id);
                          final res = await displayPrediction(
                              addressList.elementAt(index).id);
                          print(res.longitude);
                          print(res.latitude);
                          locationController.setCurrentLocation(
                              addressList.elementAt(index).addressLine1);
                          Navigator.pop(context);
                          // print(addressList.elementAt(index).latitude);
                          // print(addressList.elementAt(index).longitude);

                          // Navigator.pop(
                          //     context,
                          //     LatLng(
                          //         double.parse(
                          //             addressList.elementAt(index).latitude),
                          //         double.parse(
                          //             addressList.elementAt(index).longitude)));
                        },
                        child: ListTile(
                          title: Text(
                              "${addressList.elementAt(index).addressLine1}"),
                        ));
                  },
                  itemCount: addressList.length,
                ),
              ],
            ),
    );
  }
}
