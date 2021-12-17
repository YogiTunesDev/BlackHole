import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'search_response.dart';

class SearchAllTracksResponse {
  SearchAllTracksResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<SearchAllTracksResponseData>? data;

  SearchAllTracksResponse copyWith({
    bool? status,
    int? statusCode,
    List<SearchAllTracksResponseData>? data,
  }) {
    return SearchAllTracksResponse(
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

  factory SearchAllTracksResponse.fromMap(Map<String, dynamic> map) {
    return SearchAllTracksResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<SearchAllTracksResponseData>.from(map['data']?.map((x) =>
              SearchAllTracksResponseData.fromMap(
                  x as Map<String, dynamic>)) as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllTracksResponse.fromJson(String source) =>
      SearchAllTracksResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchAllTracksResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllTracksResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SearchAllTracksResponseData {
  SearchAllTracksResponseData({
    this.id,
    this.name,
    this.albumId,
    this.album,
    this.files,
    this.bpm,
  });

  final int? id;
  final String? name;
  final int? albumId;
  final Album? album;
  final List<FileElement>? files;
  final BpmClass? bpm;

  SearchAllTracksResponseData copyWith({
    int? id,
    String? name,
    int? albumId,
    Album? album,
    List<FileElement>? files,
    BpmClass? bpm,
  }) {
    return SearchAllTracksResponseData(
      id: id ?? this.id,
      name: name ?? this.name,
      albumId: albumId ?? this.albumId,
      album: album ?? this.album,
      files: files ?? this.files,
      bpm: bpm ?? this.bpm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'albumId': albumId,
      'album': album?.toMap(),
      'files': files?.map((x) => x.toMap()).toList(),
      'bpm': bpm?.toMap(),
    };
  }

  factory SearchAllTracksResponseData.fromMap(Map<String, dynamic> map) {
    return SearchAllTracksResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      albumId: map['album_id'] != null ? map['album_id'] as int : null,
      album: map['album'] != null
          ? Album.fromMap(map['album'] as Map<String, dynamic>)
          : null,
      files: map['files'] != null
          ? List<FileElement>.from(map['files']
                  ?.map((x) => FileElement.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      bpm: map['bpm'] != null
          ? BpmClass.fromMap(map['bpm'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllTracksResponseData.fromJson(String source) =>
      SearchAllTracksResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchAllTracksResponseData(id: $id, name: $name, albumId: $albumId, album: $album, files: $files, bpm: $bpm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllTracksResponseData &&
        other.id == id &&
        other.name == name &&
        other.albumId == albumId &&
        other.album == album &&
        listEquals(other.files, files) &&
        other.bpm == bpm;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        albumId.hashCode ^
        album.hashCode ^
        files.hashCode ^
        bpm.hashCode;
  }
}
