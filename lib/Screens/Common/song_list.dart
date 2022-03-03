import 'dart:math';
import 'dart:ui';

import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/collage.dart';
import 'package:blackhole/CustomWidgets/copy_clipboard.dart';
import 'package:blackhole/CustomWidgets/download_button.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/like_button.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/CustomWidgets/playlist_popupmenu.dart';
import 'package:blackhole/CustomWidgets/song_tile_trailing_menu.dart';
import 'package:blackhole/Screens/Home/album_list.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/model/single_album_response.dart';
import 'package:blackhole/model/single_playlist_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/util/const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:share_plus/share_plus.dart';

enum SongListType { playlist, album }

class SongsListPage extends StatefulWidget {
  final List<SongItemModel>? songList;
  final String playlistName;
  final List<String>? playlistImage;
  final int? id;
  final SongListType? songListType;
  final bool? isMyPlaylist;
  final bool isFromLibrary;
  SongsListPage({
    Key? key,
    this.songList,
    this.playlistImage,
    required this.playlistName,
    this.id,
    this.songListType,
    this.isMyPlaylist,
    this.isFromLibrary = false,
  }) : super(key: key);

  @override
  _SongsListPageState createState() => _SongsListPageState();
}

class _SongsListPageState extends State<SongsListPage> {
  int page = 1;
  bool apiloading = false;
  String? mainPlayListName;
  List<String> mainPlayListImage = [];
  List<SongItemModel> songList = [];
  bool fetched = true;
  HtmlUnescape unescape = HtmlUnescape();
  final ScrollController _scrollController = ScrollController();
  List<String> selectedPlaylist = [];
  SinglePlaylistResponse? playlistRes;

