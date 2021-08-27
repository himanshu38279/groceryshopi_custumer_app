import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/address_dialog.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/my_alert_dialog.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/models/address.dart';
import 'package:tbo_the_best_one/models/user.dart';

// ignore: must_be_immutable
class AddressCard extends StatelessWidget {
  final Address address;

  AddressCard(this.address);

  AddressController addressController;
  LoadingController loadingController;
  User user;

  @override
  Widget build(BuildContext context) {
    loadingController = Provider.of<LoadingController>(context);
    user = Provider.of<User>(context);
    addressController = Provider.of<AddressController>(context);
    return CustomContainer(
      padding: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              address.addressType.toUpperCase() == "HOME"
                  ? Icon(Icons.home)
                  : address.addressType.toUpperCase() == "WORK"
                      ? Icon(Icons.payment)
                      : Icon(Icons.location_on),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  address.addressType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _popMenuWidget(context),
            ],
          ),
          SizedBox(height: 5),
          Text(
            "${address.addressLine1} • ${address.addressLine2} ${address.locality != null && address.locality.trim() != '' ? "• ${address.locality}" : ""}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            address.mapAddress,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _popMenuWidget(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_horiz),
      offset: Offset(-40, -40),
      onSelected: (value) {
        if (value == 1) {
          // EDIT
          showAddressDialog(
            context,
            address: address,
          );
        } else {
          // DELETE
          showMyAlertDialog(
            context,
            title: "Delete Address",
            content: "Are you sure you want to delete this address ?",
            continueButtonOnPressed: () async {
              loadingController.startLoading();
              final res = await Repository.deleteAddress(
                addressId: address.addressId,
              );
              if (res ?? false) {
                addressController.deleteAddress(address.addressId);
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Address deleted successfully");
              } else
                Fluttertoast.showToast(
                  msg: "Error occurred while deleting address",
                );
              loadingController.stopLoading();
            },
          );
        }
      },
      itemBuilder: (context) =>
      [
        PopupMenuItem(value: 1, child: Text("Edit")),
        PopupMenuItem(value: 2, child: Text("Delete")),
      ],
    );
  }
}
