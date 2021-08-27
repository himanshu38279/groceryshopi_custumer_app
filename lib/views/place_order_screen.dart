import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/address_dialog.dart';
import 'package:tbo_the_best_one/components/bottom_checkout_container.dart';
import 'package:tbo_the_best_one/components/cart_summary_container.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/my_text_field.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/app_settings_controller.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';
import 'package:tbo_the_best_one/controllers/wallet_controller.dart';
import 'package:tbo_the_best_one/models/address.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

import 'order_success_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  static const id = 'place_order_screen';

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  int selectedAddressIndex = 0;
  int selectedPaymentIndex = 0;
  String notes;
  bool _isOnlinePaymentSuccessful = false;
  bool _pickupSelected = false;

  void openRazorpayCheckout({
    @required String key,
    @required double amount,
  }) async {
    Map<String, dynamic> options = {
      'key': key,
      'amount': amount * 100,
      'name': 'MyBevy',
      'prefill': {'contact': user.phone, 'email': user.email ?? ""},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void checkout() async {
    loadingController.startLoading();
    final checkoutDetails = await Repository.checkout(
      paymentType: selectedPaymentIndex == 3
          ? "Wallet + Online"
          : paymentMethods[selectedPaymentIndex],
      paymentStatus: _isOnlinePaymentSuccessful ? "PAID" : "PENDING",
      addressId: addresses[selectedAddressIndex].addressId,
      pickupAtStore: _pickupSelected,
      note: notes,
    );

    if (checkoutDetails.status ?? false) {
      if (selectedPaymentIndex == 3) {
        final wallet = await Repository.removeMoneyFromWallet(
          amount: _walletAmount,
          orderId: checkoutDetails.orderDetails.id,
        );
        if (wallet != null) walletController.setWallet(wallet);
      } else if (selectedPaymentIndex == 2) {
        final wallet = await Repository.removeMoneyFromWalletPlus(
          amount: checkoutDetails.orderDetails.grandTotal,
          orderId: checkoutDetails.orderDetails.id,
        );
        if (wallet != null) walletController.setWalletPlus(wallet);
      }

      cart.clear();
      ordersController.addOrder(checkoutDetails.orderDetails);
    }

    loadingController.stopLoading();

    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   OrderDetailsScreen.id,
    //   (route) => false,
    //   arguments: checkoutDetails.orderDetails,
    // );
    Navigator.pushNamedAndRemoveUntil(
      context,
      OrderSuccessScreen.id,
      (route) => false,
      arguments: checkoutDetails.orderDetails,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _isOnlinePaymentSuccessful = true;
    setState(() {});
    checkout();
    Fluttertoast.showToast(msg: "Payment Successful");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _isOnlinePaymentSuccessful = false;
    setState(() {});
    Fluttertoast.showToast(msg: "An error occurred while making payment");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _isOnlinePaymentSuccessful = false;
    setState(() {});
    // Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
  }

  Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  final List<String> paymentMethods = [
    "Online",
    "Cash On Delivery",
    "Wallet Plus",
    "Wallet",
  ];

  User user;
  LoadingController loadingController;
  CartController cart;
  OrdersController ordersController;
  WalletController walletController;
  List<Address> addresses;

  double _walletAmount;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    loadingController = Provider.of<LoadingController>(context);
    cart = Provider.of<CartController>(context);
    ordersController = Provider.of<OrdersController>(context);
    addresses = Provider.of<AddressController>(context).addresses;
    walletController = Provider.of<WalletController>(context);
    final appSettingsController = Provider.of<AppSettingsController>(context);
    _walletAmount = cart.totalWithoutRemovedWalletAmount *
        (appSettingsController?.orderWalletPercent ?? 0) /
        100;

    return SafeArea(
      child: CustomLoadingScreen(
        child: Scaffold(
          appBar: MyAppBar(
            screenId: PlaceOrderScreen.id,
            title: Text("Place Order"),
          ),
          bottomNavigationBar: BottomCheckoutContainer(
            screenId: PlaceOrderScreen.id,
            onTap: () async {
              if (addresses.isEmpty)
                Fluttertoast.showToast(msg: "Please add an address");
              else {
                // if online payment, open razorpay window
                if (selectedPaymentIndex == 0 || selectedPaymentIndex == 3) {
                  if (!appSettingsController.razorpayLoading)
                    openRazorpayCheckout(
                      key: appSettingsController.razorpayToken,
                      amount: cart.total,
                    );
                } else {
                  // cash on delivery
                  checkout();
                }
              }
            },
          ),
          body: ListView(
            padding: EdgeInsets.all(5),
            children: [
              CartSummaryContainer(),
              CheckboxListTile(
                title: Text("Pick from store"),
                controlAffinity: ListTileControlAffinity.trailing,
                value: _pickupSelected,
                activeColor: Theme.of(context).accentColor,
                onChanged: (value) {
                  _pickupSelected = value;
                  setState(() {});
                },
              ),
              if (!_pickupSelected) ...[
                SizedBox(height: 5),
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
              ],
              Divider(color: Colors.black54),
              Text(
                "  Select Payment Method",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              if (appSettingsController.settingsLoading)
                CustomLoader()
              else
                for (int i = 0; i < paymentMethods.length; i++)
                  if (!(selectedPaymentIndex == 3 && (i == 1 || i == 2)))
                    RadioListTile(
                      title: Text(paymentMethods[i] +
                          ((i == 2)
                              ? " ( ${walletController.walletPlusAmountAsString} )"
                              : (i == 3)
                                  ? " (${walletController.walletAmountAsString})"
                                  : "")),
                      subtitle: (i == 3)
                          ? Text(
                              "-$kRupeeSymbol$_walletAmount (${appSettingsController.orderWalletPercent}%)")
                          : null,
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: i,
                      groupValue: selectedPaymentIndex,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (value) {
                        if (i == 2 &&
                            walletController.walletPlusDetails.wallet <
                                cart.total) {
                          Fluttertoast.showToast(
                              msg: "Insufficient Balance in Wallet Plus");
                          return;
                        }

                        if (i == 3 &&
                            walletController.walletDetails.wallet <
                                _walletAmount) {
                          Fluttertoast.showToast(
                              msg: "Insufficient Balance in Wallet");
                          return;
                        }
                        selectedPaymentIndex = value;
                        if (selectedPaymentIndex == 3)
                          cart.removeWalletAmountFromTotal(_walletAmount);
                        else
                          cart.removeWalletAmountFromTotal(0);
                        setState(() {});
                      },
                    ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyTextField(
                  labelText: "Notes",
                  onChanged: (String v) => notes = v,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      ),
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
