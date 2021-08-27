class ApiRoutes {
  ApiRoutes._();

  static const String _BASE_URL = 'http://groceryshopi.com';
  static const String BASE_URL = '$_BASE_URL/pos/api';

  // Categories
  static const String GET_Category = '/Category';
  static const String POST_SubCategory = '/SubCategory';

  // Products
  static const String GET_ProductDetails = '/product/'; // + productId
  static const String POST_Products = '/product';
  static const String POST_Search = '/product/search';
  static const String POST_ProductImages = '/product/images';
  static const String POST_ProductsByBrand = '/product/product_brand';
  static const String POST_GetBuyAgainProducts = '/User/past_order_products';
  static const String POST_ProductsByOffer = '/offers/products';
  static const String POST_ProductsByStaticOfferId = '/offers/static_products';
  static const String GET_ProductMainImage = '/product/image/'; // + productId

  // Wallet
  static const String POST_WalletDetails = '/User/wallet';

  // static const String POST_WalletAddAmount = '/User/wallet_add';
  static const String POST_WalletRemoveAmount = '/User/wallet_remove';
  static const String POST_WalletStatement = '/User/wallet_statement';

  //Plus Wallet
  static const String POST_PlusWalletDetails = '/User/wallet_plus';
  static const String POST_PlusWalletAddAmount = '/User/wallet_plus_add';
  static const String POST_PlusWalletRemoveAmount = '/User/wallet_plus_remove';
  static const String POST_PlusWalletStatement = '/User/wallet_plus_statement';

  // User
  static const String POST_Login = '/User/login';
  static const String POST_VerifyUserToken = '/User/verify';
  static const String POST_UserProfile = '/User/profile';
  static const String POST_UpdateProfile = '/User/profile_update';
  static const String POST_AddRating = '/user/rate';

  // Address
  static const String POST_GetAddress = '/User/get_address';
  static const String POST_AddAddress = '/User/address_add';
  static const String POST_UpdateAddress = '/User/update_address';
  static const String POST_DeleteAddress = '/User/delete_address';

  // Cart
  static const String POST_GetCart = '/cart';
  static const String POST_AddToCart = '/cart/add';
  static const String POST_RemoveFromCart = '/cart/remove';

  // Banners
  static const String GET_PrimaryBanners = '/banners/primary';
  static const String GET_SecondaryBanners = '/banners/secondary';

  // Brands
  static const String GET_Brands = '/Brands';
  static const String POST_BrandsById = '/brands';

  // Offers
  static const String GET_Offers = '/offers';
  static const String GET_StaticOffers = '/offers/static';

  // Miscellaneous
  static const String POST_Checkout = '/cart/checkout';
  static const String POST_GetOrders = '/User/orders';
  static const String GET_RazorpayCredentials = '/razorpay';
  static const String GET_Settings = '/settings';
  static const String GET_FAQs = '/faq/';

  // static const String GET_Testimonials = '/user/rate';
  static const String GET_Testimonials = '/testimonial';
  static const String POST_QuickOrder = '/quick/add';

  static String getImageUrl(String imageUrl) {
    return "$_BASE_URL/assets/uploads/$imageUrl";
  }
}
