import 'package:flutter/material.dart';
import 'package:tabby_flutter_inapp_sdk/src/resources/colors.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:uni_pay/src/utils/extension.dart';
import 'package:uni_pay/src/utils/utils.dart';
import 'package:uni_pay/uni_pay.dart'
    show
        TabbyCredential,
        TabbyDto,
        TabbySnippet,
        UniPayCustomerInfo,
        UniPayData,
        UniPayOrder,
        UniPayPaymentMethodsItr,
        UniPayResponse,
        UniPayStatus;

import '../../../../core/controllers/uni_pay_controller.dart';
import '../models/tabby_session.dart';
import '../models/tabby_trxn.dart';
import 'tabby_repo.dart';

final _tabbyRepo = TabbyRepo();

/// Include all Tabby related Services to handle Tabby payment gateway,
///
/// Such as: Initiate tabby payment, create session, capture payment, get transaction details, etc.
class UniTabbyServices {
  static TabbySDK? _tabbySdk;
  static TabbyCredential? _tabbyCredential;

  /// Init Tabby SDK to prepare for payment
  static void initTabbySDK(UniPayData uniPayData) {
    if (uniPayData.credentials.paymentMethods.isTabbyGateway &&
        _tabbySdk == null) {
      _tabbyCredential = uniPayData.credentials.tabbyCredential!;
      _tabbySdk = TabbySDK();
      _tabbySdk?.setup(
        withApiKey: _tabbyCredential!.secretKey,
        environment: Environment.production,
      );
    }
  }

  /// Show Tabby payment snippet
  ///
  /// Please make sure you provided the required data
  static Widget showProductPageTabbySnippet(
      {required TabbySnippet tabbySnippet}) {
    return TabbyProductPageSnippet(
      price: tabbySnippet.totalAmountWithVat.toDouble(),
      currency: tabbySnippet.currency.tabbyCurrency,
      lang: tabbySnippet.locale.tabbyLang,
      merchantCode: _tabbyCredential!.merchantCode,
      apiKey: _tabbyCredential!.psKey,
    );
  }

  /// Please make sure you provided the required data
  static Widget showTabbyCheckoutSnippet({required TabbySnippet tabbySnippet}) {
    return TabbyCheckoutSnippet(
      price: tabbySnippet.totalAmountWithVat.formattedString,
      currency: tabbySnippet.currency.tabbyCurrency,
      lang: tabbySnippet.locale.tabbyLang,
    );
  }

  /// Create Tabby session to proceed with payment
  static Future<TabbySessionData?> createTabbySession(
      UniPayData uniPayData) async {
    UniPayOrder order = uniPayData.orderInfo;
    UniPayCustomerInfo customer = uniPayData.customerInfo;
    TabbyCredential tabbyCredential = uniPayData.credentials.tabbyCredential!;

    if (_tabbySdk == null) {
      throw Exception(
          "Call `UniPayServices.initUniPay()` before using this function to initialize the `UniPay` module.");
    }

    try {
      TabbyCheckoutPayload tabbyCheckoutPayload = TabbyCheckoutPayload(
        merchantCode: tabbyCredential.merchantCode,
        lang: uniPayData.locale.tabbyLang,
        payment: Payment(
          amount: order.transactionAmount.totalAmount.toString(),
          currency: order.transactionAmount.currency.tabbyCurrency,
          buyer: Buyer(
            // 'card.success@tabby.ai',
            // '0500000001'
            // 'otp.rejected@tabby.ai',
            // '0500000002'
            email: customer.email,
            phone: customer.phoneNumber,
            name: customer.fullName,
          ),
          buyerHistory: BuyerHistory(
            loyaltyLevel: 0,
            registeredSince: customer.joinedAtDate.toUtc().toIso8601String(),
            wishlistCount: 0,
          ),
          order: Order(
            referenceId: order.orderId,
            items: order.items
                .map(
                  (item) => OrderItem(
                    title: item.name,
                    description: item.itemType.name,
                    quantity: item.quantity,
                    unitPrice: item.totalPrice.formattedString,
                    referenceId: item.sku,
                    category: item.itemType.name,
                  ),
                )
                .toList(),
          ),
          orderHistory: [
            // OrderHistoryItem(
            //   purchasedAt: DateTime.now().toUtc().toIso8601String(),
            //   amount: order.transactionAmount.totalAmount.formattedString,
            //   paymentMethod: OrderHistoryItemPaymentMethod.card,
            //   status: OrderHistoryItemStatus.newOne,
            // )
          ],
          shippingAddress: ShippingAddress(
            city: customer.address.city,
            address: customer.address.addressName,
            zip: customer.address.zipCode,
          ),
        ),
      );
      final sessionResult =
          await _tabbySdk!.createSession(tabbyCheckoutPayload);
      TabbySessionData session = TabbySessionData(
        sessionId: sessionResult.sessionId,
        paymentId: sessionResult.paymentId,
        availableProducts: sessionResult.availableProducts,
        status: SessionStatus.created,
        rejectionReason: sessionResult.rejectionReason,
      );
      uniLog("✔ Tabby Session: ${session.toString()}");
      return session;
    } on ServerException catch (e) {
      uniLog("Tabby ServerException: $e");
      return null;
    }
  }

