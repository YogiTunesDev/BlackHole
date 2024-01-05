import 'dart:convert';
import 'dart:developer';

import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/util/const.dart';
import 'package:flutter/foundation.dart';

import 'cover_model.dart';
import 'profile_model.dart';
import 'quad_image_model.dart';
import 'tag_model.dart';

class SinglePlaylistResponse {
  final bool? status;
  final int? statusCode;
  final SinglePlaylistData? data;

  SinglePlaylistResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  SinglePlaylistResponse copyWith({
    bool? status,
    int? statusCode,
    SinglePlaylistData? data,
  }) {
    return SinglePlaylistResponse(
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

  factory SinglePlaylistResponse.fromMap(Map<String, dynamic> map) {
    try {
      return SinglePlaylistResponse(
        status: map['status'] != null ? map['status'] as bool : null,
        statusCode:
            map['status_code'] != null ? map['status_code'] as int : null,
        data: map['data'] != null
            ? SinglePlaylistData.fromMap(map['data'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      log('Error in 1  : $e');
    }
    return SinglePlaylistResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? SinglePlaylistData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SinglePlaylistResponse.fromJson(String source) =>
      SinglePlaylistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SinglePlaylistResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SinglePlaylistResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class SinglePlaylistData {
  final int? id;
  final String? name;
  final String? description;
  final int? userId;
  final int? creatorId;
  final bool? byop;
  final String? playlistDuration;
  final List<QuadImage?>? quadImages;
  final Profile? profile;
  final List<Tag>? tags;
  final List<PlaylistTracks>? playlistTracks;
  final List<Tracks>? tracks;
  final List<SongItemModel>? lstSongItemModel;

  SinglePlaylistData({
    this.id,
    this.name,
    this.description,
    this.userId,
    this.creatorId,
    this.byop,
    this.playlistDuration,
    this.quadImages,
    this.profile,
    this.tags,
    this.playlistTracks,
    this.tracks,
    this.lstSongItemModel,
  });

  SinglePlaylistData copyWith({
    int? id,
    String? name,
    String? description,
    int? userId,
    int? creatorId,
    bool? byop,
    String? playlistDuration,
    List<QuadImage?>? quadImages,
    Profile? profile,
    List<Tag>? tags,
    List<PlaylistTracks>? playlistTracks,
    List<Tracks>? tracks,
    List<SongItemModel>? lstSongItemModel,
  }) {
    return SinglePlaylistData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      creatorId: creatorId ?? this.creatorId,
      byop: byop ?? this.byop,
      playlistDuration: playlistDuration ?? this.playlistDuration,
      quadImages: quadImages ?? this.quadImages,
      profile: profile ?? this.profile,
      tags: tags ?? this.tags,
      playlistTracks: playlistTracks ?? this.playlistTracks,
      tracks: tracks ?? this.tracks,
      lstSongItemModel: lstSongItemModel ?? this.lstSongItemModel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'creatorId': creatorId,
      'byop': byop,
      'playlistDuration': playlistDuration,
      'quadImages': quadImages?.map((x) => x?.toMap()).toList(),
      'profile': profile?.toMap(),
      'tags': tags?.map((x) => x.toMap()).toList(),
      'playlistTracks': playlistTracks?.map((x) => x.toMap()).toList(),
      'tracks': tracks?.map((x) => x.toMap()).toList(),
      'lstSongItemModel': lstSongItemModel?.map((e) => e.toMap()).toList(),
    };
  }

  factory SinglePlaylistData.fromMap(Map<String, dynamic> map) {
    try {
      return SinglePlaylistData(
        id: map['id'] != null ? map['id'] as int : null,
        name: map['name'] != null ? map['name'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        userId: map['user_id'] != null ? map['user_id'] as int : null,
        creatorId: map['creator_id'] != null ? map['creator_id'] as int : null,
        byop: map['byop'] != null ? map['byop'] as bool : null,
        playlistDuration: map['playlist_duration'] != null
            ? map['playlist_duration'] as String
            : null,
        quadImages: map['quadImages'] != null
            ? map['quadImages'].toString() != 'null'
                ? List<QuadImage?>.from(map['quadImages']?.map((x) => x != null
                    ? QuadImage.fromMap(x as Map<String, dynamic>)
                    : null) as Iterable<dynamic>)
                : null
            : null,
        // map['quadImages'] != null
        //     ? map['quadImages'].toString() != 'null'
        //         ? List<QuadImage>.from(map['quadImages']?.map((x) => x != null
        //             ? QuadImage.fromMap(x as Map<String, dynamic>)
        //             : QuadImage()) as Iterable<dynamic>)
        //         : null
        //     : null,
        profile: map['profile'] != null
            ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
            : null,
        tags: map['tags'] != null
            ? List<Tag>.from(
                map['tags']?.map((x) => Tag.fromMap(x as Map<String, dynamic>))
                    as Iterable<dynamic>)
            : null,
        playlistTracks: map['playlist_tracks'] != null
            ? List<PlaylistTracks>.from(map['playlist_tracks']?.map(
                    (x) => PlaylistTracks.fromMap(x as Map<String, dynamic>))
                as Iterable<dynamic>)
            : null,
        tracks: map['tracks'] != null
            ? List<Tracks>.from(map['tracks']
                    ?.map((x) => Tracks.fromMap(x as Map<String, dynamic>))
                as Iterable<dynamic>)
            : null,
        lstSongItemModel: map['lstSongItemModel'] != null
            ? List<SongItemModel>.from(map['lstSongItemModel']?.map(
                    (x) => SongItemModel.fromMap(x as Map<String, dynamic>))
                as Iterable<dynamic>)
            : null,
      );
    } catch (e) {
      log('Error in 2  : $e');
    }
    return SinglePlaylistData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      creatorId: map['creator_id'] != null ? map['creator_id'] as int : null,
      byop: map['byop'] != null ? map['byop'] as bool : null,
      playlistDuration: map['playlist_duration'] != null
          ? map['playlist_duration'] as String
          : null,
      quadImages: map['quadImages'] != null
          ? map['quadImages'].toString() != 'null'
              ? List<QuadImage?>.from(map['quadImages']?.map((x) => x != null
                  ? QuadImage.fromMap(x as Map<String, dynamic>)
                  : null) as Iterable<dynamic>)
              : null
          : null,
      // map['quadImages'] != null
      //     ? map['quadImages'].toString() != 'null'
      //         ? List<QuadImage>.from(map['quadImages']?.map((x) => x != null
      //             ? QuadImage.fromMap(x as Map<String, dynamic>)
      //             : QuadImage()) as Iterable<dynamic>)
      //         : null
      //     : null,
      profile: map['profile'] != null
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      tags: map['tags'] != null
          ? List<Tag>.from(
              map['tags']?.map((x) => Tag.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>)
          : null,
      playlistTracks: map['playlist_tracks'] != null
          ? List<PlaylistTracks>.from(map['playlist_tracks']?.map(
                  (x) => PlaylistTracks.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      tracks: map['tracks'] != null
          ? List<Tracks>.from(map['tracks']
                  ?.map((x) => Tracks.fromMap(x as Map<String, dynamic>))
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

  factory SinglePlaylistData.fromJson(String source) =>
      SinglePlaylistData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SinglePlaylistData(id: $id, name: $name, description: $description, userId: $userId, creatorId: $creatorId, byop: $byop, playlistDuration: $playlistDuration, quadImages: $quadImages, profile: $profile, tags: $tags, playlistTracks: $playlistTracks, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SinglePlaylistData &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.userId == userId &&
        other.creatorId == creatorId &&
        other.byop == byop &&
        other.playlistDuration == playlistDuration &&
        listEquals(other.quadImages, quadImages) &&
        other.profile == profile &&
        listEquals(other.tags, tags) &&
        listEquals(other.playlistTracks, playlistTracks) &&
        listEquals(other.tracks, tracks) &&
        listEquals(other.lstSongItemModel, lstSongItemModel);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        creatorId.hashCode ^
        byop.hashCode ^
        playlistDuration.hashCode ^
        quadImages.hashCode ^
        profile.hashCode ^
        tags.hashCode ^
        playlistTracks.hashCode ^
        tracks.hashCode ^
        lstSongItemModel.hashCode;
  }

  List<String> getQuadImages() {
    List<String> lstStr = [];
    if (quadImages != null) {
      if (TOTALIMAGES == 0) {
        for (var i = 0; i < quadImages!.length; i++) {
          if (quadImages?[i]?.imageUrl != null &&
              quadImages?[i]?.image != null) {
            if (quadImages![i]!.imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i]!.imageUrl}/${quadImages![i]!.image}');
            }
          }
        }
      } else {
        for (var i = 0; i < TOTALIMAGES; i++) {
          if (quadImages?[i]?.imageUrl != null &&
              quadImages?[i]?.image != null) {
            if (quadImages![i]!.imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i]!.imageUrl}/${quadImages![i]!.image}');
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

class PlaylistTracks {
  final int? trackId;
  final int? playlistId;
  final int? order;
  final Track? track;

  PlaylistTracks({
    this.trackId,
    this.playlistId,
    this.order,
    this.track,
  });

  PlaylistTracks copyWith({
    int? trackId,
    int? playlistId,
    int? order,
    Track? track,
  }) {
    return PlaylistTracks(
      trackId: trackId ?? this.trackId,
      playlistId: playlistId ?? this.playlistId,
      order: order ?? this.order,
      track: track ?? this.track,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'playlistId': playlistId,
      'order': order,
      'track': track?.toMap(),
    };
  }

  factory PlaylistTracks.fromMap(Map<String, dynamic> map) {
    try {
      return PlaylistTracks(
        trackId: map['track_id'] != null ? map['track_id'] as int : null,
        playlistId:
            map['playlist_id'] != null ? map['playlist_id'] as int : null,
        order: map['order'] != null ? map['order'] as int : null,
        track: map['track'] != null
            ? Track.fromMap(map['track'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      log('Error in 6  : $e');
    }

    return PlaylistTracks(
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      playlistId: map['playlist_id'] != null ? map['playlist_id'] as int : null,
      order: map['order'] != null ? map['order'] as int : null,
      track: map['track'] != null
          ? Track.fromMap(map['track'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistTracks.fromJson(String source) =>
      PlaylistTracks.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistTracks(trackId: $trackId, playlistId: $playlistId, order: $order, track: $track)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaylistTracks &&
        other.trackId == trackId &&
        other.playlistId == playlistId &&
        other.order == order &&
        other.track == track;
  }

  @override
  int get hashCode {
    return trackId.hashCode ^
        playlistId.hashCode ^
        order.hashCode ^
        track.hashCode;
  }
}

class Track {
  final int? id;
  final int? albumId;
  final String? name;
  final String? duration;
  final PLaylistTrackAlbum? album;
  final List<Files>? files;
  final Bpm? bpm;
  final SongItemModel? songItemModel;

  Track({
    this.id,
    this.albumId,
    this.name,
    this.duration,
    this.album,
    this.files,
    this.bpm,
    this.songItemModel,
  });

  Track copyWith({
    int? id,
    int? albumId,
    String? name,
    String? duration,
    PLaylistTrackAlbum? album,
    List<Files>? files,
    Bpm? bpm,
    SongItemModel? songItemModel,
  }) {
    return Track(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      album: album ?? this.album,
      files: files ?? this.files,
      bpm: bpm ?? this.bpm,
      songItemModel: songItemModel ?? this.songItemModel,
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
      'songItemModel': songItemModel?.toMap(),
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] != null ? map['id'] as int : null,
      albumId: map['albumId'] != null ? map['albumId'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      album: map['album'] != null
          ? PLaylistTrackAlbum.fromMap(map['album'] as Map<String, dynamic>)
          : null,
      files: map['files'] != null
          ? List<Files>.from(
              map['files']?.map((x) => Files.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>)
          : null,
      bpm: map['bpm'] != null
          ? Bpm.fromMap(map['bpm'] as Map<String, dynamic>)
          : null,
      songItemModel: map['songItemModel'] != null
          ? SongItemModel.fromMap(map['songItemModel'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track(id: $id, albumId: $albumId, name: $name, duration: $duration, album: $album, files: $files, bpm: $bpm, songItemModel: $songItemModel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Track &&
        other.id == id &&
        other.albumId == albumId &&
        other.name == name &&
        other.duration == duration &&
        other.album == album &&
        listEquals(other.files, files) &&
        other.bpm == bpm &&
        other.songItemModel == songItemModel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        albumId.hashCode ^
        name.hashCode ^
        duration.hashCode ^
        album.hashCode ^
        files.hashCode ^
        bpm.hashCode ^
        songItemModel.hashCode;
  }
}

class Bpm {
  final int? trackId;
  final String? bpm;

  Bpm({
    this.trackId,
    this.bpm,
  });

  Bpm copyWith({
    int? trackId,
    String? bpm,
  }) {
    return Bpm(
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

  factory Bpm.fromMap(Map<String, dynamic> map) {
    return Bpm(
      trackId: map['trackId'] != null ? map['trackId'] as int : null,
      bpm: map['bpm'] != null ? map['bpm'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bpm.fromJson(String source) =>
      Bpm.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Bpm(trackId: $trackId, bpm: $bpm)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bpm && other.trackId == trackId && other.bpm == bpm;
  }

  @override
  int get hashCode => trackId.hashCode ^ bpm.hashCode;
}

class PLaylistTrackAlbum {
  final int? id;
  final int? artistId;
  final String? name;
  final Cover? cover;
  final Profile? profile;

  PLaylistTrackAlbum({
    this.id,
    this.artistId,
    this.name,
    this.cover,
    this.profile,
  });

  PLaylistTrackAlbum copyWith({
    int? id,
    int? artistId,
    String? name,
    Cover? cover,
    Profile? profile,
  }) {
    return PLaylistTrackAlbum(
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

  factory PLaylistTrackAlbum.fromMap(Map<String, dynamic> map) {
    return PLaylistTrackAlbum(
      id: map['id'] != null ? map['id'] as int : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PLaylistTrackAlbum.fromJson(String source) =>
      PLaylistTrackAlbum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PLaylistTrackAlbum(id: $id, artistId: $artistId, name: $name, cover: $cover, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PLaylistTrackAlbum &&
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

class Files {
  final int? id;
  final int? trackId;
  final String? format;
  final int? bitrate;
  final String? trackUrl;

  Files({
    this.id,
    this.trackId,
    this.format,
    this.bitrate,
    this.trackUrl,
  });

  Files copyWith({
    int? id,
    int? trackId,
    String? format,
    int? bitrate,
    String? trackUrl,
  }) {
    return Files(
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

  factory Files.fromMap(Map<String, dynamic> map) {
    return Files(
      id: map['id'] != null ? map['id'] as int : null,
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      format: map['format'] != null ? map['format'] as String : null,
      bitrate: map['bitrate'] != null ? map['bitrate'] as int : null,
      trackUrl: map['track_url'] != null ? map['track_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Files.fromJson(String source) =>
      Files.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Files(id: $id, trackId: $trackId, format: $format, bitrate: $bitrate, trackUrl: $trackUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Files &&
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

class Tracks {
  final int? id;
  final String? name;
  final String? artistString;
  final String? duration;
  final String? isrc;
  final String? upc;
  final int? albumId;
  final String? createdAt;
  final String? updatedAt;
  final int? audiosaladTrackId;
  final String? userType;
  final int? userId;
  final String? waveform;
  final String? audiosaladCache;
  final String? priceInCents;
  final String? externalStreamUrl;
  final String? deletedAt;
  final Album? album;

  Tracks({
    this.id,
    this.name,
    this.artistString,
    this.duration,
    this.isrc,
    this.upc,
    this.albumId,
    this.createdAt,
    this.updatedAt,
    this.audiosaladTrackId,
    this.userType,
    this.userId,
    this.waveform,
    this.audiosaladCache,
    this.priceInCents,
    this.externalStreamUrl,
    this.deletedAt,
    this.album,
  });

  Tracks copyWith({
    int? id,
    String? name,
    String? artistString,
    String? duration,
    String? isrc,
    String? upc,
    int? albumId,
    String? createdAt,
    String? updatedAt,
    int? audiosaladTrackId,
    String? userType,
    int? userId,
    String? waveform,
    String? audiosaladCache,
    String? priceInCents,
    String? externalStreamUrl,
    String? deletedAt,
    Album? album,
  }) {
    return Tracks(
      id: id ?? this.id,
      name: name ?? this.name,
      artistString: artistString ?? this.artistString,
      duration: duration ?? this.duration,
      isrc: isrc ?? this.isrc,
      upc: upc ?? this.upc,
      albumId: albumId ?? this.albumId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      audiosaladTrackId: audiosaladTrackId ?? this.audiosaladTrackId,
      userType: userType ?? this.userType,
      userId: userId ?? this.userId,
      waveform: waveform ?? this.waveform,
      audiosaladCache: audiosaladCache ?? this.audiosaladCache,
      priceInCents: priceInCents ?? this.priceInCents,
      externalStreamUrl: externalStreamUrl ?? this.externalStreamUrl,
      deletedAt: deletedAt ?? this.deletedAt,
      album: album ?? this.album,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistString': artistString,
      'duration': duration,
      'isrc': isrc,
      'upc': upc,
      'albumId': albumId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'audiosaladTrackId': audiosaladTrackId,
      'userType': userType,
      'userId': userId,
      'waveform': waveform,
      'audiosaladCache': audiosaladCache,
      'priceInCents': priceInCents,
      'externalStreamUrl': externalStreamUrl,
      'deletedAt': deletedAt,
      'album': album?.toMap(),
    };
  }

  factory Tracks.fromMap(Map<String, dynamic> map) {
    try {
      return Tracks(
        id: map['id'] != null ? map['id'] as int : null,
        name: map['name'] != null ? map['name'] as String : null,
        artistString: map['artist_string'] != null
            ? map['artist_string'] as String
            : null,
        duration: map['duration'] != null ? map['duration'] as String : null,
        isrc: map['isrc'] != null ? map['isrc'] as String : null,
        upc: map['upc'] != null ? map['upc'] as String : null,
        albumId: map['album_id'] != null ? map['album_id'] as int : null,
        createdAt:
            map['created_at'] != null ? map['created_at'] as String : null,
        updatedAt:
            map['updated_at'] != null ? map['updated_at'] as String : null,
        audiosaladTrackId: map['audiosalad_track_id'] != null
            ? map['audiosalad_track_id'] as int
            : null,
        userType: map['user_type'] != null ? map['user_type'] as String : null,
        userId: map['user_id'] != null ? map['user_id'] as int : null,
        waveform: map['waveform'] != null ? map['waveform'] as String : null,
        audiosaladCache: map['audiosalad_cache'] != null
            ? map['audiosalad_cache'].toString()
            : null,
        priceInCents: map['price_in_cents'] != null
            ? map['price_in_cents'].toString()
            : null,
        externalStreamUrl: map['external_stream_url'] != null
            ? map['external_stream_url'] as String
            : null,
        deletedAt:
            map['deleted_at'] != null ? map['deleted_at'] as String : null,
        album: map['album'] != null
            ? Album.fromMap(map['album'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      log('Error in 7  : $e');
    }

    return Tracks(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      artistString:
          map['artist_string'] != null ? map['artist_string'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      isrc: map['isrc'] != null ? map['isrc'] as String : null,
      upc: map['upc'] != null ? map['upc'] as String : null,
      albumId: map['album_id'] != null ? map['album_id'] as int : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      audiosaladTrackId: map['audiosalad_track_id'] != null
          ? map['audiosalad_track_id'] as int
          : null,
      userType: map['user_type'] != null ? map['user_type'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      waveform: map['waveform'] != null ? map['waveform'] as String : null,
      audiosaladCache: map['audiosalad_cache'] != null
          ? map['audiosalad_cache'] as String
          : null,
      priceInCents: map['price_in_cents'] != null
          ? map['price_in_cents'] as String
          : null,
      externalStreamUrl: map['external_stream_url'] != null
          ? map['external_stream_url'] as String
          : null,
      deletedAt: map['deleted_at'] != null ? map['deleted_at'] as String : null,
      album: map['album'] != null
          ? Album.fromMap(map['album'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tracks.fromJson(String source) =>
      Tracks.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tracks(id: $id, name: $name, artistString: $artistString, duration: $duration, isrc: $isrc, upc: $upc, albumId: $albumId, createdAt: $createdAt, updatedAt: $updatedAt, audiosaladTrackId: $audiosaladTrackId, userType: $userType, userId: $userId, waveform: $waveform, audiosaladCache: $audiosaladCache, priceInCents: $priceInCents, externalStreamUrl: $externalStreamUrl, deletedAt: $deletedAt, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tracks &&
        other.id == id &&
        other.name == name &&
        other.artistString == artistString &&
        other.duration == duration &&
        other.isrc == isrc &&
        other.upc == upc &&
        other.albumId == albumId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.audiosaladTrackId == audiosaladTrackId &&
        other.userType == userType &&
        other.userId == userId &&
        other.waveform == waveform &&
        other.audiosaladCache == audiosaladCache &&
        other.priceInCents == priceInCents &&
        other.externalStreamUrl == externalStreamUrl &&
        other.deletedAt == deletedAt &&
        other.album == album;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        artistString.hashCode ^
        duration.hashCode ^
        isrc.hashCode ^
        upc.hashCode ^
        albumId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        audiosaladTrackId.hashCode ^
        userType.hashCode ^
        userId.hashCode ^
        waveform.hashCode ^
        audiosaladCache.hashCode ^
        priceInCents.hashCode ^
        externalStreamUrl.hashCode ^
        deletedAt.hashCode ^
        album.hashCode;
  }
}

class Album {
  final int? id;
  final String? name;
  final int? artistId;
  final int? recordLabelId;
  final String? tmpCoverUrl;
  final String? createdAt;
  final String? updatedAt;
  final String? audiosaladReleaseId;
  final bool? available;
  final String? releaseDate;
  final String? description;
  final String? audiosaladState;
  final String? audiosaladCache;
  final String? distributorId;
  final String? upc;
  final String? catalog;
  final int? priceInCents;
  final String? ddexState;
  final String? deletedAt;
  final Cover? cover;

  Album({
    this.id,
    this.name,
    this.artistId,
    this.recordLabelId,
    this.tmpCoverUrl,
    this.createdAt,
    this.updatedAt,
    this.audiosaladReleaseId,
    this.available,
    this.releaseDate,
    this.description,
    this.audiosaladState,
    this.audiosaladCache,
    this.distributorId,
    this.upc,
    this.catalog,
    this.priceInCents,
    this.ddexState,
    this.deletedAt,
    this.cover,
  });

  Album copyWith({
    int? id,
    String? name,
    int? artistId,
    int? recordLabelId,
    String? tmpCoverUrl,
    String? createdAt,
    String? updatedAt,
    String? audiosaladReleaseId,
    bool? available,
    String? releaseDate,
    String? description,
    String? audiosaladState,
    String? audiosaladCache,
    String? distributorId,
    String? upc,
    String? catalog,
    int? priceInCents,
    String? ddexState,
    String? deletedAt,
    Cover? cover,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      recordLabelId: recordLabelId ?? this.recordLabelId,
      tmpCoverUrl: tmpCoverUrl ?? this.tmpCoverUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      audiosaladReleaseId: audiosaladReleaseId ?? this.audiosaladReleaseId,
      available: available ?? this.available,
      releaseDate: releaseDate ?? this.releaseDate,
      description: description ?? this.description,
      audiosaladState: audiosaladState ?? this.audiosaladState,
      audiosaladCache: audiosaladCache ?? this.audiosaladCache,
      distributorId: distributorId ?? this.distributorId,
      upc: upc ?? this.upc,
      catalog: catalog ?? this.catalog,
      priceInCents: priceInCents ?? this.priceInCents,
      ddexState: ddexState ?? this.ddexState,
      deletedAt: deletedAt ?? this.deletedAt,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistId': artistId,
      'recordLabelId': recordLabelId,
      'tmpCoverUrl': tmpCoverUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'audiosaladReleaseId': audiosaladReleaseId,
      'available': available,
      'releaseDate': releaseDate,
      'description': description,
      'audiosaladState': audiosaladState,
      'audiosaladCache': audiosaladCache,
      'distributorId': distributorId,
      'upc': upc,
      'catalog': catalog,
      'priceInCents': priceInCents,
      'ddexState': ddexState,
      'deletedAt': deletedAt,
      'cover': cover?.toMap(),
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      recordLabelId:
          map['record_label_id'] != null ? map['record_label_id'] as int : null,
      tmpCoverUrl:
          map['tmp_cover_url'] != null ? map['tmp_cover_url'] as String : null,
      createdAt: map['created_at'] != null ? map['created_at'] as String : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      audiosaladReleaseId: map['audiosalad_release_id'] != null
          ? map['audiosalad_release_id'].toString() as String
          : null,
      available: map['available'] != null ? map['available'] as bool : null,
      releaseDate:
          map['release_date'] != null ? map['release_date'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      audiosaladState: map['audiosalad_state'] != null
          ? map['audiosalad_state'] as String
          : null,
      audiosaladCache: map['audiosalad_cache'] != null
          ? map['audiosalad_cache'] as String
          : null,
      distributorId: map['distributor_id'] != null
          ? map['distributor_id'] as String
          : null,
      upc: map['upc'] != null ? map['upc'] as String : null,
      catalog: map['catalog'] != null ? map['catalog'] as String : null,
      priceInCents:
          map['price_in_cents'] != null ? map['price_in_cents'] as int : null,
      ddexState: map['ddex_state'] != null ? map['ddex_state'] as String : null,
      deletedAt: map['deleted_at'] != null ? map['deleted_at'] as String : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Album(id: $id, name: $name, artistId: $artistId, recordLabelId: $recordLabelId, tmpCoverUrl: $tmpCoverUrl, createdAt: $createdAt, updatedAt: $updatedAt, audiosaladReleaseId: $audiosaladReleaseId, available: $available, releaseDate: $releaseDate, description: $description, audiosaladState: $audiosaladState, audiosaladCache: $audiosaladCache, distributorId: $distributorId, upc: $upc, catalog: $catalog, priceInCents: $priceInCents, ddexState: $ddexState, deletedAt: $deletedAt, cover: $cover)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Album &&
        other.id == id &&
        other.name == name &&
        other.artistId == artistId &&
        other.recordLabelId == recordLabelId &&
        other.tmpCoverUrl == tmpCoverUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.audiosaladReleaseId == audiosaladReleaseId &&
        other.available == available &&
        other.releaseDate == releaseDate &&
        other.description == description &&
        other.audiosaladState == audiosaladState &&
        other.audiosaladCache == audiosaladCache &&
        other.distributorId == distributorId &&
        other.upc == upc &&
        other.catalog == catalog &&
        other.priceInCents == priceInCents &&
        other.ddexState == ddexState &&
        other.deletedAt == deletedAt &&
        other.cover == cover;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        artistId.hashCode ^
        recordLabelId.hashCode ^
        tmpCoverUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        audiosaladReleaseId.hashCode ^
        available.hashCode ^
        releaseDate.hashCode ^
        description.hashCode ^
        audiosaladState.hashCode ^
        audiosaladCache.hashCode ^
        distributorId.hashCode ^
        upc.hashCode ^
        catalog.hashCode ^
        priceInCents.hashCode ^
        ddexState.hashCode ^
        deletedAt.hashCode ^
        cover.hashCode;
  }
}
