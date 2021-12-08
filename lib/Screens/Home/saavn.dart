import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/model/home_model.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'album_list.dart';

bool fetched = false;
List preferredLanguage = Hive.box('settings')
    .get('preferredLanguage', defaultValue: ['Hindi']) as List;
List likedRadio =
    Hive.box('settings').get('likedRadio', defaultValue: []) as List;
HomeResponse? data;
//     Hive.box('cache').get('homepage', defaultValue: {}) as HomeResponse?;
// List lists = ['recent', ...?data['collections']];

class SaavnHomePage extends StatefulWidget {
  @override
  _SaavnHomePageState createState() => _SaavnHomePageState();
}

class _SaavnHomePageState extends State<SaavnHomePage>
    with AutomaticKeepAliveClientMixin<SaavnHomePage> {
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
    final HomeResponse? recievedData = await YogitunesAPI().fetchHomePageData();
    // print("RESPONSE DATA ::::: $recievedData");

    if (recievedData!.data != null) {
      // Hive.box('cache').put('homepage', recievedData);
      data = recievedData;
      // lists = data.length;
      // lists = [...?data['collections']];
      // lists.insert((lists.length / 2).round(), 'likedArtists');
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
      child: apiLoading
          ? const Center(child: CircularProgressIndicator())
          : data != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              return SongItem(
                                itemImage: item.quadImages!.isNotEmpty
                                    ? ('${item.quadImages![0].imageUrl!}/${item.quadImages![0].image!}')
                                    : '',
                                itemName: item.name!,
                              );
                            },
                          ),
                        ),
                    if (data!.data!.browseByActivity != null)
                      if (data!.data!.browseByActivity!.isNotEmpty)
                        const HeaderTitle(title: 'Other Activities'),
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
                              return SongItem(
                                itemImage: '',
                                itemName: item.name!,
                                isRound: true,
                              );
                            },
                          ),
                        ),
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
                                  return SongItem(
                                    itemImage: item.cover != null
                                        ? ('${item.cover!.imgUrl!}/${item.cover!.image!}')
                                        : '',
                                    itemName: item.name!,
                                  );
                                },
                              ),
                            ),
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
                              return SongItem(
                                itemImage: item.quadImages != null
                                    ? item.quadImages!.isNotEmpty
                                        ? ('${item.quadImages![0].imageUrl!}/${item.quadImages![0].image!}')
                                        : ''
                                    : '',
                                itemName: item.name!,
                              );
                            },
                          ),
                        ),
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
                              return SongItem(
                                itemImage: item.cover != null
                                    ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                                    : '',
                                itemName: item.name!,
                              );
                            },
                          ),
                        ),
                    if (data!.data!.trendingSongsNew != null)
                      if (data!.data!.trendingSongsNew!.isNotEmpty)
                        const HeaderTitle(title: 'Popular Songs'),
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
                                itemImage: item.image!,
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
                    if (data!.data!.trendingAlbums != null)
                      if (data!.data!.trendingAlbums!.isNotEmpty)
                        HeaderTitle(
                          title: 'Popular Album',
                          viewAllOnTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (_, __, ___) => const AlbumList(
                                  albumListType: AlbumListType.popularAlbum,
                                  albumName: 'Popular Album',
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
                              return SongItem(
                                itemImage: item.cover != null
                                    ? '${item.cover!.imgUrl!}/${item.cover!.image!}'
                                    : '',
                                itemName: item.name!,
                              );
                            },
                          ),
                        ),
                    if (data!.data!.browseByGenresMoods != null)
                      if (data!.data!.browseByGenresMoods!.isNotEmpty)
                        const HeaderTitle(title: 'Genres & Moods'),
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
                              return SongItem(
                                itemImage: '',
                                itemName: item.name!,
                                isRound: true,
                              );
                            },
                          ),
                        ),
                  ],
                )
              : Container(),
    );

    // return ListView.builder(
    //   physics: const BouncingScrollPhysics(),
    //   shrinkWrap: true,
    //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    //   itemCount: data.isEmpty ? 1 : lists.length,
    //   itemBuilder: (context, idx) {
    //     print("List Data :: " + lists[idx].toString());
    //     print("List Data :: " + lists[idx].toString());
    //     // List lst = lists[idx]["value"] as List;
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         if ((lists[idx]["value"] as List).length != 0)
    //           Padding(
    //             padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
    //             child: Text(
    //               formatString(
    //                   // data['modules'][lists[idx]]?['title']?.toString(),
    //                   lists[idx]["name"].toString()),
    //               style: TextStyle(
    //                 color: Theme.of(context).colorScheme.secondary,
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         if ((lists[idx]["value"] as List).length != 0)
    //           SizedBox(
    //             height: boxSize / 2 + 10,
    //             child: ListView.builder(
    //               physics: const BouncingScrollPhysics(),
    //               scrollDirection: Axis.horizontal,
    //               padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //               itemCount: (lists[idx]["value"] as List).length,
    //               //  data['modules'][lists[idx]]?['title']?.toString() ==
    //               //         'Radio Stations'
    //               //     ? (data[lists[idx]] as List).length + likedRadio.length
    //               //     : (data[lists[idx]] as List).length,
    //               itemBuilder: (context, index) {
    //                 Map item = lists[idx]["value"][index] as Map;
    //                 // if (data['modules'][lists[idx]]?['title']?.toString() ==
    //                 //     'Radio Stations') {
    //                 //   index < likedRadio.length
    //                 //       ? item = likedRadio[index] as Map
    //                 //       : item =
    //                 //           data[lists[idx]][index - likedRadio.length] as Map;
    //                 // } else {
    //                 //   item = data[lists[idx]][index] as Map;
    //                 // }
    //                 // final currentSongList = data[lists[idx]]
    //                 //     .where((e) => e['type'] == 'song')
    //                 //     .toList();
    //                 final title = item["name"]; //getSubTitle(item);
    //                 String? imageUrl;
    //                 bool isRound = false;
    //                 if (lists[idx]["name"].toString().contains("album")) {
    //                   isRound = true;
    //                   if (item.containsKey("albums_clean")) {
    //                   } else {
    //                     imageUrl = (item["cover"]["img_url"] +
    //                             "/" +
    //                             item["cover"]["image"])
    //                         .toString();
    //                   }
    //                 } else if (lists[idx]["name"]
    //                     .toString()
    //                     .contains("playlist")) {
    //                   isRound = true;
    //                   imageUrl = (item["quadImages"][0]["image_url"] +
    //                           "/" +
    //                           item["quadImages"][0]["image"])
    //                       .toString();
    //                 } else if (lists[idx]["name"]
    //                     .toString()
    //                     .toLowerCase()
    //                     .contains("browse")) {
    //                   isRound = true;
    //                 } else {
    //                   imageUrl = (item["cover"]["img_url"] +
    //                           "/" +
    //                           item["cover"]["image"])
    //                       .toString();
    //                 }
    //                 print(imageUrl);
    //                 if (item.isEmpty) return const SizedBox();
    //                 return GestureDetector(
    //                   onLongPress: () {
    //                     Feedback.forLongPress(context);
    //                     showDialog(
    //                       context: context,
    //                       builder: (context) {
    //                         return AlertDialog(
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(15.0),
    //                           ),
    //                           backgroundColor: Colors.transparent,
    //                           contentPadding: EdgeInsets.zero,
    //                           content: Card(
    //                             elevation: 5,
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(
    //                                 item['type'] == 'radio_station'
    //                                     ? 1000.0
    //                                     : 15.0,
    //                               ),
    //                             ),
    //                             clipBehavior: Clip.antiAlias,
    //                             child: CachedNetworkImage(
    //                               fit: BoxFit.cover,
    //                               errorWidget: (context, _, __) => const Image(
    //                                 fit: BoxFit.cover,
    //                                 image: AssetImage('assets/cover.jpg'),
    //                               ),
    //                               imageUrl: item['image']
    //                                   .toString()
    //                                   .replaceAll('http:', 'https:')
    //                                   .replaceAll('50x50', '500x500')
    //                                   .replaceAll('150x150', '500x500'),
    //                               placeholder: (context, url) => Image(
    //                                 fit: BoxFit.cover,
    //                                 image: (item['type'] == 'playlist' ||
    //                                         item['type'] == 'album')
    //                                     ? const AssetImage(
    //                                         'assets/album.png',
    //                                       )
    //                                     : item['type'] == 'artist'
    //                                         ? const AssetImage(
    //                                             'assets/artist.png',
    //                                           )
    //                                         : const AssetImage(
    //                                             'assets/cover.jpg',
    //                                           ),
    //                               ),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     );
    //                   },
    //                   onTap: () {
    //                     // if (item['type'] == 'radio_station') {
    //                     //   ShowSnackBar().showSnackBar(
    //                     //     context,
    //                     //     AppLocalizations.of(context)!.connectingRadio,
    //                     //     duration: const Duration(seconds: 2),
    //                     //   );
    //                     //   YogitunesAPI()
    //                     //       .createRadio(
    //                     //     item['more_info']['featured_station_type']
    //                     //                 .toString() ==
    //                     //             'artist'
    //                     //         ? item['more_info']['query'].toString()
    //                     //         : item['id'].toString(),
    //                     //     item['more_info']['language']?.toString() ?? 'hindi',
    //                     //     item['more_info']['featured_station_type'].toString(),
    //                     //   )
    //                     //       .then((value) {
    //                     //     if (value != null) {
    //                     //       YogitunesAPI().getRadioSongs(value).then(
    //                     //             (value) => Navigator.push(
    //                     //               context,
    //                     //               PageRouteBuilder(
    //                     //                 opaque: false,
    //                     //                 pageBuilder: (_, __, ___) => PlayScreen(
    //                     //                   songsList: value,
    //                     //                   index: 0,
    //                     //                   offline: false,
    //                     //                   fromDownloads: false,
    //                     //                   fromMiniplayer: false,
    //                     //                   recommend: true,
    //                     //                 ),
    //                     //               ),
    //                     //             ),
    //                     //           );
    //                     //     }
    //                     //   });
    //                     // } else {
    //                     //   // Navigator.push(
    //                     //   //   context,
    //                     //   //   PageRouteBuilder(
    //                     //   //     opaque: false,
    //                     //   //     pageBuilder: (_, __, ___) => item['type'] == 'song'
    //                     //   //         ? PlayScreen(
    //                     //   //             songsList: currentSongList as List,
    //                     //   //             index: currentSongList.indexWhere(
    //                     //   //               (e) => e['id'] == item['id'],
    //                     //   //             ),
    //                     //   //             offline: false,
    //                     //   //             fromDownloads: false,
    //                     //   //             fromMiniplayer: false,
    //                     //   //             recommend: true,
    //                     //   //           )
    //                     //   //         : SongsListPage(
    //                     //   //             listItem: item,
    //                     //   //           ),
    //                     //   //   ),
    //                     //   // );
    //                     // }
    //                   },
    //                   child: SizedBox(
    //                     width: boxSize / 2 - 30,
    //                     child: Stack(
    //                       children: [
    //                         Column(
    //                           children: [
    //                             SizedBox.square(
    //                               dimension: boxSize / 2 - 30,
    //                               child: Card(
    //                                 elevation: 5,
    //                                 shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(
    //                                     isRound ? 1000.0 : 10.0,
    //                                   ),
    //                                 ),
    //                                 clipBehavior: Clip.antiAlias,
    //                                 child: CachedNetworkImage(
    //                                   fit: BoxFit.cover,
    //                                   errorWidget: (context, _, __) => Image(
    //                                     fit: BoxFit.cover,
    //                                     image: AssetImage(isRound
    //                                         ? 'assets/album.png'
    //                                         : 'assets/cover.jpg'),
    //                                   ),
    //                                   imageUrl: imageUrl ?? "",
    //                                   //  item['image']
    //                                   //     .toString()
    //                                   //     .replaceAll('http:', 'https:')
    //                                   //     .replaceAll('50x50', '500x500')
    //                                   //     .replaceAll('150x150', '500x500'),
    //                                   placeholder: (context, url) => Image(
    //                                     fit: BoxFit.cover,
    //                                     image: isRound
    //                                         ? const AssetImage(
    //                                             'assets/album.png',
    //                                           )
    //                                         // :
    //                                         // item['type'] == 'artist'
    //                                         //     ? const AssetImage(
    //                                         //         'assets/artist.png',
    //                                         //       )
    //                                         : const AssetImage(
    //                                             'assets/cover.jpg',
    //                                           ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             Text(
    //                               formatString(title.toString()),
    //                               textAlign: TextAlign.center,
    //                               softWrap: false,
    //                               overflow: TextOverflow.ellipsis,
    //                               style: const TextStyle(
    //                                 fontWeight: FontWeight.w500,
    //                               ),
    //                             ),
    //                             // if (subTitle != '')
    //                             //   Text(
    //                             //     subTitle,
    //                             //     textAlign: TextAlign.center,
    //                             //     softWrap: false,
    //                             //     overflow: TextOverflow.ellipsis,
    //                             //     style: TextStyle(
    //                             //       fontSize: 11,
    //                             //       color: Theme.of(context)
    //                             //           .textTheme
    //                             //           .caption!
    //                             //           .color,
    //                             //     ),
    //                             //   )
    //                             // else
    //                             //   const SizedBox(),
    //                           ],
    //                         ),
    //                         // if (item['type'] == 'radio_station')
    //                         //   Align(
    //                         //     alignment: Alignment.topRight,
    //                         //     child: IconButton(
    //                         //       icon: likedRadio.contains(item)
    //                         //           ? const Icon(
    //                         //               Icons.favorite_rounded,
    //                         //               color: Colors.red,
    //                         //             )
    //                         //           : const Icon(
    //                         //               Icons.favorite_border_rounded,
    //                         //             ),
    //                         //       tooltip: likedRadio.contains(item)
    //                         //           ? AppLocalizations.of(context)!.unlike
    //                         //           : AppLocalizations.of(context)!.like,
    //                         //       onPressed: () {
    //                         //         likedRadio.contains(item)
    //                         //             ? likedRadio.remove(item)
    //                         //             : likedRadio.add(item);
    //                         //         Hive.box('settings')
    //                         //             .put('likedRadio', likedRadio);
    //                         //         setState(() {});
    //                         //       },
    //                         //     ),
    //                         //   )
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //           ),
    //       ],
    //     );
    //     // if (idx == 0) {
    //     //   return (recentList.isEmpty ||
    //     //           !(Hive.box('settings').get('showRecent', defaultValue: true)
    //     //               as bool))
    //     //       ? const SizedBox()
    //     //       : Column(
    //     //           children: [
    //     //             Row(
    //     //               children: [
    //     //                 Padding(
    //     //                   padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
    //     //                   child: Text(
    //     //                     AppLocalizations.of(context)!.lastSession,
    //     //                     style: TextStyle(
    //     //                       color: Theme.of(context).colorScheme.secondary,
    //     //                       fontSize: 18,
    //     //                       fontWeight: FontWeight.bold,
    //     //                     ),
    //     //                   ),
    //     //                 ),
    //     //               ],
    //     //             ),
    //     //             HorizontalAlbumsList(
    //     //               songsList: recentList,
    //     //               onTap: (int idx) {
    //     //                 Navigator.push(
    //     //                   context,
    //     //                   PageRouteBuilder(
    //     //                     opaque: false,
    //     //                     pageBuilder: (_, __, ___) => PlayScreen(
    //     //                       songsList: recentList,
    //     //                       index: idx,
    //     //                       offline: false,
    //     //                       fromDownloads: false,
    //     //                       fromMiniplayer: false,
    //     //                       recommend: true,
    //     //                     ),
    //     //                   ),
    //     //                 );
    //     //               },
    //     //             ),
    //     //           ],
    //     //         );
    //     // }
    //     // // if (lists[idx] == 'likedArtists') {
    //     // //   final List likedArtistsList = likedArtists.values.toList();
    //     // //   return likedArtists.isEmpty
    //     // //       ? const SizedBox()
    //     // //       : Column(
    //     // //           children: [
    //     // //             Row(
    //     // //               children: [
    //     // //                 Padding(
    //     // //                   padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
    //     // //                   child: Text(
    //     // //                     'Liked Artists',
    //     // //                     style: TextStyle(
    //     // //                       color: Theme.of(context).colorScheme.secondary,
    //     // //                       fontSize: 18,
    //     // //                       fontWeight: FontWeight.bold,
    //     // //                     ),
    //     // //                   ),
    //     // //                 ),
    //     // //               ],
    //     // //             ),
    //     // //             HorizontalAlbumsList(
    //     // //               songsList: likedArtistsList,
    //     // //               onTap: (int idx) {
    //     // //                 Navigator.push(
    //     // //                   context,
    //     // //                   PageRouteBuilder(
    //     // //                     opaque: false,
    //     // //                     pageBuilder: (_, __, ___) => ArtistSearchPage(
    //     // //                       data: likedArtistsList[idx] as Map,
    //     // //                     ),
    //     // //                   ),
    //     // //                 );
    //     // //               },
    //     // //             ),
    //     // //           ],
    //     // //         );
    //     // // }
    //     // return (data[lists[idx]] == null ||
    //     //         blacklistedHomeSections.contains(
    //     //           data['modules'][lists[idx]]?['title']
    //     //               ?.toString()
    //     //               .toLowerCase(),
    //     //         ))
    //     //     ? const SizedBox()
    //     //     : Column(
    //     //         crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: [
    //     //           Padding(
    //     //             padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
    //     //             child: Text(
    //     //               formatString(
    //     //                 data['modules'][lists[idx]]?['title']?.toString(),
    //     //               ),
    //     //               style: TextStyle(
    //     //                 color: Theme.of(context).colorScheme.secondary,
    //     //                 fontSize: 18,
    //     //                 fontWeight: FontWeight.bold,
    //     //               ),
    //     //             ),
    //     //           ),
    //     //           SizedBox(
    //     //             height: boxSize / 2 + 10,
    //     //             child: ListView.builder(
    //     //               physics: const BouncingScrollPhysics(),
    //     //               scrollDirection: Axis.horizontal,
    //     //               padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //     //               itemCount:
    //     //                   data['modules'][lists[idx]]?['title']?.toString() ==
    //     //                           'Radio Stations'
    //     //                       ? (data[lists[idx]] as List).length +
    //     //                           likedRadio.length
    //     //                       : (data[lists[idx]] as List).length,
    //     //               itemBuilder: (context, index) {
    //     //                 Map item;
    //     //                 if (data['modules'][lists[idx]]?['title']?.toString() ==
    //     //                     'Radio Stations') {
    //     //                   index < likedRadio.length
    //     //                       ? item = likedRadio[index] as Map
    //     //                       : item = data[lists[idx]]
    //     //                           [index - likedRadio.length] as Map;
    //     //                 } else {
    //     //                   item = data[lists[idx]][index] as Map;
    //     //                 }
    //     //                 final currentSongList = data[lists[idx]]
    //     //                     .where((e) => e['type'] == 'song')
    //     //                     .toList();
    //     //                 final subTitle = getSubTitle(item);
    //     //                 if (item.isEmpty) return const SizedBox();
    //     //                 return GestureDetector(
    //     //                   onLongPress: () {
    //     //                     Feedback.forLongPress(context);
    //     //                     showDialog(
    //     //                       context: context,
    //     //                       builder: (context) {
    //     //                         return AlertDialog(
    //     //                           shape: RoundedRectangleBorder(
    //     //                             borderRadius: BorderRadius.circular(15.0),
    //     //                           ),
    //     //                           backgroundColor: Colors.transparent,
    //     //                           contentPadding: EdgeInsets.zero,
    //     //                           content: Card(
    //     //                             elevation: 5,
    //     //                             shape: RoundedRectangleBorder(
    //     //                               borderRadius: BorderRadius.circular(
    //     //                                 item['type'] == 'radio_station'
    //     //                                     ? 1000.0
    //     //                                     : 15.0,
    //     //                               ),
    //     //                             ),
    //     //                             clipBehavior: Clip.antiAlias,
    //     //                             child: CachedNetworkImage(
    //     //                               fit: BoxFit.cover,
    //     //                               errorWidget: (context, _, __) =>
    //     //                                   const Image(
    //     //                                 fit: BoxFit.cover,
    //     //                                 image: AssetImage('assets/cover.jpg'),
    //     //                               ),
    //     //                               imageUrl: item['image']
    //     //                                   .toString()
    //     //                                   .replaceAll('http:', 'https:')
    //     //                                   .replaceAll('50x50', '500x500')
    //     //                                   .replaceAll('150x150', '500x500'),
    //     //                               placeholder: (context, url) => Image(
    //     //                                 fit: BoxFit.cover,
    //     //                                 image: (item['type'] == 'playlist' ||
    //     //                                         item['type'] == 'album')
    //     //                                     ? const AssetImage(
    //     //                                         'assets/album.png',
    //     //                                       )
    //     //                                     : item['type'] == 'artist'
    //     //                                         ? const AssetImage(
    //     //                                             'assets/artist.png',
    //     //                                           )
    //     //                                         : const AssetImage(
    //     //                                             'assets/cover.jpg',
    //     //                                           ),
    //     //                               ),
    //     //                             ),
    //     //                           ),
    //     //                         );
    //     //                       },
    //     //                     );
    //     //                   },
    //     //                   onTap: () {
    //     //                     if (item['type'] == 'radio_station') {
    //     //                       ShowSnackBar().showSnackBar(
    //     //                         context,
    //     //                         AppLocalizations.of(context)!.connectingRadio,
    //     //                         duration: const Duration(seconds: 2),
    //     //                       );
    //     //                       YogitunesAPI()
    //     //                           .createRadio(
    //     //                         item['more_info']['featured_station_type']
    //     //                                     .toString() ==
    //     //                                 'artist'
    //     //                             ? item['more_info']['query'].toString()
    //     //                             : item['id'].toString(),
    //     //                         item['more_info']['language']?.toString() ??
    //     //                             'hindi',
    //     //                         item['more_info']['featured_station_type']
    //     //                             .toString(),
    //     //                       )
    //     //                           .then((value) {
    //     //                         if (value != null) {
    //     //                           YogitunesAPI().getRadioSongs(value).then(
    //     //                                 (value) => Navigator.push(
    //     //                                   context,
    //     //                                   PageRouteBuilder(
    //     //                                     opaque: false,
    //     //                                     pageBuilder: (_, __, ___) =>
    //     //                                         PlayScreen(
    //     //                                       songsList: value,
    //     //                                       index: 0,
    //     //                                       offline: false,
    //     //                                       fromDownloads: false,
    //     //                                       fromMiniplayer: false,
    //     //                                       recommend: true,
    //     //                                     ),
    //     //                                   ),
    //     //                                 ),
    //     //                               );
    //     //                         }
    //     //                       });
    //     //                     } else {
    //     //                       Navigator.push(
    //     //                         context,
    //     //                         PageRouteBuilder(
    //     //                           opaque: false,
    //     //                           pageBuilder: (_, __, ___) => item['type'] ==
    //     //                                   'song'
    //     //                               ? PlayScreen(
    //     //                                   songsList: currentSongList as List,
    //     //                                   index: currentSongList.indexWhere(
    //     //                                     (e) => e['id'] == item['id'],
    //     //                                   ),
    //     //                                   offline: false,
    //     //                                   fromDownloads: false,
    //     //                                   fromMiniplayer: false,
    //     //                                   recommend: true,
    //     //                                 )
    //     //                               : SongsListPage(
    //     //                                   listItem: item,
    //     //                                 ),
    //     //                         ),
    //     //                       );
    //     //                     }
    //     //                   },
    //     //                   child: SizedBox(
    //     //                     width: boxSize / 2 - 30,
    //     //                     child: Stack(
    //     //                       children: [
    //     //                         Column(
    //     //                           children: [
    //     //                             SizedBox.square(
    //     //                               dimension: boxSize / 2 - 30,
    //     //                               child: Card(
    //     //                                 elevation: 5,
    //     //                                 shape: RoundedRectangleBorder(
    //     //                                   borderRadius: BorderRadius.circular(
    //     //                                     item['type'] == 'radio_station'
    //     //                                         ? 1000.0
    //     //                                         : 10.0,
    //     //                                   ),
    //     //                                 ),
    //     //                                 clipBehavior: Clip.antiAlias,
    //     //                                 child: CachedNetworkImage(
    //     //                                   fit: BoxFit.cover,
    //     //                                   errorWidget: (context, _, __) =>
    //     //                                       const Image(
    //     //                                     fit: BoxFit.cover,
    //     //                                     image:
    //     //                                         AssetImage('assets/cover.jpg'),
    //     //                                   ),
    //     //                                   imageUrl: item['image']
    //     //                                       .toString()
    //     //                                       .replaceAll('http:', 'https:')
    //     //                                       .replaceAll('50x50', '500x500')
    //     //                                       .replaceAll('150x150', '500x500'),
    //     //                                   placeholder: (context, url) => Image(
    //     //                                     fit: BoxFit.cover,
    //     //                                     image:
    //     //                                         (item['type'] == 'playlist' ||
    //     //                                                 item['type'] == 'album')
    //     //                                             ? const AssetImage(
    //     //                                                 'assets/album.png',
    //     //                                               )
    //     //                                             : item['type'] == 'artist'
    //     //                                                 ? const AssetImage(
    //     //                                                     'assets/artist.png',
    //     //                                                   )
    //     //                                                 : const AssetImage(
    //     //                                                     'assets/cover.jpg',
    //     //                                                   ),
    //     //                                   ),
    //     //                                 ),
    //     //                               ),
    //     //                             ),
    //     //                             Text(
    //     //                               formatString(item['title']?.toString()),
    //     //                               textAlign: TextAlign.center,
    //     //                               softWrap: false,
    //     //                               overflow: TextOverflow.ellipsis,
    //     //                               style: const TextStyle(
    //     //                                 fontWeight: FontWeight.w500,
    //     //                               ),
    //     //                             ),
    //     //                             if (subTitle != '')
    //     //                               Text(
    //     //                                 subTitle,
    //     //                                 textAlign: TextAlign.center,
    //     //                                 softWrap: false,
    //     //                                 overflow: TextOverflow.ellipsis,
    //     //                                 style: TextStyle(
    //     //                                   fontSize: 11,
    //     //                                   color: Theme.of(context)
    //     //                                       .textTheme
    //     //                                       .caption!
    //     //                                       .color,
    //     //                                 ),
    //     //                               )
    //     //                             else
    //     //                               const SizedBox(),
    //     //                           ],
    //     //                         ),
    //     //                         if (item['type'] == 'radio_station')
    //     //                           Align(
    //     //                             alignment: Alignment.topRight,
    //     //                             child: IconButton(
    //     //                               icon: likedRadio.contains(item)
    //     //                                   ? const Icon(
    //     //                                       Icons.favorite_rounded,
    //     //                                       color: Colors.red,
    //     //                                     )
    //     //                                   : const Icon(
    //     //                                       Icons.favorite_border_rounded,
    //     //                                     ),
    //     //                               tooltip: likedRadio.contains(item)
    //     //                                   ? AppLocalizations.of(context)!.unlike
    //     //                                   : AppLocalizations.of(context)!.like,
    //     //                               onPressed: () {
    //     //                                 likedRadio.contains(item)
    //     //                                     ? likedRadio.remove(item)
    //     //                                     : likedRadio.add(item);
    //     //                                 Hive.box('settings')
    //     //                                     .put('likedRadio', likedRadio);
    //     //                                 setState(() {});
    //     //                               },
    //     //                             ),
    //     //                           )
    //     //                       ],
    //     //                     ),
    //     //                   ),
    //     //                 );
    //     //               },
    //     //             ),
    //     //           ),
    //     //         ],
    //     //       );
    //   },
    // );
  }
}

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

class SongItem extends StatelessWidget {
  final String itemImage;
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
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (context, _, __) => Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          isRound ? 'assets/album.png' : 'assets/cover.jpg'),
                    ),
                    imageUrl: itemImage,
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

String formatString(String? text) {
  return text == null
      ? ''
      : text
          .replaceAll('&amp;', '&')
          .replaceAll('&#039;', "'")
          .replaceAll('&quot;', '"')
          .trim();
}
