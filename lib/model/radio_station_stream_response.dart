import 'dart:convert';

import 'package:blackhole/model/song_model.dart';
import 'package:flutter/foundation.dart';

class RadioStationsStreamResponse {
  RadioStationsStreamResponse({
    this.status,
    this.statusCode,
    this.data,
    this.songItemModel,
  });

  final bool? status;
  final int? statusCode;
  final List<RadioStationsStreamData>? data;
  final List<SongItemModel>? songItemModel;

  RadioStationsStreamResponse copyWith({
    bool? status,
    int? statusCode,
    List<RadioStationsStreamData>? data,
    List<SongItemModel>? songItemModel,
  }) {
    return RadioStationsStreamResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      songItemModel: songItemModel ?? this.songItemModel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data?.map((x) => x.toMap()).toList(),
      'songItemModel': songItemModel?.map((e) => e.toMap()).toList(),
    };
  }

  factory RadioStationsStreamResponse.fromMap(Map<String, dynamic> map) {
    return RadioStationsStreamResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null
          ? List<RadioStationsStreamData>.from(json
              .decode(map['data'].toString())
              ?.map((x) => RadioStationsStreamData.fromMap(
                  x as Map<String, dynamic>)) as Iterable<dynamic>)
          : null,
      songItemModel: map['songitemModel'] != null
          ? List<SongItemModel>.from(map['data']?.map(
              (x) => SongItemModel.fromMap(x as Map<String, dynamic>),
            ) as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioStationsStreamResponse.fromJson(String source) =>
      RadioStationsStreamResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RadioStationsStreamResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RadioStationsStreamResponse &&
        other.status == status &&
        other.statusCode == statusCode &&
        listEquals(other.data, data) &&
        listEquals(other.songItemModel, songItemModel);
  }

  @override
  int get hashCode =>
      status.hashCode ^
      statusCode.hashCode ^
      data.hashCode ^
      songItemModel.hashCode;
}

class RadioStationsStreamData {
  RadioStationsStreamData({
    this.id,
    this.title,
    this.artist,
    this.mp3,
    this.poster,
    this.trackId,
    this.sourceId,
    this.sourceType,
    this.smilFile,
    this.duration,
  });

  final int? id;
  final String? title;
  final String? artist;
  final String? mp3;
  final String? poster;
  final int? trackId;
  final int? sourceId;
  final String? sourceType;
  final String? smilFile;
  final String? duration;

  RadioStationsStreamData copyWith({
    int? id,
    String? title,
    String? artist,
    String? mp3,
    String? poster,
    int? trackId,
    int? sourceId,
    String? sourceType,
    String? smilFile,
    String? duration,
  }) {
    return RadioStationsStreamData(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      mp3: mp3 ?? this.mp3,
      poster: poster ?? this.poster,
      trackId: trackId ?? this.trackId,
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      smilFile: smilFile ?? this.smilFile,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'mp3': mp3,
      'poster': poster,
      'trackId': trackId,
      'sourceId': sourceId,
      'sourceType': sourceType,
      'smilFile': smilFile,
      'duration': duration,
    };
  }

  factory RadioStationsStreamData.fromMap(Map<String, dynamic> map) {
    return RadioStationsStreamData(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      mp3: map['mp3'] != null ? map['mp3'] as String : null,
      poster: map['poster'] != null ? map['poster'] as String : null,
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      sourceId: map['source_id'] != null ? map['source_id'] as int : null,
      sourceType:
          map['source_type'] != null ? map['source_type'] as String : null,
      smilFile: map['smil_file'] != null ? map['smil_file'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioStationsStreamData.fromJson(String source) =>
      RadioStationsStreamData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RadioStationsStreamData(id: $id, title: $title, artist: $artist, mp3: $mp3, poster: $poster, trackId: $trackId, sourceId: $sourceId, sourceType: $sourceType, smilFile: $smilFile, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RadioStationsStreamData &&
        other.id == id &&
        other.title == title &&
        other.artist == artist &&
        other.mp3 == mp3 &&
        other.poster == poster &&
        other.trackId == trackId &&
        other.sourceId == sourceId &&
        other.sourceType == sourceType &&
        other.smilFile == smilFile &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        artist.hashCode ^
        mp3.hashCode ^
        poster.hashCode ^
        trackId.hashCode ^
        sourceId.hashCode ^
        sourceType.hashCode ^
        smilFile.hashCode ^
        duration.hashCode;
  }
}
