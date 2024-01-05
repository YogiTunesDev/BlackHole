import 'dart:convert';

import 'package:blackhole/util/const.dart';
import 'package:flutter/foundation.dart';

import 'quad_image_model.dart';
import 'search_response.dart';
import 'tag_model.dart';

class SearchAllPlaylistsResponse {
  SearchAllPlaylistsResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<SearchAllPlaylistsResponseData>? data;

  SearchAllPlaylistsResponse copyWith({
    bool? status,
    int? statusCode,
    List<SearchAllPlaylistsResponseData>? data,
  }) {
    return SearchAllPlaylistsResponse(
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

  factory SearchAllPlaylistsResponse.fromMap(Map<String, dynamic> map) {
    return SearchAllPlaylistsResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<SearchAllPlaylistsResponseData>.from(map['data']?.map((x) =>
              SearchAllPlaylistsResponseData.fromMap(
                  x as Map<String, dynamic>)) as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllPlaylistsResponse.fromJson(String source) =>
      SearchAllPlaylistsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchAllPlaylistsResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllPlaylistsResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SearchAllPlaylistsResponseData {
  SearchAllPlaylistsResponseData({
    this.id,
    this.name,
    this.userId,
    this.quadImages,
    this.playlistDuration,
    this.tracksOnly,
    this.tags,
  });

  final int? id;
  final String? name;
  final int? userId;
  final List<QuadImage>? quadImages;
  final String? playlistDuration;
  final List<TracksOnly>? tracksOnly;
  final List<Tag>? tags;

  SearchAllPlaylistsResponseData copyWith({
    int? id,
    String? name,
    int? userId,
    List<QuadImage>? quadImages,
    String? playlistDuration,
    List<TracksOnly>? tracksOnly,
    List<Tag>? tags,
  }) {
    return SearchAllPlaylistsResponseData(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      quadImages: quadImages ?? this.quadImages,
      playlistDuration: playlistDuration ?? this.playlistDuration,
      tracksOnly: tracksOnly ?? this.tracksOnly,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'quadImages': quadImages?.map((x) => x.toMap()).toList(),
      'playlistDuration': playlistDuration,
      'tracksOnly': tracksOnly?.map((x) => x.toMap()).toList(),
      'tags': tags?.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchAllPlaylistsResponseData.fromMap(Map<String, dynamic> map) {
    return SearchAllPlaylistsResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      quadImages: map['quadImages'] != null
          ? List<QuadImage>.from(map['quadImages']?.map((x) => x != null
              ? QuadImage.fromMap(x as Map<String, dynamic>)
              : QuadImage()) as Iterable<dynamic>)
          : null,
      playlistDuration: map['playlist_duration'] != null
          ? map['playlist_duration'] as String
          : null,
      tracksOnly: map['tracks_only'] != null
          ? List<TracksOnly>.from(map['tracks_only']
                  ?.map((x) => TracksOnly.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      tags: map['tags'] != null
          ? List<Tag>.from(
              map['tags']?.map((x) => Tag.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchAllPlaylistsResponseData.fromJson(String source) =>
      SearchAllPlaylistsResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchAllPlaylistsResponseData(id: $id, name: $name, userId: $userId, quadImages: $quadImages, playlistDuration: $playlistDuration, tracksOnly: $tracksOnly, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchAllPlaylistsResponseData &&
        other.id == id &&
        other.name == name &&
        other.userId == userId &&
        listEquals(other.quadImages, quadImages) &&
        other.playlistDuration == playlistDuration &&
        listEquals(other.tracksOnly, tracksOnly) &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        userId.hashCode ^
        quadImages.hashCode ^
        playlistDuration.hashCode ^
        tracksOnly.hashCode ^
        tags.hashCode;
  }

  List<String> getQuadImages() {
    List<String> lstStr = [];
    if (quadImages != null) {
      if (TOTALIMAGES == 0) {
        for (var i = 0; i < quadImages!.length; i++) {
          if (quadImages?[i].imageUrl != null && quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr.add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            }
          }
        }
      } else {
        for (var i = 0; i < TOTALIMAGES; i++) {
          if (quadImages?[i].imageUrl != null && quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr.add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            } else {
              lstStr.add(
                  'https://yogitunes-assets.s3.us-east-1.amazonaws.com/uploads/cover.jpg');
            }
          } else {
            lstStr.add(
                'https://yogitunes-assets.s3.us-east-1.amazonaws.com/uploads/cover.jpg');
          }
        }
      }
    }
    return lstStr;
  }
}
