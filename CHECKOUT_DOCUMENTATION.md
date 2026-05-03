# 🛍️ تحديثات نظام الدفع والطلبات (Checkout)

## 📋 الميزات الجديدة

### 1. **صفحة Cart Total (ملخص السلة)**
- عرض مفصل لجميع المنتجات في السلة
- عرض الأسعار والكميات والألوان والأحجام
- ملخص الأسعار (Subtotal, Shipping, Tax, Total)
- الانتقال السلس إلى عملية Checkout

**المسار:** `/cart-total`

### 2. **عملية Checkout متعددة المراحل (Enhanced Checkout)**
تشمل 4 مراحل متسلسلة:

#### ✅ المرحلة 1: معلومات العميل (Customer Info)
- الاسم الأول والأخير
- البريد الإلكتروني
- رقم الهاتف
- **جلب تلقائي** للبيانات من حساب المستخدم إذا كان مسجل دخول

#### 📍 المرحلة 2: عنوان الشحن (Shipping)
- العنوان الكامل
- المدينة
- الرمز البريدي

#### 💳 المرحلة 3: طريقة الدفع (Payment)
- الدفع عند الاستلام (Cash on Delivery)
- بطاقة ائتمان/خصم (Credit/Debit Card)
- حساب الرسوم التلقائي

#### 📝 المرحلة 4: مراجعة الطلب (Review)
- عرض جميع البيانات المجمعة
- ملخص الطلب والأسعار
- تأكيد النهائي قبل الدفع

**المسار:** `/enhanced-checkout`

---

## 🔧 الملفات الجديدة

### Models (البيانات)
- **`lib/features/checkout/data/models/order_models.dart`**
  - `CartTotalModel` - نموذج إجمالي السلة
  - `CartItemTotalModel` - نموذج عنصر السلة
  - `CreateOrderRequest` - طلب إنشاء الأوردر
  - `OrderResponseModel` - استجابة الأوردر من الـ API

### Repository (طبقة البيانات)
- **`lib/features/checkout/data/repo/checkout_repository.dart`**
  - دوال للاتصال بـ API للحصول على ملخص السلة وإنشاء الأوامر

### Cubit و States (إدارة الحالة)
- **`lib/features/checkout/logic/checkout_cubit.dart`** - منطق الـ checkout
  - `loadCartTotal()` - جلب ملخص السلة
  - `updateUserData()` - تحديث بيانات العميل
  - `updatePaymentInfo()` - تحديث طريقة الدفع
  - `loadUserDataFromAuth()` - **جلب البيانات من الـ auth**
  - `createOrder()` - إنشاء الأوردر

- **`lib/features/checkout/logic/checkout_state.dart`** - حالات الـ checkout

### Views (الواجهات)
- **`lib/features/checkout/view/cart_total_screen.dart`**
  - صفحة عرض ملخص السلة

- **`lib/features/checkout/view/enhanced_checkout_screen.dart`**
  - صفحة الـ checkout متعددة المراحل مع:
    - مؤشر تقدم الخطوات
    - نماذج إدخال البيانات
    - اختيار طريقة الدفع
    - مراجعة الطلب

---

## 🔌 API Endpoints

### الحصول على ملخص السلة
```
GET /api/cart/total/
```
**الاستجابة:**
```json
{
  "count": 1,
  "total": "49.99",
  "items": [
    {
      "id": 5,
      "product": {
        "id": 7,
        "name": "Product Name",
        "price": "49.99",
        "image": "https://..."
      },
      "quantity": 1,
      "size": "M",
      "color": "#000000",
      "line_total": 49.99
    }
  ]
}
```

