import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cover_model.dart';
import 'profile_model.dart';
import 'song_model.dart';
import 'tag_model.dart';
import 'track_model.dart';

class SingleAlbumResponse {
  final bool? status;
  final int? statusCode;
  final SingleAlbumData? data;
  SingleAlbumResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  SingleAlbumResponse copyWith({
    bool? status,
    int? statusCode,
    SingleAlbumData? data,
  }) {
    return SingleAlbumResponse(
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

  factory SingleAlbumResponse.fromMap(Map<String, dynamic> map) {
    return SingleAlbumResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? SingleAlbumData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleAlbumResponse.fromJson(String source) =>
      SingleAlbumResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SingleAlbumResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleAlbumResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SingleAlbumData {
  final int? id;
  final String? name;
  final String? description;
  final int? artistId;
  final String? albumDuration;
  final Cover? cover;
  final List<Tag>? tags;
  final Profile? profile;
  final List<Track>? tracks;
  final List<SongItemModel>? lstSongItemModel;
  SingleAlbumData({
    this.id,
    this.name,
    this.description,
    this.artistId,
    this.albumDuration,
    this.cover,
    this.tags,
    this.profile,
    this.tracks,
    this.lstSongItemModel,
  });

  SingleAlbumData copyWith({
    int? id,
    String? name,
    String? description,
    int? artistId,
    String? albumDuration,
    Cover? cover,
    List<Tag>? tags,
    Profile? profile,
    List<Track>? tracks,
    List<SongItemModel>? lstSongItemModel,
  }) {
    return SingleAlbumData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      artistId: artistId ?? this.artistId,
      albumDuration: albumDuration ?? this.albumDuration,
      cover: cover ?? this.cover,
      tags: tags ?? this.tags,
      profile: profile ?? this.profile,
      tracks: tracks ?? this.tracks,
      lstSongItemModel: lstSongItemModel ?? this.lstSongItemModel,
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
      'tags': tags?.map((x) => x.toMap()).toList(),
      'profile': profile?.toMap(),
      'tracks': tracks?.map((x) => x.toMap()).toList(),
      'lstSongItemModel': lstSongItemModel?.map((e) => e.toMap()).toList(),
    };
  }

  factory SingleAlbumData.fromMap(Map<String, dynamic> map) {
    return SingleAlbumData(
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
      tags: map['tags'] != null
          ? List<Tag>.from(
              map['tags']?.map((x) => Tag.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>)
          : null,
      profile: map['profile'] != null
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      tracks: map['tracks'] != null
          ? List<Track>.from(map['tracks']
                  ?.map((x) => Track.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      lstSongItemModel: map['lstSongItemModel'] != null
          ? List<SongItemModel>.from(map['lstSongItemModel']
                  ?.map((x) => SongItemModel.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleAlbumData.fromJson(String source) =>
      SingleAlbumData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleAlbumData(id: $id, name: $name, description: $description, artistId: $artistId, albumDuration: $albumDuration, cover: $cover, tags: $tags, profile: $profile, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleAlbumData &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.artistId == artistId &&
        other.albumDuration == albumDuration &&
        other.cover == cover &&
        listEquals(other.tags, tags) &&
        other.profile == profile &&
        listEquals(other.tracks, tracks) &&
        listEquals(other.lstSongItemModel, lstSongItemModel);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        artistId.hashCode ^
        albumDuration.hashCode ^
        cover.hashCode ^
        tags.hashCode ^
        profile.hashCode ^
        tracks.hashCode ^
        lstSongItemModel.hashCode;
  }
}
