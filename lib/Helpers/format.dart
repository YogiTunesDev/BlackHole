import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/model/home_model.dart';
import 'package:blackhole/model/my_library_track_response.dart';
import 'package:blackhole/model/playlist_response.dart' as PlayListResponse;
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/single_album_response.dart';
import 'package:blackhole/model/single_playlist_response.dart'
    as SinglePlaylistResponse;
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/model/track_model.dart';
import 'package:blackhole/model/trending_song_response.dart';
import 'package:dart_des/dart_des.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// ignore: avoid_classes_with_only_static_members
class FormatResponse {
  static String decode(String input) {
    const String key = '38346591';
    final DES desECB = DES(key: key.codeUnits);

    final Uint8List encrypted = base64.decode(input);
    final List<int> decrypted = desECB.decrypt(encrypted);
    final String decoded =
        utf8.decode(decrypted).replaceAll(RegExp(r'\.mp4.*'), '.mp4');
    return decoded.replaceAll('http:', 'https:');
  }

  static String capitalize(String msg) {
    return '${msg[0].toUpperCase()}${msg.substring(1)}';
  }

  static String formatString(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .trim();
  }

  static Future<List> formatSongsResponse(
    List responseList,
    String type,
  ) async {
    final List searchedList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'song':
        case 'album':
        case 'playlist':
          response = await formatSingleSongResponse(responseList[i] as Map);
          break;
        default:
          break;
      }

