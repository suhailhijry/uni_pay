import 'package:uni_pay/src/core/models/uni_order_history.dart';

import 'uni_pay_address.dart';

class UniPayCustomerInfo {
  ///* Customer name
  late String fullName;

  ///* Customer phone number
  late String phoneNumber;

  ///* Customer address
  late UniPayAddress address;

  ///* Customer email
  String? email;

  ///* Customer joined date
  late DateTime joinedAtDate;
  late int successfulPastOrders;
  late List<UniPayOrderHistory> history;

  UniPayCustomerInfo({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    this.email = "",
    this.successfulPastOrders = 0,
    this.history = const <UniPayOrderHistory>[],
    DateTime? joinedAtDate,
  }) : joinedAtDate = joinedAtDate ?? DateTime.now();

  UniPayCustomerInfo.fromJson(Map<String, dynamic> data) {
    fullName = data['fullName'];
    phoneNumber = data['phone_number'];
    address = UniPayAddress.fromJson(data['address']);
    email = data['email'];
    history =
        data['history']?.map((v) => UniPayOrderHistory.fromJson(v)) ?? const [];
    successfulPastOrders = data['successful_past_orders'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['address'] = address.toJson();
    data['history'] = history.map((v) => v.toJson());
    data['successful_past_orders'] = successfulPastOrders;
    data['joined_at_date'] = joinedAtDate;
    return data;
  }

  @override
  String toString() {
    return 'UniPayCustomerInfo(fullName: $fullName, phoneNumber: $phoneNumber, email: $email, address: $address, joinedAtDate: $joinedAtDate)';
  }
}
