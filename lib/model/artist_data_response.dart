import 'dart:convert';

import 'package:blackhole/util/const.dart';
import 'package:flutter/foundation.dart';

import 'playlist_response.dart';

class ArtistDataResponse {
  ArtistDataResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final ArtistDataResponseData? data;

  ArtistDataResponse copyWith({
    bool? status,
    int? statusCode,
    ArtistDataResponseData? data,
  }) {
    return ArtistDataResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data?.toMap(),
    };
  }

  factory ArtistDataResponse.fromMap(Map<String, dynamic> map) {
    return ArtistDataResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? ArtistDataResponseData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistDataResponse.fromJson(String source) =>
      ArtistDataResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ArtistDataResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArtistDataResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class ArtistDataResponseData {
  ArtistDataResponseData({
    this.id,
    this.name,
    this.description,
    this.topHits,
    this.playlists,
    this.cover,
    this.albums,
  });

  final int? id;
  final String? name;
  final String? description;
  final List<TracksOnly>? topHits;
  final List<Playlist>? playlists;
  final Cover? cover;
  final List<Album>? albums;

  ArtistDataResponseData copyWith({
    int? id,
    String? name,
    String? description,
    List<TracksOnly>? topHits,
    List<Playlist>? playlists,
    Cover? cover,
    List<Album>? albums,
  }) {
    return ArtistDataResponseData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      topHits: topHits ?? this.topHits,
      playlists: playlists ?? this.playlists,
      cover: cover ?? this.cover,
      albums: albums ?? this.albums,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'topHits': topHits?.map((x) => x.toMap()).toList(),
      'playlists': playlists?.map((x) => x.toMap()).toList(),
      'cover': cover?.toMap(),
      'albums': albums?.map((x) => x.toMap()).toList(),
    };
  }

  factory ArtistDataResponseData.fromMap(Map<String, dynamic> map) {
    return ArtistDataResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      topHits: map['top_hits'] != null
          ? List<TracksOnly>.from(map['top_hits']
                  ?.map((x) => TracksOnly.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      playlists: map['playlists'] != null
          ? List<Playlist>.from(map['playlists']
                  ?.map((x) => Playlist.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      albums: map['albums'] != null
          ? List<Album>.from(map['albums']
                  ?.map((x) => Album.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistDataResponseData.fromJson(String source) =>
      ArtistDataResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ArtistDataResponseData(id: $id, name: $name, description: $description, topHits: $topHits, playlists: $playlists, cover: $cover, albums: $albums)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArtistDataResponseData &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        listEquals(other.topHits, topHits) &&
        listEquals(other.playlists, playlists) &&
        other.cover == cover &&
        listEquals(other.albums, albums);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        topHits.hashCode ^
        playlists.hashCode ^
        cover.hashCode ^
        albums.hashCode;
  }
}

class Playlist {
  Playlist({
    // this.cover,
    this.id,
    this.creatorId,
    this.name,
    this.quadImages,
  });

  final int? id;
  final int? creatorId;
  final String? name;
  final List<QuadImage>? quadImages;
  // final Cover cover;

  Playlist copyWith({
    int? id,
    int? creatorId,
    String? name,
    List<QuadImage>? quadImages,
  }) {
    return Playlist(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      name: name ?? this.name,
      quadImages: quadImages ?? this.quadImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'name': name,
      'quadImages': quadImages?.map((x) => x.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] != null ? map['id'] as int : null,
      creatorId: map['creator_id'] != null ? map['creator_id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      quadImages: map['quadImages'] != null
          ? List<QuadImage>.from(map['quadImages']
                  ?.map((x) => QuadImage.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Playlist(id: $id, creatorId: $creatorId, name: $name, quadImages: $quadImages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Playlist &&
        other.id == id &&
        other.creatorId == creatorId &&
        other.name == name &&
        listEquals(other.quadImages, quadImages);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        creatorId.hashCode ^
        name.hashCode ^
        quadImages.hashCode;
  }
  List<String> getQuadImages() {
    List<String> lstStr = [];
    if (quadImages != null) {
      if (TOTALIMAGES == 0) {
        for (var i = 0; i < quadImages!.length; i++) {
          if (quadImages?[i].imageUrl != null &&
              quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            }
          }
        }
      } else {
        for (var i = 0; i < TOTALIMAGES; i++) {
          if (quadImages?[i].imageUrl != null &&
              quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            } else {
              lstStr.add('');
            }
          }else{
            lstStr.add('');
          }
        }
      }
    }
    return lstStr;
  }
}


// class TopHit {
//     TopHit({
//         this.id,
//         this.name,
//         this.duration,
//         this.albumId,
//         this.album,
//         this.files,
//         this.bpm,
//     });

//     final int? id;
//     final String? name;
//     final String? duration;
//     final int? albumId;
//     final Album? album;
//     final List<FileElement>? files;
//     final BpmClass? bpm;
// }