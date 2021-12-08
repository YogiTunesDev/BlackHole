import 'dart:convert';

import 'package:flutter/foundation.dart';

class GenresResponse {
  final bool? status;
  final int? statusCode;
  final List<GenresData>? data;

  GenresResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  GenresResponse copyWith({
    bool? status,
    int? statusCode,
    List<GenresData>? data,
  }) {
    return GenresResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory GenresResponse.fromMap(Map<String, dynamic> map) {
    return GenresResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['statusCode'] != null ? map['statusCode'] as int : null,
      data: map['data'] != null
          ? List<GenresData>.from(map['data']
                  ?.map((x) => GenresData.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenresResponse.fromJson(String source) =>
      GenresResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GenresResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GenresResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class GenresData {
  final int? id;
  final String? name;
  GenresData({
    this.id,
    this.name,
  });

  GenresData copyWith({
    int? id,
    String? name,
  }) {
    return GenresData(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory GenresData.fromMap(Map<String, dynamic> map) {
    return GenresData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenresData.fromJson(String source) =>
      GenresData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GenresData(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GenresData && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
