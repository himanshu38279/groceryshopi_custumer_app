import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/controllers/app_settings_controller.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class CartSummaryContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    final appSettingsController = Provider.of<AppSettingsController>(context);
    if (cart.isEmpty) return NothingFoundHere();
    return CustomContainer(
      padding: 10,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTextRow(
            text1: "M.R.P",
            text2: cart.productsTotalAsString,
          ),
          // _buildTextRow(
          //   text1: "Discount",
          //   text2: cart.discountAsString,
          //   color2: Colors.green,
          // ),
          _buildTextRow(
            text1: "Tip",
            text2: cart.tipAsString,
          ),
          _buildTextRow(
            text1: "Tax",
            text2: cart.taxAsString,
          ),
          // _buildTextRow(
          //   text1: "Club Member Savings",
          //   color1: Colors.blueAccent,
          //   text2: "Not a member",
          // ),
          _buildTextRow(
            text1: "Delivery Charges",
            text2: "FREE",
            color2: Colors.green,
          ),
          if (cart.removedWalletAmount != 0)
            _buildTextRow(
              text1: "Wallet (${appSettingsController.orderWalletPercent}%)",
              text2: "- $kRupeeSymbol${cart.removedWalletAmount}",
              color2: Colors.green,
            ),
          Divider(color: Colors.black),
          _buildTextRow(
            text1: "Total",
            text2: cart.totalAsString,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

Padding _buildTextRow({
  @required String text1,
  @required String text2,
  Color color1 = Colors.black,
  Color color2 = Colors.black,
  isBold = false,
  Widget leading,
  Widget trailing,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        if (leading != null) leading,
        Text(
          text1,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color1,
          ),
        ),
        if (trailing != null) trailing,
        Spacer(),
        Text(
          text2,
          style: TextStyle(
            color: color2,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
