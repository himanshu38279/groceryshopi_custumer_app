import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/address_dialog.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';
import 'package:tbo_the_best_one/models/address.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/views/home_page_screen.dart';
import 'package:tbo_the_best_one/views/my_profile_screen.dart';

class AddressBottomSheet extends StatefulWidget {
  List<File> fileLatest;
  String type;
  AddressBottomSheet({this.fileLatest, this.type});
  @override
  _AddressBottomSheetState createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  List<Address> addresses;
  int selectedAddressIndex = 0;
  bool _isLoading = false;

  bool checkUserProfile() {
    final user = Provider.of<User>(context, listen: false);
    if (user.isLoggedIn) {
      if (user.firstName == null || user.lastName == null) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    addresses = Provider.of<AddressController>(context).addresses;
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          if (checkUserProfile()) {
            if (addresses != null && addresses.length > 0) {
              Provider.of<OrdersController>(context, listen: false)
                  .addQuickOrder(widget.type, widget.fileLatest,
                      addresses.elementAt(selectedAddressIndex).addressId)
                  .then((value) {
                setState(() {
                  _isLoading = true;
                });
                if (value) {
                  Fluttertoast.showToast(msg: "Order created successfully");
                  Navigator.popAndPushNamed(context, HomePage.id);
                } else {
                  Fluttertoast.showToast(msg: "Failed to create order");
                }
              });
            } else {
              Fluttertoast.showToast(msg: "Add new address");
            }
          } else {
            Fluttertoast.showToast(
                msg: "Please complete profile before placing order");
            Navigator.pushNamed(context, MyProfileScreen.id);
          }
        },
        child: Container(
          color: kAccentColor,
          child: Center(
            child: Text(
              "Create Order",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
          width: double.infinity,
          height: 50,
        ),
      ),
      body: Container(
          child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "  Select Address",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          _buildAddNewAddressContainer(context),
          for (int index = 0; index < addresses.length; index++)
            RadioListTile(
              title: Text(addresses[index].addressType),
              subtitle: Text(addresses[index].mapAddress),
              controlAffinity: ListTileControlAffinity.trailing,
              value: index,
              groupValue: selectedAddressIndex,
              activeColor: Theme.of(context).accentColor,
              onChanged: (value) {
                selectedAddressIndex = value;
                setState(() {});
              },
            ),
          SizedBox(height: 10),
          SizedBox(height: 10),
        ],
      )),
    );
  }

  Container _buildAddNewAddressContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListTile(
        onTap: () => showAddressDialog(context),
        title: Text("Add new address"),
        trailing: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
