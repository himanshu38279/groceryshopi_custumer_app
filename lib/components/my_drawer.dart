import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';
import 'package:tbo_the_best_one/controllers/wallet_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/services/firebase_phone_auth_service.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/views/about_us_screen.dart';
import 'package:tbo_the_best_one/views/buy_again_products.dart';
import 'package:tbo_the_best_one/views/customer_support_screen.dart';
import 'package:tbo_the_best_one/views/login_screen.dart';
import 'package:tbo_the_best_one/views/my_addresses.dart';
import 'package:tbo_the_best_one/views/my_cart_screen.dart';
import 'package:tbo_the_best_one/views/my_orders_screen.dart';
import 'package:tbo_the_best_one/views/my_profile_screen.dart';
import 'package:tbo_the_best_one/views/offer_zone_screen.dart';
import 'package:tbo_the_best_one/views/order_success_screen.dart';
import 'package:tbo_the_best_one/views/order_through_list_upload.dart';
import 'package:tbo_the_best_one/views/order_through_voice_note.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    final user = Provider.of<User>(context);
    final addressController = Provider.of<AddressController>(context);
    final walletController = Provider.of<WalletController>(context);
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.7,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return true;
        },
        child: ListView(
          children: [
            // _buildAllInOneClubContainer(context),
            _buildTextContainer(
              context,
              showCompleteProfileText:
                  (user.firstName == null || user.firstName.trim() == ""),
              text:
                  "Welcome ${user.firstName == null || user.firstName.trim() == "" ? "Guest" : user.firstName}",
              onTap: () {
                if (user.isLoggedIn)
                  Navigator.popAndPushNamed(context, MyProfileScreen.id);
                else {
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                  Fluttertoast.showToast(msg: "Please login");
                }
              },
              iconData: Icons.edit,
            ),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.location_on,
            //   title: Provider.of<LocationService>(context).currentLocation,
            //   pageId: SelectCurrentLocation.id,
            //   trailing: Icon(Icons.edit, size: 20),
            // ),
            !user.isLoggedIn
                ? _buildButton(
                    context,
                    leadingIcon: Icons.person,
                    title: user.isLoggedIn ? user.phone : "Login",
                    overrideOnTap: true,
                    onTap: () {
                      if (user.isLoggedIn)
                        Navigator.popAndPushNamed(context, MyProfileScreen.id);
                      else
                        Navigator.popAndPushNamed(context, LoginScreen.id);
                    },
                  )
                : Container(),
            if (user.isLoggedIn)
              _buildButton(
                context,
                leadingIcon: Icons.map,
                title: "My Addresses",
                overrideOnTap: true,
                onTap: () {
                  if (!addressController.addressesLoading)
                    Navigator.popAndPushNamed(context, MyAddressesScreen.id);
                },
                trailing: addressController.addressesLoading
                    ? CustomLoader()
                    : SizedBox.shrink(),
              ),
            _buildButton(
              context,
              leadingIcon: Icons.event_note,
              title: "My Orders",
              overrideOnTap: true,
              onTap: () {
                if (user.isLoggedIn)
                  Navigator.popAndPushNamed(context, MyOrdersScreen.id);
                else {
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                  Fluttertoast.showToast(msg: "Please login");
                }
              },
            ),
            _buildButton(
              context,
              leadingIcon: Icons.shopping_cart,
              title: "My Cart",
              overrideOnTap: true,
              onTap: () {
                if (!cart.cartIsLoading)
                  Navigator.popAndPushNamed(context, MyCart.id);
              },
              trailing: cart.cartIsLoading
                  ? CustomLoader()
                  : cart.isEmpty
                      ? SizedBox.shrink()
                      : CircleAvatar(
                          radius: 10,
                          backgroundColor: Theme.of(context).accentColor,
                          child: Text(
                            cart.itemCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
            ),
            _buildButton(
              context,
              leadingIcon: Icons.radio_button_checked,
              title: "Buy Again",
              overrideOnTap: true,
              onTap: () {
                if (user.isLoggedIn)
                  Navigator.popAndPushNamed(context, BuyAgainProductsScreen.id);
                else {
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                  Fluttertoast.showToast(msg: "Please login");
                }
              },
            ),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.branding_watermark_outlined,
            //   title: "Shop By Brands",
            //   pageId: ShopByBrandsScreen.id,
            // ),
            // if (user.isLoggedIn)
            //   _buildButton(
            //     context,
            //     leadingIcon: Icons.monetization_on,
            //     title: "My Wallet",
            //     overrideOnTap: true,
            //     onTap: () {
            //       if (!walletController.loading)
            //         Navigator.popAndPushNamed(context, MyWallet.id);
            //     },
            //     trailing: walletController.loading
            //         ? CustomLoader()
            //         : Text(walletController.totalAmountAsString),
            //   ),
            _buildButton(
              context,
              leadingIcon: Icons.local_offer,
              title: "Offer Zone",
              pageId: OfferZoneScreen.id,
            ),
            _buildButton(
              context,
              leadingIcon: Icons.store,
              title: "Refer Your Friends",
              // trailing: Text("0"),
              overrideOnTap: true,
              onTap: () async {
                Navigator.pop(context);
                await Share.share(
                    'Check out The Best One Store : $kPlayStoreLink');
              },
              // pageId: ReferYourFriendsScreen.id,
            ),
            user.isLoggedIn
                ? ExpansionTile(
                    leading: Icon(Icons.star, color: Colors.black),
                    title: Text("Quick Order"),
                    initiallyExpanded: true,
                    children: [
                      _buildButton(
                        context,
                        leadingIcon: Icons.mic,
                        title: "Order Through Voice Notes",
                        pageId: OrderThroughVoiceNote.id,
                      ),
                      _buildButton(
                        context,
                        leadingIcon: Icons.format_list_numbered_rtl_sharp,
                        title: "Order Through List Upload",
                        pageId: OrderThroughListUpload.id,
                      ),
                    ],
                  )
                : Container(),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.important_devices,
            //   title: "WinWin Points",
            //   trailing: Text("0"),
            //   pageId: OfferZoneScreen.id,
            // ),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.shopping_basket,
            //   title: "TBO Sale",
            //   pageId: OfferZoneScreen.id,
            // ),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.inbox,
            //   title: "My Rewards",
            //   pageId: MyRewardsScreen.id,
            // ),
            _buildTextContainer(context, text: "Others"),
            _buildButton(
              context,
              leadingIcon: Icons.blur_circular,
              title: "Customer Support",
              pageId: CustomerSupportScreen.id,
            ),
            _buildButton(
              context,
              leadingIcon: Icons.star_border,
              title: "Rate Us",
              onTap: () async {
                Navigator.pop(context);
                if (Platform.isAndroid) {
                  if (await canLaunch(kPlayStoreLink))
                    await launch(kPlayStoreLink);
                } else {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable())
                    inAppReview.requestReview();
                  else
                    inAppReview.openStoreListing();
                }
              },
              overrideOnTap: true,
            ),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.share,
            //   title: "Share",
            //   overrideOnTap: true,
            //   onTap: () async {
            //     if (await canLaunch(kPlayStoreLink))
            //       await launch(kPlayStoreLink);
            //   },
            // ),
            _buildButton(
              context,
              leadingIcon: Icons.account_box,
              title: "About Us",
              pageId: AboutUsScreen.id,
            ),
            if (user.isLoggedIn)
              _buildButton(
                context,
                leadingIcon: Icons.power_settings_new,
                title: "Logout",
                overrideOnTap: true,
                onTap: () async {
                  cart.clear();
                  addressController.clear();
                  walletController.clear();
                  Provider.of<OrdersController>(context, listen: false).clear();
                  Provider.of<ProductsController>(context, listen: false)
                      .clear();
                  await user.logout();
                  await Provider.of<FirebasePhoneAuthService>(
                    context,
                    listen: false,
                  ).signOut();
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: "Logged out successfully");
                },
              ),
            // Divider(color: Colors.grey, height: 1),
            // _buildButton(
            //   context,
            //   leadingIcon: Icons.settings,
            //   title: "About This Release",
            //   pageId: AboutThisReleaseScreen.id,
            // ),
          ],
        ),
      ),
    );
  }

  InkWell _buildTextContainer(
    BuildContext context, {
    @required String text,
    bool showCompleteProfileText = false,
    VoidCallback onTap,
    IconData iconData,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.symmetric(
            vertical: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (showCompleteProfileText)
                    Text(
                      "Complete your profile",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                ],
              ),
            ),
            if (iconData != null) Icon(iconData, size: 20),
          ],
        ),
      ),
    );
  }

  // InkWell _buildAllInOneClubContainer(BuildContext context) {
  //   return InkWell(
  //     onTap: () => Navigator.popAndPushNamed(context, OfferZoneScreen.id),
  //     child: Container(
  //       height: 60,
  //       decoration: BoxDecoration(color: Color(0xFFFFE198)),
  //       child: Row(
  //         children: [
  //           SizedBox(width: 10),
  //           Image.asset(
  //             'assets/images/rupee.png',
  //             width: 30,
  //             height: 30,
  //           ),
  //           SizedBox(width: 15),
  //           Expanded(
  //             child: RichText(
  //               text: TextSpan(
  //                 style: TextStyle(fontFamily: 'ProductSans'),
  //                 children: [
  //                   TextSpan(
  //                     text: "The Best One Club\n",
  //                     style: TextStyle(color: Colors.blueAccent),
  //                   ),
  //                   TextSpan(
  //                     text: "Exclusive wholesale prices",
  //                     style: TextStyle(color: Colors.black),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Container(
  //             color: Color(0xFFFFD25B),
  //             height: double.infinity,
  //             padding: EdgeInsets.all(5),
  //             child: Icon(Icons.arrow_forward_ios, size: 15),
  //             alignment: Alignment.center,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  FlatButton _buildButton(
    BuildContext context, {
    @required IconData leadingIcon,
    @required String title,
    String pageId,
    Widget trailing,
    VoidCallback onTap,
    bool overrideOnTap = false,
  }) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      onPressed: () {
        if (overrideOnTap)
          onTap();
        else
          Navigator.popAndPushNamed(context, pageId);
      },
      child: Row(
        children: [
          Icon(leadingIcon, size: 20),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              title ?? "",
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          if (trailing != null) trailing
        ],
      ),
    );
  }
}
