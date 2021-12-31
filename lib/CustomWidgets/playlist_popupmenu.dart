import 'package:audio_service/audio_service.dart';
import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Helpers/mediaitem_converter.dart';
import 'package:blackhole/Helpers/playlist.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

class PlaylistPopupMenu extends StatefulWidget {
  final List<SongItemModel> data;
  final String title;
  final SongListType? songListType;
  final int id;
  final bool isFromMyLibrary;
  const PlaylistPopupMenu({
    Key? key,
    required this.data,
    required this.title,
    this.songListType,
    required this.id,
    this.isFromMyLibrary = false,
  }) : super(key: key);

  @override
  _PlaylistPopupMenuState createState() => _PlaylistPopupMenuState();
}

class _PlaylistPopupMenuState extends State<PlaylistPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert_rounded,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
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
        if (widget.songListType == SongListType.album ||
            widget.songListType == SongListType.playlist)
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(
                  widget.isFromMyLibrary
                      ? Icons.remove_rounded
                      : Icons.my_library_add_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 10.0),
                Text(widget.isFromMyLibrary
                    ? 'Remove from library'
                    : 'Add to Library'),
              ],
            ),
          ),
        // PopupMenuItem(
        //   value: 1,
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.favorite_border_rounded,
        //         color: Theme.of(context).iconTheme.color,
        //       ),
        //       const SizedBox(width: 10.0),
        //       Text(AppLocalizations.of(context)!.savePlaylist),
        //     ],
        //   ),
        // ),
      ],
      onSelected: (int? value) async {
        if (value == 1) {
          addPlaylist(widget.title, widget.data).then(
            (value) => ShowSnackBar().showSnackBar(
              context,
              '"${widget.title}" ${AppLocalizations.of(context)!.addedToPlaylists}',
            ),
          );
        }
        if (value == 2) {
          if (widget.songListType == SongListType.playlist) {
            await YogitunesAPI().playlistAddToLibrary(widget.id, context);
          } else {
            if (widget.isFromMyLibrary) {
              await YogitunesAPI().albumRemoveFromLibrary(widget.id, context);
            } else {
              await YogitunesAPI().albumAddToLibrary(widget.id, context);
            }
          }
        }
        if (value == 0) {
          final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
          final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
          if (currentMediaItem != null &&
              currentMediaItem.extras!['url'].toString().startsWith('http')) {
            // TODO: make sure to check if song is already in queue
            final queue = audioHandler.queue.value;
            widget.data.map((e) {
              final element = MediaItemConverter.mapToMediaItem(e.toMap());
              if (!queue.contains(element)) {
                audioHandler.addQueueItem(element);
              }
            });

            ShowSnackBar().showSnackBar(
              context,
              '"${widget.title}" ${AppLocalizations.of(context)!.addedToQueue}',
            );
          } else {
            ShowSnackBar().showSnackBar(
              context,
              currentMediaItem == null
                  ? AppLocalizations.of(context)!.nothingPlaying
                  : AppLocalizations.of(context)!.cantAddToQueue,
            );
          }
        }
      },
    );
  }
}
