import 'dart:convert';

class LoginResponse {
  LoginResponse({
    this.status,
    this.statusCode,
    this.data,
    this.message,
    this.apiToken,
    this.id,
  });

  final bool? status;
  final int? statusCode;
  final dynamic data;
  final String? message;
  final String? apiToken;
  final int? id;

  LoginResponse copyWith({
    bool? status,
    int? statusCode,
    dynamic? data,
    String? message,
    String? apiToken,
    int? id,
  }) {
    return LoginResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
      apiToken: apiToken ?? this.apiToken,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data,
      'message': message,
      'apiToken': apiToken,
      'id': id,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'],
      message: map['message'] != null ? map['message'] as String : null,
      apiToken: map['api_token'] != null ? map['api_token'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LoginResponse(status: $status, statusCode: $statusCode, data: $data, message: $message, apiToken: $apiToken, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data &&
        other.message == message &&
        other.apiToken == apiToken &&
        other.id == id;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        statusCode.hashCode ^
        data.hashCode ^
        message.hashCode ^
        apiToken.hashCode ^
        id.hashCode;
  }
}
