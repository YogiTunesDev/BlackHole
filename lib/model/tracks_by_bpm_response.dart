import 'dart:convert';

import 'package:flutter/foundation.dart';

// import 'cover_model.dart';
import 'playlist_response.dart';
// import 'profile_model.dart';

class TracksBybpmResponse {
  TracksBybpmResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final TracksBybpmResponseData? data;

  TracksBybpmResponse copyWith({
    bool? status,
    int? statusCode,
    TracksBybpmResponseData? data,
  }) {
    return TracksBybpmResponse(
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

  factory TracksBybpmResponse.fromMap(Map<String, dynamic> map) {
    return TracksBybpmResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['statusCode'] != null ? map['statusCode'] as int : null,
      data: map['data'] != null
          ? TracksBybpmResponseData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TracksBybpmResponse.fromJson(String source) =>
      TracksBybpmResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TracksBybpmResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TracksBybpmResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class TracksBybpmResponseData {
  TracksBybpmResponseData({
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

  final int? currentPage;
  final List<TracksBybpmData>? data;
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

  TracksBybpmResponseData copyWith({
    int? currentPage,
    List<TracksBybpmData>? data,
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
    return TracksBybpmResponseData(
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

  factory TracksBybpmResponseData.fromMap(Map<String, dynamic> map) {
    return TracksBybpmResponseData(
      currentPage:
          map['currentPage'] != null ? map['currentPage'] as int : null,
      data: map['data'] != null
          ? List<TracksBybpmData>.from(map['data']?.map(
                  (x) => TracksBybpmData.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      firstPageUrl:
          map['firstPageUrl'] != null ? map['firstPageUrl'] as String : null,
      from: map['from'] != null ? map['from'] as int : null,
      lastPage: map['lastPage'] != null ? map['lastPage'] as int : null,
      lastPageUrl:
          map['lastPageUrl'] != null ? map['lastPageUrl'] as String : null,
      nextPageUrl:
          map['nextPageUrl'] != null ? map['nextPageUrl'] as String : null,
      path: map['path'] != null ? map['path'] as String : null,
      perPage: map['perPage'] != null ? map['perPage'] as int : null,
      prevPageUrl:
          map['prevPageUrl'] != null ? map['prevPageUrl'] as String : null,
      to: map['to'] != null ? map['to'] as int : null,
      total: map['total'] != null ? map['total'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TracksBybpmResponseData.fromJson(String source) =>
      TracksBybpmResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TracksBybpmResponseData(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TracksBybpmResponseData &&
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

class TracksBybpmData {
  TracksBybpmData({
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
  

  TracksBybpmData copyWith({
    int? id,
    int? albumId,
    String? name,
    String? duration,
    Album? album,
    List<FileElement>? files,
    BpmClass? bpm,
  }) {
    return TracksBybpmData(
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

  factory TracksBybpmData.fromMap(Map<String, dynamic> map) {
    return TracksBybpmData(
      id: map['id'] != null ? map['id'] as int : null,
      albumId: map['albumId'] != null ? map['albumId'] as int : null,
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

  factory TracksBybpmData.fromJson(String source) =>
      TracksBybpmData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TracksBybpmData(id: $id, albumId: $albumId, name: $name, duration: $duration, album: $album, files: $files, bpm: $bpm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TracksBybpmData &&
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
