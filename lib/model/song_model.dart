import 'dart:convert';
import 'dart:developer';

class SongItemModel {
  final String? id;
  final String? artist;
  final String? album;
  final String? image;
  final int? duration;
  final String? title;
  final String? url;
  final String? year;
  final String? language;
  final String? genre;
  final String? kbs;
  final bool? hasLyrics;
  final String? releaseDate;
  final String? albumId;
  final String? subtitle;
  final String? permaUrl;
  final String? libraryId;

  ///Tags only required to save playlist info locally.
  final String? mainPlaylistName;
  final List<String>? mainPlaylistImages;

  SongItemModel(
      {this.id,
      this.artist,
      this.album,
      this.image,
      this.duration,
      this.title,
      this.url,
      this.year,
      this.language,
      this.genre,
      this.kbs,
      this.hasLyrics,
      this.releaseDate,
      this.albumId,
      this.subtitle,
      this.permaUrl,
      this.libraryId,
      this.mainPlaylistName,
      this.mainPlaylistImages});

  SongItemModel copyWith({
    String? id,
    String? artist,
    String? album,
    String? image,
    int? duration,
    String? title,
    String? url,
    String? year,
    String? language,
    String? genre,
    String? kbs,
    bool? hasLyrics,
    String? releaseDate,
    String? albumId,
    String? subtitle,
    String? permaUrl,
    String? libraryId,
  }) {
    return SongItemModel(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      url: url ?? this.url,
      year: year ?? this.year,
      language: language ?? this.language,
      genre: genre ?? this.genre,
      kbs: kbs ?? this.kbs,
      hasLyrics: hasLyrics ?? this.hasLyrics,
      releaseDate: releaseDate ?? this.releaseDate,
      albumId: albumId ?? this.albumId,
      subtitle: subtitle ?? this.subtitle,
      permaUrl: permaUrl ?? this.permaUrl,
      libraryId: libraryId ?? this.libraryId,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'artist': artist,
      'album': album,
      'image': image,
      'duration': duration,
      'title': title,
      'url': url,
      'path': url,
      'year': year,
      'language': language,
      'genre': genre,
      'kbs': kbs,
      'hasLyrics': hasLyrics,
      'releaseDate': releaseDate,
      'albumId': albumId,
      'subtitle': subtitle,
      'permaUrl': permaUrl,
      'libraryId': libraryId,
    };
    if (mainPlaylistName != null) map['mainPlaylistName'] = mainPlaylistName;
    if (mainPlaylistImages != null) map['mainPlaylistImages'] = jsonEncode(mainPlaylistImages);
    return map;
  }

