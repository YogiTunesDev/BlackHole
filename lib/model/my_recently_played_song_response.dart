import 'dart:convert';

import 'package:blackhole/model/home_model.dart';
import 'package:collection/collection.dart';

class MyRecentlyPlayedSongResponse {
  MyRecentlyPlayedSongResponse({
    this.status,
    this.statusCode,
    this.data,
  });

  final bool? status;
  final int? statusCode;
  final List<MyRecentlyPlayedSong>? data;

  MyRecentlyPlayedSongResponse copyWith({
    bool? status,
    int? statusCode,
    List<MyRecentlyPlayedSong>? data,
  }) {
    return MyRecentlyPlayedSongResponse(
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

  factory MyRecentlyPlayedSongResponse.fromMap(Map<String, dynamic> map) {
    return MyRecentlyPlayedSongResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<MyRecentlyPlayedSong>.from(map['data']?.map((x) =>
                  MyRecentlyPlayedSong.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyRecentlyPlayedSongResponse.fromJson(String source) =>
      MyRecentlyPlayedSongResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MyRecentlyPlayedSongResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MyRecentlyPlayedSongResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}
