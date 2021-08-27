import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/models/brand.dart';
import 'package:tbo_the_best_one/models/category.dart';
import 'package:tbo_the_best_one/models/offer.dart';
import 'package:tbo_the_best_one/models/order_detail.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/views/about_this_release_screen.dart';
import 'package:tbo_the_best_one/views/about_us_screen.dart';
import 'package:tbo_the_best_one/views/buy_again_products.dart';
import 'package:tbo_the_best_one/views/categories_list_screen.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';
import 'package:tbo_the_best_one/views/customer_support_screen.dart';
import 'package:tbo_the_best_one/views/home_page_screen.dart';
import 'package:tbo_the_best_one/views/login_screen.dart';
import 'package:tbo_the_best_one/views/my_addresses.dart';
import 'package:tbo_the_best_one/views/my_cart_screen.dart';
import 'package:tbo_the_best_one/views/my_orders_screen.dart';
import 'package:tbo_the_best_one/views/my_profile_screen.dart';
import 'package:tbo_the_best_one/views/my_rewards_screen.dart';
import 'package:tbo_the_best_one/views/my_wallet_screen.dart';
import 'package:tbo_the_best_one/views/offer_zone_screen.dart';
import 'package:tbo_the_best_one/views/order_details_screen.dart';
import 'package:tbo_the_best_one/views/order_success_screen.dart';
import 'package:tbo_the_best_one/views/order_through_list_upload.dart';
import 'package:tbo_the_best_one/views/order_through_voice_note.dart';
import 'package:tbo_the_best_one/views/otp_screen.dart';
import 'package:tbo_the_best_one/views/place_order_screen.dart';
import 'package:tbo_the_best_one/views/product_details_page.dart';
import 'package:tbo_the_best_one/views/products_by_brand_screen.dart';
import 'package:tbo_the_best_one/views/products_by_offer_screen.dart';
import 'package:tbo_the_best_one/views/products_by_static_offer_screen.dart';
import 'package:tbo_the_best_one/views/refer_your_friends_screen.dart';
import 'package:tbo_the_best_one/views/search_page.dart';
import 'package:tbo_the_best_one/views/select_current_location_screen.dart';
import 'package:tbo_the_best_one/views/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print("PUSHED ${settings.name} WITH ARGS: ${settings.arguments}");
    switch (settings.name) {
      case ProductsByBrandScreen.id:
        return MaterialPageRoute(
          builder: (context) => ProductsByBrandScreen(brand: args as Brand),
        );
      case CategoryScreen.id:
        return MaterialPageRoute(
          builder: (context) => CategoryScreen(
            category: (args as Map)['category'] as Category,
            initialIndex: (args as Map)['initialIndex'] ?? 0,
          ),
        );
      case MyProfileScreen.id:
        return MaterialPageRoute(builder: (context) => MyProfileScreen());
      case HomePage.id:
        return MaterialPageRoute(builder: (context) => HomePage());
      case CustomerSupportScreen.id:
        return MaterialPageRoute(builder: (context) => CustomerSupportScreen());
      case CategoriesListScreen.id:
        return MaterialPageRoute(builder: (context) => CategoriesListScreen());
      case MyAddressesScreen.id:
        return MaterialPageRoute(builder: (context) => MyAddressesScreen());
      case MyCart.id:
        return MaterialPageRoute(builder: (context) => MyCart());
      case OrderSuccessScreen.id:
        return MaterialPageRoute(builder: (_) => OrderSuccessScreen(details: args as OrderDetail,));
      // case ShopByBrandsScreen.id:
      //   return MaterialPageRoute(
      //     builder: (context) => ShopByBrandsScreen(),
      //   );
      case SearchPage.id:
        return MaterialPageRoute(builder: (context) => SearchPage());
      case BuyAgainProductsScreen.id:
        return MaterialPageRoute(
          builder: (context) => BuyAgainProductsScreen(),
        );
      case ProductsByStaticOfferScreen.id:
        return MaterialPageRoute(
          builder: (context) =>
              ProductsByStaticOfferScreen(offer: args as Offer),
        );
      case ProductsByOfferScreen.id:
        return MaterialPageRoute(
          builder: (context) => ProductsByOfferScreen(offer: args as Offer),
        );
      case PlaceOrderScreen.id:
        return MaterialPageRoute(builder: (context) => PlaceOrderScreen());
      case OrderThroughVoiceNote.id:
        return MaterialPageRoute(builder: (context) => OrderThroughVoiceNote());
      case OrderThroughListUpload.id:
        return MaterialPageRoute(
            builder: (context) => OrderThroughListUpload());
      case OrderDetailsScreen.id:
        return MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(
            details: args as OrderDetail,
          ),
        );
      case MyRewardsScreen.id:
        return MaterialPageRoute(builder: (context) => MyRewardsScreen());
      case OTPScreen.id:
        return MaterialPageRoute(
          builder: (context) => OTPScreen(
            phoneNumber: (args as Map)['phoneNumber'] as String,
            countryCode: (args as Map)['countryCode'] as String,
          ),
        );
      case MyOrdersScreen.id:
        return MaterialPageRoute(builder: (context) => MyOrdersScreen());
      case AboutUsScreen.id:
        return MaterialPageRoute(builder: (context) => AboutUsScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case AboutThisReleaseScreen.id:
        return MaterialPageRoute(
          builder: (context) => AboutThisReleaseScreen(),
        );
      case OfferZoneScreen.id:
        return MaterialPageRoute(builder: (context) => OfferZoneScreen());
      case MyWallet.id:
        return MaterialPageRoute(builder: (context) => MyWallet());
      case SelectCurrentLocation.id:
        return MaterialPageRoute(builder: (context) => SelectCurrentLocation());
      case SplashScreen.id:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case ReferYourFriendsScreen.id:
        return MaterialPageRoute(
          builder: (context) => ReferYourFriendsScreen(),
        );
      case ProductDetailsPage.id:
        return MaterialPageRoute(
          builder: (context) => ProductDetailsPage(args as Product),
        );
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String name) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ROUTE \n\n$name\n\nNOT FOUND'),
        ),
      );
    });
  }
}