  @override
  void initState() {
    super.initState();
    // _fetchSongs();
    songList = widget.songList ?? [];
    if (songList.isEmpty) {
      if (widget.id == null && widget.songListType == null) {
        Navigator.pop(context);
      } else {
        _fetchSongs();
      }
    }
    if (widget.playlistImage != null) {
      if (widget.playlistImage!.isNotEmpty) {
        mainPlayListImage = widget.playlistImage ?? [];
      }
    }
    if (widget.playlistName != null) {
      if (widget.playlistName.isNotEmpty) {
        mainPlayListName = widget.playlistName;
      }
    }
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.position.pixels <= 210) {
          print("LENGTH ::: ${_scrollController.position.pixels}");
          setState(() {});
        }
      }

      // if (_scrollController.position.pixels >=
      //         _scrollController.position.maxScrollExtent &&
      //     widget.listItem['type'].toString() == 'songs' &&
      //     !loading) {
      //   page += 1;
      //   _fetchSongs();
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  callback() {
    setState(() {
      _fetchSongs();
    });
  }

  void _fetchSongs() async {
    try {
      setState(() {
        apiloading = true;
      });
      if (widget.songListType == SongListType.album) {
        final SingleAlbumResponse? albumRes =
            await YogitunesAPI().fetchYogiSingleAlbumData(widget.id!);
        if (albumRes != null) {
          if (albumRes.status!) {
            if (albumRes.data != null) {
              if (albumRes.data!.lstSongItemModel != null) {
                if (albumRes.data!.lstSongItemModel!.isNotEmpty) {
                  songList = albumRes.data!.lstSongItemModel!;
                }
              }
              mainPlayListImage[0] = (albumRes.data?.cover?.imgUrl ?? '') +
                  (albumRes.data?.cover?.imgUrl != null ? '/' : '') +
                  (albumRes.data?.cover?.image ?? '');
              mainPlayListName ??= albumRes.data?.name ?? '';
            }
          }
        }
      } else if (widget.songListType == SongListType.playlist) {
        playlistRes =
            await YogitunesAPI().fetchYogiSinglePlaylistData(widget.id!);

        if (playlistRes != null) {
          if (playlistRes!.status!) {
            if (playlistRes!.data != null) {
              if (playlistRes!.data!.lstSongItemModel != null) {
                if (playlistRes!.data!.lstSongItemModel!.isNotEmpty) {
                  songList = playlistRes!.data!.lstSongItemModel!;
                  for (int i = 0;
                      i < playlistRes!.data!.lstSongItemModel!.length;
                      i++) {
                    selectedPlaylist.insert(i,
                        playlistRes!.data!.lstSongItemModel![i].id.toString());
                    print(selectedPlaylist);
                  }
                }
              }
              if (playlistRes?.data != null) {
                mainPlayListImage = playlistRes!.data!.getQuadImages();
              }
              // mainPlayListImage ??=
              //     (playlistRes!.data?.quadImages?[0]?.imageUrl ?? '') +
              //         (playlistRes!.data?.quadImages?[0]?.imageUrl != null
              //             ? "/"
              //             : '') +
              //         (playlistRes!.data?.quadImages?[0]?.image ?? '');

              mainPlayListName ??= playlistRes!.data?.name ?? '';
            }
          }
        }
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    } finally {
      setState(() {
        apiloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("mainPlayListImage :: $mainPlayListImage");
    // print("LENGTH ::: ${_scrollController.position.pixels}");
    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    stretch: true,
                    // floating: true,
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    actions: [
                      if (!apiloading && songList.isNotEmpty)
                        MultiDownloadButton(
                          data: List<dynamic>.from(
                            songList.map((x) => x.toMap()),
                          ),
                          playlistName: mainPlayListName ?? '',
                        ),
                      if (!apiloading && songList.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.share_rounded),
                          tooltip: AppLocalizations.of(context)!.share,
                          onPressed: () {
                            String strURL = strSHAREURL;
                            if (widget.songListType == SongListType.album) {
                              strURL += 'albums/';
                            } else {
                              strURL += 'playlists/';
                            }
                            strURL += widget.id.toString();
                            Share.share(
                              strURL, //widget.listItem['perma_url'].toString(),
                            );
                          },
                        ),
                      if (!apiloading && songList.isNotEmpty)
                        PlaylistPopupMenu(
                          data: songList,
                          title: mainPlayListName ?? '',
                          songListType: widget.songListType,
                          id: widget.id!,
                          isFromMyLibrary: widget.isFromLibrary,
                          // widget.listItem['title']?.toString() ??
                          //     'Songs',
                        ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        // width:
                        // (!_scrollController.hasClients ||
                        // _scrollController.positions.length > 1)
                        // ?
                        // MediaQuery.of(context).size.width,
                        // : MediaQuery.of(context).size.width - 75,
                        margin: (!_scrollController.hasClients ||
                                _scrollController.position.pixels <=
                                    MediaQuery.of(context).size.height * 0.2)
                            ? const EdgeInsets.all(0)
                            : const EdgeInsets.only(
                                left: 50,
                                right: 150,
                              ),
                        child: Text(
                          mainPlayListName ?? '',
                          maxLines: (!_scrollController.hasClients ||
                                  _scrollController.position.pixels <=
                                      MediaQuery.of(context).size.height * 0.2)
                              ? 3
                              : 1,
                          textAlign: (!_scrollController.hasClients ||
                                  _scrollController.position.pixels <=
                                      MediaQuery.of(context).size.height * 0.2)
                              ? TextAlign.center
                              : TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      centerTitle: true,
                      background: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(
                            Rect.fromLTRB(
                              0,
                              0,
                              rect.width,
                              rect.height,
                            ),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: mainPlayListImage.isEmpty
                            ? const Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/cover.jpg',
                                ),
                              )
                            : mainPlayListImage.length == 1
                                ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    errorWidget: (context, _, __) =>
                                        const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/album.png',
                                      ),
                                    ),
                                    imageUrl: mainPlayListImage[0],
                                    placeholder: (context, url) => const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/album.png',
                                      ),
                                    ),
                                  )
                                : Collage(
                                    showGrid: true,
                                    imageList: mainPlayListImage,
                                    placeholderImage: 'assets/album.png',
                                  ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (apiloading)
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width / 7,
                                width: MediaQuery.of(context).size.width / 7,
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        )
                      else if (songList.isEmpty)
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) => PlayScreen(
                                          songsList: songList,
                                          index: 0,
                                          offline: false,
                                          fromDownloads: false,
                                          fromMiniplayer: false,
                                          recommend: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 5,
                                    ),
                                    height: 45.0,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary ==
                                                  Colors.white
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          AppLocalizations.of(context)!.play,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary ==
                                                    Colors.white
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final List<SongItemModel> tempList =
                                        List.from(songList);
                                    tempList.shuffle();
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) => PlayScreen(
                                          songsList: tempList,
                                          index: 0,
                                          offline: false,
                                          fromDownloads: false,
                                          fromMiniplayer: false,
                                          recommend: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 5,
                                    ),
                                    height: 45.0,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.shuffle_rounded,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          AppLocalizations.of(context)!.shuffle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.songListType == SongListType.playlist)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 20, left: 20),
                                child: Text(
                                  playlistRes?.data?.playlistDuration != null
                                      ? 'Duration: ${playlistRes!.data!.playlistDuration.toString()}'
                                      : '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ...songList.map((entry) {
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.only(left: 15.0),
                                title: Text(
                                  '${entry.title}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onLongPress: () {
                                  copyToClipboard(
                                    context: context,
                                    text: '${entry.title}',
                                  );
                                },
                                subtitle: Text(
                                  entry.artist ?? 'Unkown',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    errorWidget: (context, _, __) =>
                                        const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/cover.jpg',
                                      ),
                                    ),
                                    imageUrl: '${entry.image}',
                                    placeholder: (context, url) => const Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/cover.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DownloadButton(
                                      data: entry.toMap(),
                                      icon: 'download',
                                    ),
                                    // LikeButton(
                                    //   mediaItem: null,
                                    //   data: entry,
                                    // ),
                                    SongTileTrailingMenu(
                                      data: entry,
                                      isMyPlaylist:
                                          widget.isMyPlaylist ?? false,
                                      selectedPlaylist: selectedPlaylist,
                                      playlistName: mainPlayListName ?? '',
                                      playlistId:
                                          int.parse(widget.id.toString()),
                                      callback: () => callback(),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  List<SongItemModel> songItemModel = [];
                                  songItemModel.add(entry);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) => PlayScreen(
                                        songsList: songList,
                                        index: songList.indexWhere(
                                          (element) => element == entry,
                                        ),
                                        offline: false,
                                        fromDownloads: false,
                                        fromMiniplayer: false,
                                        recommend: true,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList()
                          ],
                        )
                    ]),
                  )
                ],
              ),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}
