import 'dart:convert';

class SubscriptionStatusResponse {
  SubscriptionStatusResponse({
    this.status,
    this.statusCode,
    this.data,
    this.message,
    this.initialPlatform,
    this.studioTeacher,
    this.validMobileSubscription,
  });

  final bool? status;
  final int? statusCode;
  final String? data;
  final String? message;
  final String? initialPlatform;
  final bool? studioTeacher;
  final bool? validMobileSubscription;

  SubscriptionStatusResponse copyWith({
    bool? status,
    int? statusCode,
    String? data,
    String? message,
    String? initialPlatform,
    bool? studioTeacher,
    bool? validMobileSubscription,
  }) {
    return SubscriptionStatusResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
      initialPlatform: initialPlatform ?? this.initialPlatform,
      studioTeacher: studioTeacher ?? this.studioTeacher,
      validMobileSubscription:
          validMobileSubscription ?? this.validMobileSubscription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data,
      'message': message,
      'initialPlatform': initialPlatform,
      'studioTeacher': studioTeacher,
      'validMobileSubscription': validMobileSubscription,
    };
  }

  factory SubscriptionStatusResponse.fromMap(Map<String, dynamic> map) {
    return SubscriptionStatusResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null ? map['data'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      initialPlatform: map['initial_platform'] != null
          ? map['initial_platform'] as String
          : null,
      studioTeacher:
          map['studio_teacher'] != null ? map['studio_teacher'] as bool : null,
      validMobileSubscription: map['valid_mobile_subscription'] != null
          ? map['valid_mobile_subscription'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionStatusResponse.fromJson(String source) =>
      SubscriptionStatusResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionStatusResponse(status: $status, statusCode: $statusCode, data: $data, message: $message, initialPlatform: $initialPlatform, studioTeacher: $studioTeacher, validMobileSubscription: $validMobileSubscription)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionStatusResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data &&
        other.message == message &&
        other.initialPlatform == initialPlatform &&
        other.studioTeacher == studioTeacher &&
        other.validMobileSubscription == validMobileSubscription;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        statusCode.hashCode ^
        data.hashCode ^
        message.hashCode ^
        initialPlatform.hashCode ^
        studioTeacher.hashCode ^
        validMobileSubscription.hashCode;
  }
}
