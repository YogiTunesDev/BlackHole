import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'single_playlist_response.dart';

class TrendingSongResponse {
  final bool? status;
  final int? statusCode;
  final TrendingSongData? data;
  TrendingSongResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  TrendingSongResponse copyWith({
    bool? status,
    int? statusCode,
    TrendingSongData? data,
  }) {
    return TrendingSongResponse(
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

  factory TrendingSongResponse.fromMap(Map<String, dynamic> map) {
    return TrendingSongResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['statusCode'] != null ? map['statusCode'] as int : null,
      data: map['data'] != null
          ? TrendingSongData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrendingSongResponse.fromJson(String source) =>
      TrendingSongResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TrendingSongResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrendingSongResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class TrendingSongData {
  int? currentPage;
  List<Track>? data;
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
  TrendingSongData({
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

  TrendingSongData copyWith({
    int? currentPage,
    List<Track>? data,
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
    return TrendingSongData(
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

  factory TrendingSongData.fromMap(Map<String, dynamic> map) {
    return TrendingSongData(
      currentPage:
          map['currentPage'] != null ? map['currentPage'] as int : null,
      data: map['data'] != null
          ? List<Track>.from(
              map['data']?.map((x) => Track.fromMap(x as Map<String, dynamic>))
                  as Iterable<dynamic>,)
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

  factory TrendingSongData.fromJson(String source) =>
      TrendingSongData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TrendingSongData(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrendingSongData &&
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