  factory SongItemModel.fromMap(Map<String, dynamic> map) {
    try {
      return SongItemModel(
        id: map['id'] != null ? map['id'] as String : null,
        artist: map['artist'] != null ? map['artist'] as String : null,
        album: map['album'] != null ? map['album'] as String : null,
        image: map['image'] != null ? map['image'] as String : null,
        duration: map['duration'] != null ? int.parse(map['duration'].toString()) : null,
        title: map['title'] != null ? map['title'] as String : null,
        url: map['url'] != null
            ? map['url'] as String
            : map['path'] != null
                ? map['path'] as String
                : null,
        year: map['year'] != null ? map['year'] as String : null,
        language: map['language'] != null ? map['language'] as String : null,
        genre: map['genre'] != null ? map['genre'] as String : null,
        kbs: map['kbs'] != null ? map['kbs'] as String : null,
        hasLyrics: map['hasLyrics'] != null ? map['hasLyrics'] as bool : null,
        releaseDate: map['releaseDate'] != null ? map['releaseDate'] as String : null,
        albumId: map['albumId'] != null ? map['albumId'] as String : null,
        subtitle: map['subtitle'] != null ? map['subtitle'] as String : null,
        permaUrl: map['permaUrl'] != null ? map['permaUrl'] as String : null,
        libraryId: map['libraryId'] != null ? map['libraryId'] as String : null,
        mainPlaylistName: map['mainPlaylistName'] != null ? map['mainPlaylistName'] as String : null,
        mainPlaylistImages: map['mainPlaylistImages'] != null ? List<String>.from(jsonDecode(map['mainPlaylistImages'] as String) as List<dynamic>) : null,
      );
    } catch (e) {
      log('Error in 8  : $e');
    }

    return SongItemModel(
      id: map['id'] != null ? map['id'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      album: map['album'] != null ? map['album'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      duration: map['duration'] != null ? int.parse(map['duration'].toString()) : null,
      title: map['title'] != null ? map['title'] as String : null,
      url: map['url'] != null
          ? map['url'] as String
          : map['path'] != null
              ? map['path'] as String
              : null,
      year: map['year'] != null ? map['year'] as String : null,
      language: map['language'] != null ? map['language'] as String : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
      kbs: map['kbs'] != null ? map['kbs'] as String : null,
      hasLyrics: map['hasLyrics'] != null ? map['hasLyrics'] as bool : null,
      releaseDate: map['releaseDate'] != null ? map['releaseDate'] as String : null,
      albumId: map['albumId'] != null ? map['albumId'] as String : null,
      subtitle: map['subtitle'] != null ? map['subtitle'] as String : null,
      permaUrl: map['permaUrl'] != null ? map['permaUrl'] as String : null,
      libraryId: map['libraryId'] != null ? map['libraryId'] as String : null,
      mainPlaylistName: map['mainPlaylistName'] != null ? map['mainPlaylistName'] as String : null,
      mainPlaylistImages: map['mainPlaylistImages'] != null ? List<String>.from(jsonDecode(map['mainPlaylistImages'] as String) as List<dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongItemModel.fromJson(String source) => SongItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongItemModel(id: $id, artist: $artist, album: $album, image: $image, duration: $duration, title: $title, url: $url, year: $year, language: $language, genre: $genre, kbs: $kbs, hasLyrics: $hasLyrics, releaseDate: $releaseDate, albumId: $albumId, subtitle: $subtitle, permaUrl: $permaUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SongItemModel &&
        other.id == id &&
        other.artist == artist &&
        other.album == album &&
        other.image == image &&
        other.duration == duration &&
        other.title == title &&
        other.url == url &&
        other.year == year &&
        other.language == language &&
        other.genre == genre &&
        other.kbs == kbs &&
        other.hasLyrics == hasLyrics &&
        other.releaseDate == releaseDate &&
        other.albumId == albumId &&
        other.subtitle == subtitle &&
        other.permaUrl == permaUrl &&
        other.libraryId == libraryId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        artist.hashCode ^
        album.hashCode ^
        image.hashCode ^
        duration.hashCode ^
        title.hashCode ^
        url.hashCode ^
        year.hashCode ^
        language.hashCode ^
        genre.hashCode ^
        kbs.hashCode ^
        hasLyrics.hashCode ^
        releaseDate.hashCode ^
        albumId.hashCode ^
        subtitle.hashCode ^
        permaUrl.hashCode ^
        libraryId.hashCode;
  }
}

// {
//                                     'id': queue[index].id,
//                                     'artist': queue[index].artist.toString(),
//                                     'album': queue[index].album.toString(),
//                                     'image': queue[index].artUri.toString(),
//                                     'duration': queue[index]
//                                         .duration!
//                                         .inSeconds
//                                         .toString(),
//                                     'title': queue[index].title,
//                                     'url':
//                                         queue[index].extras?['url'].toString(),
//                                     'year':
//                                         queue[index].extras?['year'].toString(),
//                                     'language': queue[index]
//                                         .extras?['language']
//                                         .toString(),
//                                     'genre': queue[index].genre?.toString(),
//                                     '320kbps': queue[index].extras?['320kbps'],
//                                     'has_lyrics':
//                                         queue[index].extras?['has_lyrics'],
//                                     'release_date':
//                                         queue[index].extras?['release_date'],
//                                     'album_id':
//                                         queue[index].extras?['album_id'],
//                                     'subtitle':
//                                         queue[index].extras?['subtitle'],
//                                     'perma_url':
//                                         queue[index].extras?['perma_url'],
//                                   }
