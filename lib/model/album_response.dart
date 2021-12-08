import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'home_model.dart';

class AlbumResponse {
  final bool? status;
  final int? statusCode;
  final Data? data;
  AlbumResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  AlbumResponse copyWith({
    bool? status,
    int? statusCode,
    Data? data,
  }) {
    return AlbumResponse(
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

  factory AlbumResponse.fromMap(Map<String, dynamic> map) {
    return AlbumResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumResponse.fromJson(String source) =>
      AlbumResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AlbumResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlbumResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class Data {
  final int? currentPage;
  final List<AlbumData>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;
  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Data copyWith({
    int? currentPage,
    List<AlbumData>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) {
    return Data(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentPage': currentPage,
      'data': data?.map((x) => x.toMap()).toList(),
      'firstPageUrl': firstPageUrl,
      'from': from,
      'lastPage': lastPage,
      'lastPageUrl': lastPageUrl,
      'nextPageUrl': nextPageUrl,
      'path': path,
      'perPage': perPage,
      'prevPageUrl': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      currentPage:
          map['current_page'] != null ? map['current_page'] as int : null,
      data: map['data'] != null
          ? List<AlbumData>.from(
              map['data']?.map((x) => AlbumData.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>)
          : null,
      firstPageUrl: map['first_page_url'] != null
          ? map['first_page_url'] as String
          : null,
      from: map['from'] != null ? map['from'] as int : null,
      lastPage: map['last_page'] != null ? map['last_page'] as int : null,
      lastPageUrl:
          map['last_page_url'] != null ? map['last_page_url'] as String : null,
      nextPageUrl:
          map['next_page_url'] != null ? map['next_page_url'] as String : null,
      path: map['path'] != null ? map['path'] as String : null,
      perPage: map['per_page'] != null ? map['per_page'] as int : null,
      prevPageUrl:
          map['prev_page_url'] != null ? map['prev_page_url'] as String : null,
      to: map['to'] != null ? map['to'] as int : null,
      total: map['total'] != null ? map['total'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumData(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        other.currentPage == currentPage &&
        listEquals(other.data, data) &&
        other.firstPageUrl == firstPageUrl &&
        other.from == from &&
        other.lastPage == lastPage &&
        other.lastPageUrl == lastPageUrl &&
        other.nextPageUrl == nextPageUrl &&
        other.path == path &&
        other.perPage == perPage &&
        other.prevPageUrl == prevPageUrl &&
        other.to == to &&
        other.total == total;
  }

  @override
  int get hashCode {
    return currentPage.hashCode ^
        data.hashCode ^
        firstPageUrl.hashCode ^
        from.hashCode ^
        lastPage.hashCode ^
        lastPageUrl.hashCode ^
        nextPageUrl.hashCode ^
        path.hashCode ^
        perPage.hashCode ^
        prevPageUrl.hashCode ^
        to.hashCode ^
        total.hashCode;
  }
}

class AlbumData {
  AlbumData({
    this.id,
    this.name,
    this.description,
    this.artistId,
    this.albumDuration,
    this.cover,
    this.profile,
    this.tracks,
  });

  final int? id;
  final String? name;
  final String? description;
  final int? artistId;
  final String? albumDuration;
  final Cover? cover;
  final Profile? profile;
  final List<Track>? tracks;

  AlbumData copyWith({
    int? id,
    String? name,
    String? description,
    int? artistId,
    String? albumDuration,
    Cover? cover,
    Profile? profile,
    List<Track>? tracks,
  }) {
    return AlbumData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      artistId: artistId ?? this.artistId,
      albumDuration: albumDuration ?? this.albumDuration,
      cover: cover ?? this.cover,
      profile: profile ?? this.profile,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'artistId': artistId,
      'albumDuration': albumDuration,
      'cover': cover?.toMap(),
      'profile': profile?.toMap(),
      'tracks': tracks?.map((x) => x.toMap()).toList(),
    };
  }

  factory AlbumData.fromMap(Map<String, dynamic> map) {
    return AlbumData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      albumDuration: map['album_duration'] != null
          ? map['album_duration'] as String
          : null,
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

  factory AlbumData.fromJson(String source) =>
      AlbumData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumData(id: $id, name: $name, description: $description, artistId: $artistId, albumDuration: $albumDuration, cover: $cover, profile: $profile, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlbumData &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.artistId == artistId &&
        other.albumDuration == albumDuration &&
        other.cover == cover &&
        other.profile == profile &&
        listEquals(other.tracks, tracks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        artistId.hashCode ^
        albumDuration.hashCode ^
        cover.hashCode ^
        profile.hashCode ^
        tracks.hashCode;
  }
}
