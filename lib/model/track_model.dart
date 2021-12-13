import 'dart:convert';

import 'package:flutter/foundation.dart';

class Track {
  Track({
    this.id,
    this.albumId,
    this.name,
    this.duration,
    this.files,
  });

  final int? id;
  final int? albumId;
  final String? name;
  final String? duration;
  final List<FileElement>? files;

  Track copyWith({
    int? id,
    int? albumId,
    String? name,
    String? duration,
    List<FileElement>? files,
  }) {
    return Track(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      files: files ?? this.files,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'albumId': albumId,
      'name': name,
      'duration': duration,
      'files': files != null ? files?.map((x) => x.toMap()).toList() : null,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] != null ? map['id'] as int : null,
      albumId: map['album_id'] != null ? map['album_id'] as int : null,
      name: map['name'] != null ? map['name'] as String  : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      files: map['files'] != null
          ? List<FileElement>.from(map['files']
                  ?.map((x) => FileElement.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track(id: $id, albumId: $albumId, name: $name, duration: $duration, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Track &&
        other.id == id &&
        other.albumId == albumId &&
        other.name == name &&
        other.duration == duration &&
        listEquals(other.files, files);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        albumId.hashCode ^
        name.hashCode ^
        duration.hashCode ^
        files.hashCode;
  }
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
