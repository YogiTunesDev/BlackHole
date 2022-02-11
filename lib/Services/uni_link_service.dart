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
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      debugPrint('initialLink :: $initialLink');
      sub = linkStream.listen((String? link) {
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
        debugPrint('Link received :: $link');
        // Parse the link and warn the user, if it is not correct
      }, onError: (err) {
        debugPrint('error Uni Link :: $err');
        // Handle exception by warning the user their action did not succeed
      });

      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      debugPrint('Platform Exception');
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}
