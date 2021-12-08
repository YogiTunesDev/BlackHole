import 'dart:convert';

import 'package:blackhole/model/song_model.dart';
import 'package:flutter/foundation.dart';

class HomeResponse {
  HomeResponse({
    this.statusCode,
    this.status,
    this.data,
  });

  final int? statusCode;
  final bool? status;
  final Data? data;

  HomeResponse copyWith({
    int? statusCode,
    bool? status,
    Data? data,
  }) {
    return HomeResponse(
      statusCode: statusCode ?? this.statusCode,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'status': status,
      'data': data?.toMap(),
    };
  }

  factory HomeResponse.fromMap(Map<String, dynamic> map) {
    print(map);
    return HomeResponse(
      statusCode: map['statusCode'] != null
          ? int.parse(map['statusCode'].toString())
          : null,
      status: map['status'] != null ? map['status'] as bool : null,
      data: map['data'] != null
          ? Data.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeResponse.fromJson(String source) =>
      HomeResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HomeResponse(statusCode: $statusCode, status: $status, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeResponse &&
        other.statusCode == statusCode &&
        other.status == status &&
        other.data == data;
  }

  @override
  int get hashCode => statusCode.hashCode ^ status.hashCode ^ data.hashCode;
}

class Data {
  Data({
    this.myRecentlyPlayedSongs,
    this.featuredAlbums,
    this.trendingAlbums,
    this.trendingSongs,
    this.trendingSongsNew,
    this.popularPlaylists,
    this.popularYogaPlaylists,
    this.newReleases,
    this.recentlyAdded,
    this.browseByActivity,
    this.browseByGenresMoods,
  });

  final List<dynamic>? myRecentlyPlayedSongs;
  final List<FeaturedAlbum>? featuredAlbums;
  final List<TrendingAlbum>? trendingAlbums;
  final List<TrendingAlbum>? trendingSongs;
  final List<SongItemModel>? trendingSongsNew;
  final List<PopularPlaylist>? popularPlaylists;
  final List<PopularPlaylist>? popularYogaPlaylists;
  final List<NewRelease>? newReleases;
  final List<NewRelease>? recentlyAdded;
  final List<BrowseBy>? browseByActivity;
  final List<BrowseBy>? browseByGenresMoods;

  Data copyWith({
    List<dynamic>? myRecentlyPlayedSongs,
    List<FeaturedAlbum>? featuredAlbums,
    List<TrendingAlbum>? trendingAlbums,
    List<TrendingAlbum>? trendingSongs,
    List<SongItemModel>? trendingSongsNew,
    List<PopularPlaylist>? popularPlaylists,
    List<PopularPlaylist>? popularYogaPlaylists,
    List<NewRelease>? newReleases,
    List<NewRelease>? recentlyAdded,
    List<BrowseBy>? browseByActivity,
    List<BrowseBy>? browseByGenresMoods,
  }) {
    return Data(
      myRecentlyPlayedSongs:
          myRecentlyPlayedSongs ?? this.myRecentlyPlayedSongs,
      featuredAlbums: featuredAlbums ?? this.featuredAlbums,
      trendingAlbums: trendingAlbums ?? this.trendingAlbums,
      trendingSongs: trendingSongs ?? this.trendingSongs,
      trendingSongsNew: trendingSongsNew ?? this.trendingSongsNew,
      popularPlaylists: popularPlaylists ?? this.popularPlaylists,
      popularYogaPlaylists: popularYogaPlaylists ?? this.popularYogaPlaylists,
      newReleases: newReleases ?? this.newReleases,
      recentlyAdded: recentlyAdded ?? this.recentlyAdded,
      browseByActivity: browseByActivity ?? this.browseByActivity,
      browseByGenresMoods: browseByGenresMoods ?? this.browseByGenresMoods,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'myRecentlyPlayedSongs': myRecentlyPlayedSongs,
      'featuredAlbums': featuredAlbums != null
          ? featuredAlbums?.map((x) => x.toMap()).toList()
          : null,
      'trendingAlbums': trendingAlbums != null
          ? trendingAlbums?.map((x) => x.toMap()).toList()
          : null,
      'trendingSongs': trendingSongs != null
          ? trendingSongs?.map((x) => x.toMap()).toList()
          : null,
      'trendingSongsNew': trendingSongsNew != null
          ? trendingSongsNew?.map((e) => e.toMap()).toList()
          : null,
      'popularPlaylists': popularPlaylists != null
          ? popularPlaylists?.map((x) => x.toMap()).toList()
          : null,
      'popularYogaPlaylists': popularYogaPlaylists != null
          ? popularYogaPlaylists?.map((x) => x.toMap()).toList()
          : null,
      'newReleases': newReleases != null
          ? newReleases?.map((x) => x.toMap()).toList()
          : null,
      'recentlyAdded': recentlyAdded != null
          ? recentlyAdded?.map((x) => x.toMap()).toList()
          : null,
      'browseByActivity': browseByActivity != null
          ? browseByActivity?.map((x) => x.toMap()).toList()
          : null,
      'browseByGenresMoods': browseByGenresMoods != null
          ? browseByGenresMoods?.map((x) => x.toMap()).toList()
          : null,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      myRecentlyPlayedSongs: map['My recently played songs'] != null
          ? List<dynamic>.from(map['My recently played songs'] as List<dynamic>)
          : null,
      featuredAlbums: map['Featured albums'] != null
          ? List<FeaturedAlbum>.from(map['Featured albums']
                  ?.map((x) => FeaturedAlbum.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      trendingAlbums: map['Trending albums'] != null
          ? List<TrendingAlbum>.from(map['Trending albums']
                  ?.map((x) => TrendingAlbum.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      trendingSongs: map['Trending songs'] != null
          ? List<TrendingAlbum>.from(map['Trending songs']
                  ?.map((x) => TrendingAlbum.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      trendingSongsNew: map['Trending songs new'] != null
          ? List<SongItemModel>.from(map['Trending songs new']
                  ?.map((x) => SongItemModel.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      popularPlaylists: map['Popular playlists'] != null
          ? List<PopularPlaylist>.from(map['Popular playlists']?.map(
                  (x) => PopularPlaylist.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      popularYogaPlaylists: map['Popular yoga playlists'] != null
          ? List<PopularPlaylist>.from(map['Popular yoga playlists']?.map(
                  (x) => PopularPlaylist.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      newReleases: map['New releases'] != null
          ? List<NewRelease>.from(map['New releases']
                  ?.map((x) => NewRelease.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      recentlyAdded: map['Recently added'] != null
          ? List<NewRelease>.from(map['Recently added']
                  ?.map((x) => NewRelease.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      browseByActivity: map['Browse by activity'] != null
          ? List<BrowseBy>.from(map['Browse by activity']
                  ?.map((x) => BrowseBy.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      browseByGenresMoods: map['Browse by genres & moods'] != null
          ? List<BrowseBy>.from(map['Browse by genres & moods']
                  ?.map((x) => BrowseBy.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(myRecentlyPlayedSongs: $myRecentlyPlayedSongs, featuredAlbums: $featuredAlbums, trendingAlbums: $trendingAlbums, trendingSongs: $trendingSongs, popularPlaylists: $popularPlaylists, popularYogaPlaylists: $popularYogaPlaylists, newReleases: $newReleases, recentlyAdded: $recentlyAdded, browseByActivity: $browseByActivity, browseByGenresMoods: $browseByGenresMoods)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Data &&
        listEquals(other.myRecentlyPlayedSongs, myRecentlyPlayedSongs) &&
        listEquals(other.featuredAlbums, featuredAlbums) &&
        listEquals(other.trendingAlbums, trendingAlbums) &&
        listEquals(other.trendingSongs, trendingSongs) &&
        listEquals(other.trendingSongsNew, trendingSongsNew) &&
        listEquals(other.popularPlaylists, popularPlaylists) &&
        listEquals(other.popularYogaPlaylists, popularYogaPlaylists) &&
        listEquals(other.newReleases, newReleases) &&
        listEquals(other.recentlyAdded, recentlyAdded) &&
        listEquals(other.browseByActivity, browseByActivity) &&
        listEquals(other.browseByGenresMoods, browseByGenresMoods);
  }

  @override
  int get hashCode {
    return myRecentlyPlayedSongs.hashCode ^
        featuredAlbums.hashCode ^
        trendingAlbums.hashCode ^
        trendingSongs.hashCode ^
        popularPlaylists.hashCode ^
        popularYogaPlaylists.hashCode ^
        newReleases.hashCode ^
        recentlyAdded.hashCode ^
        browseByActivity.hashCode ^
        browseByGenresMoods.hashCode;
  }
}

class BrowseBy {
  BrowseBy({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  BrowseBy copyWith({
    int? id,
    String? name,
  }) {
    return BrowseBy(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory BrowseBy.fromMap(Map<String, dynamic> map) {
    return BrowseBy(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'].toString() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrowseBy.fromJson(String source) =>
      BrowseBy.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BrowseBy(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BrowseBy && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class FeaturedAlbum {
  FeaturedAlbum({
    this.id,
    this.name,
    this.albumsClean,
  });

  final int? id;
  final String? name;
  final List<AlbumsClean>? albumsClean;

  FeaturedAlbum copyWith({
    int? id,
    String? name,
    List<AlbumsClean>? albumsClean,
  }) {
    return FeaturedAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      albumsClean: albumsClean ?? this.albumsClean,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'albumsClean': albumsClean != null
          ? albumsClean?.map((x) => x.toMap()).toList()
          : null,
    };
  }

  factory FeaturedAlbum.fromMap(Map<String, dynamic> map) {
    return FeaturedAlbum(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'].toString() : null,
      albumsClean: map['albums_clean'] != null
          ? List<AlbumsClean>.from(map['albums_clean']
                  ?.map((x) => AlbumsClean.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeaturedAlbum.fromJson(String source) =>
      FeaturedAlbum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FeaturedAlbum(id: $id, name: $name, albumsClean: $albumsClean)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeaturedAlbum &&
        other.id == id &&
        other.name == name &&
        listEquals(other.albumsClean, albumsClean);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ albumsClean.hashCode;
}

class AlbumsClean {
  AlbumsClean({
    this.id,
    this.name,
    this.artistId,
    this.pivot,
    this.cover,
    this.profile,
  });

  final int? id;
  final String? name;
  final int? artistId;
  final Pivot? pivot;
  final Cover? cover;
  final Profile? profile;

  AlbumsClean copyWith({
    int? id,
    String? name,
    int? artistId,
    Pivot? pivot,
    Cover? cover,
    Profile? profile,
  }) {
    return AlbumsClean(
      id: id ?? this.id,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      pivot: pivot ?? this.pivot,
      cover: cover ?? this.cover,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistId': artistId,
      'pivot': pivot?.toMap(),
      'cover': cover?.toMap(),
      'profile': profile?.toMap(),
    };
  }

  factory AlbumsClean.fromMap(Map<String, dynamic> map) {
    return AlbumsClean(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'].toString() : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      pivot: map['pivot'] != null
          ? Pivot.fromMap(map['pivot'] as Map<String, dynamic>)
          : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? Profile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumsClean.fromJson(String source) =>
      AlbumsClean.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AlbumsClean(id: $id, name: $name, artistId: $artistId, pivot: $pivot, cover: $cover, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlbumsClean &&
        other.id == id &&
        other.name == name &&
        other.artistId == artistId &&
        other.pivot == pivot &&
        other.cover == cover &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        artistId.hashCode ^
        pivot.hashCode ^
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
      image: map['image'] != null ? map['image'].toString() : null,
      imgUrl: map['img_url'] != null ? map['img_url'].toString() : null,
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

class Pivot {
  Pivot({
    this.tagId,
    this.taggableId,
  });

  final int? tagId;
  final int? taggableId;

  Pivot copyWith({
    int? tagId,
    int? taggableId,
  }) {
    return Pivot(
      tagId: tagId ?? this.tagId,
      taggableId: taggableId ?? this.taggableId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tagId': tagId,
      'taggableId': taggableId,
    };
  }

  factory Pivot.fromMap(Map<String, dynamic> map) {
    return Pivot(
      tagId: map['tag_id'] != null ? map['tag_id'] as int : null,
      taggableId: map['taggable_id'] != null ? map['taggable_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pivot.fromJson(String source) =>
      Pivot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pivot(tagId: $tagId, taggableId: $taggableId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pivot &&
        other.tagId == tagId &&
        other.taggableId == taggableId;
  }

  @override
  int get hashCode => tagId.hashCode ^ taggableId.hashCode;
}

class Profile {
  Profile({
    this.id,
    this.name,
    this.cover,
  });

  final int? id;
  final String? name;
  final Cover? cover;

  Profile copyWith({
    int? id,
    String? name,
    Cover? cover,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': cover?.toMap(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'].toString() : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Profile(id: $id, name: $name, cover: $cover)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.id == id &&
        other.name == name &&
        other.cover == cover;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ cover.hashCode;
}

class NewRelease {
  NewRelease({
    this.id,
    this.name,
    this.artistId,
    this.cover,
    this.profile,
    this.tracks,
  });

  final int? id;
  final String? name;
  final int? artistId;
  final Cover? cover;
  final TrendingAlbum? profile;
  final List<Track>? tracks;

  NewRelease copyWith({
    int? id,
    String? name,
    int? artistId,
    Cover? cover,
    TrendingAlbum? profile,
    List<Track>? tracks,
  }) {
    return NewRelease(
      id: id ?? this.id,
      name: name ?? this.name,
      artistId: artistId ?? this.artistId,
      cover: cover ?? this.cover,
      profile: profile ?? this.profile,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artistId': artistId,
      'cover': cover?.toMap(),
      'profile': profile?.toMap(),
      'tracks': tracks?.map((x) => x.toMap()).toList(),
    };
  }

  factory NewRelease.fromMap(Map<String, dynamic> map) {
    return NewRelease(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'].toString() : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? TrendingAlbum.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      tracks: map['tracks'] != null
          ? List<Track>.from(map['tracks']
                  ?.map((x) => Track.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewRelease.fromJson(String source) =>
      NewRelease.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewRelease(id: $id, name: $name, artistId: $artistId, cover: $cover, profile: $profile, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewRelease &&
        other.id == id &&
        other.name == name &&
        other.artistId == artistId &&
        other.cover == cover &&
        other.profile == profile &&
        listEquals(other.tracks, tracks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        artistId.hashCode ^
        cover.hashCode ^
        profile.hashCode ^
        tracks.hashCode;
  }
}

class TrendingAlbum {
  TrendingAlbum({
    this.id,
    this.name,
    this.cover,
    this.artistId,
    this.tracks,
  });

  final int? id;
  final String? name;
  final Cover? cover;
  final int? artistId;
  final List<Track>? tracks;

  TrendingAlbum copyWith({
    int? id,
    String? name,
    Cover? cover,
    int? artistId,
    List<Track>? tracks,
  }) {
    return TrendingAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      artistId: artistId ?? this.artistId,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': cover?.toMap(),
      'artistId': artistId,
      'tracks': tracks != null ? tracks?.map((x) => x.toMap()).toList() : null,
    };
  }

  factory TrendingAlbum.fromMap(Map<String, dynamic> map) {
    return TrendingAlbum(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as int : null,
      tracks: map['tracks'] != null
          ? List<Track>.from(map['tracks']
                  ?.map((x) => Track.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrendingAlbum.fromJson(String source) =>
      TrendingAlbum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TrendingAlbum(id: $id, name: $name, cover: $cover, artistId: $artistId, tracks: $tracks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrendingAlbum &&
        other.id == id &&
        other.name == name &&
        other.cover == cover &&
        other.artistId == artistId &&
        listEquals(other.tracks, tracks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        cover.hashCode ^
        artistId.hashCode ^
        tracks.hashCode;
  }
}

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
      name: map['name'] != null ? map['name'].toString() : null,
      duration: map['duration'] != null ? map['duration'].toString() : null,
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
      format: map['format'] != null ? map['format'].toString() : null,
      bitrate: map['bitrate'] != null ? map['bitrate'] as int : null,
      trackUrl: map['track_url'] != null ? map['track_url'].toString() : null,
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

class PopularPlaylist {
  PopularPlaylist({
    this.id,
    this.name,
    this.quadImages,
  });

  final int? id;
  final String? name;
  final List<QuadImage>? quadImages;

  PopularPlaylist copyWith({
    int? id,
    String? name,
    List<QuadImage>? quadImages,
  }) {
    return PopularPlaylist(
      id: id ?? this.id,
      name: name ?? this.name,
      quadImages: quadImages ?? this.quadImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quadImages': quadImages != null
          ? quadImages?.map((x) => x.toMap()).toList()
          : null,
    };
  }

  factory PopularPlaylist.fromMap(Map<String, dynamic> map) {
    return PopularPlaylist(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'].toString() : null,
      quadImages: map['quadImages'] != null
          ? List<QuadImage>.from(map['quadImages']
                  ?.map((x) => QuadImage.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PopularPlaylist.fromJson(String source) =>
      PopularPlaylist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PopularPlaylist(id: $id, name: $name, quadImages: $quadImages)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PopularPlaylist &&
        other.id == id &&
        other.name == name &&
        listEquals(other.quadImages, quadImages);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ quadImages.hashCode;
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
      imageUrl: map['image_url'] != null ? map['image_url'].toString() : null,
      image: map['image'] != null ? map['image'].toString() : null,
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
