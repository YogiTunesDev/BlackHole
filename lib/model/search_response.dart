import 'dart:convert';

import 'package:blackhole/util/const.dart';
import 'package:flutter/foundation.dart';

import 'cover_model.dart';
import 'quad_image_model.dart';
import 'tag_model.dart';

class SearchResponse {
  SearchResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final SearchResponsesData? data;

  SearchResponse copyWith({
    bool? status,
    int? statusCode,
    SearchResponsesData? data,
  }) {
    return SearchResponse(
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

  factory SearchResponse.fromMap(Map<String, dynamic> map) {
    return SearchResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? SearchResponsesData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchResponse.fromJson(String source) =>
      SearchResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SearchResponsesData {
  SearchResponsesData({
    this.tracks,
    this.albums,
    this.playlists,
    this.artists,
  });

  final List<Track>? tracks;
  final List<Album>? albums;
  final List<Playlist>? playlists;
  final List<Artist>? artists;

  SearchResponsesData copyWith({
    List<Track>? tracks,
    List<Album>? albums,
    List<Playlist>? playlists,
    List<Artist>? artists,
  }) {
    return SearchResponsesData(
      tracks: tracks ?? this.tracks,
      albums: albums ?? this.albums,
      playlists: playlists ?? this.playlists,
      artists: artists ?? this.artists,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tracks': tracks?.map((x) => x.toMap()).toList(),
      'albums': albums?.map((x) => x.toMap()).toList(),
      'playlists': playlists?.map((x) => x.toMap()).toList(),
      'artists': artists?.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchResponsesData.fromMap(Map<String, dynamic> map) {
    return SearchResponsesData(
      tracks: map['tracks'] != null
          ? List<Track>.from(map['tracks']
                  ?.map((x) => Track.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      albums: map['albums'] != null
          ? List<Album>.from(map['albums']
                  ?.map((x) => Album.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      playlists: map['playlists'] != null
          ? List<Playlist>.from(map['playlists']
                  ?.map((x) => Playlist.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      artists: map['artists'] != null
          ? List<Artist>.from(map['artists']
                  ?.map((x) => Artist.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchResponsesData.fromJson(String source) =>
      SearchResponsesData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchResponsesData(tracks: $tracks, albums: $albums, playlists: $playlists, artists: $artists)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchResponsesData &&
        listEquals(other.tracks, tracks) &&
        listEquals(other.albums, albums) &&
        listEquals(other.playlists, playlists) &&
        listEquals(other.artists, artists);
  }

  @override
  int get hashCode {
    return tracks.hashCode ^
        albums.hashCode ^
        playlists.hashCode ^
        artists.hashCode;
  }
}

class Artist {
  Artist({
    this.id,
    this.name,
    this.description,
    this.cover,
  });

  final int? id;
  final String? name;
  final String? description;
  final Cover? cover;

  Artist copyWith({
    int? id,
    String? name,
    String? description,
    Cover? cover,
  }) {
    return Artist(
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

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
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

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, description: $description, cover: $cover)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Artist &&
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

class Playlist {
  Playlist({
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

  Playlist copyWith({
    int? id,
    String? name,
    int? userId,
    List<QuadImage>? quadImages,
    String? playlistDuration,
    List<TracksOnly>? tracksOnly,
    List<Tag>? tags,
  }) {
    return Playlist(
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

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
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

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, userId: $userId, quadImages: $quadImages, playlistDuration: $playlistDuration, tracksOnly: $tracksOnly, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Playlist &&
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
              lstStr.add('');
            }
          } else {
            lstStr.add('');
          }
        }
      }
    }
    return lstStr;
  }
}

class TracksOnly {
  TracksOnly({
    this.id,
    this.albumId,
    this.name,
    this.duration,
    this.album,
    this.files,
    this.bpm,
  });

  final int? id;
  final int? albumId;
  final String? name;
  final String? duration;
  final Album? album;
  final List<FileElement>? files;
  final BpmClass? bpm;

  TracksOnly copyWith({
    int? id,
    int? albumId,
    String? name,
    String? duration,
    Album? album,
    List<FileElement>? files,
    BpmClass? bpm,
  }) {
    return TracksOnly(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      album: album ?? this.album,
      files: files ?? this.files,
      bpm: bpm ?? this.bpm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'albumId': albumId,
      'name': name,
      'duration': duration,
      'album': album?.toMap(),
      'files': files?.map((x) => x.toMap()).toList(),
      'bpm': bpm?.toMap(),
    };
  }

  factory TracksOnly.fromMap(Map<String, dynamic> map) {
    return TracksOnly(
      id: map['id'] != null ? map['id'] as int : null,
      albumId: map['album_id'] != null ? map['album_id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
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

  factory TracksOnly.fromJson(String source) =>
      TracksOnly.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TracksOnly(id: $id, albumId: $albumId, name: $name, duration: $duration, album: $album, files: $files, bpm: $bpm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TracksOnly &&
        other.id == id &&
        other.albumId == albumId &&
        other.name == name &&
        other.duration == duration &&
        other.album == album &&
        listEquals(other.files, files) &&
        other.bpm == bpm;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        albumId.hashCode ^
        name.hashCode ^
        duration.hashCode ^
        album.hashCode ^
        files.hashCode ^
        bpm.hashCode;
  }
}

class Album {
  Album({
    this.id,
    this.artistId,
    this.name,
    this.cover,
    this.profile,
  });

  final int? id;
  final int? artistId;
  final String? name;
  final Cover? cover;
  final Artist? profile;

  Album copyWith({
    int? id,
    int? artistId,
    String? name,
    Cover? cover,
    Artist? profile,
  }) {
    return Album(
      id: id ?? this.id,
      artistId: artistId ?? this.artistId,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'artistId': artistId,
      'name': name,
      'cover': cover?.toMap(),
      'profile': profile?.toMap(),
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] != null ? map['id'] as int : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? Artist.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Album(id: $id, artistId: $artistId, name: $name, cover: $cover, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Album &&
        other.id == id &&
        other.artistId == artistId &&
        other.name == name &&
        other.cover == cover &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        artistId.hashCode ^
        name.hashCode ^
        cover.hashCode ^
        profile.hashCode;
  }
}

class BpmClass {
  BpmClass({
    this.trackId,
    this.bpm,
  });

  final int? trackId;
  final String? bpm;

  BpmClass copyWith({
    int? trackId,
    String? bpm,
  }) {
    return BpmClass(
      trackId: trackId ?? this.trackId,
      bpm: bpm ?? this.bpm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'bpm': bpm,
    };
  }

  factory BpmClass.fromMap(Map<String, dynamic> map) {
    return BpmClass(
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      bpm: map['bpm'] != null ? map['bpm'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BpmClass.fromJson(String source) =>
      BpmClass.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BpmClass(trackId: $trackId, bpm: $bpm)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BpmClass && other.trackId == trackId && other.bpm == bpm;
  }

  @override
  int get hashCode => trackId.hashCode ^ bpm.hashCode;
}

class FileElement {
  FileElement({
    this.id,
    this.trackId,
    this.format,
    this.bitrate,
    this.trackUrl,
  });

  final int? id;
  final int? trackId;
  final String? format;
  final int? bitrate;
  final String? trackUrl;

  FileElement copyWith({
    int? id,
    int? trackId,
    String? format,
    int? bitrate,
    String? trackUrl,
  }) {
    return FileElement(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      format: format ?? this.format,
      bitrate: bitrate ?? this.bitrate,
      trackUrl: trackUrl ?? this.trackUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trackId': trackId,
      'format': format,
      'bitrate': bitrate,
      'trackUrl': trackUrl,
    };
  }

  factory FileElement.fromMap(Map<String, dynamic> map) {
    return FileElement(
      id: map['id'] != null ? map['id'] as int : null,
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      format: map['format'] != null ? map['format'] as String : null,
      bitrate: map['bitrate'] != null ? map['bitrate'] as int : null,
      trackUrl: map['track_url'] != null ? map['track_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileElement.fromJson(String source) =>
      FileElement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FileElement(id: $id, trackId: $trackId, format: $format, bitrate: $bitrate, trackUrl: $trackUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileElement &&
        other.id == id &&
        other.trackId == trackId &&
        other.format == format &&
        other.bitrate == bitrate &&
        other.trackUrl == trackUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        trackId.hashCode ^
        format.hashCode ^
        bitrate.hashCode ^
        trackUrl.hashCode;
  }
}

class Track {
  Track({
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

  Track copyWith({
    int? id,
    String? name,
    int? albumId,
    Album? album,
    List<FileElement>? files,
    BpmClass? bpm,
  }) {
    return Track(
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

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
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

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track(id: $id, name: $name, albumId: $albumId, album: $album, files: $files, bpm: $bpm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Track &&
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
