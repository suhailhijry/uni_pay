import 'uni_pay_address.dart';

class UniPayCustomerInfo {
  ///* Customer name
  late String fullName;

  ///* Customer phone number
  late String phoneNumber;

  ///* Customer email
  String? email;

  ///* Customer address
  UniPayAddress? address;

  ///* Customer joined date
  late DateTime joinedAtDate;

  UniPayCustomerInfo({
    required this.fullName,
    required this.phoneNumber,
    this.email = "",
    this.address,
    DateTime? joinedAtDate,
  }) : joinedAtDate = joinedAtDate ?? DateTime.now();

  UniPayCustomerInfo.fromJson(Map<String, dynamic> data) {
    fullName = data['fullName'];
    phoneNumber = data['phone_number'];
    email = data['email'];
    address = UniPayAddress.fromJson(data['address']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['address'] = address?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'UniPayCustomerInfo(fullName: $fullName, phoneNumber: $phoneNumber, email: $email, address: $address, joinedAtDate: $joinedAtDate)';
  }
}