  /// Process the Tabby payment
  static Future processTabbyPayment(BuildContext context, UniPayStatus status,
      {String? transactionId}) {
    UniPayResponse response = UniPayResponse(status: status);

    /// If payment is successful, then return the transaction ID
    if (status.isSuccess) {
      response.transactionId = transactionId ??
          "TABBY_TRXN_${UniPayControllers.uniPayData.orderInfo.orderId}}";
    }
    return UniPayControllers.handlePaymentsResponseAndCallback(context,
        response: response);
  }

  /// Check the Pre-score result session, before proceeding with payment
  static Future<TabbySessionData?> checkPreScoreSession(
      UniPayData uniPayData) async {
    // Initialize Tabby SDK
    if (_tabbySdk == null) {
      initTabbySDK(uniPayData);
    }
    return createTabbySession(uniPayData);
  }

  /// Get the transaction details from Tabby
  static Future<TabbyTransaction> getTabbyTransactionDetails(
      {required TabbyDto tabbyDto}) {
    return _tabbyRepo.getTransactionDetails(tabbyDto: tabbyDto);
  }

  /// Capture the transaction to Tabby, so that they will complete the payment for your merchant.
  static Future<TabbyTransaction> captureTabbyPayment(
      {required TabbyDto tabbyDto}) {
    return _tabbyRepo.captureTabbyOrder(tabbyDto: tabbyDto);
  }
}

class TabbyCheckoutSnippet extends StatefulWidget {
  const TabbyCheckoutSnippet({
    required this.currency,
    required this.price,
    required this.lang,
    Key? key,
  }) : super(key: key);

  final String price;
  final Currency currency;
  final Lang lang;

  @override
  State<TabbyCheckoutSnippet> createState() => _TabbyCheckoutSnippetState();
}

const gap = SizedBox(height: 6);

class _TabbyCheckoutSnippetState extends State<TabbyCheckoutSnippet> {
  late List<String> localeStrings;

  @override
  void initState() {
    localeStrings =
        AppLocales.instance().checkoutSnippet(widget.lang).values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final installmentPrice =
        getPrice(price: widget.price, currency: widget.currency);
    final amountText = '${widget.currency.displayName} $installmentPrice';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            localeStrings[0],
            style: TextStyle(
              fontSize: 14,
              color: dividerColor,
            ),
          ),
        ),
        gap,
        gap,
        Row(
          children: [
            CheckoutSnippetCell(
              position: 1,
              localeStrings: localeStrings,
              amountText: amountText,
            ),
            CheckoutSnippetCell(
              position: 2,
              localeStrings: localeStrings,
              amountText: amountText,
            ),
            CheckoutSnippetCell(
              position: 3,
              localeStrings: localeStrings,
              amountText: amountText,
            ),
            CheckoutSnippetCell(
              position: 4,
              localeStrings: localeStrings,
              amountText: amountText,
            ),
          ],
        ),
      ],
    );
  }
}

class CheckoutSnippetCell extends StatelessWidget {
  const CheckoutSnippetCell({
    required this.position,
    required this.localeStrings,
    required this.amountText,
    Key? key,
  }) : super(key: key);

  final List<String> localeStrings;
  final String amountText;
  final int position;

  @override
  Widget build(BuildContext context) {
    final isFirst = position == 1;
    final isLast = position == 4;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: isFirst
                    ? const SizedBox.shrink()
                    : Container(
                        height: 1,
                        color: dividerColor,
                      ),
              ),
              CheckoutSnippetImage(position: position),
              Expanded(
                child: isLast
                    ? const SizedBox.shrink()
                    : Container(
                        height: 1,
                        color: dividerColor,
                      ),
              ),
            ],
          ),
          gap,
          CheckoutWhenText(position: position, localeStrings: localeStrings),
          gap,
          CheckoutSnippetAmountText(amount: amountText),
        ],
      ),
    );
  }
}

class CheckoutWhenText extends StatelessWidget {
  const CheckoutWhenText({
    required this.position,
    required this.localeStrings,
    Key? key,
  }) : super(key: key);

  final List<String> localeStrings;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Text(
      localeStrings[position],
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CheckoutSnippetImage extends StatelessWidget {
  const CheckoutSnippetImage({
    required this.position,
    Key? key,
  }) : super(key: key);

  final int position;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Image(
        image: AssetImage(
          'assets/images/r$position.png',
          package: 'tabby_flutter_inapp_sdk',
        ),
        width: 40,
        height: 40,
      ),
    );
  }
}

class CheckoutSnippetAmountText extends StatelessWidget {
  const CheckoutSnippetAmountText({
    required this.amount,
    Key? key,
  }) : super(key: key);
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      amount,
      style: TextStyle(
        fontSize: 11,
        color: dividerColor,
      ),
    );
  }
}

const checkoutSnippetLocalesEn = {
  'useAnyCard': 'Use any card.',
  'today': 'Today',
  'in1Month': 'In 1 month',
  'in2Months': 'In 2 months',
  'in3Months': 'In 3 months',
};

const checkoutSnippetLocalesAr = {
  'useAnyCard': 'استخدم أي بطاقة.',
  'today': 'اليوم',
  'in1Month': 'بعد شهر',
  'in2Months': 'بعد شهرين',
  'in3Months': 'بعد ثلاثة أشهر',
};

class AppLocales {
  AppLocales._();

  /// Provides instance [AppLocales].
  factory AppLocales.instance() => _instance;

  static final AppLocales _instance = AppLocales._();

  Map<String, String> checkoutSnippet(Lang lang) {
    switch (lang) {
      case Lang.en:
        return checkoutSnippetLocalesEn;
      default:
        return checkoutSnippetLocalesAr;
    }
  }
}
