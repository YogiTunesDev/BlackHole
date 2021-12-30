import 'dart:convert';

import 'package:blackhole/model/single_playlist_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:collection/collection.dart';

class MyLibraryTrackResponse {
  final bool? status;
  final int? statusCode;
  final MyLibraryTrackResponseData? data;
  MyLibraryTrackResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  MyLibraryTrackResponse copyWith({
    bool? status,
    int? statusCode,
    MyLibraryTrackResponseData? data,
  }) {
    return MyLibraryTrackResponse(
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

  factory MyLibraryTrackResponse.fromMap(Map<String, dynamic> map) {
    return MyLibraryTrackResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? MyLibraryTrackResponseData.fromMap(
              map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyLibraryTrackResponse.fromJson(String source) =>
      MyLibraryTrackResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MyLibraryTrackResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyLibraryTrackResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class MyLibraryTrackResponseData {
  int? currentPage;
  List<MyLibraryTrack>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;
  MyLibraryTrackResponseData({
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

  MyLibraryTrackResponseData copyWith({
    int? currentPage,
    List<MyLibraryTrack>? data,
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
    return MyLibraryTrackResponseData(
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

  factory MyLibraryTrackResponseData.fromMap(Map<String, dynamic> map) {
    return MyLibraryTrackResponseData(
      currentPage:
          map['current_page'] != null ? map['current_page'] as int : null,
      data: map['data'] != null
          ? List<MyLibraryTrack>.from(map['data']?.map(
                  (x) => MyLibraryTrack.fromMap(x as Map<String, dynamic>))
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

  factory MyLibraryTrackResponseData.fromJson(String source) =>
      MyLibraryTrackResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyLibraryTrackResponseData(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MyLibraryTrackResponseData &&
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

class MyLibraryTrack {
  final int? id;
  final int? albumId;
  final int? libraryId;
  final int? trackId;
  final int? order;
  final String? source;
  final Track? track;
  final SongItemModel? songItemModel;
  MyLibraryTrack({
    this.id,
    this.albumId,
    this.libraryId,
    this.trackId,
    this.order,
    this.source,
    this.track,
    this.songItemModel,
  });

  MyLibraryTrack copyWith({
    int? id,
    int? albumId,
    int? libraryId,
    int? trackId,
    int? order,
    String? source,
    Track? track,
    SongItemModel? songItemModel,
  }) {
    return MyLibraryTrack(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      libraryId: libraryId ?? this.libraryId,
      trackId: trackId ?? this.trackId,
      order: order ?? this.order,
      source: source ?? this.source,
      track: track ?? this.track,
      songItemModel: songItemModel ?? this.songItemModel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'albumId': albumId,
      'libraryId': libraryId,
      'trackId': trackId,
      'order': order,
      'source': source,
      'track': track?.toMap(),
      'songItemModel': songItemModel?.toMap(),
    };
  }

  factory MyLibraryTrack.fromMap(Map<String, dynamic> map) {
    return MyLibraryTrack(
      id: map['id'] != null ? map['id'] as int : null,
      albumId: map['album_id'] != null ? map['album_id'] as int : null,
      libraryId: map['library_id'] != null ? map['library_id'] as int : null,
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      order: map['order'] != null ? map['order'] as int : null,
      source: map['source'] != null ? map['source'] as String : null,
      track: map['track'] != null
          ? Track.fromMap(map['track'] as Map<String, dynamic>)
          : null,
      songItemModel: map['songItemModel'] != null
          ? SongItemModel.fromMap(map['songItemModel'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyLibraryTrack.fromJson(String source) =>
      MyLibraryTrack.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyLibraryTrack(id: $id, albumId: $albumId, libraryId: $libraryId, trackId: $trackId, order: $order, source: $source, track: $track)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyLibraryTrack &&
        other.id == id &&
        other.albumId == albumId &&
        other.libraryId == libraryId &&
        other.trackId == trackId &&
        other.order == order &&
        other.source == source &&
        other.track == track;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        albumId.hashCode ^
        libraryId.hashCode ^
        trackId.hashCode ^
        order.hashCode ^
        source.hashCode ^
        track.hashCode;
  }
}
