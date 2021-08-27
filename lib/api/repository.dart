import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tbo_the_best_one/api/api_routes.dart';
import 'package:tbo_the_best_one/api/models/checkout_details.dart';
import 'package:tbo_the_best_one/api/models/get_address.dart';
import 'package:tbo_the_best_one/api/models/get_brands.dart';
import 'package:tbo_the_best_one/api/models/get_cart.dart';
import 'package:tbo_the_best_one/api/models/get_categories.dart';
import 'package:tbo_the_best_one/api/models/get_offers.dart';
import 'package:tbo_the_best_one/api/models/get_order_history.dart';
import 'package:tbo_the_best_one/api/models/get_primary_banners.dart';
import 'package:tbo_the_best_one/api/models/get_secondary_banners.dart';
import 'package:tbo_the_best_one/api/models/get_wallet.dart';
import 'package:tbo_the_best_one/api/models/post_products.dart';
import 'package:tbo_the_best_one/models/address.dart';
import 'package:tbo_the_best_one/models/brand.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/models/quick_order.dart';
import 'package:tbo_the_best_one/models/razorpay_credentials.dart';
import 'package:tbo_the_best_one/models/search_result.dart';
import 'package:tbo_the_best_one/models/testimonial.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/models/wallet.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class Repository {
  Repository._();

  static Dio get _dio {
    return Dio(
      BaseOptions(
        baseUrl: ApiRoutes.BASE_URL,
        headers: {
          // 'Authorization': 'Bearer $accessToken',
          // "X-Requested-With": "XMLHttpRequest",
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    )..interceptors.addAll(
        [
          PrettyDioLogger(requestBody: true),
        ],
      );
  }

  static Future<bool> quickOrderImages({
    @required String type,
    @required List<File> files,
  }) async {
    try {
      final _formData = FormData.fromMap({
        'Authorization': accessToken,
        'order_type': type,
        'attachment': await MultipartFile.fromFile(
          files[0].path,
          filename: files[0].path,
        ),
        'more': [
          for (File file in files)
            await MultipartFile.fromFile(file.path, filename: file.path),
        ],
      });

      final res = await _dio.post(
        ApiRoutes.POST_QuickOrder,
        data: _formData,
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return res.data['status'] as bool;
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<bool> quickOrder({
    @required String type,
    @required List<File> files,
    String addreess_id,
  }) async {
    try {
      final _formData = FormData.fromMap({
        'Authorization': accessToken,
        'order_type': "audio",
        'address_id': addreess_id,
        'attachment': await MultipartFile.fromFile(
          files[0].path,
          filename: files[0].path,
        )
      });

      final res = await _dio.post(
        ApiRoutes.POST_QuickOrder,
        data: _formData,
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return res.data['status'] as bool;
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetWallet> getWalletPlusDetails() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_PlusWalletDetails,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetWallet.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetWallet> getWalletDetails() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_WalletDetails,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetWallet.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<Wallet> addMoneyToWalletPlus({@required double amount}) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_PlusWalletAddAmount,
        data: {
          'Authorization': accessToken,
          'amount': amount,
          'via': 'razorpay',
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return Wallet.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<Wallet> removeMoneyFromWalletPlus({
    @required double amount,
    @required String orderId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_PlusWalletRemoveAmount,
        data: {
          'Authorization': accessToken,
          'amount': amount,
          'for': "order_$orderId",
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return Wallet.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<Wallet> removeMoneyFromWallet({
    @required double amount,
    @required String orderId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_WalletRemoveAmount,
        data: {
          'Authorization': accessToken,
          'amount': amount,
          'for': "order_$orderId",
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return Wallet.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<List<WalletStatement>> getWalletPlusStatements() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_PlusWalletStatement,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return (res.data['data'] as List)
            .map((e) => WalletStatement.fromJson(e))
            .toList()
            .cast<WalletStatement>();
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<List<WalletStatement>> getWalletStatements() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_WalletStatement,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return (res.data['data'] as List)
            .map((e) => WalletStatement.fromJson(e))
            .toList()
            .cast<WalletStatement>();
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<SearchResult> search(String searchQuery) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_Search,
        data: {'search_query': searchQuery},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return SearchResult.fromJson(res.data);
      }
    } catch (e) {
      print(e);
      return SearchResult.fromJson({});
    }
    return SearchResult.fromJson({});
  }

  static Future<User> updateProfile({
    @required Map<String, String> profileMap,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_UpdateProfile,
        data: {'Authorization': accessToken, ...profileMap},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.data['status'] as bool)
          return User.fromJson(res.data['data']);
        else
          return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<User> getUserProfile() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_UserProfile,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.data['status'] as bool)
          return User.fromJson(res.data['data']);
        else
          return User();
      }
    } catch (e) {
      print(e);
      return User();
    }
    return User();
  }

  static Future<List<Map<String, dynamic>>> getFAQs() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_FAQs);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getSettings() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_Settings);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetOffers> getStaticOffers() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_StaticOffers);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetOffers.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetOffers> getOffers() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_Offers);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetOffers.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetPrimaryBanners> getPrimaryBanners() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_PrimaryBanners);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetPrimaryBanners.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetSecondaryBanners> getSecondaryBanners() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_SecondaryBanners);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetSecondaryBanners.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<RazorpayCredential> getRazorpayCredentials() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_RazorpayCredentials);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return RazorpayCredential.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetOrderHistory> getOrderHistory() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_GetOrders,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetOrderHistory.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<QuickOrder> addQuicVoiceOrder(
      File attachment, List<File> moreFiles, String orderType) async {
    try {
      final more = [];
      for (int i = 0; i < moreFiles.length; i++) {
        more.add(MultipartFile.fromFileSync(moreFiles[i].path,
            filename: DateTime.now().toString() + "-$i"));
      }
      FormData formData = FormData.fromMap({
        'Authorization': accessToken,
        'order_type': '',
        'more': more,
        'attachment': await MultipartFile.fromFile(attachment.path,
            filename: DateTime.now().toString())
      });
      final res = await _dio.post(
        ApiRoutes.POST_QuickOrder,
        data: formData,
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return QuickOrder.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetCart> getCart() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_GetCart,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetCart.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<bool> deleteAddress({
    @required String addressId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_DeleteAddress,
        data: {
          'Authorization': accessToken,
          'address_id': addressId,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return res.data['status'] as bool;
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  static Future<Address> updateAddress({
    @required Map<String, dynamic> newAddress,
    @required String addressId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_UpdateAddress,
        data: {
          'Authorization': accessToken,
          'address_id': addressId,
          ...newAddress,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return Address.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<Address> addAddress(
      {@required Map<String, dynamic> newAddress}) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_AddAddress,
        data: {'Authorization': accessToken, ...newAddress},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return Address.fromJson(res.data['data']);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<GetAddress> getAddresses() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_GetAddress,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return GetAddress.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<CheckoutDetails> checkout({
    @required String paymentType,
    @required String paymentStatus,
    @required String addressId,
    @required bool pickupAtStore,
    String note,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_Checkout,
        data: {
          'Authorization': accessToken,
          'payment_type': paymentType,
          'payment_status': paymentStatus,
          'note': note,
          'address_id': addressId,
          'pick_up_at_store': pickupAtStore ? 1 : 0,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return CheckoutDetails.fromJson(res.data);
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<bool> addToCart({
    @required String productId,
    int quantity = 1,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_AddToCart,
        data: {
          'Authorization': accessToken,
          'product_id': productId,
          'qty': quantity,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.data['status'] == false && res.data['msg'] == '3')
          Fluttertoast.showToast(msg: "Product maximum quantity added");
      }
      return res.data['status'] as bool;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> addRating({
    @required String orderId,
    @required double rating,
    @required String comment,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_AddRating,
        data: {
          'Authorization': accessToken,
          'order_id': orderId,
          'stars': rating,
          'comment': comment,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return res.data['status'] as bool;
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  static Future<List<Testimonial>> getTestimonials() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_Testimonials);
      if (res.statusCode >= 200 && res.statusCode < 300)
        return (res.data as List)
            .map((e) => Testimonial.fromJson(e))
            .toList()
            .cast<Testimonial>();
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<bool> removeFromCart({
    @required String productId,
    int quantity = 1,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_RemoveFromCart,
        data: {
          'Authorization': accessToken,
          'product_id': productId,
          'qty': quantity,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300)
        return res.data['status'] as bool;
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  // static Future<Map<String, dynamic>> verifyUserToken(String token) async {
  //   try {
  //     final res = await _dio.post(
  //       ApiRoutes.POST_VerifyUserToken,
  //       data: {'Authorization': token},
  //     );
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       return res.data;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  //   return null;
  // }

  static Future<String> loginUser({@required String phoneNumber}) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_Login,
        data: {
          'phone': phoneNumber,
          'device_token': fcmToken,
        },
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return res.data['data']['token'];
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  static Future<String> getProductMainImage(
      {@required String productId}) async {
    try {
      final res = await _dio.get(ApiRoutes.GET_ProductMainImage + productId);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.data['data'] == null) return null;
        return ApiRoutes.getImageUrl(res.data['data']['image'] as String);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<String>> getProductImagesList(
      {@required String productId}) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_ProductImages,
        data: {'product_id': productId},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        List<String> _imageUrls = [];
        for (Map imageDocument in res.data['data']) {
          _imageUrls.add(ApiRoutes.getImageUrl(imageDocument['photo']));
        }
        return _imageUrls;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PostProducts> getBuyAgainProducts() async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_GetBuyAgainProducts,
        data: {'Authorization': accessToken},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return PostProducts.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PostProducts> getProductsByStaticOfferId({
    @required String staticOfferId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_ProductsByStaticOfferId,
        data: {'offer_id': staticOfferId},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return PostProducts.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PostProducts> getProductsByOfferId({
    @required String offerId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_ProductsByOffer,
        data: {'offer_id': offerId},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return PostProducts.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PostProducts> getProductsByBrandId({
    @required String brandId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_ProductsByBrand,
        data: {'brand_id': brandId},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return PostProducts.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<PostProducts> getProducts({
    @required String categoryId,
    String subCategoryId,
  }) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_Products,
        data: {'category_id': categoryId, 'sub_category_id': subCategoryId},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return PostProducts.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Product> getProductDetails({@required String id}) async {
    try {
      final res = await _dio.get(ApiRoutes.GET_ProductDetails + id);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Product.fromJson(res.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<GetBrands> getBrands() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_Brands);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return GetBrands.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Brand> getBrandById(String id) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_BrandsById,
        data: {'brand_id': id},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Brand.fromJson(res.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<GetCategories> getCategories() async {
    try {
      final res = await _dio.get(ApiRoutes.GET_Category);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return GetCategories.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<GetCategories> getSubCategories({@required String id}) async {
    try {
      final res = await _dio.post(
        ApiRoutes.POST_SubCategory,
        data: {'category_id': id},
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return GetCategories.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
