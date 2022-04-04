import 'dart:math';

import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/collage.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/Screens/Search/search_view_all.dart';
import 'package:blackhole/model/home_model.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/radio_stations_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/model/user_info_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'album_list.dart';

bool fetched = false;
List preferredLanguage = Hive.box('settings')
    .get('preferredLanguage', defaultValue: ['Hindi']) as List;
List likedRadio =
    Hive.box('settings').get('likedRadio', defaultValue: []) as List;

//     Hive.box('cache').get('homepage', defaultValue: {}) as HomeResponse?;
// List lists = ['recent', ...?data['collections']];

class SaavnHomePage extends StatefulWidget {
  @override
  _SaavnHomePageState createState() => _SaavnHomePageState();
}

class _SaavnHomePageState extends State<SaavnHomePage>
    with AutomaticKeepAliveClientMixin<SaavnHomePage> {
  HomeResponse? data;
  List<RadioStationsData> lstRadioStation = [];
  List recentList =
      Hive.box('cache').get('recentSongs', defaultValue: []) as List;
  Map likedArtists =
      Hive.box('settings').get('likedArtists', defaultValue: {}) as Map;
  List blacklistedHomeSections = Hive.box('settings')
      .get('blacklistedHomeSections', defaultValue: []) as List;
  bool apiLoading = false;
  Future<void> getHomePageData() async {
    apiLoading = true;
    setState(() {});

    Map userInfoData =
        Hive.box('settings').get('userInfoData', defaultValue: {}) as Map;
    if (userInfoData.isEmpty) {
      final UserInfoResponse? userinfodatares =
          await YogitunesAPI().fetchUserData();
      // print("RESPONSE DATA ::::: $recievedData");
      if (userinfodatares != null) {
        if (userinfodatares.data != null) {
          // Hive.box('cache').put('homepage', recievedData);
          Hive.box('settings').put('name', userinfodatares.data?.name);
          Hive.box('settings').put('userInfoData', userinfodatares.toMap());
          // lists = data.length;
          // lists = [...?data['collections']];
          // lists.insert((lists.length / 2).round(), 'likedArtists');
        }
      }
    }

    /// fetch home page data
    final HomeResponse? recievedData = await YogitunesAPI().fetchHomePageData();
    if (recievedData != null) {
      if (recievedData.data != null) {
        data = recievedData;
      }
    }

    /// fetch radio station list
    final RadioStationsResponse? radioStationsResponse =
        await YogitunesAPI().fetchYogiRadioStationPageData(1);
    if (radioStationsResponse != null) {
      if (radioStationsResponse.data != null) {
        if (radioStationsResponse.data!.data != null) {
          lstRadioStation.addAll(radioStationsResponse.data!.data!);
        }
      }
    }
    apiLoading = false;
    setState(() {});
    // recievedData = await FormatResponse.formatPromoLists(data);
    // if (recievedData.isNotEmpty) {
    //   Hive.box('cache').put('homepage', recievedData);
    //   data = recievedData;
    //   lists=data;
    // lists = ['recent', ...?data['collections']];
    //   // lists.insert((lists.length / 2).round(), 'likedArtists');
    // }
    // setState(() {});
  }

  String getSubTitle(Map item) {
    final type = item['type'];
    if (type == 'charts') {
      return '';
    } else if (type == 'playlist' || type == 'radio_station') {
      return formatString(item['subtitle']?.toString());
    } else if (type == 'song') {
      return formatString(item['artist']?.toString());
    } else {
      final artists = item['more_info']?['artistMap']?['artists']
          .map((artist) => artist['name'])
          .toList();
      return formatString(artists?.join(', ')?.toString());
    }
  }

  List<Color> colorList = [
    Colors.red,
    Colors.amber,
    Colors.green,
    Colors.yellow,
    Colors.teal,
    Colors.purple,
    Colors.pink,
    Colors.blueGrey,
    Colors.indigo,
    Colors.orange,
    Colors.brown
  ];

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // if (!fetched) {
    getHomePageData();
    // fetched = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double boxSize =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: apiLoading
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ))
          : data != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// recently played list
                    if (data!.data!.myRecentlyPlayedSongs != null)
                      if (data!.data!.myRecentlyPlayedSongs!.isNotEmpty)
                        HeaderTitle(
                          title: 'My Recently Played Albums',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType:
                                      AlbumListType.recentlyPlayedSong,
                                  albumName: 'Recent Played Albums',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.myRecentlyPlayedSongs != null)
                      if (data!.data!.myRecentlyPlayedSongs!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount:
                                data!.data!.myRecentlyPlayedSongs!.length,
                            itemBuilder: (context, index) {
                              final MyRecentlyPlayedSong item =
                                  data!.data!.myRecentlyPlayedSongs![index];
                              final String itemImage = item.album?.cover != null
                                  ? ('${item.album!.cover!.imgUrl}/${item.album!.cover!.image!}')
                                  : '';

                              String type = '';
                              if (item.type != null) {
                                if (item.type == 'Album') {
                                  type = item.type.toString();
                                }
                              }

                              if (type.isNotEmpty) {
                                return SongItem(
                                  itemImage: [itemImage],
                                  itemName: item.track!.name!,
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            SongsListPage(
                                                songListType:
                                                    SongListType.album,
                                                playlistName: item.album!.name!,
                                                playlistImage: [itemImage],
                                                id: item.album!.id),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),

                    /// yoga plalists list
                    if (data!.data!.popularYogaPlaylists != null)
                      if (data!.data!.popularYogaPlaylists!.isNotEmpty)
                        HeaderTitle(
                          title: 'Yoga Playlists',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.yogaPlaylist,
                                  albumName: 'Yoga Playlists',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.popularYogaPlaylists != null)
                      if (data!.data!.popularYogaPlaylists!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.popularYogaPlaylists!.length,
                            itemBuilder: (context, index) {
                              final PopularPlaylist item =
                                  data!.data!.popularYogaPlaylists![index];
                              final String itemImage = item
                                      .quadImages!.isNotEmpty
                                  ? ('${item.quadImages![0].imageUrl!}/${item.quadImages![0].image!}')
                                  : '';
                              return SongItem(
                                itemImage: item.getQuadImages(),
                                itemName: item.name!,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SongsListPage(
                                        songListType: SongListType.playlist,
                                        playlistName: item.name!,
                                        playlistImage: item.getQuadImages(),
                                        id: item.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                    ///other activity list
                    if (data!.data!.browseByActivity != null)
                      if (data!.data!.browseByActivity!.isNotEmpty)
                        HeaderTitle(
                          title: 'Other Activities',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.otherActivity,
                                  albumName: 'Other Activities',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.browseByActivity != null)
                      if (data!.data!.browseByActivity!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.browseByActivity!.length,
                            itemBuilder: (context, index) {
                              final BrowseBy item =
                                  data!.data!.browseByActivity![index];
                              int randomNumber = Random().nextInt(11);
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) => AlbumList(
                                        albumListType:
                                            AlbumListType.otherActivity,
                                        albumName: item.name,
                                        id: item.id,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: boxSize / 2 - 30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox.square(
                                          dimension: boxSize / 2 - 40,
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                1000.0,
                                              ),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: boxSize / 2 - 40,
                                                  width: boxSize / 2 - 40,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        colorList[randomNumber],
                                                        colorList[randomNumber]
                                                            .withOpacity(0.5),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                ),
                                                Opacity(
                                                  opacity: 0.2,
                                                  child: SizedBox(
                                                    height: boxSize / 2 - 40,
                                                    width: boxSize / 2 - 40,
                                                    child: const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/album.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          formatString(item.name),
                                          textAlign: TextAlign.center,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              //     SongItem(
                              //   itemImage: '',
                              //   itemName: item.name!,
                              //   isRound: true,
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       PageRouteBuilder(
                              //         opaque: false,
                              //         pageBuilder: (_, __, ___) => AlbumList(
                              //           albumListType:
                              //               AlbumListType.otherActivity,
                              //           albumName: item.name,
                              //           id: item.id,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );
                            },
                          ),
                        ),

                    /// new releases list
                    if (data!.data!.newReleases != null)
                      if (data!.data!.newReleases!.isNotEmpty)
                        HeaderTitle(
                          title: 'New Releases',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.newRelease,
                                  albumName: 'New Releases',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.newReleases != null)
                      if (data!.data!.newReleases!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.newReleases!.length,
                            itemBuilder: (context, index) {
                              final NewRelease item =
                                  data!.data!.newReleases![index];
                              final String itemImage = item.cover != null
                                  ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                                  : '';
                              return SongItem(
                                itemImage: [itemImage],
                                itemName: item.name!,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SongsListPage(
                                        songListType: SongListType.album,
                                        playlistName: item.name!,
                                        playlistImage: [itemImage],
                                        id: item.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                    /// genres & moods list
                    if (data!.data!.browseByGenresMoods != null)
                      if (data!.data!.browseByGenresMoods!.isNotEmpty)
                        HeaderTitle(
                          title: 'Genres & Moods',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.genresMoods,
                                  albumName: 'Genres & Moods',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.browseByGenresMoods != null)
                      if (data!.data!.browseByGenresMoods!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.browseByGenresMoods!.length,
                            itemBuilder: (context, index) {
                              final BrowseBy item =
                                  data!.data!.browseByGenresMoods![index];
                              int randomNumber = Random().nextInt(11);
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) => AlbumList(
                                        albumListType:
                                            AlbumListType.genresMoods,
                                        albumName: item.name,
                                        id: item.id,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: boxSize / 2 - 30,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox.square(
                                          dimension: boxSize / 2 - 40,
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                1000.0,
                                              ),
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: boxSize / 2 - 40,
                                                  width: boxSize / 2 - 40,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        colorList[randomNumber],
                                                        colorList[randomNumber]
                                                            .withOpacity(0.5),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                ),
                                                Opacity(
                                                  opacity: 0.2,
                                                  child: SizedBox(
                                                    height: boxSize / 2 - 40,
                                                    width: boxSize / 2 - 40,
                                                    child: const Image(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/album.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          formatString(item.name),
                                          textAlign: TextAlign.center,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              // return SongItem(
                              //   itemImage: '',
                              //   itemName: item.name!,
                              //   isRound: true,
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       PageRouteBuilder(
                              //         opaque: false,
                              //         pageBuilder: (_, __, ___) => AlbumList(
                              //           albumListType:
                              //               AlbumListType.genresMoods,
                              //           albumName: item.name,
                              //           id: item.id,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );
                            },
                          ),
                        ),

                    /// featured albums list
                    if (data!.data!.featuredAlbums != null)
                      if (data!.data!.featuredAlbums!.isNotEmpty)
                        if (data!.data!.featuredAlbums![0].albumsClean != null)
                          if (data!
                              .data!.featuredAlbums![0].albumsClean!.isNotEmpty)
                            HeaderTitle(
                              title: 'Featured Albums',
                              viewAllOnTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (_, __, ___) =>
                                        const AlbumList(
                                      albumListType:
                                          AlbumListType.featuredAlbums,
                                      albumName: 'Featured Albums',
                                    ),
                                  ),
                                );
                              },
                            ),
                    if (data!.data!.featuredAlbums != null)
                      if (data!.data!.featuredAlbums!.isNotEmpty)
                        if (data!.data!.featuredAlbums![0].albumsClean != null)
                          if (data!
                              .data!.featuredAlbums![0].albumsClean!.isNotEmpty)
                            SizedBox(
                              height: boxSize / 2 + 10,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                itemCount: data!.data!.featuredAlbums![0]
                                    .albumsClean!.length,
                                itemBuilder: (context, index) {
                                  final AlbumsClean item = data!.data!
                                      .featuredAlbums![0].albumsClean![index];
                                  final String itemImage = item.cover != null
                                      ? ('${item.cover!.imgUrl!}/${item.cover!.image!}')
                                      : '';
                                  return SongItem(
                                    itemImage: [itemImage],
                                    itemName: item.name!,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (_, __, ___) =>
                                              SongsListPage(
                                            songListType: SongListType.album,
                                            playlistName: item.name!,
                                            playlistImage: [itemImage],
                                            id: item.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),

                    /// radio station list
                    if (lstRadioStation.isNotEmpty)
                      HeaderTitle(
                        title: 'Radio Station',
                        viewAllOnTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => const AlbumList(
                                albumListType: AlbumListType.popularAlbum,
                                albumName: 'Radio Station',
                              ),
                            ),
                          );
                        },
                      ),
                    if (lstRadioStation.isNotEmpty)
                      SizedBox(
                        height: boxSize / 2 + 10,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemCount: lstRadioStation.length,
                          itemBuilder: (context, index) {
                            final RadioStationsData item =
                                lstRadioStation[index];
                            final String itemImage = item.cover != null
                                ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                                : '';
                            return SongItem(
                              itemImage: [itemImage],
                              itemName: item.name!,
                              onTap: () {
                                openDialogForGetRadioStationStreamData(
                                    item.id!);
                              },
                            );
                          },
                        ),
                      ),

                    /// popular album list
                    if (data!.data!.trendingAlbums != null)
                      if (data!.data!.trendingAlbums!.isNotEmpty)
                        HeaderTitle(
                          title: 'Popular Albums',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.popularAlbum,
                                  albumName: 'Popular Albums',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.trendingAlbums != null)
                      if (data!.data!.trendingAlbums!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.trendingAlbums!.length,
                            itemBuilder: (context, index) {
                              final TrendingAlbum item =
                                  data!.data!.trendingAlbums![index];
                              final String itemImage = item.cover != null
                                  ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                                  : '';
                              return SongItem(
                                itemImage: [itemImage],
                                itemName: item.name!,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SongsListPage(
                                        songListType: SongListType.album,
                                        playlistName: item.name!,
                                        playlistImage: [itemImage],
                                        id: item.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                    /// popular playlist list
                    if (data!.data!.popularPlaylists != null)
                      if (data!.data!.popularPlaylists!.isNotEmpty)
                        HeaderTitle(
                          title: 'Popular Playlists',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.popularPlaylist,
                                  albumName: 'Popular Playlists',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.popularPlaylists != null)
                      if (data!.data!.popularPlaylists!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.popularPlaylists!.length,
                            itemBuilder: (context, index) {
                              final PopularPlaylist item =
                                  data!.data!.popularPlaylists![index];
                              final String itemImage = item.quadImages != null
                                  ? item.quadImages!.isNotEmpty
                                      ? ('${item.quadImages![0].imageUrl!}/${item.quadImages![0].image!}')
                                      : ''
                                  : '';
                              return SongItem(
                                itemImage: item.getQuadImages(),
                                itemName: item.name!,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SongsListPage(
                                        songListType: SongListType.playlist,
                                        playlistName: item.name!,
                                        playlistImage: item.getQuadImages(),
                                        id: item.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                    /// popular songs list
                    if (data!.data!.trendingSongsNew != null)
                      if (data!.data!.trendingSongsNew!.isNotEmpty)
                        HeaderTitle(
                          title: 'Popular Songs',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.popularSong,
                                  albumName: 'Popular Songs',
                                ),
                              ),
                            );
                          },
                        ),
                    if (data!.data!.trendingSongsNew != null)
                      if (data!.data!.trendingSongsNew!.isNotEmpty)
                        SizedBox(
                          height: boxSize / 2 + 10,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: data!.data!.trendingSongsNew!.length,
                            itemBuilder: (context, index) {
                              final SongItemModel item =
                                  data!.data!.trendingSongsNew![index];
                              // String imageUrl = item.cover != null
                              //     ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                              //     : '';
                              return SongItem(
                                itemImage: [item.image!],
                                itemName: item.title!,
                                onTap: () {
                                  // List<SongItemModel> lstSongs = [];
                                  // lstSongs.add(item);
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) => PlayScreen(
                                        songsList:
                                            data!.data!.trendingSongsNew!,
                                        index: index,
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
                          ),
                        ),
                  ],
                )
              : Center(
                  child: emptyScreen(
                    context,
                    0,
                    ':( ',
                    100,
                    AppLocalizations.of(context)!.sorry,
                    60,
                    AppLocalizations.of(context)!.resultsNotFound,
                    20,
                  ),
                ),
    );
  }

  void openDialogForGetRadioStationStreamData(int id) async {
    // Dialog mainDialog = Dialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   elevation: 0.0,
    //   backgroundColor: Colors.transparent,
    //   child: Center(
    //     child: SizedBox(
    //       height: MediaQuery.of(context).size.width / 2,
    //       width: MediaQuery.of(context).size.width / 2,
    //       child: Card(
    //         elevation: 10,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(15),
    //         ),
    //         clipBehavior: Clip.antiAlias,
    //         child: GradientContainer(
    //           child: Center(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 SizedBox(
    //                   height: MediaQuery.of(context).size.width / 7,
    //                   width: MediaQuery.of(context).size.width / 7,
    //                   child: CircularProgressIndicator(
    //                     valueColor: AlwaysStoppedAnimation<Color>(
    //                       Theme.of(context).colorScheme.secondary,
    //                     ),
    //                     strokeWidth: 5,
    //                   ),
    //                 ),
    //                 Text(
    //                   AppLocalizations.of(
    //                     context,
    //                   )!
    //                       .fetchingStream,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) => WillPopScope(
    //     onWillPop: () async => false,
    //     child: mainDialog,
    //   ),
    // );

    popupLoader(
        context,
        AppLocalizations.of(
          context,
        )!
            .fetchingStream);

    final RadioStationsStreamResponse? radioStationsStreamResponse =
        await YogitunesAPI().fetchYogiRadioStationStreamData(id);
    Navigator.pop(context);
    if (radioStationsStreamResponse != null) {
      if (radioStationsStreamResponse.songItemModel != null) {
        if (radioStationsStreamResponse.songItemModel!.isNotEmpty) {
          List<SongItemModel> lstSong = [];

          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => PlayScreen(
                songsList: radioStationsStreamResponse.songItemModel!,
                index: 0,
                offline: false,
                fromDownloads: false,
                fromMiniplayer: false,
                recommend: false,
              ),
            ),
          );
        }
      }
    }
  }
}

/// text header title widget
class HeaderTitle extends StatelessWidget {
  final String title;
  final Function()? viewAllOnTap;
  const HeaderTitle({Key? key, required this.title, this.viewAllOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              formatString(title),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: viewAllOnTap,
            child: const Text(
              'View All',
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// text header widget
class Header extends StatelessWidget {
  final String title;
  const Header({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              formatString(title),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// single song item widget
class SongItem extends StatelessWidget {
  final List<String> itemImage;
  final String itemName;
  final bool isRound;
  final Function()? onTap;
  const SongItem(
      {Key? key,
      required this.itemImage,
      required this.itemName,
      this.isRound = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double boxSize =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: boxSize / 2 - 30,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: boxSize / 2 - 40,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      isRound ? 1000.0 : 10.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: itemImage.length == 1
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, _, __) => Image(
                            fit: BoxFit.cover,
                            image: AssetImage(isRound
                                ? 'assets/album.png'
                                : 'assets/cover.jpg'),
                          ),
                          imageUrl: itemImage[0],
                          //  item['image']
                          //     .toString()
                          //     .replaceAll('http:', 'https:')
                          //     .replaceAll('50x50', '500x500')
                          //     .replaceAll('150x150', '500x500'),
                          placeholder: (context, url) => Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              isRound ? 'assets/album.png' : 'assets/cover.jpg',
                            ),
                          ),
                        )
                      : Collage(
                          showGrid: true,
                          imageList: itemImage,
                          placeholderImage:
                              isRound ? 'assets/album.png' : 'assets/cover.jpg',
                        ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                formatString(itemName),
                textAlign: TextAlign.center,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// This function is used to format String
String formatString(String? text) {
  return text == null
      ? ''
      : text
          .replaceAll('&amp;', '&')
          .replaceAll('&#039;', "'")
          .replaceAll('&quot;', '"')
          .trim();
}
