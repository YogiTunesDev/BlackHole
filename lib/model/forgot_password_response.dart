import 'dart:convert';

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final String? data;

  ForgotPasswordResponse copyWith({
    bool? status,
    int? statusCode,
    String? data,
  }) {
    return ForgotPasswordResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data,
    };
  }

  factory ForgotPasswordResponse.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null ? map['data'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ForgotPasswordResponse.fromJson(String source) =>
      ForgotPasswordResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ForgotPasswordResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ForgotPasswordResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}
