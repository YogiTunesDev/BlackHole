import 'dart:convert';

import 'package:blackhole/model/song_model.dart';
import 'package:flutter/foundation.dart';

import 'profile_model.dart';
import 'tag_model.dart';

class PlaylistResponse {
  PlaylistResponse({this.status, this.statusCode, this.data});

  final bool? status;
  final int? statusCode;
  final Data? data;

  PlaylistResponse copyWith({
    bool? status,
    int? statusCode,
    Data? data,
  }) {
    return PlaylistResponse(
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

  factory PlaylistResponse.fromMap(Map<String, dynamic> map) {
    return PlaylistResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistResponse.fromJson(String source) =>
      PlaylistResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PlaylistResponse(status: $status, statusCode: $statusCode, playlistData: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaylistResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class Data {
  Data({
    this.currentPage,
    this.playListData,
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

  final int? currentPage;
  final List<PlayListData>? playListData;
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

  Data copyWith({
    int? currentPage,
    List<PlayListData>? playListData,
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
      playListData: playListData ?? this.playListData,
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
      'data': playListData?.map((x) => x.toMap()).toList(),
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
      playListData: map['data'] != null
          ? List<PlayListData>.from(map['data']
                  ?.map((x) => PlayListData.fromMap(x as Map<String, dynamic>))
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
    return 'PlaylistData(currentPage: $currentPage, data: $playListData, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        other.currentPage == currentPage &&
        listEquals(other.playListData, playListData) &&
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
        playListData.hashCode ^
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

class PlayListData {
  PlayListData({
    this.id,
    this.name,
    this.description,
    this.userId,
    this.quadImages,
    this.playlistDuration,
    this.tracksOnly,
    this.tags,
    this.songlist,
  });

  final int? id;
  final String? name;
  final String? description;
  final int? userId;
  final List<QuadImage>? quadImages;
  final String? playlistDuration;
  final List<TracksOnly>? tracksOnly;
  final List<Tag>? tags;
  final List<SongItemModel>? songlist;

  PlayListData copyWith({
    int? id,
    String? name,
    String? description,
    int? userId,
    List<QuadImage>? quadImages,
    String? playlistDuration,
    List<TracksOnly>? tracksOnly,
    List<Tag>? tags,
    List<SongItemModel>? songlist,
  }) {
    return PlayListData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      quadImages: quadImages ?? this.quadImages,
      playlistDuration: playlistDuration ?? this.playlistDuration,
      tracksOnly: tracksOnly ?? this.tracksOnly,
      tags: tags ?? this.tags,
      songlist: songlist ?? this.songlist,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'quadImages': quadImages?.map((x) => x.toMap()).toList(),
      'playlistDuration': playlistDuration,
      'tracksOnly': tracksOnly?.map((x) => x.toMap()).toList(),
      'tags': tags?.map((x) => x.toMap()).toList(),
      'songlist':
          songlist != null ? songlist?.map((e) => e.toMap()).toList() : null,
    };
  }

  factory PlayListData.fromMap(Map<String, dynamic> map) {
    return PlayListData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      quadImages: map['quadImages'] != null
          ? List<QuadImage>.from(map['quadImages']
                  ?.map((x) => QuadImage.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
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
      songlist: map['songlist'] != null
          ? List<SongItemModel>.from(map['songlist']
                  ?.map((x) => SongItemModel.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayListData.fromJson(String source) =>
      PlayListData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayListData(id: $id, name: $name, description: $description, userId: $userId, quadImages: $quadImages, playlistDuration: $playlistDuration, tracksOnly: $tracksOnly, tags: $tags, songlist: $songlist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayListData &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.userId == userId &&
        listEquals(other.quadImages, quadImages) &&
        other.playlistDuration == playlistDuration &&
        listEquals(other.tracksOnly, tracksOnly) &&
        listEquals(other.tags, tags) &&
        listEquals(other.songlist, songlist);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        quadImages.hashCode ^
        playlistDuration.hashCode ^
        tracksOnly.hashCode ^
        tags.hashCode ^
        songlist.hashCode;
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
          ? Album.fromMap(map['album'] as Map<String, dynamic>) as Album
          : null,
      files: map['files'] != null
          ? List<FileElement>.from(map['files']
                  ?.map((x) => FileElement.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      bpm: map['bpm'] != null
          ? BpmClass.fromMap(map['bpm'] as Map<String, dynamic>) as BpmClass
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
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>) as Cover
          : null,
      profile: map['profile'] != null
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>) as Profile
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

class Cover {
  Cover({
    this.id,
    this.coverableId,
    this.image,
    this.imgUrl,
  });

  final int? id;
  final int? coverableId;
  final String? image;
  final String? imgUrl;

  Cover copyWith({
    int? id,
    int? coverableId,
    String? image,
    String? imgUrl,
  }) {
    return Cover(
      id: id ?? this.id,
      coverableId: coverableId ?? this.coverableId,
      image: image ?? this.image,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coverableId': coverableId,
      'image': image,
      'imgUrl': imgUrl,
    };
  }

  factory Cover.fromMap(Map<String, dynamic> map) {
    return Cover(
      id: map['id'] != null ? map['id'] as int : null,
      coverableId:
          map['coverable_id'] != null ? map['coverable_id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      imgUrl: map['img_url'] != null ? map['img_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cover.fromJson(String source) =>
      Cover.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cover(id: $id, coverableId: $coverableId, image: $image, imgUrl: $imgUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cover &&
        other.id == id &&
        other.coverableId == coverableId &&
        other.image == image &&
        other.imgUrl == imgUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        coverableId.hashCode ^
        image.hashCode ^
        imgUrl.hashCode;
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
