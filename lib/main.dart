import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:tbo_the_best_one/controllers/address_controller.dart';
import 'package:tbo_the_best_one/controllers/app_settings_controller.dart';
import 'package:tbo_the_best_one/controllers/banners_controller.dart';
import 'package:tbo_the_best_one/controllers/brands_controller.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/controllers/loading_controller.dart';
import 'package:tbo_the_best_one/controllers/offers_controller.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';
import 'package:tbo_the_best_one/controllers/search_controller.dart';
import 'package:tbo_the_best_one/controllers/testimonials_controller.dart';
import 'package:tbo_the_best_one/controllers/wallet_controller.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/services/firebase_phone_auth_service.dart';
import 'package:tbo_the_best_one/services/location_service.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/utilities/route_generator.dart';
import 'package:tbo_the_best_one/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartController>(
          create: (_) => CartController(),
        ),
        ChangeNotifierProvider<User>(
          create: (_) => User(),
        ),
        ChangeNotifierProvider<LoadingController>(
          create: (_) => LoadingController(),
        ),
        ChangeNotifierProvider<CategoriesController>(
          create: (_) => CategoriesController(),
        ),
        ChangeNotifierProvider<SearchController>(
          create: (_) => SearchController(),
        ),
        ChangeNotifierProvider<OrdersController>(
          create: (_) => OrdersController(),
        ),
        ChangeNotifierProvider<OffersController>(
          create: (_) => OffersController(),
        ),
        ChangeNotifierProvider<TestimonialsController>(
          create: (_) => TestimonialsController(),
        ),
        ChangeNotifierProvider<BrandsController>(
          create: (_) => BrandsController(),
        ),
        ChangeNotifierProvider<BannersController>(
          create: (_) => BannersController(),
        ),
        ChangeNotifierProvider<AppSettingsController>(
          create: (_) => AppSettingsController(),
        ),
        ChangeNotifierProvider<WalletController>(
          create: (_) => WalletController(),
        ),
        ChangeNotifierProvider<ProductsController>(
          create: (_) => ProductsController(),
        ),
        ChangeNotifierProvider<AddressController>(
          create: (_) => AddressController(),
        ),
        ChangeNotifierProvider<FirebasePhoneAuthService>(
          create: (_) => FirebasePhoneAuthService(),
        ),
        ChangeNotifierProvider<LocationService>(
          create: (_) => LocationService(),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: ShowCaseWidget(
          builder: Builder(
            builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: kAppTheme,
                darkTheme: kAppTheme,
                onGenerateRoute: RouteGenerator.generateRoute,
                initialRoute: SplashScreen.id,
              );
            },
          ),
        ),
      ),
    );
  }
}
