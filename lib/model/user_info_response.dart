import 'dart:convert';

class UserInfoResponse {
  final bool? status;
  final int? statusCode;
  final UserInfoData? data;
  final String? message;
  final String? requestIp;
  final String? userIp;
  UserInfoResponse({
    this.status,
    this.statusCode,
    this.data,
    this.message,
    this.requestIp,
    this.userIp,
  });

  UserInfoResponse copyWith({
    bool? status,
    int? statusCode,
    UserInfoData? data,
    String? message,
    String? requestIp,
    String? userIp,
  }) {
    return UserInfoResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
      requestIp: requestIp ?? this.requestIp,
      userIp: userIp ?? this.userIp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data?.toMap(),
      'message': message,
      'requestIp': requestIp,
      'userIp': userIp,
    };
  }

  factory UserInfoResponse.fromMap(Map<String, dynamic> map) {
    return UserInfoResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['statusCode'] != null ? map['statusCode'] as int : null,
      data: map['data'] != null
          ? UserInfoData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      message: map['message']?.toString(),
      requestIp: map['requestIp']?.toString(),
      userIp: map['userIp']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoResponse.fromJson(String source) =>
      UserInfoResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfoResponse(status: $status, statusCode: $statusCode, data: $data, message: $message, requestIp: $requestIp, userIp: $userIp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfoResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data &&
        other.message == message &&
        other.requestIp == requestIp &&
        other.userIp == userIp;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        statusCode.hashCode ^
        data.hashCode ^
        message.hashCode ^
        requestIp.hashCode ^
        userIp.hashCode;
  }
}

class UserInfoData {
  final int? id;
  final String? name;
  final String? email;
  final String? apiToken;
  final String? customerId;
  final String? stripeId;
  final String? trialEndsAt;
  final String? trialCountry;
  final String? cardCountry;
  final String? initialPlatform;
  final String? subscription;
  UserInfoData({
    this.id,
    this.name,
    this.email,
    this.apiToken,
    this.customerId,
    this.stripeId,
    this.trialEndsAt,
    this.trialCountry,
    this.cardCountry,
    this.initialPlatform,
    this.subscription,
  });

  UserInfoData copyWith({
    int? id,
    String? name,
    String? email,
    String? apiToken,
    String? customerId,
    String? stripeId,
    String? trialEndsAt,
    String? trialCountry,
    String? cardCountry,
    String? initialPlatform,
    String? subscription,
  }) {
    return UserInfoData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      apiToken: apiToken ?? this.apiToken,
      customerId: customerId ?? this.customerId,
      stripeId: stripeId ?? this.stripeId,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      trialCountry: trialCountry ?? this.trialCountry,
      cardCountry: cardCountry ?? this.cardCountry,
      initialPlatform: initialPlatform ?? this.initialPlatform,
      subscription: subscription ?? this.subscription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'apiToken': apiToken,
      'customerId': customerId,
      'stripeId': stripeId,
      'trialEndsAt': trialEndsAt,
      'trialCountry': trialCountry,
      'cardCountry': cardCountry,
      'initialPlatform': initialPlatform,
      'subscription': subscription,
    };
  }

  factory UserInfoData.fromMap(Map<String, dynamic> map) {
    return UserInfoData(
      id: typeConversion<int?>(map['id']),
      name: map['name']?.toString(),
      email: map['email']?.toString(),
      apiToken: map['apiToken']?.toString(),
      customerId: map['customerId']?.toString(),
      stripeId: map['stripeId']?.toString(),
      trialEndsAt: map['trialEndsAt']?.toString(),
      trialCountry: map['trialCountry']?.toString(),
      cardCountry: map['cardCountry']?.toString(),
      initialPlatform: map['initialPlatform']?.toString(),
      subscription: map['subscription']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoData.fromJson(String source) =>
      UserInfoData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfoData(id: $id, name: $name, email: $email, apiToken: $apiToken, customerId: $customerId, stripeId: $stripeId, trialEndsAt: $trialEndsAt, trialCountry: $trialCountry, cardCountry: $cardCountry, initialPlatform: $initialPlatform, subscription: $subscription)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInfoData &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.apiToken == apiToken &&
        other.customerId == customerId &&
        other.stripeId == stripeId &&
        other.trialEndsAt == trialEndsAt &&
        other.trialCountry == trialCountry &&
        other.cardCountry == cardCountry &&
        other.initialPlatform == initialPlatform &&
        other.subscription == subscription;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        apiToken.hashCode ^
        customerId.hashCode ^
        stripeId.hashCode ^
        trialEndsAt.hashCode ^
        trialCountry.hashCode ^
        cardCountry.hashCode ^
        initialPlatform.hashCode ^
        subscription.hashCode;
  }
}

T? typeConversion<T>(x) => x is T ? x : null;
