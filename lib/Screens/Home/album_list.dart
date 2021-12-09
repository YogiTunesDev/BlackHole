import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/copy_clipboard.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Home/saavn.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/model/album_response.dart';
import 'package:blackhole/model/genres_response.dart';
import 'package:blackhole/model/playlist_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/model/trending_song_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:blackhole/model/single_playlist_response.dart'
    as singlePlaylistResponse;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AlbumListType {
  yogaPlaylist,
  otherActivity,
  featuredAlbums,
  popularPlaylist,
  newRelease,
  popularAlbum,
  genresMoods,
  popularSong,
}
enum MainType { album, playlist, genres, genresAlbum, song }

class AlbumList extends StatefulWidget {
  final AlbumListType albumListType;
  final String? albumName;
  final int? id;
  const AlbumList({
    Key? key,
    required this.albumListType,
    required this.albumName,
    this.id,
  }) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  MainType? mainType;
  List<PlayListData> lstPlaylistData = [];
  List<AlbumData> lstAlbumData = [];
  bool apiLoading = false;
  int pageNo = 1;
  bool isFinish = false;
  List<GenresData> lstGenresData = [];
  List<singlePlaylistResponse.Track> lstSongTrending = [];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    pageNo = 1;
    final String? finalUrl = getListUrl();
    if (finalUrl == null) {
      Navigator.pop(context);
    } else {
      getApiData();
    }
    _scrollController.addListener(_listScrollListener);
  }

  void getApiData() async {
    try {
      apiLoading = true;
      setState(() {});
      if (mainType == MainType.playlist) {
        final PlaylistResponse? playlistRes =
            await YogitunesAPI().fetchYogiPlaylistData(getListUrl()!, pageNo);
        pageNo++;
        if (playlistRes != null) {
          if (playlistRes.status!) {
            if (playlistRes.data != null) {
              if (playlistRes.data!.playListData!.isNotEmpty) {
                lstPlaylistData.addAll(playlistRes.data!.playListData!);
              } else {
                isFinish = true;
              }
            } else {
              isFinish = true;
            }
          } else {
            isFinish = true;
          }
        } else {
          isFinish = true;
        }
      } else if (mainType == MainType.album) {
        final AlbumResponse? playlistRes =
            await YogitunesAPI().fetchYogiAlbumData(getListUrl()!, pageNo);
        pageNo++;
        if (playlistRes != null) {
          if (playlistRes.status!) {
            if (playlistRes.data != null) {
              if (playlistRes.data!.data!.isNotEmpty) {
                lstAlbumData.addAll(playlistRes.data!.data!);
              } else {
                isFinish = true;
              }
            } else {
              isFinish = true;
            }
          } else {
            isFinish = true;
          }
        } else {
          isFinish = true;
        }
      } else if (mainType == MainType.genres) {
        final GenresResponse? playlistRes =
            await YogitunesAPI().fetchYogiGenresData(getListUrl()!);
        pageNo++;
        if (playlistRes != null) {
          if (playlistRes.status!) {
            if (playlistRes.data != null) {
              lstGenresData.addAll(playlistRes.data!);
              isFinish = true;
            } else {
              isFinish = true;
            }
          } else {
            isFinish = true;
          }
        } else {
          isFinish = true;
        }
      } else if (mainType == MainType.genresAlbum) {
        final AlbumResponse? playlistRes = await YogitunesAPI()
            .fetchYogiGenresAlbumData(getListUrl()!, widget.id!, pageNo);
        pageNo++;
        if (playlistRes != null) {
          if (playlistRes.status!) {
            if (playlistRes.data != null) {
              if (playlistRes.data!.data!.isNotEmpty) {
                lstAlbumData.addAll(playlistRes.data!.data!);
              } else {
                isFinish = true;
              }
            } else {
              isFinish = true;
            }
          } else {
            isFinish = true;
          }
        } else {
          isFinish = true;
        }
      } else if (mainType == MainType.song) {
        final TrendingSongResponse? playlistRes = await YogitunesAPI()
            .fetchYogiTrendingSongData(getListUrl()!, pageNo);

        pageNo++;
        if (playlistRes != null) {
          if (playlistRes.status!) {
            if (playlistRes.data != null) {
              if (playlistRes.data!.data!.isNotEmpty) {
                lstSongTrending.addAll(playlistRes.data!.data!);
              } else {
                isFinish = true;
              }
            } else {
              isFinish = true;
            }
          } else {
            isFinish = true;
          }
        } else {
          isFinish = true;
        }
      }
    } on Exception catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    } finally {
      apiLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    actions: const [
                      // MultiDownloadButton(
                      //   data: songList,
                      //   playlistName:
                      //       widget.listItem['title']?.toString() ??
                      //           'Songs',
                      // ),
                      // PlaylistPopupMenu(
                      //   data: songList,
                      //   title: widget.listItem['title']?.toString() ??
                      //       'Songs',
                      // ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        widget.albumName!,
                        textAlign: TextAlign.center,
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
                        child: const Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/cover.jpg',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // Row(
                      //   mainAxisAlignment:
                      //       MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         // Navigator.push(
                      //         //   context,
                      //         //   PageRouteBuilder(
                      //         //     opaque: false,
                      //         //     pageBuilder: (_, __, ___) =>
                      //         //         PlayScreen(
                      //         //       songsList: songList,
                      //         //       index: 0,
                      //         //       offline: false,
                      //         //       fromDownloads: false,
                      //         //       fromMiniplayer: false,
                      //         //       recommend: true,
                      //         //     ),
                      //         //   ),
                      //         // );
                      //       },
                      //       child: Container(
                      //         margin: const EdgeInsets.only(
                      //           top: 20,
                      //           bottom: 5,
                      //         ),
                      //         height: 45.0,
                      //         width: 120,
                      //         decoration: BoxDecoration(
                      //           borderRadius:
                      //               BorderRadius.circular(100.0),
                      //           color: Theme.of(context)
                      //               .colorScheme
                      //               .secondary,
                      //           boxShadow: const [
                      //             BoxShadow(
                      //               color: Colors.black26,
                      //               blurRadius: 5.0,
                      //               offset: Offset(0.0, 3.0),
                      //             )
                      //           ],
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.play_arrow_rounded,
                      //               color: Theme.of(context)
                      //                           .colorScheme
                      //                           .secondary ==
                      //                       Colors.white
                      //                   ? Colors.black
                      //                   : Colors.white,
                      //             ),
                      //             const SizedBox(width: 5.0),
                      //             Text(
                      //               AppLocalizations.of(context)!
                      //                   .play,
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 18.0,
                      //                 color: Theme.of(context)
                      //                             .colorScheme
                      //                             .secondary ==
                      //                         Colors.white
                      //                     ? Colors.black
                      //                     : Colors.white,
                      //               ),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         final List tempList =
                      //             List.from(songList);
                      //         tempList.shuffle();
                      //         // Navigator.push(
                      //         //   context,
                      //         //   PageRouteBuilder(
                      //         //     opaque: false,
                      //         //     pageBuilder: (_, __, ___) =>
                      //         //         PlayScreen(
                      //         //       songsList: tempList,
                      //         //       index: 0,
                      //         //       offline: false,
                      //         //       fromDownloads: false,
                      //         //       fromMiniplayer: false,
                      //         //       recommend: true,
                      //         //     ),
                      //         //   ),
                      //         // );
                      //       },
                      //       child: Container(
                      //         margin: const EdgeInsets.only(
                      //           top: 20,
                      //           bottom: 5,
                      //         ),
                      //         height: 45.0,
                      //         width: 130,
                      //         decoration: BoxDecoration(
                      //           borderRadius:
                      //               BorderRadius.circular(100.0),
                      //           color: Colors.white,
                      //           boxShadow: const [
                      //             BoxShadow(
                      //               color: Colors.black26,
                      //               blurRadius: 5.0,
                      //               offset: Offset(0.0, 3.0),
                      //             )
                      //           ],
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.center,
                      //           children: [
                      //             const Icon(
                      //               Icons.shuffle_rounded,
                      //               color: Colors.black,
                      //             ),
                      //             const SizedBox(width: 5.0),
                      //             Text(
                      //               AppLocalizations.of(context)!
                      //                   .shuffle,
                      //               style: const TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 18.0,
                      //                 color: Colors.black,
                      //               ),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      if (((lstPlaylistData.isEmpty &&
                                  mainType == MainType.playlist) ||
                              (lstAlbumData.isEmpty &&
                                  mainType == MainType.album) ||
                              (lstGenresData.isEmpty &&
                                  mainType == MainType.genres) ||
                              (lstAlbumData.isEmpty &&
                                  mainType == MainType.genresAlbum) ||
                              (lstSongTrending.isEmpty &&
                                  mainType == MainType.song)) &&
                          !apiLoading)
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: mainType == MainType.playlist
                              ? GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: lstPlaylistData.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final PlayListData item =
                                        lstPlaylistData[index];
                                    String itemImage = item
                                            .quadImages!.isNotEmpty
                                        ? ('${item.quadImages![0].imageUrl!}/${item.quadImages![0].image!}')
                                        : '';
                                    return SongItem(
                                      itemImage: itemImage,
                                      itemName: item.name!,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (_, __, ___) =>
                                                SongsListPage(
                                              songList: item.songlist,
                                              playlistName: item.name!,
                                              playlistImage: itemImage,
                                              id: item.id,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : mainType == MainType.album ||
                                      mainType == MainType.genresAlbum
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                      ),
                                      itemCount: lstAlbumData.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final AlbumData item =
                                            lstAlbumData[index];
                                        final String itemImage = item
                                                    .cover!.image !=
                                                null
                                            ? ('${item.cover!.imgUrl}/${item.cover!.image}')
                                            : '';
                                        return SongItem(
                                          itemImage: itemImage,
                                          itemName: item.name!,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder: (_, __, ___) =>
                                                    SongsListPage(
                                                  songListType:
                                                      SongListType.album,
                                                  playlistName: item.name!,
                                                  playlistImage: itemImage,
                                                  id: item.id,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : mainType == MainType.genres
                                      ? GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          itemCount: lstGenresData.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final GenresData item =
                                                lstGenresData[index];

                                            return SongItem(
                                              itemImage: '',
                                              itemName: item.name!,
                                              isRound: true,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    opaque: false,
                                                    pageBuilder: (_, __, ___) =>
                                                        AlbumList(
                                                      albumListType:
                                                          AlbumListType
                                                              .genresMoods,
                                                      albumName: item.name,
                                                      id: item.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : mainType == MainType.song
                                          ? GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                              ),
                                              itemCount: lstSongTrending.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final SongItemModel item =
                                                    lstSongTrending[index]
                                                        .songItemModel!;

                                                return SongItem(
                                                  itemImage: item.image ?? '',
                                                  itemName: item.title ?? '',
                                                  onTap: () {
                                                    List<SongItemModel>
                                                        lstMainSongs = [];
                                                    lstMainSongs.add(item);
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        opaque: false,
                                                        pageBuilder:
                                                            (_, __, ___) =>
                                                                PlayScreen(
                                                          songsList:
                                                              lstMainSongs,
                                                          index: 0,
                                                          offline: false,
                                                          fromDownloads: false,
                                                          fromMiniplayer: false,
                                                          recommend: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : Container(),
                        ),
                      if (apiLoading)
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                            ),
                            child: Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width / 7,
                                width: MediaQuery.of(context).size.width / 7,
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        )
                      // ...lstPlaylistData.map((entry) {
                      //   final PlayListData item = entry;
                      //   return SongItem(
                      //     itemImage: item.quadImages!.isNotEmpty
                      //         ? ('${item.quadImages![0].imageUrl!}/${item.quadImages![0].image!}')
                      //         : '',
                      //     itemName: item.name!,
                      //   );
                      // }).toList()
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

  String? getListUrl() {
    final AlbumListType albumListType = widget.albumListType;
    if (albumListType == AlbumListType.yogaPlaylist) {
      mainType = MainType.playlist;
      return 'browse/popular_yoga_playlists';
    } else if (albumListType == AlbumListType.otherActivity) {
      mainType = MainType.genres;
      return 'browse/activities';
    } else if (albumListType == AlbumListType.featuredAlbums) {
      mainType = MainType.album;
      return 'browse/featured_albums';
    } else if (albumListType == AlbumListType.popularPlaylist) {
      mainType = MainType.playlist;
      return 'browse/popular_playlists';
    } else if (albumListType == AlbumListType.newRelease) {
      mainType = MainType.album;
      return 'browse/new_releases';
    } else if (albumListType == AlbumListType.popularAlbum) {
      mainType = MainType.album;
      return 'browse/trending_albums';
    } else if (albumListType == AlbumListType.genresMoods) {
      if (widget.id != null) {
        mainType = MainType.genresAlbum;
      } else {
        mainType = MainType.genres;
      }
      return 'browse/genres_moods';
    } else if (albumListType == AlbumListType.popularSong) {
      mainType = MainType.song;
      return 'browse/trending_songs';
    }
  }

  void _listScrollListener() {
    // if (lstPlaylistData.isNotEmpty) {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!isFinish & !apiLoading) {
        getApiData();
      }
    }
    // }
  }
}
