import 'dart:async';

import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Search/artist_data.dart';
import 'package:blackhole/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class UniLinkService {
  UniLinkService._();
  static final UniLinkService instance = UniLinkService._();
  StreamSubscription? sub;
  Future<void> initUniLinks(BuildContext context) async {
    debugPrint('Init Uni Link');
    try {
      await initialLink(context);
      sub = getLinksStream().listen((String? link) {
        debugPrint('Link received :: $link');
        redirectScreen(link, context);
      }, onError: (err) {
        debugPrint('error Uni Link :: $err');
      });
    } on PlatformException {
      debugPrint('Platform Exception');
    }
  }

  void redirectScreen(String? link, BuildContext context) {
    if (link != null) {
      if (link.isNotEmpty) {
        final data = link.split('/');
        if (data.isNotEmpty) {
          final String type = data[data.length - 2];
          late int id;
          try {
            id = int.parse(data[data.length - 1]);
          } catch (e) {
            id = 0;
          }

          if (type == 'playlists' && id != 0) {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => SongsListPage(
                  songListType: SongListType.playlist,
                  playlistName: '',
                  playlistImage: '',
                  id: id,
                ),
              ),
            );
          } else if (type == 'albums' && id != 0) {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => SongsListPage(
                  songListType: SongListType.album,
                  playlistName: '',
                  playlistImage: '',
                  id: id,
                ),
              ),
            );
          } else if (type == 'artists' && id != 0) {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => ArtistData(
                  id: id,
                  title: '',
                ),
              ),
            );
          } else if (type == 'tracks' && id != 0) {
            openSingleSongData(context, id, popupVisible: false);
          }
        }
      }
    }
  }

  Future<void> initialLink(BuildContext context) async {
    final link = await getInitialLink();
    debugPrint('initialLink :: $link');
    redirectScreen(link, context);
  }
}
