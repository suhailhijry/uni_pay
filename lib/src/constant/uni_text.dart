class UniPayText {
  static bool isEnglish = true;

  static String get payWithCard =>
      isEnglish ? "Pay By Card" : "ادفع عبر بطاقتك المصرفية";

  static String get somethingWentWrong => isEnglish
      ? "Something went wrong, please try again later"
      : "حدث خطأ ما ، يرجى المحاولة مرة أخرى في وقت لاحق";

  static String get payByTamara => isEnglish
      ? "Tamara: Split your bill into 4 interest-free installments."
      : "تمارا: قسم فاتورتك على 4 دفعات بدون فوائد";

  static String get payNow => isEnglish ? "Pay Now" : "ادفع الآن";

  static String get checkout => isEnglish ? "Checkout" : "الدفع";

  static String get paymentStatus =>
      isEnglish ? "Payment Status" : "حالة الدفع";

  static String get checkoutByTamara =>
      isEnglish ? "Checkout by Tamara" : "الدفع عبر تمارا";

  static String get checkoutByTabby =>
      isEnglish ? "Checkout by Tabby" : "الدفع عبر تابي";

  static String get useAnyCard =>
      isEnglish ? "Use any card" : "استخدم أي بطاقة";

  static String get tabbyErrorMsg => isEnglish
      ? "Your payment request has been declined by Tabby, kindly try again later."
      : "تم رفض طلب الدفع الخاص بك من قبل Tabby ، يرجى المحاولة مرة أخرى في وقت لاحق.";

  static String pleaseProvideCredentials =
      "Please provide payment gateway secret credentials to proceed the payment";
  static String pleaseProvideTamaraCredentails =
      "Please provide Tamara secret credentials to proceed the payment";

  static String pleaseProvideTabbyCredentails =
      "Please provide Tabby secret credentials to proceed the payment";

  static String pleaseProvideMoyasarCredentails =
      "Please provide Moyasar secret credentials to proceed the payment";
  static String noGatewayProvided =
      "No payment gateway provided, please provide one of the following gateways: [UniPayPaymentMethods.card]";

  static String get paymentFailed => isEnglish
      ? "Sorry, your payment was failed, make sure you have the enough balance on your card or the online payment is enabled for your card."
      : "عذرًا ، فشل الدفع الخاص بك ، تأكد من أن لديك رصيدًا كافيًا في بطاقتك أو تم تمكين الدفع عبر الإنترنت لبطاقتك.";

  ///* Tamara ----------
  static String get tamaraSplitBill => isEnglish
      ? "Tamara: Split in 3, interest-free"
      : "تمارا: قسم فاتورتك على 3 دفعات بدون فوائد";

  static String get tamaraSplitBillSubTitle => isEnglish
      ? "Pay a fraction of your total now and the rest over time, No hidden fees, no interest!"
      : "ادفع جزء من المبلغ الآن والباقي على حسب خطة الدفع, بدون فوائد ورسوم خفية!";

  ///* Tabby ----------
  static String get tabbySplitBill =>
      isEnglish ? "Pay later with Tabby" : "ادفع لاحقًا عبر تابي";

  ///* Card

  static String get payByCardSubTitle => isEnglish
      ? "We accept mada, visa, mastercard, and american express."
      : "نقبل مدى وفيزا وماستركارد وأمريكان إكسبريس";

  static String get learnMore => isEnglish ? "Learn More!" : "اعرف أكثر!";

  static String get applePayMerchantIdentifierError => isEnglish
      ? "Please provide apple pay merchant identifier to proceed the payment"
      : "يرجى تقديم معرف تاجر Apple Pay لمتابعة الدفع";

  static String noTransactionFound =
      "No transaction found for the provided metadata!";

  // Tamara Campaign
  static String get tamaraCampaign1 => isEnglish
      ? "Or split in 3 payments of"
      : "أو قسم فاتورتك على 3 دفعات بقيمة";

  static String get tamaraCampaign2 => isEnglish
      ? "- No late fees, Sharia compliant!"
      : "بدون رسوم تأخير، متوافقة مع الشريعة الإسلامية";

  static String sar(amount) => isEnglish ? " SAR $amount " : " $amount ر.س ";

  static String get tamaraCheckoutTitle => isEnglish
      ? "Split in 3 payments - No late fees, Sharia compliant"
      : "قسمها على 3 دفعات - بدون رسوم تأخير، متوافقة مع الشريعة الإسلامية";

  static String tabbyRejectionTranslation(String reason) {
    return switch (reason) {
      "not_available" => isEnglish
          ? "Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order."
          : "نأسف، تابي غير قادرة على الموافقة على هذه العملية. الرجاء استخدام طريقة دفع أخرى.",
      "order_amount_too_high" => isEnglish
          ? "This purchase is above your current spending limit with Tabby, try a smaller cart or use another payment method"
          : "قيمة الطلب تفوق الحد الأقصى المسموح به حاليًا مع تابي. يُرجى تخفيض قيمة السلة أو استخدام وسيلة دفع أخرى.",
      "order_amount_too_low" => isEnglish
          ? "The purchase amount is below the minimum amount required to use Tabby, try adding more items or use another payment method"
          : "قيمة الطلب أقل من الحد الأدنى المطلوب لاستخدام خدمة تابي. يُرجى زيادة قيمة الطلب أو استخدام وسيلة دفع أخرى.",
      String() => isEnglish
          ? "Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order."
          : "نأسف، تابي غير قادرة على الموافقة على هذه العملية. الرجاء استخدام طريقة دفع أخرى.",
    };
  }
}
