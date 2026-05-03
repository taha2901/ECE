class ApiConstants {
  static const String apiBaseUrl = 'https://midoghanam.pythonanywhere.com/api';

  // Auth
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String me = '/auth/me/';
  static const String changePassword = '/auth/change-password/';
  static const String refreshToken = '/auth/token/refresh/';

  // ================= Customers =================
  static const String customers = '/partners/customers/';
  static const String registerCustomer = '/partners/customers/register/';
  static String updateCustomer(String id) => '/partners/customers/update/$id/';
  static String deleteCustomer(String id) =>
      '/partners/customers/delete/$id/'; // ✅ جديد

  // Suppliers
  static const String getAllSuppliers = '/partners/suppliers/';
  static const String registerSupplier = '/partners/suppliers/register/';
  static const String updateSupplier = '/partners/suppliers/update/';
  static String deleteSupplier(String id) =>
      '/partners/suppliers/delete/$id/'; // ✅ لو موجود عندكم

  // Wishlist
  static const String wishlist = '/wishlist/';
  static const String addToWishlist = '/wishlist/add/';
  static String removeFromWishlist(int productId) =>
      '/wishlist/remove/$productId/';

  // Categories
  static const String getAllCategories = '/categories/';
  static String getCategoryDetails(int id) => '/categories/$id/';

  // Products
  static const String getAllProducts = '/products/';
  static const String addProduct = '/products/add/';
  static const String getProductDetails = '/products/get/';
  static const String editProduct = '/products/edit/';
  static const String deleteProduct =
      '/products/delete/'; // ✅ query: ?productId=

  // =================== Billing / Sales ===================
  static const String createSale = '/billing/sales/create/';
  static const String getSales = '/billing/sales/';
  static String getSaleDetails(int id) => '/billing/sales/$id/';

  // Purchases
  static const String purchasesList = '/billing/purchases/';
  static const String createPurchase = '/billing/purchases/create/';
  static String purchaseDetails(int id) => '/billing/purchases/$id/';

  // =================== Returns / Refunds ===================
  static const String refundsList = '/billing/refunds/';
  static const String createRefund = '/billing/refunds/create/';

  // Sales invoices by customer
  static String salesByCustomer(String id) => "/billing/sales/customer/$id/";

  // =================== Customers Balance ===================
  static String customerPayBalance(String customerId) =>
      "/billing/customers/$customerId/pay-balance/";
  static const String customersWithBalance = "/billing/customers/with-balance/";

  // Purchases invoices by supplier
  static String purchasesBySupplier(String id) =>
      "/billing/purchases/supplier/$id/";
  static const String billingDashboard = '/billing/dashboard/';

  // =================== Billing Stats ===================
  static const String salesStats = '/billing/sales/stats/';
  static const String purchasesStats = '/billing/purchases/stats/';

  // Profit Stats
  static const String profitStats = "/billing/profit-stats/";

  static String payCustomerBalance(String id) =>
      "/billing/customers/$id/pay-balance/";
  static String createSaleInvoice() => "/billing/sales/create/";
  static String createPurchaseInvoice() => "/billing/purchases/create/";

  // =================== Suppliers Balance ===================
  static const String suppliersWithBalance = "/billing/suppliers/with-balance/";
  static String supplierPayBalance(String supplierId) =>
      "/billing/suppliers/$supplierId/pay-balance/";

  // =================== Purchases Pay Balance ===================
  static String payPurchaseBalance(int id) =>
      "/billing/purchases/$id/pay-balance/";

  // =================== Expenses ===================
  static const String createExpense = "/billing/expenses/create/";

  static const String cashbox = "/billing/cashbox/";

  // =================== Cart & Orders ===================
  static const String cartTotal = '/cart/total/';
  static const String orders = '/orders/';
  static String orderDetails(int id) => '/orders/$id/';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
