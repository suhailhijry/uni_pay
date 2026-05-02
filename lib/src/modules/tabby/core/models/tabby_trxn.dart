import 'package:uni_pay/uni_pay.dart';

/// Tabby Payment Status
enum TabbyResStatus {
  authorized,
  closed,
  failed,
  notSpecified;

  /// Is order authorized
  bool get isAuthorized => this == TabbyResStatus.authorized;

  /// Is order closed
  bool get isClosed => this == TabbyResStatus.closed;

  /// Is order failed
  bool get isFailed => this == TabbyResStatus.failed;

  /// Is order not specified
  bool get isNotSpecified => this == TabbyResStatus.notSpecified;
}

class TabbyTransaction {
  /// Transaction ID
  String id;

  /// Payment Status
  TabbyResStatus status;

  /// Amount
  num amount;

  /// Created At
  DateTime createdAt;

  /// Closed At
  DateTime? closedAt;

  /// Meta Data
  Map<String, dynamic>? meta;

  /// Currency
  String currency;

  /// Order
  IOrder? order;

  /// Captures
  List<ICaptureData> captures;

  /// Refunds
  List<ICaptureData> refunds;

  /// Error Message for failed transaction
  String errorMessage;

  /// Customer/Buyer information
  UniPayCustomerInfo? customer;

  TabbyTransaction({
    this.id = "",
    this.status = TabbyResStatus.notSpecified,
    this.amount = 0,
    DateTime? createdAt,
    this.closedAt,
    this.meta,
    this.currency = "SAR",
    this.order,
    this.captures = const [],
    this.refunds = const [],
    this.errorMessage = "",
    this.customer,
  }) : createdAt = createdAt ?? DateTime.now();

  /// From Json to Model
  factory TabbyTransaction.fromMap(Map<String, dynamic> data) {
    return TabbyTransaction(
      id: data['id'],
      status: TabbyResStatus.values.firstWhere((e) =>
          e.name.toLowerCase() == data['status'].toString().toLowerCase()),
      amount: num.tryParse(data['amount']) ?? 0,
      createdAt: DateTime.parse(data['created_at']),
      closedAt:
          data['closed_at'] != null ? DateTime.parse(data['closed_at']) : null,
      meta: data['meta'],
      currency: data['currency'],
      order: data['order'] != null ? IOrder.fromMap(data['order']) : null,
      captures: List<ICaptureData>.from((data['captures'] ?? [])
          .map((c) => ICaptureData.fromMap(c))
          .toList()),
      refunds: List<ICaptureData>.from(
          (data['refunds'] ?? []).map((r) => ICaptureData.fromMap(r)).toList()),
      customer: UniPayCustomerInfo(
        fullName: data['buyer']['name'],
        email: data['buyer']['email'],
        phoneNumber: data['buyer']['phone'],
        address: UniPayAddress(
          addressName: data['shipping_address']['address'],
          city: data['shipping_address']['city'],
          zipCode: data['shipping_address']['zip'],
        ),
      ),
    );
  }

  /// From Model to Json
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.name,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'meta': meta,
      'currency': currency,
      'order': order?.toMap(),
      'captures': captures.map((c) => c.toMap()).toList(),
      'refunds': refunds.map((r) => r.toMap()).toList(),
      'buyer': {
        'name': customer?.fullName,
        'email': customer?.email,
        'phone': customer?.phoneNumber,
        'shipping_address': {
          'address': customer?.address?.addressName,
          'city': customer?.address?.city,
          'zip': customer?.address?.zipCode,
        },
      },
    };
  }

  /// Is Payment Authorised
  bool get isPaymentAuthorized => status == TabbyResStatus.authorized;

  /// Is Payment Closed
  bool get isPaymentClosed => status == TabbyResStatus.closed;

  /// Is Payment Failed
  bool get isPaymentFailed => status == TabbyResStatus.failed;

  @override
  String toString() {
    return 'TabbyTransaction(id: $id, status: $status, amount: $amount, createdAt: $createdAt, closedAt: $closedAt, meta: $meta, currency: $currency, order: $order, captures: $captures, refunds: $refunds, customer: $customer errorMessage: $errorMessage)';
  }
}

/// ------ Order short info from Tabby ----------------- ///
class IOrder {
  String referenceId;
  DateTime updatedAt;

  IOrder({required this.referenceId, required this.updatedAt});

  /// From Json to Model
  factory IOrder.fromMap(Map<String, dynamic> data) {
    return IOrder(
      referenceId: data['reference_id'] ?? "",
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  /// From Json to Model
  Map<String, dynamic> toMap() => {
        'reference_id': referenceId,
        'updated_at': updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'IOrder(referenceId: $referenceId, updatedAt: $updatedAt)';
  }
}

/// ------ Capture Data from Tabby ----------------- ///
class ICaptureData {
  String id;
  num amount;
  DateTime createdAt;

  ICaptureData({
    required this.id,
    required this.amount,
    required this.createdAt,
  });

  /// From Json to Model
  factory ICaptureData.fromMap(Map<String, dynamic> data) {
    return ICaptureData(
      id: data['id'] ?? "",
      amount: num.tryParse(data['amount']) ?? 0,
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  /// From Model to Json
  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'ICaptureData(id: $id, amount: $amount, createdAt: $createdAt)';
  }
}