      if (response!.containsKey('Error')) {
        log('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        searchedList.add(response);
      }
    }
    return searchedList;
  }

  static Future<Map> formatSingleSongResponse(Map response) async {
    // Map cachedSong = Hive.box('cache').get(response['id']);
    // if (cachedSong != null) {
    //   return cachedSong;
    // }
    try {
      final List artistNames = [];
      if (response['more_info']?['artistMap']?['primary_artists'] == null ||
          response['more_info']?['artistMap']?['primary_artists'].length == 0) {
        if (response['more_info']?['artistMap']?['featured_artists'] == null ||
            response['more_info']?['artistMap']?['featured_artists'].length ==
                0) {
          if (response['more_info']?['artistMap']?['artists'] == null ||
              response['more_info']?['artistMap']?['artists'].length == 0) {
            artistNames.add('Unknown');
          } else {
            response['more_info']['artistMap']['artists'][0]['id']
                .forEach((element) {
              artistNames.add(element['name']);
            });
          }
        } else {
          response['more_info']['artistMap']['featured_artists']
              .forEach((element) {
            artistNames.add(element['name']);
          });
        }
      } else {
        response['more_info']['artistMap']['primary_artists']
            .forEach((element) {
          artistNames.add(element['name']);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['more_info']['album'].toString()),
        'year': response['year'],
        'duration': response['more_info']['duration'],
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        '320kbps': response['more_info']['320kbps'],
        'has_lyrics': response['more_info']['has_lyrics'],
        'lyrics_snippet':
            formatString(response['more_info']['lyrics_snippet'].toString()),
        'release_date': response['more_info']['release_date'],
        'album_id': response['more_info']['album_id'],
        'subtitle': formatString(response['subtitle'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'perma_url': response['perma_url'],
        'url': decode(response['more_info']['encrypted_media_url'].toString()),
      };
      // Hive.box('cache').put(response['id'], info);
    } catch (e) {
      return {'Error': e};
    }
  }

  static Future<Map> formatSingleAlbumSongResponse(Map response) async {
    try {
      final List artistNames = [];
      if (response['primary_artists'] == null ||
          response['primary_artists'].toString().trim() == '') {
        if (response['featured_artists'] == null ||
            response['featured_artists'].toString().trim() == '') {
          if (response['singers'] == null ||
              response['singer'].toString().trim() == '') {
            response['singers'].toString().split(', ').forEach((element) {
              artistNames.add(element);
            });
          } else {
            artistNames.add('Unknown');
          }
        } else {
          response['featured_artists']
              .toString()
              .split(', ')
              .forEach((element) {
            artistNames.add(element);
          });
        }
      } else {
        response['primary_artists'].toString().split(', ').forEach((element) {
          artistNames.add(element);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['album'].toString()),
        // .split('(')
        // .first
        'year': response['year'],
        'duration': response['duration'],
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        '320kbps': response['320kbps'],
        'has_lyrics': response['has_lyrics'],
        'lyrics_snippet': formatString(response['lyrics_snippet'].toString()),
        'release_date': response['release_date'],
        'album_id': response['album_id'],
        'subtitle': formatString(
          '${response["primary_artists"].toString().trim()} - ${response["album"].toString().trim()}',
        ),
        'title': formatString(response['song'].toString()),
        // .split('(')
        // .first
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'perma_url': response['perma_url'],
        'url': decode(response['encrypted_media_url'].toString())
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  static Future<List<Map>> formatAlbumResponse(
    List responseList,
    String type,
  ) async {
    final List<Map> searchedAlbumList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'album':
          response = await formatSingleAlbumResponse(responseList[i] as Map);
          break;
        case 'artist':
          response = await formatSingleArtistResponse(responseList[i] as Map);
          break;
        case 'playlist':
          response = await formatSinglePlaylistResponse(responseList[i] as Map);
          break;
        case 'show':
          response = await formatSingleShowResponse(responseList[i] as Map);
          break;
      }
      if (response!.containsKey('Error')) {
        log('Error at index $i inside FormatAlbumResponse: ${response["Error"]}');
      } else {
        searchedAlbumList.add(response);
      }
    }
    return searchedAlbumList;
  }

  static Future<Map> formatSingleAlbumResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'year': response['more_info']?['year'] ?? response['year'],
        'language': capitalize(
          response['more_info']?['language'] == null
              ? response['language'].toString()
              : response['more_info']['language'].toString(),
        ),
        'genre': capitalize(
          response['more_info']?['language'] == null
              ? response['language'].toString()
              : response['more_info']['language'].toString(),
        ),
        'album_id': response['id'],
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': response['music'] == null
            ? (response['more_info']?['music']) == null
                ? (response['more_info']?['artistMap']?['primary_artists'] ==
                            null ||
                        (response['more_info']?['artistMap']?['primary_artists']
                                as List)
                            .isEmpty)
                    ? ''
                    : formatString(
                        response['more_info']['artistMap']['primary_artists'][0]
                                ['name']
                            .toString(),
                      )
                : formatString(response['more_info']['music'].toString())
            : formatString(response['music'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'count': response['more_info']?['song_pids'] == null
            ? 0
            : response['more_info']['song_pids'].toString().split(', ').length,
        'songs_pids': response['more_info']['song_pids'].toString().split(', '),
        'perma_url': response['url'].toString(),
      };
    } catch (e) {
      log('Error inside formatSingleAlbumResponse: $e');
      return {'Error': e};
    }
  }

  static Future<Map> formatSinglePlaylistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'language': capitalize(
          response['language'] == null
              ? response['more_info']['language'].toString()
              : response['language'].toString(),
        ),
        'genre': capitalize(
          response['language'] == null
              ? response['more_info']['language'].toString()
              : response['language'].toString(),
        ),
        'playlistId': response['id'],
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        'artist': formatString(response['extra'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'perma_url': response['url'].toString(),
      };
    } catch (e) {
      log('Error inside formatSinglePlaylistResponse: $e');
      return {'Error': e};
    }
  }

  static Future<Map> formatSingleArtistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': response['title'] == null
            ? formatString(response['name'].toString())
            : formatString(response['title'].toString()),
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        'artistId': response['id'],
        'artistToken': response['url'] == null
            ? response['perma_url'].toString().split('/').last
            : response['url'].toString().split('/').last,
        'subtitle': response['description'] == null
            ? capitalize(response['role'].toString())
            : formatString(response['description'].toString()),
        'title': response['title'] == null
            ? formatString(response['name'].toString())
            : formatString(response['title'].toString()),
        // .split('(')
        // .first
        'perma_url': response['url'].toString(),
        'artist': formatString(response['title'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      log('Error inside formatSingleArtistResponse: $e');
      return {'Error': e};
    }
  }

  static Future<List> formatArtistTopAlbumsResponse(List responseList) async {
    final List result = [];
    for (int i = 0; i < responseList.length; i++) {
      final Map response =
          await formatSingleArtistTopAlbumSongResponse(responseList[i] as Map);
      if (response.containsKey('Error')) {
        log('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        result.add(response);
      }
    }
    return result;
  }

  static Future<Map> formatSingleArtistTopAlbumSongResponse(
    Map response,
  ) async {
    try {
      final List artistNames = [];
      if (response['more_info']?['artistMap']?['primary_artists'] == null ||
          response['more_info']['artistMap']['primary_artists'].length == 0) {
        if (response['more_info']?['artistMap']?['featured_artists'] == null ||
            response['more_info']['artistMap']['featured_artists'].length ==
                0) {
          if (response['more_info']?['artistMap']?['artists'] == null ||
              response['more_info']['artistMap']['artists'].length == 0) {
            artistNames.add('Unknown');
          } else {
            response['more_info']['artistMap']['artists'].forEach((element) {
              artistNames.add(element['name']);
            });
          }
        } else {
          response['more_info']['artistMap']['featured_artists']
              .forEach((element) {
            artistNames.add(element['name']);
          });
        }
      } else {
        response['more_info']['artistMap']['primary_artists']
            .forEach((element) {
          artistNames.add(element['name']);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'year': response['year'],
        'language': capitalize(response['language'].toString()),
        'genre': capitalize(response['language'].toString()),
        'album_id': response['id'],
        'subtitle': formatString(response['subtitle'].toString()),
        'title': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  static Future<List> formatSimilarArtistsResponse(List responseList) async {
    final List result = [];
    for (int i = 0; i < responseList.length; i++) {
      final Map response =
          await formatSingleSimilarArtistResponse(responseList[i] as Map);
      if (response.containsKey('Error')) {
        log('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        result.add(response);
      }
    }
    return result;
  }

  static Future<Map> formatSingleSimilarArtistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'artist': formatString(response['name'].toString()),
        'title': formatString(response['name'].toString()),
        'subtitle': capitalize(response['dominantType'].toString()),
        'image': response['image_url']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'artistToken': response['perma_url'].toString().split('/').last,
        'perma_url': response['perma_url'].toString(),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  static Future<Map> formatSingleShowResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  static Future<PlayListResponse.PlaylistResponse?> formatYogiPlaylistData(
    PlayListResponse.PlaylistResponse? playlistRes,
  ) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    PlayListResponse.PlaylistResponse? mainRes;
    try {
      final PlayListResponse.PlaylistResponse? res = playlistRes;
      if (res != null) {
        if (res.status!) {
          final PlayListResponse.Data? resData = res.data;
          if (resData != null) {
            if (res.data!.playListData!.isNotEmpty) {
              List<PlayListResponse.PlayListData>? playListDataTemp =
                  res.data!.playListData;
              for (var i = 0; i < playListDataTemp!.length; i++) {
                final PlayListResponse.PlayListData item =
                    res.data!.playListData![i];
                List<SongItemModel> songList = [];
                for (var j = 0; j < item.tracksOnly!.length; j++) {
                  PlayListResponse.TracksOnly trackonly = item.tracksOnly![j];
                  final String imageUrl = trackonly.album!.cover != null
                      ? '${trackonly.album!.cover!.imgUrl!}/${trackonly.album!.cover!.image!}'
                      : '';
                  String? albumName;
                  String? artistName;

                  if (trackonly.album != null) {
                    if (trackonly.album!.name != null) {
                      albumName = trackonly.album!.name;
                    }
                  }
                  if (trackonly.album != null) {
                    if (trackonly.album!.profile != null) {
                      if (trackonly.album!.profile!.name != null) {
                        artistName = trackonly.album!.profile!.name;
                      }
                    }
                  }
                  int? mDur;
                  if (trackonly.duration != null) {
                    final String mDuration = trackonly.duration!;
                    final List<String> lstTime = mDuration.split(':');
                    if (lstTime.length == 3) {
                      mDur = Duration(
                        hours: int.parse(
                          lstTime[0],
                        ),
                        minutes: int.parse(
                          lstTime[1],
                        ),
                        seconds: int.parse(
                          lstTime[2],
                        ),
                      ).inSeconds;
                    }
                  }
                  songList.add(
                    SongItemModel(
                      id: trackonly.id!.toString(),
                      title: trackonly.name,
                      subtitle: trackonly.album!.profile!.name,
                      album: albumName,
                      image: imageUrl,
                      url: isHighQualityStreming
                          ? trackonly
                              .files![trackonly.files!.length - 1].trackUrl
                          : trackonly.files![0].trackUrl,
                      artist: artistName,
                      duration: mDur,
                    ),
                  );
                }
                playListDataTemp[i] = item.copyWith(songlist: songList);
              }
              PlayListResponse.Data tempdata =
                  resData.copyWith(playListData: playListDataTemp);
              mainRes = playlistRes!.copyWith(data: tempdata);
            }
          }
        }
      }
    } catch (e) {
      log('Error in formatYogiPlaylistData: $e');
    }

    if (mainRes == null) {
      return playlistRes;
    } else {
      return mainRes;
    }
  }

  static Future<SingleAlbumResponse?> formatYogiSingleALbumData(
      SingleAlbumResponse? playlistRes) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    SingleAlbumResponse? mainRes;
    try {
      final SingleAlbumResponse? res = playlistRes;
      if (res != null) {
        if (res.status!) {
          if (res.data != null) {
            List<SongItemModel> songList = [];
            if (res.data!.tracks != null) {
              final List<Track>? playListDataTemp = res.data!.tracks;
              for (var i = 0; i < playListDataTemp!.length; i++) {
                final Track trackonly = playListDataTemp[i];
                final String imageUrl = res.data!.cover != null
                    ? '${res.data!.cover!.imgUrl!}/${res.data!.cover!.image!}'
                    : '';
                String? albumName;
                String? artistName;

                if (res.data != null) {
                  if (res.data!.name != null) {
                    albumName = res.data!.name;
                  }
                }
                if (res.data != null) {
                  if (res.data!.profile != null) {
                    if (res.data!.profile!.name != null) {
                      artistName = res.data!.profile!.name;
                    }
                  }
                }
                int? mDur;
                if (trackonly.duration != null) {
                  final String mDuration = trackonly.duration!;
                  final List<String> lstTime = mDuration.split(':');
                  if (lstTime.length == 3) {
                    mDur = Duration(
                      hours: int.parse(
                        lstTime[0],
                      ),
                      minutes: int.parse(
                        lstTime[1],
                      ),
                      seconds: int.parse(
                        lstTime[2],
                      ),
                    ).inSeconds;
                  }
                }
                songList.add(
                  SongItemModel(
                    id: trackonly.id!.toString(),
                    title: trackonly.name,
                    subtitle: res.data!.profile!.name,
                    album: albumName,
                    albumId: res.data!.id.toString(),
                    image: imageUrl,
                    url: isHighQualityStreming
                        ? trackonly.files![trackonly.files!.length - 1].trackUrl
                        : trackonly.files![0].trackUrl,
                    artist: artistName,
                    duration: mDur,
                  ),
                );
              }
            }
            final SingleAlbumData singleAlbumData =
                res.data!.copyWith(lstSongItemModel: songList);
            final SingleAlbumResponse finalSingleAlbum =
                res.copyWith(data: singleAlbumData);
            mainRes = finalSingleAlbum;
          }
        }
      }
    } catch (e) {
      log('Error in formatYogiPlaylistData: $e');
    }

    if (mainRes == null) {
      return playlistRes;
    } else {
      return mainRes;
    }
  }

  static Future<SinglePlaylistResponse.SinglePlaylistResponse?>
      formatYogiSinglePlaylistData(
          SinglePlaylistResponse.SinglePlaylistResponse? playlistRes) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    SinglePlaylistResponse.SinglePlaylistResponse? mainRes;
    try {
      final SinglePlaylistResponse.SinglePlaylistResponse? res = playlistRes;
      if (res != null) {
        if (res.status!) {
          if (res.data != null) {
            String? subtitle;
            if (res.data!.profile != null) {
              if (res.data!.profile!.name != null) {
                subtitle = res.data!.profile!.name;
              }
            }
            List<SongItemModel> songList = [];
            if (res.data!.playlistTracks != null) {
              final List<SinglePlaylistResponse.PlaylistTracks>
                  playListDataTemp = res.data!.playlistTracks!;
              for (var i = 0; i < playListDataTemp.length; i++) {
                final SinglePlaylistResponse.PlaylistTracks playlisttrackonly =
                    playListDataTemp[i];
                final SinglePlaylistResponse.Track trackonly =
                    playlisttrackonly.track!;
                final String imageUrl = trackonly.album!.cover != null
                    ? '${trackonly.album!.cover!.imgUrl!}/${trackonly.album!.cover!.image!}'
                    : '';
                String? albumName;
                String? albumId;
                String? artistName;
                String? artistId;
                if (trackonly.album != null) {
                  if (trackonly.album!.name != null) {
                    albumName = trackonly.album!.name;
                    albumId = trackonly.album!.id.toString();
                  }
                  if (trackonly.album!.profile != null) {
                    if (trackonly.album!.profile!.name != null) {
                      artistName = trackonly.album!.profile!.name;
                      artistId = trackonly.album!.profile!.id.toString();
                    }
                  }
                }
                int? mDur;
                if (trackonly.duration != null) {
                  final String mDuration = trackonly.duration!;
                  final List<String> lstTime = mDuration.split(':');
                  if (lstTime.length == 3) {
                    mDur = Duration(
                      hours: int.parse(
                        lstTime[0],
                      ),
                      minutes: int.parse(
                        lstTime[1],
                      ),
                      seconds: int.parse(
                        lstTime[2],
                      ),
                    ).inSeconds;
                  }
                }
                songList.add(
                  SongItemModel(
                    id: trackonly.id!.toString(),
                    title: trackonly.name,
                    subtitle: subtitle,
                    album: albumName,
                    albumId: albumId,
                    image: imageUrl,
                    url: isHighQualityStreming
                        ? trackonly.files![trackonly.files!.length - 1].trackUrl
                        : trackonly.files![0].trackUrl,
                    artist: artistName,
                    duration: mDur,
                  ),
                );
              }
            }
            final SinglePlaylistResponse.SinglePlaylistData singleAlbumData =
                res.data!.copyWith(lstSongItemModel: songList);
            final SinglePlaylistResponse.SinglePlaylistResponse
                finalSingleAlbum = res.copyWith(data: singleAlbumData);
            mainRes = finalSingleAlbum;
          }
        }
      }
    } catch (e) {
      log('Error in formatYogiPlaylistData: $e');
    }

    if (mainRes == null) {
      return playlistRes;
    } else {
      return mainRes;
    }
  }

  static Future<MyLibraryTrackResponse?> formatMyLibraryTrackSong(
      MyLibraryTrackResponse? myLibraryTrackres) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    MyLibraryTrackResponse? mainRes;
    try {
      final MyLibraryTrackResponse? res = myLibraryTrackres;
      if (res != null) {
        if (res.status!) {
          if (res.data != null) {
            // List<SongItemModel> songList = [];
            if (res.data!.data != null) {
              List<MyLibraryTrack> playListDataTemp = res.data!.data!;
              for (var i = 0; i < playListDataTemp.length; i++) {
                final SinglePlaylistResponse.Track trackonly =
                    playListDataTemp[i].track!;
                String imageUrl = '';
                String? albumName;
                String? albumId;
                String? artistName;
                String? artistId;
                if (trackonly.album != null) {
                  if (trackonly.album!.name != null) {
                    albumName = trackonly.album!.name;
                    albumId = trackonly.album!.id.toString();
                  }
                  if (trackonly.album!.profile != null) {
                    if (trackonly.album!.profile!.name != null) {
                      artistName = trackonly.album!.profile!.name;
                      artistId = trackonly.album!.profile!.id.toString();
                    }
                  }
                  if (trackonly.album!.cover != null) {
                    imageUrl = trackonly.album!.cover != null
                        ? '${trackonly.album!.cover!.imgUrl!}/${trackonly.album!.cover!.image!}'
                        : '';
                  }
                }
                int? mDur;
                if (trackonly.duration != null) {
                  final String mDuration = trackonly.duration!;
                  final List<String> lstTime = mDuration.split(':');
                  if (lstTime.length == 3) {
                    mDur = Duration(
                      hours: int.parse(
                        lstTime[0],
                      ),
                      minutes: int.parse(
                        lstTime[1],
                      ),
                      seconds: int.parse(
                        lstTime[2],
                      ),
                    ).inSeconds;
                  }
                }
                String fileUrl = '';
                if (trackonly.files != null) {
                  fileUrl = isHighQualityStreming
                      ? trackonly.files![trackonly.files!.length - 1].trackUrl!
                      : trackonly.files![0].trackUrl!;
                }
                String titlename = '';
                String libraryId = '';

                if (playListDataTemp[i].libraryId != null) {
                  libraryId = playListDataTemp[i].libraryId!.toString();
                }

                final songItem = SongItemModel(
                  id: trackonly.id!.toString(),
                  title: trackonly.name,
                  subtitle: '', //subtitle,
                  album: albumName,
                  albumId: albumId,
                  image: imageUrl,
                  url: fileUrl,
                  artist: artistName,
                  duration: mDur,
                  libraryId: libraryId,
                );
                playListDataTemp[i] =
                    playListDataTemp[i].copyWith(songItemModel: songItem);
              }
              final MyLibraryTrackResponseData singleAlbumData =
                  res.data!.copyWith(data: playListDataTemp);
              final MyLibraryTrackResponse finalSingleAlbum =
                  res.copyWith(data: singleAlbumData);
              mainRes = finalSingleAlbum;
            }
          }
        }
      }
    } catch (e, stack) {
      log('Error in formatYogiPlaylistData: $e');
      debugPrint(stack.toString());
    }

    if (mainRes == null) {
      return myLibraryTrackres;
    } else {
      return mainRes;
    }
  }

  static Future<TrendingSongResponse?> formatYogiTrendingSongData(
      TrendingSongResponse? playlistRes) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    TrendingSongResponse? mainRes;
    try {
      final TrendingSongResponse? res = playlistRes;
      if (res != null) {
        if (res.status!) {
          if (res.data != null) {
            // List<SongItemModel> songList = [];
            if (res.data!.data != null) {
              List<SinglePlaylistResponse.Track> playListDataTemp =
                  res.data!.data!;
              for (var i = 0; i < playListDataTemp.length; i++) {
                final SinglePlaylistResponse.Track trackonly =
                    playListDataTemp[i];
                String imageUrl = '';
                String? albumName;
                String? albumId;
                String? artistName;
                String? artistId;
                if (trackonly.album != null) {
                  if (trackonly.album!.name != null) {
                    albumName = trackonly.album!.name;
                    albumId = trackonly.album!.id.toString();
                  }
                  if (trackonly.album!.profile != null) {
                    if (trackonly.album!.profile!.name != null) {
                      artistName = trackonly.album!.profile!.name;
                      artistId = trackonly.album!.profile!.id.toString();
                    }
                  }
                  if (trackonly.album!.cover != null) {
                    imageUrl = trackonly.album!.cover != null
                        ? '${trackonly.album!.cover!.imgUrl!}/${trackonly.album!.cover!.image!}'
                        : '';
                  }
                }
                int? mDur;
                if (trackonly.duration != null) {
                  final String mDuration = trackonly.duration!;
                  final List<String> lstTime = mDuration.split(':');
                  if (lstTime.length == 3) {
                    mDur = Duration(
                      hours: int.parse(
                        lstTime[0],
                      ),
                      minutes: int.parse(
                        lstTime[1],
                      ),
                      seconds: int.parse(
                        lstTime[2],
                      ),
                    ).inSeconds;
                  }
                }
                String fileUrl = '';
                if (trackonly.files != null) {
                  fileUrl = isHighQualityStreming
                      ? trackonly.files![trackonly.files!.length - 1].trackUrl!
                      : trackonly.files![0].trackUrl!;
                }
                String titlename = '';

                final songItem = SongItemModel(
                  id: trackonly.id!.toString(),
                  title: trackonly.name,
                  subtitle: '', //subtitle,
                  album: albumName,
                  albumId: albumId,
                  image: imageUrl,
                  url: fileUrl,
                  artist: artistName,
                  duration: mDur,
                );
                playListDataTemp[i] =
                    trackonly.copyWith(songItemModel: songItem);
              }
              final TrendingSongData singleAlbumData =
                  res.data!.copyWith(data: playListDataTemp);
              final TrendingSongResponse finalSingleAlbum =
                  res.copyWith(data: singleAlbumData);
              mainRes = finalSingleAlbum;
            }
          }
        }
      }
    } catch (e, stack) {
      log('Error in formatYogiPlaylistData: $e');
      debugPrint(stack.toString());
    }

    if (mainRes == null) {
      return playlistRes;
    } else {
      return mainRes;
    }
  }

  static Future<HomeResponse?> formatHomePageData(
      HomeResponse? homeResponse) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    try {
      final HomeResponse res = homeResponse!;
      List<SongItemModel> songList = [];
      if (res.data != null) {
        if (res.data!.trendingSongs != null) {
          for (var i = 0; i < res.data!.trendingSongs!.length; i++) {
            final TrendingAlbum item = res.data!.trendingSongs![i];
            final String imageUrl = item.cover != null
                ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                : '';
            String? albumName;
            String? artistName;

            if (item.tracks != null) {
              if (item.tracks![0].name != null) {
                albumName = item.tracks![0].name;
              }
            }
            int? mDur;
            if (item.tracks != null) {
              if (item.tracks!.isNotEmpty) {
                if (item.tracks![0].duration != null) {
                  final String mDuration = item.tracks![0].duration!;
                  final List<String> lstTime = mDuration.split(':');
                  if (lstTime.length == 3) {
                    mDur = Duration(
                      hours: int.parse(
                        lstTime[0],
                      ),
                      minutes: int.parse(
                        lstTime[1],
                      ),
                      seconds: int.parse(
                        lstTime[2],
                      ),
                    ).inSeconds;
                  }
                }
              }
            }
            songList.add(
              SongItemModel(
                id: item.tracks![0].id!.toString(),
                title: item.name,
                album: albumName,
                image: imageUrl,
                url: isHighQualityStreming
                    ? item.tracks![0].files![item.tracks![0].files!.length - 1]
                        .trackUrl
                    : item.tracks![0].files![0].trackUrl,
                artist: artistName,
                duration: mDur,
              ),
            );
          }
        }
      }
      final Data data = res.data!.copyWith(trendingSongsNew: songList);
      final tempres = res.copyWith(data: data);
      return tempres;
    } catch (e) {
      log('Error in formatHomePageData: $e');
      return homeResponse;
    }
  }

  static Future<RadioStationsStreamResponse?> formatYogiRadioStationStreamData(
      RadioStationsStreamResponse? playlistRes) async {
    bool isHighQualityStreming = Hive.box('settings')
        .get('highQualityStreming', defaultValue: false) as bool;
    RadioStationsStreamResponse? mainRes;
    try {
      final RadioStationsStreamResponse? res = playlistRes;
      if (res != null) {
        if (res.status!) {
          if (res.data != null) {
            List<SongItemModel> songList = [];

            final List<RadioStationsStreamData>? playListDataTemp = res.data!;
            for (var i = 0; i < playListDataTemp!.length; i++) {
              final RadioStationsStreamData trackonly = playListDataTemp[i];
              // final String imageUrl = ;
              int? mDur;
              if (trackonly.duration != null) {
                final String mDuration = trackonly.duration!;
                final List<String> lstTime = mDuration.split(':');
                if (lstTime.length == 3) {
                  mDur = Duration(
                    hours: int.parse(
                      lstTime[0],
                    ),
                    minutes: int.parse(
                      lstTime[1],
                    ),
                    seconds: int.parse(
                      lstTime[2],
                    ),
                  ).inSeconds;
                }
              }
              songList.add(
                SongItemModel(
                  id: trackonly.hashCode.toString(),
                  title: trackonly.title,
                  subtitle: trackonly.title,
                  album: trackonly.artist,
                  albumId: trackonly.artist,
                  image: trackonly.poster,
                  url: trackonly.mp3,
                  artist: trackonly.artist,
                  duration: mDur,
                ),
              );
            }

            final RadioStationsStreamResponse finalSingleAlbum =
                res.copyWith(songItemModel: songList);
            mainRes = finalSingleAlbum;
          }
        }
      }
    } catch (e) {
      log('Error in formatYogiPlaylistData: $e');
    }

    if (mainRes == null) {
      return playlistRes;
    } else {
      return mainRes;
    }
  }

  static Future<Map> formatPromoLists(Map data) async {
    try {
      final List promoList = data['collections_temp'] as List;
      for (int i = 0; i < promoList.length; i++) {
        data[promoList[i]] = await formatSongsInList(
          data[promoList[i]] as List,
          fetchDetails: true,
        );
      }
      data['collections'].addAll(promoList);
      data['collections_temp'] = [];
    } catch (e) {
      log('Error in formatPromoLists: $e');
    }
    return data;
  }

  static Future<List> formatSongsInList(
    List list, {
    required bool fetchDetails,
  }) async {
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final Map item = list[i] as Map;
        if (item['type'] == 'song') {
          if (item['mini_obj'] as bool? ?? false) {
            if (fetchDetails) {
              Map cachedDetails =
                  Hive.box('cache').get(item['id'], defaultValue: {}) as Map;
              if (cachedDetails.isEmpty) {
                cachedDetails = await YogitunesAPI()
                    .fetchSongDetails(item['id'].toString());
                Hive.box('cache').put(cachedDetails['id'], cachedDetails);
              }
              list[i] = cachedDetails;
            }
            continue;
          }
          list[i] = await formatSingleSongResponse(item);
        }
      }
    }
    list.removeWhere((value) => value == null);
    return list;
  }
}
