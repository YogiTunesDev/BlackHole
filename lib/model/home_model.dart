import 'dart:convert';

import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/util/const.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'cover_model.dart';
import 'profile_model.dart';
import 'quad_image_model.dart';
import 'tag_model.dart';
import 'track_model.dart';

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
          ? int.parse(map['statusCode'] as String)
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

  final List<MyRecentlyPlayedSong>? myRecentlyPlayedSongs;
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
    List<MyRecentlyPlayedSong>? myRecentlyPlayedSongs,
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
      'myRecentlyPlayedSongs': myRecentlyPlayedSongs != null
          ? myRecentlyPlayedSongs?.map((x) => x.toMap()).toList()
          : null,
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
          ? List<MyRecentlyPlayedSong>.from(map['My recently played songs']
                  ?.map((x) =>
                      MyRecentlyPlayedSong.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
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

class MyRecentlyPlayedSong {
  MyRecentlyPlayedSong({
    this.trackId,
    this.sourceId,
    this.type,
    this.quadImages,
    this.playlist,
    this.track,
    this.album,
  });

  final int? trackId;
  final int? sourceId;
  final String? type;
  final List<QuadImage>? quadImages;
  final TrendingAlbum? playlist;
  final BrowseBy? track;
  final TrendingAlbum? album;

  MyRecentlyPlayedSong copyWith({
    int? trackId,
    int? sourceId,
    String? type,
    List<QuadImage>? quadImages,
    TrendingAlbum? playlist,
    BrowseBy? track,
    TrendingAlbum? album,
  }) {
    return MyRecentlyPlayedSong(
      trackId: trackId ?? this.trackId,
      sourceId: sourceId ?? this.sourceId,
      type: type ?? this.type,
      quadImages: quadImages ?? this.quadImages,
      playlist: playlist ?? this.playlist,
      track: track ?? this.track,
      album: album ?? this.album,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'sourceId': sourceId,
      'type': type,
      'quadImages': quadImages?.map((x) => x.toMap()).toList(),
      'playlist': playlist?.toMap(),
      'track': track?.toMap(),
      'album': album?.toMap(),
    };
  }

  factory MyRecentlyPlayedSong.fromMap(Map<String, dynamic> map) {
    return MyRecentlyPlayedSong(
      trackId: map['track_id'] != null ? map['track_id'] as int : null,
      sourceId: map['source_id'] != null ? map['source_id'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      quadImages: map['quadImages'] != null
          ? List<QuadImage>.from(map['quadImages']
                  ?.map((x) => QuadImage.fromMap(x as Map<String, dynamic>))
              as Iterable<dynamic>)
          : null,
      playlist: map['playlist'] != null
          ? TrendingAlbum.fromMap(map['playlist'] as Map<String, dynamic>)
          : null,
      track: map['track'] != null
          ? BrowseBy.fromMap(map['track'] as Map<String, dynamic>)
          : null,
      album: map['album'] != null
          ? TrendingAlbum.fromMap(map['album'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyRecentlyPlayedSong.fromJson(String source) =>
      MyRecentlyPlayedSong.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyRecentlyPlayedSong(trackId: $trackId, sourceId: $sourceId, type: $type, quadImages: $quadImages, playlist: $playlist, track: $track, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MyRecentlyPlayedSong &&
        other.trackId == trackId &&
        other.sourceId == sourceId &&
        other.type == type &&
        listEquals(other.quadImages, quadImages) &&
        other.playlist == playlist &&
        other.track == track &&
        other.album == album;
  }

  @override
  int get hashCode {
    return trackId.hashCode ^
        sourceId.hashCode ^
        type.hashCode ^
        quadImages.hashCode ^
        playlist.hashCode ^
        track.hashCode ^
        album.hashCode;
  }
  List<String> getQuadImages() {
    List<String> lstStr = [];
    if (quadImages != null) {
      if (TOTALIMAGES == 0) {
        for (var i = 0; i < quadImages!.length; i++) {
          if (quadImages?[i].imageUrl != null &&
              quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            }
          }
        }
      } else {
        for (var i = 0; i < TOTALIMAGES; i++) {
          if (quadImages?[i].imageUrl != null &&
              quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            } else {
              lstStr.add('');
            }
          }else{
            lstStr.add('');
          }
        }
      }
    }
    return lstStr;
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
      name: map['name'] != null ? map['name'] as String : null,
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
      name: map['name'] != null ? map['name'] as String : null,
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
      name: map['name'] != null ? map['name'] as String : null,
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
      name: map['name'] != null ? map['name'] as String : null,
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
      name: map['name'] != null ? map['name'] as String : null,
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
  List<String> getQuadImages() {
    List<String> lstStr = [];
    if (quadImages != null) {
      if (TOTALIMAGES == 0) {
        for (var i = 0; i < quadImages!.length; i++) {
          if (quadImages?[i].imageUrl != null &&
              quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            }
          }
        }
      } else {
        for (var i = 0; i < TOTALIMAGES; i++) {
          if (quadImages?[i].imageUrl != null &&
              quadImages?[i].image != null) {
            if (quadImages![i].imageUrl!.isNotEmpty) {
              lstStr
                  .add('${quadImages![i].imageUrl}/${quadImages![i].image}');
            } else {
              lstStr.add('');
            }
          }else{
            lstStr.add('');
          }
        }
      }
    }
    return lstStr;
  }
}
