class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;

  // Page padding
  static const double pagePadding = 20.0;
  static const double sectionGap = 28.0;
}

class AppRadius {
  AppRadius._();

  static const double xs = 6.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double pill = 100.0;
  static const double circle = 999.0;
}

class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration verySlow = Duration(milliseconds: 600);
}

class AppAssets {
  AppAssets._();

  // Illustrations
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String emptyCart = 'assets/images/empty_cart.png';
  static const String emptyWishlist = 'assets/images/empty_wishlist.png';
  static const String emptyOrders = 'assets/images/empty_orders.png';
  static const String paymentSuccess = 'assets/images/payment_success.png';
  static const String logo = 'assets/images/logo.png';

  // Icons
  static const String googleIcon = 'assets/icons/google.svg';
  static const String appleIcon = 'assets/icons/apple.svg';
  static const String visaIcon = 'assets/icons/visa.svg';
  static const String mastercardIcon = 'assets/icons/mastercard.svg';
}

class AppStrings {
  AppStrings._();

  static const String appName = 'Luxe Store';
  static const String tagline = 'Shop the World';

  // Auth
  static const String signIn = 'Sign In';
  static const String signUp = 'Create Account';
  static const String forgotPassword = 'Forgot Password?';
  static const String orContinueWith = 'or continue with';

  // Bottom Nav
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String cart = 'Cart';
  static const String wishlist = 'Wishlist';
  static const String profile = 'Profile';

  // Common
  static const String addToCart = 'Add to Cart';
  static const String buyNow = 'Buy Now';
  static const String seeAll = 'See All';
  static const String search = 'Search products...';
  static const String noInternet = 'No internet connection';
  static const String somethingWrong = 'Something went wrong';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
}