import 'package:uni_pay/src/core/models/uni_pay_address.dart';
import 'package:uni_pay/src/core/models/uni_pay_customer.dart';

import 'transaction.dart';

enum OrderStatus {
  unknown,
  newOne,
  processing,
  complete,
  refunded,
  canceled;

  String get name {
    return switch (this) {
      unknown => "unknown",
      newOne => "new",
      processing => "processing",
      complete => "complete",
      refunded => "refunded",
      canceled => "canceled"
    };
  }

  static OrderStatus from(String value) {
    return switch (value) {
      "unknown" => unknown,
      "new" => newOne,
      "processing" => processing,
      "complete" => complete,
      "refunded" => refunded,
      "canceled" => canceled,
      _ => unknown,
    };
  }
}

class UniPayOrderHistory {
  late TransactionAmount transactionAmount;
  late OrderStatus status;
  late UniPayAddress address;
  late DateTime orderedAt;
  late UniPayCustomerInfo? buyer;

  UniPayOrderHistory({
    required this.transactionAmount,
    required this.orderedAt,
    required this.address,
    this.buyer,
    this.status = OrderStatus.unknown,
  });

  UniPayOrderHistory.fromJson(Map<String, dynamic> json) {
    transactionAmount = TransactionAmount.fromJson(json['transactionAmount']);
    orderedAt = json['orderedAt'];
    address = UniPayAddress.fromJson(json['address']);
    buyer = UniPayCustomerInfo.fromJson(json['buyer']);
    status = OrderStatus.from(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionAmount'] = transactionAmount.toJson();
    data['orderedAt'] = orderedAt;
    data['address'] = address.toJson();
    data['buyer'] = buyer?.toJson();
    data['status'] = status.name;
    return data;
  }
}
