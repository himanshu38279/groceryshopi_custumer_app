import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/my_text_field.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/components/wallet_statement_card.dart';
import 'package:tbo_the_best_one/controllers/app_settings_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/controllers/wallet_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/models/wallet.dart';

class MyWallet extends StatefulWidget {
  static const id = 'my_wallet';

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  void openRazorpayCheckout({
    @required String key,
    @required double amount,
  }) async {
    Map<String, dynamic> options = {
      'key': key,
      'amount': amount * 100,
      'name': 'The Best One Store',
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

  double _amount;

  Future<void> _addMoney() async {
    loadingController.startLoading();
    final wallet = await Repository.addMoneyToWalletPlus(amount: _amount);
    if (wallet != null) {
      Fluttertoast.showToast(msg: "Amount added successfully in wallet");
      _controller.setWalletPlus(wallet);
    }
    loadingController.stopLoading();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _addMoney();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "An error occurred while making payment");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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

  User user;

  LoadingController loadingController;
  WalletController _controller;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    final appSettingsController = Provider.of<AppSettingsController>(context);
    loadingController = Provider.of<LoadingController>(context);
    _controller = Provider.of<WalletController>(context);
    final _walletPlusStatements = _controller.walletPlusStatements;
    final _walletStatements = _controller.walletStatements;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Wallet"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: ListTile(
              title: Text(
                "Total Balance",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              trailing: _controller.loading
                  ? CustomLoader()
                  : Text(
                      _controller.totalAmountAsString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                physics: const BouncingScrollPhysics(),
                indicatorColor: Theme.of(context).accentColor,
                tabs: [
                  Tab(
                    child: Text(
                      "Wallet (${_controller.walletAmountAsString})",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Wallet Plus (${_controller.walletPlusAmountAsString})",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildTransactionsListView(
                      text: "Wallet Transactions",
                      statements: _walletStatements,
                      loading: _controller.walletStatementsLoading,
                    ),
                    _buildTransactionsListView(
                      text: "Wallet Plus Transactions",
                      statements: _walletPlusStatements,
                      loading: _controller.walletPlusStatementsLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
          onPressed: () {
            // add money
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Add Money To Wallet Plus",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        MyTextField(
                          keyboardType: TextInputType.number,
                          labelText: "Amount",
                          onChanged: (amount) =>
                              _amount = double.tryParse(amount),
                        ),
                        SizedBox(height: 15),
                        MyButton(
                          text: "Pay Amount",
                          width: double.infinity,
                          onTap: () {
                            if (_amount == null)
                              Fluttertoast.showToast(msg: "Amount not valid");
                            else
                              Navigator.pop(context);

                            // open checkout
                            if (!appSettingsController.razorpayLoading)
                              openRazorpayCheckout(
                                key: appSettingsController.razorpayToken,
                                amount: _amount,
                              );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionsListView({
    @required String text,
    @required bool loading,
    @required List<WalletStatement> statements,
  }) {
    if (loading)
      return ShimmerList();
    else if (statements.isEmpty)
      return NothingFoundHere();
    else
      return ListView.builder(
        padding: EdgeInsets.all(10),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return WalletStatementCard(statements[index]);
        },
        itemCount: statements.length,
      );
    // return ListView(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Text(
    //         text,
    //         style: TextStyle(
    //           color: Colors.black,
    //           fontSize: 20,
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 10),
    //     loading
    //         ? ShimmerList()
    //         : statements.isEmpty
    //             ? NothingFoundHere()
    //             : ListView.builder(
    //                 padding: EdgeInsets.all(10),
    //                 physics: NeverScrollableScrollPhysics(),
    //                 shrinkWrap: true,
    //                 itemBuilder: (context, index) {
    //                   return WalletStatementCard(statements[index]);
    //                 },
    //                 itemCount: statements.length,
    //               ),
    //   ],
    // );
  }
}
