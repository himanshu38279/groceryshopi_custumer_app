import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/my_text_field.dart';
import 'package:tbo_the_best_one/components/text_container.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/models/address.dart';
import 'package:tbo_the_best_one/services/location_service.dart';
import 'package:tbo_the_best_one/utilities/api_keys.dart';

void showAddressDialog(BuildContext context, {Address address}) {
  showDialog(
    context: context,
    builder: (context) => _AddressDialog(address: address),
  );
}

class _AddressDialog extends StatefulWidget {
  final Address address;

  const _AddressDialog({this.address});

  @override
  _AddressDialogState createState() => _AddressDialogState();
}

class _AddressDialogState extends State<_AddressDialog> {
  final _formKey = GlobalKey<FormState>();

  final addressMap = <String, dynamic>{};
  TextEditingController _mapAddressController;

  List<String> defaultAddressTypes = ["HOME", "WORK"];
  String selectedAddressType;

  @override
  void initState() {
    _mapAddressController = TextEditingController(
      text: widget.address?.mapAddress,
    );
    addressMap['lat'] = widget.address?.lat;
    addressMap['lng'] = widget.address?.lng;
    addressMap['map_address'] = widget.address?.mapAddress;
    addressMap['address_line_1'] = widget.address?.addressLine1;
    addressMap['address_line_2'] = widget.address?.addressLine2;
    addressMap['address_type'] = widget.address?.addressType;

    if (widget.address == null) {
      selectedAddressType = defaultAddressTypes[0];
      addressMap['address_type'] = selectedAddressType;
    } else {
      if (defaultAddressTypes
          .contains(widget.address.addressType.toUpperCase())) {
        selectedAddressType = widget.address.addressType;
        addressMap['address_type'] = selectedAddressType;
      } else
        selectedAddressType = "OTHER";
    }

    addressMap['locality'] = widget.address?.locality;
    super.initState();
  }

  @override
  void dispose() {
    _mapAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingController = Provider.of<LoadingController>(context);
    final addressController = Provider.of<AddressController>(context);
    return CustomLoadingScreen(
      child: Dialog(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  for (String defaultAddress in defaultAddressTypes) ...[
                    Expanded(
                      child: TextContainer(
                        defaultAddress,
                        selected: selectedAddressType == defaultAddress,
                        onTap: () {
                          selectedAddressType = defaultAddress;
                          addressMap['address_type'] = selectedAddressType;
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                  Expanded(
                    child: TextContainer(
                      "OTHER",
                      selected: selectedAddressType == "OTHER",
                      onTap: () {
                        setState(() => selectedAddressType = "OTHER");
                        addressMap['address_type'] = null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              selectedAddressType == "OTHER"
                  ? MyTextField(
                      defaultValue: addressMap['address_type'],
                      labelText: "Address Type",
                      onChanged: (String v) => addressMap['address_type'] = v,
                      validator: (String v) {
                        if (v == null || v.trim() == "")
                          return "Please enter address type";
                      },
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              MyTextField(
                readOnly: true,
                onTap: () async {
                  final PickResult res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: ApiKeys.GOOGLE_MAPS_API_KEY,
                        initialPosition:
                            Provider.of<LocationService>(context).coordinates,
                        useCurrentLocation: true,
                        selectInitialPosition: true,
                        automaticallyImplyAppBarLeading: false,
                        onPlacePicked: (result) {
                          Navigator.pop(context, result);
                        },
                      ),
                    ),
                  );
                  addressMap['map_address'] = res.formattedAddress;
                  addressMap['lat'] = res.geometry.location.lat;
                  addressMap['lng'] = res.geometry.location.lng;
                  _mapAddressController.text = addressMap['map_address'];
                  setState(() {});
                },
                labelText: "Choose Map Address",
                overrideHintText: true,
                hintText: "Choose Map Address",
                onChanged: (String v) => addressMap['map_address'] = v,
                controller: _mapAddressController,
                validator: (String v) {
                  if (v == null || v.trim() == "")
                    return "Please choose map address";
                },
                trailing: Icon(Icons.my_location),
              ),
              SizedBox(height: 10),
              MyTextField(
                defaultValue: addressMap['address_line_1'],
                labelText: "House Number",
                onChanged: (String v) => addressMap['address_line_1'] = v,
                validator: (String v) {
                  if (v == null || v.trim() == "")
                    return "Please enter house number";
                },
              ),
              SizedBox(height: 10),
              MyTextField(
                defaultValue: addressMap['address_line_2'],
                labelText: "Area/Sector",
                onChanged: (String v) => addressMap['address_line_2'] = v,
                validator: (String v) {
                  if (v == null || v.trim() == "") return "Please enter area/sector";
                },
              ),
              SizedBox(height: 10),
              MyTextField(
                defaultValue: addressMap['locality'],
                labelText: "Landmark",
                onChanged: (String v) => addressMap['locality'] = v,
              ),
              SizedBox(height: 10),
              MyButton(
                text: "Save Address",
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    print(addressMap);
                    loadingController.startLoading();

                    Address newAddress;
                    if (widget.address == null) {
                      newAddress = await Repository.addAddress(
                        newAddress: addressMap,
                      );
                    } else {
                      newAddress = await Repository.updateAddress(
                        newAddress: addressMap,
                        addressId: widget.address.addressId,
                      );
                    }
                    loadingController.stopLoading();
                    if (newAddress != null) {
                      if (widget.address != null)
                        addressController.updateAddress(
                          addressId: widget.address.addressId,
                          address: newAddress,
                        );
                      else
                        addressController.addAddress(newAddress);
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg:
                            "Address ${widget.address == null ? "added" : "edited"} successfully",
                      );
                    } else
                      Fluttertoast.showToast(
                        msg:
                            "An error occurred while ${widget.address == null ? "added" : "edited"} address",
                      );
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
