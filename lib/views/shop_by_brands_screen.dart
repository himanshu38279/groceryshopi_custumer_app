// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tbo_the_best_one/components/custom_container.dart';
// import 'package:tbo_the_best_one/components/my_app_bar.dart';
// import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
// import 'package:tbo_the_best_one/components/nothing_found_here.dart';
// import 'package:tbo_the_best_one/components/shimmers.dart';
// import 'package:tbo_the_best_one/controllers/brands_controller.dart';
// import 'package:tbo_the_best_one/views/products_by_brand_screen.dart';
//
// class ShopByBrandsScreen extends StatelessWidget {
//   static const id = 'shop_by_brands_screen';
//
//   @override
//   Widget build(BuildContext context) {
//     final _controller = Provider.of<BrandsController>(context);
//     return SafeArea(
//       child: Scaffold(
//         appBar: MyAppBar(
//           title: Text("Shop By Brands"),
//           screenId: id,
//         ),
//         body: _controller.brandsLoading
//             ? ShimmerList()
//             : _controller.brands.isEmpty
//                 ? NothingFoundHere()
//                 : ListView.builder(
//                     padding: EdgeInsets.all(5),
//                     itemBuilder: (context, index) {
//                       return CustomContainer(
//                         padding: 5,
//                         onTap: () {
//                           Navigator.pushNamed(
//                             context,
//                             ProductsByBrandScreen.id,
//                             arguments: _controller.brands[index],
//                           );
//                         },
//                         child: ListTile(
//                           leading: MyCachedNetworkImage(
//                             url: _controller.brands[index].image,
//                             width: 100,
//                             height: double.infinity,
//                             borderRadius: 5,
//                           ),
//                           title: Text(_controller.brands[index].name),
//                           subtitle:
//                               Text(_controller.brands[index].description ?? ""),
//                         ),
//                       );
//                     },
//                     itemCount: _controller.brands.length,
//                   ),
//       ),
//     );
//   }
// }
