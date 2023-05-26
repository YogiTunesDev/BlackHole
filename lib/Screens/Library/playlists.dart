import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/APIs/spotify_api.dart';
import 'package:blackhole/CustomWidgets/collage.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/CustomWidgets/textinput_dialog.dart';
import 'package:blackhole/Helpers/import_export_playlist.dart';
import 'package:blackhole/Helpers/playlist.dart';
import 'package:blackhole/Helpers/search_add_playlist.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/model/custom_playlist_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final settingsBox = Hive.box('settings');
  List playlistNames = [];
  Map playlistDetails = {};
  bool loading = false;
  bool dataLoader = false;
  CustomPlaylistResponse? customPlaylistResponse;

  @override
  void initState() {
    super.initState();
    fetchPlaylistData();
  }

  Future fetchPlaylistData() async {
    setState(() {
      dataLoader = true;
    });
    customPlaylistResponse = await YogitunesAPI().fetchPlaylistData();

    if (mounted) {
      setState(() {
        dataLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    playlistNames = settingsBox.get('playlistNames')?.toList() as List? ??
        ['Favorite Songs'];
    if (!playlistNames.contains('Favorite Songs')) {
      playlistNames.insert(0, 'Favorite Songs');
      settingsBox.put('playlistNames', playlistNames);
    }
    playlistDetails =
        settingsBox.get('playlistDetails', defaultValue: {}) as Map;

    return GradientContainer(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: Text(
                        AppLocalizations.of(context)!.playlists,
                      ),
                      centerTitle: true,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.secondary,
                      elevation: 0,
                    ),
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 5),
                          ListTile(
                            title: Text(
                                AppLocalizations.of(context)!.createPlaylist),
                            leading: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () async {
                              await showTextInputDialog(
                                context: context,
                                title: AppLocalizations.of(context)!
                                    .createNewPlaylist,
                                initialText: '',
                                keyboardType: TextInputType.name,
                                onSubmitted: (String value) async {
                                  if (value.isNotEmpty) {
                                    Navigator.pop(context);
                                    setState(() {
                                      loading = true;
                                    });

                                    String? playlistId = await YogitunesAPI()
                                        .createPlaylist(value, context);

                                    if (playlistId != null) {
                                      Navigator.pushNamed(
                                        context,
                                        '/createPlaylist',
                                        arguments: {
                                          'playlistId': playlistId,
                                          'name': value,
                                        },
                                      ).then((value) {
                                        fetchPlaylistData();
                                        setState(() {});
                                      });
                                    }

                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    final snackBar = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('Enter Value',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary)));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                              );
                              setState(() {});
                            },
                          ),
                          if (dataLoader)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else if (customPlaylistResponse?.data == null)
                            emptyScreen(
                              context,
                              0,
                              ':( ',
                              100,
                              AppLocalizations.of(context)!.sorry,
                              60,
                              AppLocalizations.of(context)!.resultsNotFound,
                              20,
                            )
                          else
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: customPlaylistResponse!.data!.length,
                              itemBuilder: (context, index) {
                                final PlaylistResponseData itemData =
                                    customPlaylistResponse!.data![index];

                                return ListTile(
                                  leading: Card(
                                    elevation: 5,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Collage(
                                        showGrid: true,
                                        cacheSize: 50,
                                        imageList: itemData.getQuadImages(
                                          isThumbnail: true,
                                        ),
                                        placeholderImage: 'assets/cover.jpg',
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    customPlaylistResponse!
                                        .data![index].playlist!.name
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    customPlaylistResponse!
                                            .data![index].playlistTracks!.length
                                            .toString() +
                                        ' Songs',
                                  ),
                                  trailing: PopupMenuButton(
                                    icon: const Icon(Icons.more_vert_rounded),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    onSelected: (int? value) async {
                                      if (value == 1) {
                                        exportPlaylist(
                                          context,
                                          customPlaylistResponse!
                                              .data![index].playlist!.name
                                              .toString(),
                                          customPlaylistResponse!
                                              .data![index].playlist!.name
                                              .toString(),
                                        );
                                      }
                                      if (value == 2) {
                                        sharePlaylist(
                                          context,
                                          customPlaylistResponse!
                                              .data![index].playlist!.name
                                              .toString(),
                                          customPlaylistResponse!
                                              .data![index].playlist!.name
                                              .toString(),
                                        );
                                      }
                                      if (value == 0) {
                                        // setState(() {
                                        //   dataLoader = true;
                                        // });

                                        popupLoader(context, 'Loading');

                                        await YogitunesAPI().deletePlylist(
                                            customPlaylistResponse!
                                                .data![index].playlist!.id
                                                .toString(),
                                            context);

                                        customPlaylistResponse =
                                            await YogitunesAPI()
                                                .fetchPlaylistData();

                                        Navigator.pop(context);
                                        setState(() {});
                                        // setState(() {
                                        //   dataLoader = false;
                                        // });

                                        // playlistDetails.remove(name);
                                        // await settingsBox.put(
                                        //   'playlistDetails',
                                        //   playlistDetails,
                                        // );
                                        // await playlistNames.removeAt(index);
                                        // await settingsBox.put(
                                        //   'playlistNames',
                                        //   playlistNames,
                                        // );
                                        // await Hive.openBox(name);
                                        // await Hive.box(name).deleteFromDisk();
                                        // setState(() {});
                                      }
                                      if (value == 3) {
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (BuildContext context) {
                                        //     final _controller =
                                        //         TextEditingController(
                                        //       text: showName,
                                        //     );
                                        //     return AlertDialog(
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(15.0),
                                        //       ),
                                        //       content: Column(
                                        //         mainAxisSize: MainAxisSize.min,
                                        //         children: [
                                        //           Row(
                                        //             children: [
                                        //               Text(
                                        //                 AppLocalizations.of(
                                        //                   context,
                                        //                 )!
                                        //                     .rename,
                                        //                 style: TextStyle(
                                        //                   color:
                                        //                       Theme.of(context)
                                        //                           .colorScheme
                                        //                           .secondary,
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //           TextField(
                                        //             autofocus: true,
                                        //             textAlignVertical:
                                        //                 TextAlignVertical
                                        //                     .bottom,
                                        //             controller: _controller,
                                        //             onSubmitted: (value) async {
                                        //               Navigator.pop(context);
                                        //               playlistDetails[name] ==
                                        //                       null
                                        //                   ? playlistDetails
                                        //                       .addAll({
                                        //                       name: {
                                        //                         'name':
                                        //                             value.trim()
                                        //                       }
                                        //                     })
                                        //                   : playlistDetails[
                                        //                           name]
                                        //                       .addAll({
                                        //                       'name':
                                        //                           value.trim()
                                        //                     });

                                        //               await settingsBox.put(
                                        //                 'playlistDetails',
                                        //                 playlistDetails,
                                        //               );
                                        //               setState(() {});
                                        //             },
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       actions: [
                                        //         TextButton(
                                        //           style: TextButton.styleFrom(
                                        //             primary: Theme.of(context)
                                        //                 .iconTheme
                                        //                 .color,
                                        //           ),
                                        //           onPressed: () {
                                        //             Navigator.pop(context);
                                        //           },
                                        //           child: Text(
                                        //             AppLocalizations.of(
                                        //                     context)!
                                        //                 .cancel,
                                        //           ),
                                        //         ),
                                        //         TextButton(
                                        //           style: TextButton.styleFrom(
                                        //             primary: Colors.white,
                                        //             backgroundColor:
                                        //                 Theme.of(context)
                                        //                     .colorScheme
                                        //                     .secondary,
                                        //           ),
                                        //           onPressed: () async {
                                        //             Navigator.pop(context);
                                        //             playlistDetails[name] ==
                                        //                     null
                                        //                 ? playlistDetails
                                        //                     .addAll({
                                        //                     name: {
                                        //                       'name':
                                        //                           _controller
                                        //                               .text
                                        //                               .trim()
                                        //                     }
                                        //                   })
                                        //                 : playlistDetails[name]
                                        //                     .addAll({
                                        //                     'name': _controller
                                        //                         .text
                                        //                         .trim()
                                        //                   });

                                        //             await settingsBox.put(
                                        //               'playlistDetails',
                                        //               playlistDetails,
                                        //             );
                                        //             setState(() {});
                                        //           },
                                        //           child: Text(
                                        //             AppLocalizations.of(
                                        //                     context)!
                                        //                 .ok,
                                        //             style: TextStyle(
                                        //               color: Theme.of(context)
                                        //                           .colorScheme
                                        //                           .secondary ==
                                        //                       Colors.white
                                        //                   ? Colors.black
                                        //                   : null,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         const SizedBox(
                                        //           width: 5,
                                        //         ),
                                        //       ],
                                        //     );
                                        //   },
                                        // );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      // if (name != 'Favorite Songs')
                                      //   PopupMenuItem(
                                      //     value: 3,
                                      //     child: Row(
                                      //       children: [
                                      //         const Icon(Icons.edit_rounded),
                                      //         const SizedBox(width: 10.0),
                                      //         Text(
                                      //           AppLocalizations.of(context)!
                                      //               .rename,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // if (name != 'Favorite Songs')
                                      PopupMenuItem(
                                        value: 0,
                                        child: Row(
                                          children: [
                                            const Icon(Icons.delete_rounded),
                                            const SizedBox(width: 10.0),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .delete,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // PopupMenuItem(
                                      //   value: 1,
                                      //   child: Row(
                                      //     children: [
                                      //       const Icon(MdiIcons.export),
                                      //       const SizedBox(width: 10.0),
                                      //       Text(
                                      //         AppLocalizations.of(context)!
                                      //             .export,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            const Icon(MdiIcons.share),
                                            const SizedBox(width: 10.0),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .share,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    final bool? isPlaylistModified =
                                        await Navigator.push<bool>(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            SongsListPage(
                                          songListType: SongListType.playlist,
                                          playlistName: customPlaylistResponse!
                                              .data![index].playlist!.name
                                              .toString(),
                                          playlistImage:
                                              itemData.getQuadImages(),
                                          id: customPlaylistResponse!
                                              .data![index].playlist!.id,
                                          isMyPlaylist: true,
                                        ),
                                      ),
                                    );
                                    if (isPlaylistModified!) {
                                      return fetchPlaylistData();
                                    }

                                    // await Hive.openBox(name);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => LikedSongs(
                                    //       playlistName: name,
                                    //       showName: playlistDetails
                                    //               .containsKey(name)
                                    //           ? playlistDetails[name]['name']
                                    //                   ?.toString() ??
                                    //               name
                                    //           : name,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const MiniPlayer(),
              ],
            ),
    );
  }
}

Future<void> fetchPlaylists(
  String code,
  BuildContext context,
  List playlistNames,
  Box settingsBox,
) async {
  final List data = await SpotifyApi().getAccessToken(code);
  if (data.isNotEmpty) {
    final String accessToken = data[0].toString();
    final List spotifyPlaylists =
        await SpotifyApi().getUserPlaylists(accessToken);
    final int? index = await showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext contxt) {
        return BottomGradientContainer(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            itemCount: spotifyPlaylists.length + 1,
            itemBuilder: (ctxt, idx) {
              if (idx == 0) {
                return ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.importPublicPlaylist,
                  ),
                  leading: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await showTextInputDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.enterPlaylistLink,
                      initialText: '',
                      keyboardType: TextInputType.url,
                      onSubmitted: (String value) async {
                        Navigator.pop(context);
                        value = value.split('?')[0].split('/').last;

                        final Map data = await SpotifyApi()
                            .getTracksOfPlaylist(accessToken, value, 0);
                        final int _total = data['total'] as int;

                        Stream<Map> songsAdder() async* {
                          int _done = 0;
                          final List tracks = [];
                          for (int i = 0; i * 100 <= _total; i++) {
                            final Map data =
                                await SpotifyApi().getTracksOfPlaylist(
                              accessToken,
                              value,
                              i * 100,
                            );
                            tracks.addAll(data['tracks'] as List);
                          }

                          String playName =
                              AppLocalizations.of(context)!.spotifyPublic;
                          while (playlistNames.contains(playName) ||
                              await Hive.boxExists(value)) {
                            // ignore: use_string_buffers
                            playName = '$playName (1)';
                          }
                          playlistNames.add(playName);
                          settingsBox.put('playlistNames', playlistNames);

                          for (final track in tracks) {
                            String? trackArtist;
                            String? trackName;
                            try {
                              trackArtist = track['track']['artists'][0]['name']
                                  .toString();
                              trackName = track['track']['name'].toString();
                              yield {'done': ++_done, 'name': trackName};
                            } catch (e) {
                              yield {'done': ++_done, 'name': ''};
                            }
                            try {
                              final List result =
                                  await YogitunesAPI().fetchTopSearchResult(
                                '$trackName by $trackArtist',
                              );
                              addMapToPlaylist(
                                playName,
                                result[0] as Map,
                              );
                            } catch (e) {
                              // print('Error in $_done: $e');
                            }
                          }
                        }

                        await SearchAddPlaylist.showProgress(
                          _total,
                          context,
                          songsAdder(),
                        );
                      },
                    );
                    Navigator.pop(context);
                  },
                );
              }

              final String playName = spotifyPlaylists[idx - 1]['name']
                  .toString()
                  .replaceAll('/', ' ');
              final int playTotal =
                  spotifyPlaylists[idx - 1]['tracks']['total'] as int;
              return playTotal == 0
                  ? const SizedBox()
                  : ListTile(
                      title: Text(playName),
                      subtitle: Text(
                        playTotal == 1 ? '$playTotal Song' : '$playTotal Songs',
                      ),
                      leading: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (spotifyPlaylists[idx - 1]['images'] as List)
                                .isEmpty
                            ? Image.asset('assets/cover.jpg')
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                errorWidget: (context, _, __) => const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/cover.jpg'),
                                ),
                                imageUrl:
                                    '${spotifyPlaylists[idx - 1]["images"][0]['url'].replaceAll('http:', 'https:')}',
                                placeholder: (context, url) => const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/cover.jpg'),
                                ),
                              ),
                      ),
                      onTap: () async {
                        Navigator.pop(context, idx - 1);
                      },
                    );
            },
          ),
        );
      },
    );
    if (index != null) {
      String playName =
          spotifyPlaylists[index]['name'].toString().replaceAll('/', ' ');
      final int _total = spotifyPlaylists[index]['tracks']['total'] as int;

      Stream<Map> songsAdder() async* {
        int _done = 0;
        final List tracks = [];
        for (int i = 0; i * 100 <= _total; i++) {
          final Map data = await SpotifyApi().getTracksOfPlaylist(
            accessToken,
            spotifyPlaylists[index]['id'].toString(),
            i * 100,
          );

          tracks.addAll(data['tracks'] as List);
        }
        if (!playlistNames.contains(playName)) {
          while (await Hive.boxExists(playName)) {
            // ignore: use_string_buffers
            playName = '$playName (1)';
          }
          playlistNames.add(playName);
          settingsBox.put('playlistNames', playlistNames);
        }

        for (final track in tracks) {
          String? trackArtist;
          String? trackName;
          try {
            trackArtist = track['track']['artists'][0]['name'].toString();
            trackName = track['track']['name'].toString();
            yield {'done': ++_done, 'name': trackName};
          } catch (e) {
            yield {'done': ++_done, 'name': ''};
          }
          try {
            final List result = await YogitunesAPI()
                .fetchTopSearchResult('$trackName by $trackArtist');
            addMapToPlaylist(playName, result[0] as Map);
          } catch (e) {
            // print('Error in $_done: $e');
          }
        }
      }

      await SearchAddPlaylist.showProgress(_total, context, songsAdder());
    }
  } else {
    // print('Failed');
  }
  return;
}