### إنشاء أوردر
```
POST /api/orders/
```
**الطلب:**
```json
{
  "user": 1,
  "first_name": "Rania",
  "last_name": "Ahmed",
  "email": "rania@test.com",
  "phone": "01000000000",
  "address": "Cairo",
  "city": "Cairo",
  "zip_code": "12345",
  "subtotal": "100",
  "shipping_fee": "20",
  "tax": "10",
  "total": "130",
  "discount_amount": "0",
  "coupon": null,
  "status": "processing",
  "payment_method": "deposit",
  "items": [...]
}
```

---

## 🎯 تدفق الاستخدام

```
Cart Screen 
  ↓ (Click "Proceed to Checkout")
Cart Total Screen (Review items & price)
  ↓ (Click "Proceed to Checkout")
Enhanced Checkout - Step 1 (Customer Info)
  ↓ (Data auto-filled from Auth if logged in)
Enhanced Checkout - Step 2 (Shipping)
  ↓
Enhanced Checkout - Step 3 (Payment Method)
  ↓
Enhanced Checkout - Step 4 (Review)
  ↓
Create Order (API Call)
  ↓
Success / Error
```

---

## 🚀 الاستخدام في الكود

### جلب ملخص السلة
```dart
context.read<CheckoutCubit>().loadCartTotal();
```

### تحديث بيانات العميل
```dart
context.read<CheckoutCubit>().updateUserData(
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  phone: '+1234567890',
  address: '123 Main St',
  city: 'Cairo',
  zipCode: '12345',
);
```

### تحديث طريقة الدفع
```dart
context.read<CheckoutCubit>().updatePaymentInfo(
  paymentMethod: 'deposit', // or 'card'
  shippingFee: 10.0,
  tax: 5.0,
);
```

### جلب البيانات من الحساب (إن أمكن)
```dart
context.read<CheckoutCubit>().loadUserDataFromAuth();
```

### إنشاء الأوردر
```dart
context.read<CheckoutCubit>().createOrder();
```

---

## 🔐 الحماية والتحقق

- ✅ التحقق من تعبئة جميع الحقول المطلوبة
- ✅ حماية الطرق (protected routes) - لا يمكن الوصول بدون تسجيل دخول
- ✅ معالجة الأخطاء الشاملة
- ✅ رسائل خطأ واضحة للمستخدم

---

## 📦 التثبيت والإعداد

### تم إضافة في Service Locator
```dart
// Checkout
sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepository(sl<ApiService>()));
sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(sl<CheckoutRepository>(), sl<AuthCubit>()));
```

### تم إضافة في Main BlocProvider
```dart
BlocProvider<CheckoutCubit>(
  create: (_) => sl<CheckoutCubit>(),
),
```

### تم إضافة في Router
- `/cart-total` - صفحة ملخص السلة
- `/enhanced-checkout` - صفحة الـ checkout

---

## 🎨 التصميم والواجهات

- ✨ تصميم عصري وجميل
- 📱 واجهة متجاوبة (Responsive)
- 🎯 مؤشرات بصرية واضحة للتقدم
- 🎭 ألوان متسقة مع الثيم العام للتطبيق
- ⚡ تحريكات سلسة وسهلة الاستخدام

---

## 🔮 الميزات المستقبلية الممكنة

- 💰 دعم طرق دفع متعددة (Stripe, PayPal, إلخ)
- 🎁 كود خصم وكوبونات
- 📊 تتبع حالة الطلب
- 💬 دعم العملاء المباشر
- 📧 تنبيهات البريد الإلكتروني

---

## 📞 ملاحظات مهمة

1. تأكد من أن المستخدم مسجل دخول قبل الوصول لصفحات الـ checkout
2. تتم ملء بيانات العميل تلقائياً من حساب المستخدم إذا كانت محفوظة
3. يمكن تعديل البيانات قبل الإرسال للـ API
4. الأوردر يتم إنشاؤه فقط بعد مراجعة جميع البيانات
5. معرّف المستخدم يتم جلبه تلقائياً من الـ authentication

---

## 🎉 تم! اختبر النظام الآن!

Navigate to `/cart` → `/cart-total` → `/enhanced-checkout` ✨
