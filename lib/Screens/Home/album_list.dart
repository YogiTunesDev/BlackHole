import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/copy_clipboard.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Home/saavn.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/model/album_response.dart';
import 'package:blackhole/model/genres_response.dart';
import 'package:blackhole/model/home_model.dart';
import 'package:blackhole/model/my_recently_played_song_response.dart';
import 'package:blackhole/model/playlist_response.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
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
  recentlyPlayedSong,
}
enum MainType { album, playlist, genres, genresAlbum, song, track }

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
  List<MyRecentlyPlayedSong> lstRecentPlayedSong = [];
  final ScrollController _scrollController = ScrollController();

  String selectedSort = '';
  String selectedDuration = '';
  String selectedType = '';
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
        final PlaylistResponse? playlistRes = await YogitunesAPI()
            .fetchYogiPlaylistData(getListUrl()!, pageNo, selectedSort,
                selectedDuration, selectedType);
        print("PLAYLIST ::::::::::::::::");
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
        final AlbumResponse? playlistRes = await YogitunesAPI()
            .fetchYogiAlbumData(getListUrl()!, pageNo, selectedSort);
        print("ALBUM ::::::::::::::::");
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
        print("GENRES ::::::::::::::::");
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
        print("GENRES ALBUM ::::::::::::::::");
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
            .fetchYogiTrendingSongData(getListUrl()!, pageNo, selectedSort);
        print("SONG ::::::::::::::::");
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
      } else if (mainType == MainType.track) {
        final MyRecentlyPlayedSongResponse? myRecentlyPlayedSongResponse =
            await YogitunesAPI()
                .viewAllRecentTrack(getListUrl()!, pageNo: pageNo);
        print("TRACK ::::::::::::::::");
        pageNo++;
        if (myRecentlyPlayedSongResponse != null) {
          if (myRecentlyPlayedSongResponse.data != null) {
            lstRecentPlayedSong.addAll(myRecentlyPlayedSongResponse.data!);
          }
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

  void clearAllData() {
    lstPlaylistData = [];
    lstGenresData = [];
    lstAlbumData = [];
    lstSongTrending = [];
    lstRecentPlayedSong = [];
    pageNo = 1;
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
                    actions: [
                      if (widget.albumListType == AlbumListType.yogaPlaylist ||
                          widget.albumListType == AlbumListType.popularPlaylist)
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              builder: (BuildContext contex) {
                                return SizedBox(
                                  // height:
                                  //     MediaQuery.of(context).size.height * 0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Filter',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Playlist Duration',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            FilterButton(
                                              name: '30m',
                                              onTap: () {
                                                setState(() {
                                                  if (selectedDuration ==
                                                      '30') {
                                                    selectedDuration = '';
                                                  } else {
                                                    selectedDuration = '30';
                                                  }
                                                  clearAllData();
                                                  getApiData();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              isSelected:
                                                  selectedDuration == '30',
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            FilterButton(
                                              name: '45m',
                                              onTap: () {
                                                setState(() {
                                                  if (selectedDuration ==
                                                      '45') {
                                                    selectedDuration = '';
                                                  } else {
                                                    selectedDuration = '45';
                                                  }
                                                  clearAllData();
                                                  getApiData();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              isSelected:
                                                  selectedDuration == '45',
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            FilterButton(
                                              name: '60m',
                                              onTap: () {
                                                setState(() {
                                                  if (selectedDuration ==
                                                      '60') {
                                                    selectedDuration = '';
                                                  } else {
                                                    selectedDuration = '60';
                                                  }
                                                  clearAllData();
                                                  getApiData();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              isSelected:
                                                  selectedDuration == '60',
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            FilterButton(
                                              name: '75m',
                                              onTap: () {
                                                setState(() {
                                                  if (selectedDuration ==
                                                      '75') {
                                                    selectedDuration = '';
                                                  } else {
                                                    selectedDuration = '75';
                                                  }
                                                  clearAllData();
                                                  getApiData();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              isSelected:
                                                  selectedDuration == '75',
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            FilterButton(
                                              name: '90m',
                                              onTap: () {
                                                setState(() {
                                                  if (selectedDuration ==
                                                      '90') {
                                                    selectedDuration = '';
                                                  } else {
                                                    selectedDuration = '90';
                                                  }
                                                  clearAllData();
                                                  getApiData();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              isSelected:
                                                  selectedDuration == '90',
                                            ),
                                          ],
                                        ),
                                        if (widget.albumListType ==
                                            AlbumListType.yogaPlaylist)
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Yoga Type',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  FilterButton(
                                                    name: 'Vinyasa Gentle',
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedType ==
                                                            'Vinyasa Gentle') {
                                                          selectedType = '';
                                                        } else {
                                                          selectedType =
                                                              'Vinyasa Gentle';
                                                        }
                                                        clearAllData();
                                                        getApiData();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    isSelected: selectedType ==
                                                        'Vinyasa Gentle',
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  FilterButton(
                                                    name: 'Vinyasa Strong',
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedType ==
                                                            'Vinyasa Strong') {
                                                          selectedType = '';
                                                        } else {
                                                          selectedType =
                                                              'Vinyasa Strong';
                                                        }
                                                        clearAllData();
                                                        getApiData();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    isSelected: selectedType ==
                                                        'Vinyasa Strong',
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  FilterButton(
                                                    name: 'Yin/Restorative',
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedType ==
                                                            'Yin/Restorative') {
                                                          selectedType = '';
                                                        } else {
                                                          selectedType =
                                                              'Yin/Restorative';
                                                        }
                                                        clearAllData();
                                                        getApiData();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    isSelected: selectedType ==
                                                        'Yin/Restorative',
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  FilterButton(
                                                    name: 'Power Flow',
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedType ==
                                                            'Power Flow') {
                                                          selectedType = '';
                                                        } else {
                                                          selectedType =
                                                              'Power Flow';
                                                        }
                                                        clearAllData();
                                                        getApiData();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    isSelected: selectedType ==
                                                        'Power Flow',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_alt_rounded),
                        ),
                      if (widget.albumListType == AlbumListType.yogaPlaylist ||
                          widget.albumListType ==
                              AlbumListType.featuredAlbums ||
                          widget.albumListType ==
                              AlbumListType.popularPlaylist ||
                          widget.albumListType == AlbumListType.newRelease ||
                          widget.albumListType == AlbumListType.popularSong ||
                          widget.albumListType == AlbumListType.popularAlbum)
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              builder: (BuildContext contex) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            selectedSort = '&orderBy=name';
                                            clearAllData();
                                            getApiData();
                                            Navigator.pop(context);
                                          });
                                        },
                                        title: Text(
                                          'Title',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      ListTile(
                                        onTap: () {
                                          setState(() {
                                            selectedSort =
                                                widget.albumListType ==
                                                            AlbumListType
                                                                .yogaPlaylist ||
                                                        widget.albumListType ==
                                                            AlbumListType
                                                                .popularPlaylist
                                                    ? '&orderBy=created_at'
                                                    : '&orderBy=artist';
                                            clearAllData();

                                            getApiData();
                                            Navigator.pop(context);
                                          });
                                        },
                                        title: Text(
                                          widget.albumListType ==
                                                      AlbumListType
                                                          .yogaPlaylist ||
                                                  widget.albumListType ==
                                                      AlbumListType
                                                          .popularPlaylist
                                              ? 'Created At'
                                              : 'Artist',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        title: Text(
                                          'Cancel',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.sort_by_alpha),
                        )

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
                      if (((lstPlaylistData.isEmpty &&
                                  mainType == MainType.playlist) ||
                              (lstAlbumData.isEmpty &&
                                  mainType == MainType.album) ||
                              (lstGenresData.isEmpty &&
                                  mainType == MainType.genres) ||
                              (lstAlbumData.isEmpty &&
                                  mainType == MainType.genresAlbum) ||
                              (lstSongTrending.isEmpty &&
                                  mainType == MainType.song) ||
                              (lstRecentPlayedSong.isEmpty &&
                                  mainType == MainType.track)) &&
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
                                        ? item.quadImages![0] != null
                                            ? ('${item.quadImages![0]!.imageUrl!}/${item.quadImages![0]!.image!}')
                                            : ''
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
                                                          widget.albumListType,
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
                                          : mainType == MainType.track
                                              ? GridView.builder(
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                  ),
                                                  itemCount: lstRecentPlayedSong
                                                      .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final MyRecentlyPlayedSong
                                                        item =
                                                        lstRecentPlayedSong[
                                                            index];
                                                    String itemImage = item
                                                                .album !=
                                                            null
                                                        ? ('${item.album!.cover!.imgUrl}/${item.album!.cover!.image}')
                                                        : '';
                                                    return SongItem(
                                                      itemImage: itemImage,
                                                      itemName:
                                                          item.track!.name!,
                                                      onTap: () async {
                                                        popupLoader(
                                                            context,
                                                            AppLocalizations.of(
                                                              context,
                                                            )!
                                                                .fetchingStream);

                                                        final RadioStationsStreamResponse?
                                                            radioStationsStreamResponse =
                                                            await YogitunesAPI()
                                                                .fetchSingleSongData(
                                                                    item.track!
                                                                        .id!);
                                                        Navigator.pop(context);
                                                        if (radioStationsStreamResponse !=
                                                            null) {
                                                          if (radioStationsStreamResponse
                                                                  .songItemModel !=
                                                              null) {
                                                            if (radioStationsStreamResponse
                                                                .songItemModel!
                                                                .isNotEmpty) {
                                                              List<SongItemModel>
                                                                  lstSong = [];

                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  opaque: false,
                                                                  pageBuilder: (_,
                                                                          __,
                                                                          ___) =>
                                                                      PlayScreen(
                                                                    songsList:
                                                                        radioStationsStreamResponse
                                                                            .songItemModel!,
                                                                    index: 0,
                                                                    offline:
                                                                        false,
                                                                    fromDownloads:
                                                                        false,
                                                                    fromMiniplayer:
                                                                        false,
                                                                    recommend:
                                                                        false,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        }
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
      if (widget.id != null) {
        mainType = MainType.playlist;
        return 'browse/activities/${widget.id}';
      } else {
        mainType = MainType.genres;
        return 'browse/activities';
      }
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
    } else if (albumListType == AlbumListType.recentlyPlayedSong) {
      mainType = MainType.track;
      return 'browse/main/my-recently-played-songs';
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

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  final String name;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                name,
                // vocals[index]['val'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
