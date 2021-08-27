import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase.dart';
import 'package:tbo_the_best_one/components/buy_membership_bottom_container.dart';
import 'package:tbo_the_best_one/components/cart_icon.dart';
import 'package:tbo_the_best_one/components/categories_list.dart';
import 'package:tbo_the_best_one/components/category_card.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_drawer.dart';
import 'package:tbo_the_best_one/components/my_search_field.dart';
import 'package:tbo_the_best_one/components/offer_card.dart';
import 'package:tbo_the_best_one/components/primary_banner_slider.dart';
import 'package:tbo_the_best_one/components/secondary_banner_slider.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/controllers/offers_controller.dart';
import 'package:tbo_the_best_one/controllers/testimonials_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/services/location_service.dart';
import 'package:tbo_the_best_one/services/one_time_showcase.dart';
import 'package:tbo_the_best_one/views/categories_list_screen.dart';
import 'package:tbo_the_best_one/views/login_screen.dart';
import 'package:tbo_the_best_one/views/order_through_list_upload.dart';
import 'package:tbo_the_best_one/views/order_through_voice_note.dart';
import 'package:tbo_the_best_one/views/select_current_location_screen.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  static const id = 'home_page';
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  OffersController _offersController;
  CategoriesController _categoriesController;

  @override
  Widget build(BuildContext context) {
    _offersController = Provider.of<OffersController>(context);
    _categoriesController = Provider.of<CategoriesController>(context);
    final _isLoggedIn = Provider.of<User>(context).isLoggedIn;
    final user = Provider.of<User>(context);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => OneTimeShowcase.handleShowcase(context),
    );

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        drawer: MyDrawer(),
        bottomNavigationBar: BuyMembershipBottomContainer(),
        body: ListView(
          cacheExtent: 1500,
          children: <Widget>[
            PrimaryBannerSlider(),
            SizedBox(height: 10),
            _buildOffersList(),
            _buildQuickOrderTiles(context, _isLoggedIn),
            _buildShopByCategoryContainer(),
            SecondaryBannerSlider(),
            // _buildStaticOffersContainer(),
            CategoriesList(),
            _buildTestimonials(context),
            // _buildLowestPricesContainer(context),
            // ProductListView(title: "Top Staples"),
            // ProductListView(title: "Top Savers Today!"),
            // _buildBigBrandsFestContainer(),
            // ProductListView(title: "Best of Home Essentials"),
            // _buildShopByCategoryListView(),
            // _buildHomeFurnishingGrid(),
            // _buildKitchenAndDining(),
            // _buildFashion(),
          ],
        ),
      ),
    );
  }

  // Widget _buildStaticOffersContainer() {
  //   if (_offersController.staticOffersLoading)
  //     return ContainerShimmer();
  //   else if (_offersController.staticOffers.isEmpty)
  //     return SizedBox.shrink();
  //   else
  //     return ListView.builder(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: () {
  //             Navigator.pushNamed(
  //               context,
  //               ProductsByStaticOfferScreen.id,
  //               arguments: _offersController.staticOffers[index],
  //             );
  //           },
  //           child: MyCachedNetworkImage(
  //             url: _offersController.staticOffers[index].offerImage,
  //             width: double.infinity,
  //           ),
  //         );
  //       },
  //       itemCount: _offersController.staticOffers.length,
  //     );
  // }

  Widget _buildQuickOrderTiles(BuildContext context, bool _isLoggedIn) {
    return Row(
      children: [
        Expanded(
          child: CustomContainer(
            backgroundColor: Colors.orange,
            shadowColor: Colors.orange,
            borderRadius: 10,
            onTap: () {
              if (_isLoggedIn) {
                Navigator.pushNamed(context, OrderThroughVoiceNote.id);
              } else {
                Navigator.pushNamed(context, LoginScreen.id);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Order Through Voice Notes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: Image.asset("assets/images/voice-note.png")),
              ],
            ),
          ),
        ),
        Expanded(
          child: CustomContainer(
            backgroundColor: Colors.green,
            shadowColor: Colors.green,
            borderRadius: 10,
            onTap: () {
              if (_isLoggedIn) {
                Navigator.pushNamed(context, OrderThroughListUpload.id);
              } else {
                Navigator.pushNamed(context, LoginScreen.id);
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Order Through List Upload",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: Image.asset("assets/images/list.png")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonials(BuildContext context) {
    final _controller = Provider.of<TestimonialsController>(context);
    if (_controller.testimonialsLoading)
      return CustomLoader();
    else if (_controller.testimonials.isEmpty)
      return SizedBox.shrink();
    else
      return Column(
        children: [
          SizedBox(height: 15),
          Text(
            "What Our Customers Say",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          CarouselSlider.builder(
            itemBuilder: (context, index) {
              return CustomContainer(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                width: double.infinity,
                height: 125,
                padding: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: Text(
                        "${_controller.testimonials[index].nameInitials}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _controller.testimonials[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          HtmlWidget(
                            _controller.testimonials[index].comment,
                            // maxLines: 4,
                            // overflow: TextOverflow.ellipsis,
                            // style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      _controller.testimonials[index].stars,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _controller.testimonials.length,
            options: CarouselOptions(
              viewportFraction: 0.9,
              initialPage: 0,
              height: 125,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 200),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      );
  }

  Widget _buildShopByCategoryContainer() {
    if (_categoriesController.categoriesLoading)
      return CustomLoader();
    else if (_categoriesController.categories.isEmpty)
      return SizedBox.shrink();
    else
      return Column(
        children: [
          SizedBox(height: 15),
          Text(
            "Shop By Category",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return CategoryCard(_categoriesController.categories[index]);
            },
            itemCount: _categoriesController.categories.length,
          ),
          SizedBox(height: 10),
        ],
      );
  }

  // Container _buildLowestPricesContainer(BuildContext context) {
  //   return Container(
  //     color: Theme.of(context).accentColor,
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   "Lowest Prices on Daily Essentials",
  //                   softWrap: true,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 25,
  //                   ),
  //                 ),
  //               ),
  //               MyButton(
  //                 text: "View all",
  //                 textColor: Theme.of(context).accentColor,
  //                 backgroundColor: Colors.white,
  //                 shadowColor: Theme.of(context).accentColor,
  //                 onTap: () {},
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 450,
  //           width: double.infinity,
  //           child: GridView.builder(
  //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               mainAxisSpacing: 10,
  //               crossAxisSpacing: 10,
  //             ),
  //             physics: BouncingScrollPhysics(),
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               return ProductCardSquare(MockProduct.tempProducts[index]);
  //             },
  //             padding: EdgeInsets.only(left: 10, right: 10),
  //             itemCount: MockProduct.tempProducts.length,
  //           ),
  //         ),
  //         SizedBox(height: 15),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOffersList() {
    if (_offersController.offersLoading)
      return ContainerShimmer(height: 250);
    else if (_offersController.offers.isEmpty)
      return SizedBox.shrink();
    else
      return Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                "Offers",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return OfferCard(_offersController.offers[index]);
                },
                itemCount: _offersController.offers.length,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    final locationController = Provider.of<LocationService>(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(120),
      child: Container(
        width: double.infinity,
        height: 120,
        color: Theme.of(context).appBarTheme.color,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Showcase(
                  key: OneTimeShowcase.menuIconDrawerKey,
                  description: "Tap on the menu icon to open the drawer",
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                      color: Theme.of(context).appBarTheme.iconTheme.color,
                    ),
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                ),
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'ProductSans'),
                      children: [
                        TextSpan(
                          text: "Delivery Location\n",
                          style: TextStyle(fontSize: 11),
                        ),
                        locationController.currentLocation == null
                            ? WidgetSpan(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    LinearProgressIndicator(),
                                  ],
                                ),
                              )
                            : TextSpan(
                                text: locationController.currentLocation,
                              ),
                      ],
                    ),
                  ),
                ),
                Showcase(
                  key: OneTimeShowcase.currentLocationEditKey,
                  description:
                      "Click on the edit icon to change current location",
                  child: IconButton(
                    icon: Icon(Icons.edit_outlined),
                    iconSize: 18,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, SelectCurrentLocation.id);
                    },
                  ),
                ),
                Showcase(
                  key: OneTimeShowcase.cartViewKey,
                  description:
                      "Click on the cart to see the products in your cart",
                  child: CartIcon(),
                ),
              ],
            ),
            Container(
              height: 60,
              color: Theme.of(context).appBarTheme.color,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CategoriesListScreen.id);
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FittedBox(child: Text("Categories")),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 3,
                    child: Showcase(
                      key: OneTimeShowcase.searchBarKey,
                      description: "Click here to search all the products",
                      contentPadding: EdgeInsets.all(5),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: MySearchField(readOnly: true),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   height: 50,
            //   alignment: Alignment.center,
            //   margin: EdgeInsets.all(5),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: MySearchField(readOnly: true),
            // ),
          ],
        ),
      ),
    );
  }
}
