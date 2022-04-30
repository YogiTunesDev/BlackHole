import 'dart:convert';

import 'package:blackhole/util/const.dart';
import 'package:flutter/foundation.dart';

import 'cover_model.dart';
import 'profile_model.dart';

class CustomPlaylistResponse {
  CustomPlaylistResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<PlaylistResponseData>? data;

  CustomPlaylistResponse copyWith({
    bool? status,
    int? statusCode,
    List<PlaylistResponseData>? data,
  }) {
    return CustomPlaylistResponse(
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

  factory CustomPlaylistResponse.fromMap(Map<String, dynamic> map) {
    return CustomPlaylistResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<PlaylistResponseData>.from(map['data']?.map((x) =>
                  PlaylistResponseData.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomPlaylistResponse.fromJson(String source) =>
      CustomPlaylistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomPlaylistResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomPlaylistResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class PlaylistResponseData {
  PlaylistResponseData({
    this.id,
    this.itemId,
    this.userId,
    this.quadImages,
    this.playlist,
    this.playlistTracks,
  });

  final int? id;
  final int? itemId;
  final int? userId;
  final List<QuadImage?>? quadImages;
  final Playlist? playlist;
  final List<PlaylistTrack>? playlistTracks;

  PlaylistResponseData copyWith({
    int? id,
    int? itemId,
    int? userId,
    List<QuadImage?>? quadImages,
    Playlist? playlist,
    List<PlaylistTrack>? playlistTracks,
  }) {
    return PlaylistResponseData(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      quadImages: quadImages ?? this.quadImages,
      playlist: playlist ?? this.playlist,
      playlistTracks: playlistTracks ?? this.playlistTracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'userId': userId,
      'quadImages': quadImages?.map((x) => x?.toMap()).toList(),
      'playlist': playlist?.toMap(),
      'playlistTracks': playlistTracks?.map((x) => x.toMap()).toList(),
    };
  }

  factory PlaylistResponseData.fromMap(Map<String, dynamic> map) {
    return PlaylistResponseData(
      id: map['id'] != null ? map['id'] as int : null,
      itemId: map['item_id'] != null ? map['item_id'] as int : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      quadImages: map['quadImages'] != null
          ? map['quadImages'].toString() != 'null'
              ? List<QuadImage?>.from(map['quadImages']?.map((x) => x != null
                  ? QuadImage.fromMap(x as Map<String, dynamic>)
                  : null) as Iterable<dynamic>)
              : null
          : null,
      playlist: map['playlist'] != null
          ? Playlist.fromMap(map['playlist'] as Map<String, dynamic>)
          : null,
      playlistTracks: map['playlist_tracks'] != null
          ? List<PlaylistTrack>.from(map['playlist_tracks']
                  ?.map((x) => PlaylistTrack.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistResponseData.fromJson(String source) =>
      PlaylistResponseData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistResponseData(id: $id, itemId: $itemId, userId: $userId, quadImages: $quadImages, playlist: $playlist, playlistTracks: $playlistTracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaylistResponseData &&
        other.id == id &&
        other.itemId == itemId &&
        other.userId == userId &&
        listEquals(other.quadImages, quadImages) &&
        other.playlist == playlist &&
        listEquals(other.playlistTracks, playlistTracks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemId.hashCode ^
        userId.hashCode ^
        quadImages.hashCode ^
        playlist.hashCode ^
        playlistTracks.hashCode;
  }

  List<String> getQuadImages({bool isThumbnail = false}) {
    List<String> lstStr = [];
    if (quadImages != null) {
      if (TOTALIMAGES == 0) {
        for (var i = 0; i < quadImages!.length; i++) {
          if (quadImages?[i]?.imageUrl != null &&
              quadImages?[i]?.image != null) {
            if (quadImages![i]!.imageUrl!.isNotEmpty) {
              lstStr.add(
                  '${quadImages![i]!.imageUrl}/${isThumbnail ? "thumb_" : ""}${quadImages![i]!.image}');
            }
          }
        }
      } else {
        for (var i = 0; i < TOTALIMAGES; i++) {
          if (quadImages?[i]?.imageUrl != null &&
              quadImages?[i]?.image != null) {
            if (quadImages![i]!.imageUrl!.isNotEmpty) {
              lstStr.add(
                  '${quadImages![i]!.imageUrl}/${isThumbnail ? "thumb_" : ""}${quadImages![i]!.image}');
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

class Playlist {
  Playlist({
    this.id,
    this.name,
    this.byop,
    this.description,
  });

  final int? id;
  final String? name;
  final bool? byop;
  final String? description;

  Playlist copyWith({
    int? id,
    String? name,
    bool? byop,
    String? description,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      byop: byop ?? this.byop,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'byop': byop,
      'description': description,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      byop: map['byop'] != null ? map['byop'] as bool : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, byop: $byop, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Playlist &&
        other.id == id &&
        other.name == name &&
        other.byop == byop &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ byop.hashCode ^ description.hashCode;
  }
}

class PlaylistTrack {
  PlaylistTrack({
    this.libraryId,
    this.playlistId,
    this.trackId,
    this.order,
    this.track,
  });

  final int? libraryId;
  final int? playlistId;
  final int? trackId;
  final int? order;
  final Track? track;

  PlaylistTrack copyWith({
    int? libraryId,
    int? playlistId,
    int? trackId,
    int? order,
    Track? track,
  }) {
    return PlaylistTrack(
      libraryId: libraryId ?? this.libraryId,
      playlistId: playlistId ?? this.playlistId,
      trackId: trackId ?? this.trackId,
      order: order ?? this.order,
      track: track ?? this.track,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'libraryId': libraryId,
      'playlistId': playlistId,
      'trackId': trackId,
      'order': order,
      'track': track?.toMap(),
    };
  }

  factory PlaylistTrack.fromMap(Map<String, dynamic> map) {
    return PlaylistTrack(
      libraryId: map['library_id'] != null ? map['library_id'] as int : null,
      playlistId: map['playlist_id'] != null ? map['playlist_id'] as int : null,
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      order: map['order'] != null ? map['order'] as int : null,
      track: map['track'] != null
          ? Track.fromMap(map['track'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistTrack.fromJson(String source) =>
      PlaylistTrack.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlaylistTrack(libraryId: $libraryId, playlistId: $playlistId, trackId: $trackId, order: $order, track: $track)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaylistTrack &&
        other.libraryId == libraryId &&
        other.playlistId == playlistId &&
        other.trackId == trackId &&
        other.order == order &&
        other.track == track;
  }

  @override
  int get hashCode {
    return libraryId.hashCode ^
        playlistId.hashCode ^
        trackId.hashCode ^
        order.hashCode ^
        track.hashCode;
  }
}

class Track {
  Track({
    this.id,
    this.name,
    this.duration,
    this.albumId,
    this.album,
  });

  final int? id;
  final String? name;
  final String? duration;
  final int? albumId;
  final Album? album;

  Track copyWith({
    int? id,
    String? name,
    String? duration,
    int? albumId,
    Album? album,
  }) {
    return Track(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      albumId: albumId ?? this.albumId,
      album: album ?? this.album,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'albumId': albumId,
      'album': album?.toMap(),
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      albumId: map['album_id'] != null ? map['album_id'] as int : null,
      album: map['album'] != null
          ? Album.fromMap(map['album'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track(id: $id, name: $name, duration: $duration, albumId: $albumId, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Track &&
        other.id == id &&
        other.name == name &&
        other.duration == duration &&
        other.albumId == albumId &&
        other.album == album;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        duration.hashCode ^
        albumId.hashCode ^
        album.hashCode;
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
  final Profile? profile;

  Album copyWith({
    int? id,
    int? artistId,
    String? name,
    Cover? cover,
    Profile? profile,
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
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
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

class QuadImage {
  QuadImage({
    this.imageUrl,
    this.image,
  });

  final String? imageUrl;
  final String? image;

  QuadImage copyWith({
    String? imageUrl,
    String? image,
  }) {
    return QuadImage(
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'image': image,
    };
  }

  factory QuadImage.fromMap(Map<String, dynamic> map) {
    return QuadImage(
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuadImage.fromJson(String source) =>
      QuadImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QuadImage(imageUrl: $imageUrl, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuadImage &&
        other.imageUrl == imageUrl &&
        other.image == image;
  }

  @override
  int get hashCode => imageUrl.hashCode ^ image.hashCode;
}
