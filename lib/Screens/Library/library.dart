import 'package:blackhole/Screens/Home/album_list.dart';
import 'package:blackhole/Screens/Search/search_view_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        AppBar(
          title: Text(
            AppLocalizations.of(context)!.library,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return Transform.rotate(
                angle: 22 / 7 * 2,
                child: IconButton(
                  color: Theme.of(context).iconTheme.color,
                  icon: const Icon(
                    Icons.horizontal_split_rounded,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            },
          ),
        ),
        // LibraryTile(
        //   title: AppLocalizations.of(context)!.nowPlaying,
        //   icon: Icons.queue_music_rounded,
        //   onTap: () {
        //     Navigator.pushNamed(context, '/nowplaying');
        //   },
        // ),
        // LibraryTile(
        //   title: AppLocalizations.of(context)!.lastSession,
        //   icon: Icons.history_rounded,
        //   onTap: () {
        //     Navigator.pushNamed(context, '/recent');
        //   },
        // ),
        // LibraryTile(
        //   title: AppLocalizations.of(context)!.favorites,
        //   icon: Icons.favorite_rounded,
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) =>
        //             const LikedSongs(playlistName: 'Favorite Songs'),
        //       ),
        //     );
        //   },
        // ),
        // if (Platform.isAndroid)
        //   LibraryTile(
        //     title: AppLocalizations.of(context)!.myMusic,
        //     icon: MdiIcons.folderMusic,
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const DownloadedSongs(
        //             showPlaylists: true,
        //           ),
        //         ),
        //       );
        //     },
        //   ),

        LibraryTile(
          title: 'Album',
          icon: Icons.album_rounded,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => const SearchViewAll(
                  title: 'Albums',
                  isFromLibrary: true,
                  searchAllType: SearchAllType.albums,
                ),
              ),
            );
            // Navigator.pushNamed(context, '/nowplaying');
          },
        ),
        LibraryTile(
          title: 'Track',
          icon: Icons.music_note_rounded,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => AlbumList(
                  // albumListType: AlbumListType.popularSong,
                  albumName: 'Tracks',
                  isFromLibrary: true,
                ),
              ),
            );
            // Navigator.pushNamed(context, '/nowplaying');
          },
        ),
        LibraryTile(
          title: 'Artist',
          icon: Icons.person_rounded,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => const SearchViewAll(
                  title: 'Artists',
                  isFromLibrary: true,
                  searchAllType: SearchAllType.artists,
                ),
              ),
            );
            // Navigator.pushNamed(context, '/nowplaying');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.downs,
          icon: Icons.download_done_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/downloads');
          },
        ),
        LibraryTile(
          title: AppLocalizations.of(context)!.playlists,
          icon: Icons.playlist_play_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/playlists');
          },
        ),
      ],
    );
  }
}

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
