import 'dart:convert';

class ResetPasswordResponse {
  ResetPasswordResponse({
    this.status,
    this.statusCode,
    this.data,
    this.message,
  });

  final bool? status;
  final int? statusCode;
  final dynamic data;
  final String? message;

  ResetPasswordResponse copyWith({
    bool? status,
    int? statusCode,
    dynamic? data,
    String? message,
  }) {
    return ResetPasswordResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data,
      'message': message,
    };
  }

  factory ResetPasswordResponse.fromMap(Map<String, dynamic> map) {
    return ResetPasswordResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'],
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordResponse.fromJson(String source) =>
      ResetPasswordResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ResetPasswordResponse(status: $status, statusCode: $statusCode, data: $data, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResetPasswordResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data &&
        other.message == message;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        statusCode.hashCode ^
        data.hashCode ^
        message.hashCode;
  }
}
