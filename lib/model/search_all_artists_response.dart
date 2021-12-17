import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cover_model.dart';

class SearchAllArtistsResponse {
  SearchAllArtistsResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<SearchAllArtistsResponseData>? data;

  SearchAllArtistsResponse copyWith({
    bool? status,
    int? statusCode,
    List<SearchAllArtistsResponseData>? data,
  }) {
    return SearchAllArtistsResponse(
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

  factory SearchAllArtistsResponse.fromMap(Map<String, dynamic> map) {
    return SearchAllArtistsResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<SearchAllArtistsResponseData>.from(map['data']?.map((x) =>
              SearchAllArtistsResponseData.fromMap(
                  x as Map<String, dynamic>)) as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllArtistsResponse.fromJson(String source) =>
      SearchAllArtistsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchAllArtistsResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllArtistsResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SearchAllArtistsResponseData {
  SearchAllArtistsResponseData({
    this.id,
    this.name,
    this.description,
    this.cover,
  });

  final int? id;
  final String? name;
  final String? description;
  final Cover? cover;

  SearchAllArtistsResponseData copyWith({
    int? id,
    String? name,
    String? description,
    Cover? cover,
  }) {
    return SearchAllArtistsResponseData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cover': cover?.toMap(),
    };
  }

  factory SearchAllArtistsResponseData.fromMap(Map<String, dynamic> map) {
    return SearchAllArtistsResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllArtistsResponseData.fromJson(String source) =>
      SearchAllArtistsResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchAllArtistsResponseData(id: $id, name: $name, description: $description, cover: $cover)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllArtistsResponseData &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.cover == cover;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ cover.hashCode;
  }
}
