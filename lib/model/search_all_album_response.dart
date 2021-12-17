import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cover_model.dart';
import 'profile_model.dart';
import 'track_model.dart';



class SearchAllAlbumResponse {
  SearchAllAlbumResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<SearchAllAlbumResponseData>? data;

  SearchAllAlbumResponse copyWith({
    bool? status,
    int? statusCode,
    List<SearchAllAlbumResponseData>? data,
  }) {
    return SearchAllAlbumResponse(
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

  factory SearchAllAlbumResponse.fromMap(Map<String, dynamic> map) {
    return SearchAllAlbumResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['statusCode'] != null ? map['statusCode'] as int : null,
      data: map['data'] != null
          ? List<SearchAllAlbumResponseData>.from(map['data']?.map((x) =>
                  SearchAllAlbumResponseData.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllAlbumResponse.fromJson(String source) =>
      SearchAllAlbumResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchAllAlbumResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllAlbumResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SearchAllAlbumResponseData {
  SearchAllAlbumResponseData({
    this.id,
    this.name,
    this.artistId,
    this.cover,
    this.profile,
    this.tracks,
  });

  final int? id;
  final String? name;
  final int? artistId;
  final Cover? cover;
  final Profile? profile;
  final List<Track>? tracks;

  SearchAllAlbumResponseData copyWith({
    int? id,
    String? name,
    int? artistId,
    Cover? cover,
    Profile? profile,
    List<Track>? tracks,
  }) {
    return SearchAllAlbumResponseData(
      id: id ?? this.id,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      cover: cover ?? this.cover,
      profile: profile ?? this.profile,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistId': artistId,
      'cover': cover?.toMap(),
      'profile': profile?.toMap(),
      'tracks': tracks?.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchAllAlbumResponseData.fromMap(Map<String, dynamic> map) {
    return SearchAllAlbumResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      artistId: map['artistId'] != null ? map['artistId'] as int : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      tracks: map['tracks'] != null
          ? List<Track>.from(map['tracks']
                  ?.map((x) => Track.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllAlbumResponseData.fromJson(String source) =>
      SearchAllAlbumResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchAllAlbumResponseData(id: $id, name: $name, artistId: $artistId, cover: $cover, profile: $profile, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllAlbumResponseData &&
        other.id == id &&
        other.name == name &&
        other.artistId == artistId &&
        other.cover == cover &&
        other.profile == profile &&
        listEquals(other.tracks, tracks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        artistId.hashCode ^
        cover.hashCode ^
        profile.hashCode ^
        tracks.hashCode;
  }
}
