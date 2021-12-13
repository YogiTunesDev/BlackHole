import 'dart:convert';

class ForgotPasswordVerificationResponse {
  ForgotPasswordVerificationResponse({
    this.status,
    this.statusCode,
    this.data,
    this.message,
    this.apiToken,
  });

  final bool? status;
  final int? statusCode;
  final dynamic data;
  final String? message;
  final String? apiToken;

  ForgotPasswordVerificationResponse copyWith({
    bool? status,
    int? statusCode,
    dynamic? data,
    String? message,
    String? apiToken,
  }) {
    return ForgotPasswordVerificationResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
      apiToken: apiToken ?? this.apiToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data,
      'message': message,
      'apiToken': apiToken,
    };
  }

  factory ForgotPasswordVerificationResponse.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordVerificationResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'],
      message: map['message'] != null ? map['message'] as String : null,
      apiToken: map['api_token'] != null ? map['api_token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ForgotPasswordVerificationResponse.fromJson(String source) =>
      ForgotPasswordVerificationResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ForgotPasswordVerificationResponse(status: $status, statusCode: $statusCode, data: $data, message: $message, apiToken: $apiToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ForgotPasswordVerificationResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data &&
        other.message == message &&
        other.apiToken == apiToken;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        statusCode.hashCode ^
        data.hashCode ^
        message.hashCode ^
        apiToken.hashCode;
  }
}
