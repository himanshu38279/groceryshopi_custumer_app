import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/address_card.dart';
import 'package:tbo_the_best_one/components/address_dialog.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';

class MyAddressesScreen extends StatelessWidget {
  static const id = 'my_addresses_screen';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final addressController = Provider.of<AddressController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: MyAddressesScreen.id,
          title: Text("My Addresses"),
        ),
        body: addressController.addressesLoading
            ? ShimmerList()
            : addressController.addresses.isEmpty
                ? NothingFoundHere()
                : RefreshIndicator(
                    onRefresh: () async {
                      if (user.isLoggedIn)
                        await addressController.update();
                      else
                        Fluttertoast.showToast(msg: "Please login");
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(5),
                      itemBuilder: (context, index) {
                        return AddressCard(
                          addressController.addresses[index],
                        );
                      },
                      itemCount: addressController.addresses.length,
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () => showAddressDialog(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
