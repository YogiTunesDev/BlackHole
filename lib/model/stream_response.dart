import 'dart:convert';

import 'package:flutter/foundation.dart';

class StreamResponse {
    StreamResponse({
        this.status,
        this.statusCode,
        this.data,
    });

    final bool? status;
    final int? statusCode;
    final List<Datum>? data;

  StreamResponse copyWith({
    bool? status,
    int? statusCode,
    List<Datum>? data,
  }) {
    return StreamResponse(
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

  factory StreamResponse.fromMap(Map<String, dynamic> map) {
    return StreamResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null ? List<Datum>.from(json.decode(map['data'] as String) ?.map((x) => Datum.fromMap(x as Map<String, dynamic>)) as Iterable<dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamResponse.fromJson(String source) => StreamResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StreamResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StreamResponse &&
      other.status == status &&
      other.statusCode == statusCode &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class Datum {
    Datum({
        this.title,
        this.duration,
        this.artist,
        this.mp3,
        this.poster,
    });

    final String? title;
    final String? duration;
    final String? artist;
    final String? mp3;
    final String? poster;

  Datum copyWith({
    String? title,
    String? duration,
    String? artist,
    String? mp3,
    String? poster,
  }) {
    return Datum(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      artist: artist ?? this.artist,
      mp3: mp3 ?? this.mp3,
      poster: poster ?? this.poster,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'duration': duration,
      'artist': artist,
      'mp3': mp3,
      'poster': poster,
    };
  }

  factory Datum.fromMap(Map<String, dynamic> map) {
    return Datum(
      title: map['title'] != null ? map['title'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      mp3: map['mp3'] != null ? map['mp3'] as String : null,
      poster: map['poster'] != null ? map['poster'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Datum.fromJson(String source) => Datum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Datum(title: $title, duration: $duration, artist: $artist, mp3: $mp3, poster: $poster)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Datum &&
      other.title == title &&
      other.duration == duration &&
      other.artist == artist &&
      other.mp3 == mp3 &&
      other.poster == poster;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      duration.hashCode ^
      artist.hashCode ^
      mp3.hashCode ^
      poster.hashCode;
  }
}
