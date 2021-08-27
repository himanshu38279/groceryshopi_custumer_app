import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/order_details_product_card.dart';
import 'package:tbo_the_best_one/models/order_detail.dart';
import 'package:tbo_the_best_one/services/rating_service.dart';
import 'package:tbo_the_best_one/views/home_page_screen.dart';
import 'package:tbo_the_best_one/views/my_orders_screen.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends StatelessWidget {
  static const id = 'order_success_screen';
  final OrderDetail details;

  OrderDetailsScreen({@required this.details});

  // String _comment;
  // double _rating = 4;

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    // final loadingController = Provider.of<LoadingController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Navigator.canPop(context)) RatingService.handleRating(context);
    });

    return WillPopScope(
      onWillPop: () {
        // if can pop, page is opened from order card
        if (Navigator.canPop(context))
          Navigator.pop(context);
        else
          // page is pushed after checkout
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.id,
            (route) => false,
          );
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("Order Details"),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomePage.id,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          body: ListView(
            children: [
              // if (details != null)
              //   Lottie.asset(
              //     "assets/lottie/success.json",
              //     height: 200,
              //   ),
              // Text(
              //   "ORDER ${details != null ? "SUCCESS" : "FAILURE"}",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: details != null ? Colors.green[600] : Colors.red,
              //     fontSize: 25,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // // show details only if order success
              // SizedBox(height: 20),
              if (details != null) ...[
                SizedBox(height: 10),
                Text("Placed on ${details.date}", textAlign: TextAlign.center),
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.white,
                  leading: Icon(
                    Icons.notes_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text("Order Status"),
                  subtitle: Text(details.saleStatus),
                ),
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.white,
                  leading: Icon(
                    Icons.money,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text("Payment Method"),
                  subtitle: Text(details.paymentMethod ?? ""),
                ),
                SizedBox(height: 10),
                if (details.orderProducts != null)
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                            "${details.orderProducts.length} ITEM(S)    •    AMOUNT : ${details.totalAsString}"),
                        Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return OrderDetailsProductCard(
                              details.orderProducts[index],
                            );
                          },
                          itemCount: details.orderProducts.length,
                        ),
                      ],
                    ),
                  ),
                // ExpansionTile(
                //     title: Text("Product Details"),
                //     expandedAlignment: Alignment.centerLeft,
                //     childrenPadding: EdgeInsets.symmetric(
                //       vertical: 10,
                //       horizontal: 15,
                //     ),
                //     expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       DataTable(
                //           columns: [
                //             DataColumn(label: Text("Name")),
                //             DataColumn(label: Text("Quantity")),
                //           ],
                //           rows: details.orderProducts
                //               .map(
                //                 (e) => DataRow(
                //                   cells: [
                //                     DataCell(Text(e.productName)),
                //                     DataCell(Text(e.quantity)),
                //                   ],
                //                 ),
                //               )
                //               .toList()),
                //     ]),
                // SizedBox(height: 20),
                // ListTile(
                //   leading: Icon(
                //     Icons.location_on_sharp,
                //     color: Theme.of(context).accentColor,
                //   ),
                //   title: Text("Delivery Location"),
                //   subtitle: Text(
                //     addressController.getMapAddress(details.addressId) ??
                //         "Address deleted",
                //   ),
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.money,
                //     color: Theme.of(context).accentColor,
                //   ),
                //   title: Text("Payment Status"),
                //   subtitle: Text(details.paymentStatus),
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.money,
                //     color: Theme.of(context).accentColor,
                //   ),
                //   title: Text("Total Amount"),
                //   subtitle: Text(details.totalAsString),
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.event_note,
                //     color: Theme.of(context).accentColor,
                //   ),
                //   title: Text("Notes"),
                //   subtitle: Text(
                //     (details.note == null || details.note.trim() == "")
                //         ? "No notes provided"
                //         : details.note,
                //   ),
                // ),
              ],
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(5),
            // child: Navigator.canPop(context)
            //     // order is complete and user profile is complete
            //     ? (details.saleStatus == "DELIVERED")
            //         ? _buildRatingButton(context, user, loadingController)
            //         : null
            //     :
            child: Navigator.canPop(context)
                ? SizedBox.shrink()
                : Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          text: "Shop More",
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomePage.id,
                            (route) => false,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MyButton(
                          text: "My Orders",
                          onTap: () =>
                              Navigator.pushNamed(context, MyOrdersScreen.id),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

// Widget _buildRatingButton(
//   BuildContext context,
//   User user,
//   LoadingController loadingController,
// ) {
//   return MyButton(
//     text: "Rate Us",
//     onTap: () {
//       if (user.firstName == null || user.firstName.trim() == "") {
//         Fluttertoast.showToast(msg: "Please complete your profile");
//         Navigator.pushNamed(context, MyProfileScreen.id);
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return StatefulBuilder(
//               builder: (context, setState) {
//                 return CustomLoadingScreen(
//                   child: Dialog(
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Rate Us",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: RatingBar.builder(
//                                   initialRating: _rating,
//                                   minRating: 1,
//                                   maxRating: 5,
//                                   direction: Axis.horizontal,
//                                   allowHalfRating: true,
//                                   itemCount: 5,
//                                   itemBuilder: (context, _) => Icon(
//                                     Icons.star,
//                                     color: Colors.amberAccent,
//                                   ),
//                                   onRatingUpdate: (rating) {
//                                     _rating = rating;
//                                     setState(() {});
//                                   },
//                                 ),
//                               ),
//                               Text(
//                                 _rating.toString(),
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 15),
//                           MyTextField(
//                             labelText: "Comment",
//                             onChanged: (v) => _comment = v,
//                           ),
//                           SizedBox(height: 15),
//                           MyButton(
//                             text: "Rate Us",
//                             width: double.infinity,
//                             onTap: () async {
//                               loadingController.startLoading();
//                               final res = await Repository.addRating(
//                                 orderId: details.id,
//                                 rating: _rating,
//                                 comment: _comment,
//                               );
//                               if (res)
//                                 Fluttertoast.showToast(
//                                     msg: "Rating added successfully");
//                               else
//                                 Fluttertoast.showToast(
//                                     msg: "You have already rated this order");
//                               loadingController.stopLoading();
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       }
//     },
//   );
// }
}
