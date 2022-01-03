import 'package:audio_service/audio_service.dart';
import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/add_playlist.dart';
import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Helpers/add_mediitem_to_queue.dart';
import 'package:blackhole/Helpers/mediaitem_converter.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Search/search.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SongTileTrailingMenu extends StatefulWidget {
  final SongItemModel data;
  final bool isMyPlaylist;
  final List<String> selectedPlaylist;
  final String playlistName;
  final int? playlistId;
  final bool isFromLibrary;

  final VoidCallback callback;

  const SongTileTrailingMenu({
    this.isFromLibrary = false,
    Key? key,
    required this.data,
    required this.isMyPlaylist,
    required this.selectedPlaylist,
    required this.playlistName,
    this.playlistId,
    required this.callback,
  }) : super(key: key);

  @override
  _SongTileTrailingMenuState createState() => _SongTileTrailingMenuState();
}

class _SongTileTrailingMenuState extends State<SongTileTrailingMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).iconTheme.color,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.queue_music_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.playNext),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.playlist_add_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.addToQueue),
            ],
          ),
        ),
        if (widget.isMyPlaylist)
          PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(
                  Icons.remove,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 10.0),
                const Text('Remove from playlist'),
              ],
            ),
          )
        else
          PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(
                  Icons.playlist_add_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 10.0),
                Text(AppLocalizations.of(context)!.addToPlaylist),
              ],
            ),
          ),
        // PopupMenuItem(
        //   value: 4,
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.album_rounded,
        //         color: Theme.of(context).iconTheme.color,
        //       ),
        //       const SizedBox(width: 10.0),
        //       Text(AppLocalizations.of(context)!.viewAlbum),
        //     ],
        //   ),
        // ),
        PopupMenuItem(
          value: 5,
          child: Row(
            children: [
              Icon(
                widget.isFromLibrary
                    ? Icons.remove_rounded
                    : Icons.library_add_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(widget.isFromLibrary
                  ? 'Remove from library'
                  : 'Add to library',),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(
                Icons.share_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.share),
            ],
          ),
        ),
      ],
      onSelected: (int? value) async {
        final MediaItem mediaItem =
            MediaItemConverter.mapToMediaItem(widget.data.toMap());
        if (value == 3) {
          Share.share(widget.data.url.toString());
        }
        // if (value == 4) {
        //   Navigator.push(
        //     context,
        //     PageRouteBuilder(
        //       opaque: false,
        //       pageBuilder: (_, __, ___) => SongsListPage(
        //         listItem: {
        //           'type': 'album',
        //           'id': mediaItem.extras?['album_id'],
        //           'title': mediaItem.album,
        //           'image': mediaItem.artUri,
        //         },
        //       ),
        //     ),
        //   );
        // }
        if (value == 5) {
          if (widget.isFromLibrary) {
            await YogitunesAPI().trackRemoveFromLibrary(
                int.parse(widget.data.id.toString()),
                int.parse(widget.data.libraryId.toString()),
                context,);
          } else {
            await YogitunesAPI().trackAddToLibrary(
                int.parse(widget.data.id.toString()), context,);
          }
        }
        if (value == 0) {
          if (widget.isMyPlaylist) {
            debugPrint(widget.selectedPlaylist.toString());

            widget.selectedPlaylist
                .removeWhere((element) => element == widget.data.id.toString());
            popupLoader(context, 'Loading');
            final res = await YogitunesAPI().editPlaylist(
              widget.playlistId.toString(),
              widget.playlistName,
              widget.selectedPlaylist,
            );

            Navigator.pop(context);
            if (res['status'] as bool) {
              debugPrint('FUNCTION');
              widget.callback();
            } else {
              ShowSnackBar().showSnackBar(context, res['data'].toString());
            }
          } else {
            AddToPlaylist().addToPlaylist(context, mediaItem);
          }
        }
        if (value == 1) {
          addToNowPlaying(context: context, mediaItem: mediaItem);
        }
        if (value == 2) {
          playNext(mediaItem, context);
        }
      },
    );
  }
}

class YtSongTileTrailingMenu extends StatefulWidget {
  final Video data;
  const YtSongTileTrailingMenu({Key? key, required this.data})
      : super(key: key);

  @override
  _YtSongTileTrailingMenuState createState() => _YtSongTileTrailingMenuState();
}

class _YtSongTileTrailingMenuState extends State<YtSongTileTrailingMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).iconTheme.color,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                CupertinoIcons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                AppLocalizations.of(
                  context,
                )!
                    .searchHome,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.queue_music_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.playNext),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.playlist_add_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.addToQueue),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(
                Icons.playlist_add_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.addToPlaylist),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            children: [
              Icon(
                // Icons.music_video_rounded,
                Icons.video_library_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.watchVideo),
            ],
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Row(
            children: [
              Icon(
                Icons.share_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10.0),
              Text(AppLocalizations.of(context)!.share),
            ],
          ),
        ),
      ],
      onSelected: (int? value) {
        if (value == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(
                query: widget.data.title.split('|')[0].split('(')[0],
              ),
            ),
          );
        }
        // if (value == 1 || value == 2 || value == 3) {
        //   YouTubeServices()
        //       .formatVideo(
        //     video: widget.data,
        //     quality: Hive.box('settings')
        //         .get(
        //           'ytQuality',
        //           defaultValue: 'High',
        //         )
        //         .toString(),
        //   )
        //       .then((songMap) {
        //     final MediaItem mediaItem =
        //         MediaItemConverter.mapToMediaItem(songMap!);
        //     if (value == 1) {
        //       playNext(mediaItem, context);
        //     }
        //     if (value == 2) {
        //       addToNowPlaying(context: context, mediaItem: mediaItem);
        //     }
        //     if (value == 3) {
        //       AddToPlaylist().addToPlaylist(context, mediaItem);
        //     }
        //   });
        // }
        if (value == 4) {
          launch(widget.data.url);
        }
        if (value == 5) {
          Share.share(widget.data.url);
        }
      },
    );
  }
}
