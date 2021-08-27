import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/my_text_field.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/views/login_screen.dart';

// ignore: must_be_immutable
class CardAddButton extends StatelessWidget {
  final double width;
  final double height;
  final String addText;
  final Product product;
  final int minValue;
  final double iconSize;
  final Color disabledColor;
  Color enabledColor;
  final Color iconColor;
  final Color countColor;
  final Color textColor;
  Color textBackgroundColor;
  final Color countBackgroundColor;
  Color borderColor;
  final bool showBorder;
  final IconData addIcon;
  final IconData removeIcon;

  CardAddButton({
    @required this.product,
    this.height,
    this.iconSize,
    this.width = 100,
    this.minValue = 0,
    this.addText = 'ADD',
    this.disabledColor = Colors.grey,
    this.enabledColor,
    this.countColor = Colors.black,
    this.iconColor = Colors.white,
    this.textBackgroundColor,
    this.countBackgroundColor = Colors.white,
    this.textColor = Colors.white,
    this.borderColor,
    this.showBorder = true,
    this.addIcon = Icons.add,
    this.removeIcon = Icons.remove,
  });

  void onMinValue() {}

  void onMaxValue() {
    Fluttertoast.showToast(
      msg: "You have already added maximum amount of this item in your cart",
    );
  }

  int count;
  int dialogEnteredCount;

  @override
  Widget build(BuildContext context) {
    enabledColor ??= Theme.of(context).accentColor;
    textBackgroundColor ??= Theme.of(context).accentColor;
    borderColor ??= Theme.of(context).accentColor;

    final user = Provider.of<User>(context);
    final cart = Provider.of<CartController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    count = cart.getItemCount(product.id);

    void onAdd() async {
      if (user.isLoggedIn) {
        cart.startLoading(product.id);
        final res = await Repository.addToCart(productId: this.product.id);
        cart.stopLoading(product.id);
        if (res ?? false) {
          cart.incrementProductCount(this.product);
        }
        // else {
        // Fluttertoast.showToast(
        //   msg: "An error occurred while adding product to cart",
        // );
        // }
      } else {
        Navigator.pushNamed(context, LoginScreen.id);
        Fluttertoast.showToast(
          msg: "Please login before adding products to cart",
          gravity: ToastGravity.CENTER,
        );
      }
    }

    void onRemove() async {
      cart.startLoading(product.id);
      final res = await Repository.removeFromCart(
        productId: this.product.id,
      );
      cart.stopLoading(product.id);
      if (res ?? false) {
        cart.decrementProductCount(this.product.id);
      } else {
        Fluttertoast.showToast(
          msg: "An error occurred while removing product from cart",
        );
      }
    }

    return SizedBox(
      height: height?.toDouble(),
      width: width?.toDouble(),
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              count == 0 ? this.textBackgroundColor : this.countBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: this.showBorder ? Border.all(color: this.borderColor) : null,
        ),
        child: this.product.maxQuantity == 0
            ? Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                child: FittedBox(
                  child: Text(
                    "SOLD OUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Row(
                children: [
                  count == 0
                      ? SizedBox.shrink()
                      : _buildButton(
                          onTap: () => count == minValue
                              ? this.onMinValue()
                              : onRemove(),
                        ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (count == 0) {
                          if (count == product.maxQuantity)
                            this.onMaxValue();
                          else
                            onAdd();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomLoadingScreen(
                                child: Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(height: 10),
                                        MyTextField(
                                          labelText: "Quantity",
                                          keyboardType: TextInputType.number,
                                          onChanged: (v) => dialogEnteredCount =
                                              int.tryParse(v),
                                        ),
                                        SizedBox(height: 10),
                                        MyButton(
                                          text:
                                              "Add to cart ${product.maxQuantity == 0 ? "" : " (Max. ${product.maxQuantity})"}",
                                          width: double.infinity,
                                          onTap: () async {
                                            if (dialogEnteredCount == null)
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please enter a valid amount");
                                            else if (dialogEnteredCount >
                                                product.maxQuantity)
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Quantity cannot be greater than maximum quantity");
                                            else {
                                              if (user.isLoggedIn) {
                                                loadingController
                                                    .startLoading();

                                                final res =
                                                    await Repository.addToCart(
                                                        productId:
                                                            this.product.id,
                                                        quantity:
                                                            dialogEnteredCount);
                                                loadingController.stopLoading();

                                                if (res ?? false) {
                                                  cart.incrementProductCount(
                                                      this.product,
                                                      value:
                                                          dialogEnteredCount);
                                                }
                                                // else {
                                                // Fluttertoast.showToast(
                                                //   msg: "An error occurred while adding product to cart",
                                                // );
                                                // }
                                                Navigator.pop(context);
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.pushNamed(
                                                    context, LoginScreen.id);
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Please login before adding products to cart",
                                                  gravity: ToastGravity.CENTER,
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        count == 0 ? addText : count.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: count == 0 ? this.textColor : this.countColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  _buildButton(
                    onTap: () => count == product.maxQuantity
                        ? this.onMaxValue()
                        : onAdd(),
                    isAddButton: true,
                  ),
                ],
              ),
      ),
    );
  }

  Container _buildButton({
    @required VoidCallback onTap,
    bool isAddButton = false,
  }) {
    return Container(
      color: isAddButton
          ? this.count == product.maxQuantity
              ? this.disabledColor
              : this.enabledColor
          : this.count == minValue
              ? this.disabledColor
              : this.enabledColor,
      alignment: Alignment.center,
      width: 30,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(
          isAddButton ? this.addIcon : this.removeIcon,
          color: this.iconColor,
          size: this.iconSize,
        ),
        onPressed: onTap,
      ),
    );
  }
}
