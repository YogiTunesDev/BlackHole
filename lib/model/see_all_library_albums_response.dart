import 'dart:convert';

import 'package:collection/collection.dart';

import 'custom_playlist_response.dart';

class SeeAllLibraryAlbumsResponse {
  SeeAllLibraryAlbumsResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<SeeAllLibraryAlbumsResponseData>? data;

  SeeAllLibraryAlbumsResponse copyWith({
    bool? status,
    int? statusCode,
    List<SeeAllLibraryAlbumsResponseData>? data,
  }) {
    return SeeAllLibraryAlbumsResponse(
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

  factory SeeAllLibraryAlbumsResponse.fromMap(Map<String, dynamic> map) {
    return SeeAllLibraryAlbumsResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<SeeAllLibraryAlbumsResponseData>.from(map['data']?.map((x) =>
              SeeAllLibraryAlbumsResponseData.fromMap(
                  x as Map<String, dynamic>)) as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeeAllLibraryAlbumsResponse.fromJson(String source) =>
      SeeAllLibraryAlbumsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SeeAllLibraryAlbumsResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is SeeAllLibraryAlbumsResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SeeAllLibraryAlbumsResponseData {
  SeeAllLibraryAlbumsResponseData({
    this.id,
    this.itemId,
    this.userId,
    this.albumDuration,
    this.album,
    this.albumTracks,
  });

  final int? id;
  final int? itemId;
  final int? userId;
  final String? albumDuration;
  final Album? album;
  final List<AlbumTrack>? albumTracks;

  SeeAllLibraryAlbumsResponseData copyWith({
    int? id,
    int? itemId,
    int? userId,
    String? albumDuration,
    Album? album,
    List<AlbumTrack>? albumTracks,
  }) {
    return SeeAllLibraryAlbumsResponseData(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      albumDuration: albumDuration ?? this.albumDuration,
      album: album ?? this.album,
      albumTracks: albumTracks ?? this.albumTracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'userId': userId,
      'albumDuration': albumDuration,
      'album': album?.toMap(),
      'albumTracks': albumTracks?.map((x) => x.toMap()).toList(),
    };
  }

  factory SeeAllLibraryAlbumsResponseData.fromMap(Map<String, dynamic> map) {
    return SeeAllLibraryAlbumsResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      itemId: map['itemId'] != null ? map['itemId'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      albumDuration:
          map['albumDuration'] != null ? map['albumDuration'] as String : null,
      album: map['album'] != null
          ? Album.fromMap(map['album'] as Map<String, dynamic>)
          : null,
      albumTracks: map['albumTracks'] != null
          ? List<AlbumTrack>.from(map['albumTracks']
                  ?.map((x) => AlbumTrack.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeeAllLibraryAlbumsResponseData.fromJson(String source) =>
      SeeAllLibraryAlbumsResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SeeAllLibraryAlbumsResponseData(id: $id, itemId: $itemId, userId: $userId, albumDuration: $albumDuration, album: $album, albumTracks: $albumTracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is SeeAllLibraryAlbumsResponseData &&
        other.id == id &&
        other.itemId == itemId &&
        other.userId == userId &&
        other.albumDuration == albumDuration &&
        other.album == album &&
        listEquals(other.albumTracks, albumTracks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemId.hashCode ^
        userId.hashCode ^
        albumDuration.hashCode ^
        album.hashCode ^
        albumTracks.hashCode;
  }
}

class AlbumTrack {
  AlbumTrack({
    this.libraryId,
    this.albumId,
    this.trackId,
    this.order,
    this.track,
  });

  final int? libraryId;
  final int? albumId;
  final int? trackId;
  final int? order;
  final Track? track;

  AlbumTrack copyWith({
    int? libraryId,
    int? albumId,
    int? trackId,
    int? order,
    Track? track,
  }) {
    return AlbumTrack(
      libraryId: libraryId ?? this.libraryId,
      albumId: albumId ?? this.albumId,
      trackId: trackId ?? this.trackId,
      order: order ?? this.order,
      track: track ?? this.track,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'libraryId': libraryId,
      'albumId': albumId,
      'trackId': trackId,
      'order': order,
      'track': track?.toMap(),
    };
  }

  factory AlbumTrack.fromMap(Map<String, dynamic> map) {
    return AlbumTrack(
      libraryId: map['libraryId'] != null ? map['libraryId'] as int : null,
      albumId: map['albumId'] != null ? map['albumId'] as int : null,
      trackId: map['trackId'] != null ? map['trackId'] as int : null,
      order: map['order'] != null ? map['order'] as int : null,
      track: map['track'] != null
          ? Track.fromMap(map['track'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumTrack.fromJson(String source) =>
      AlbumTrack.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumTrack(libraryId: $libraryId, albumId: $albumId, trackId: $trackId, order: $order, track: $track)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlbumTrack &&
        other.libraryId == libraryId &&
        other.albumId == albumId &&
        other.trackId == trackId &&
        other.order == order &&
        other.track == track;
  }

  @override
  int get hashCode {
    return libraryId.hashCode ^
        albumId.hashCode ^
        trackId.hashCode ^
        order.hashCode ^
        track.hashCode;
  }
}
