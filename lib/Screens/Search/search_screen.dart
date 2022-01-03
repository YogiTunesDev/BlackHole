import 'dart:math';

import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Home/album_list.dart';
import 'package:blackhole/Screens/Home/saavn.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/Screens/Search/artist_data.dart';
import 'package:blackhole/Screens/Search/search.dart';
import 'package:blackhole/Screens/Search/search_view_all.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/search_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/util/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  final controller = TextEditingController();

  SearchResponse? searchResponse;

  List<String> lstKeywordSearch = [];
  Box<dynamic>? searchCacheData;

  bool isMyLibrary = false;
  bool libraryVisibility = true;
  bool isLoading = false;

  String tempQuery = '';
  String query = '';

  String capitalize(String msg) {
    return '${msg[0].toUpperCase()}${msg.substring(1)}';
  }

  keywords() async {
    searchCacheData = await Hive.openBox('searchData');

    // searchCacheData = await HiveManager.instance.openHiveBox('searchData');
    List<String> lstMain = searchCacheData!
        .get("searchKeywordList", defaultValue: []) as List<String>;
    lstKeywordSearch.addAll(lstMain);
    setState(() {});
  }

  onSubmitSearch(String search) async {
    setState(() {
      isLoading = true;
      libraryVisibility = false;
    });
    

    if (lstKeywordSearch.contains(search)) {
      lstKeywordSearch.remove(search);
    }
lstKeywordSearch.insert(0, search);
    searchCacheData!.put("searchKeywordList", lstKeywordSearch);
    searchResponse = await YogitunesAPI().search(search, isMyLibrary);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    keywords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        keyboardHide(context);
      },
      child: Stack(
        children: [
          NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                const SliverAppBar(
                  expandedHeight: 50,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // pinned: true,
                  toolbarHeight: 50,
                  // floating: true,
                  automaticallyImplyLeading: false,
                ),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  stretch: true,
                  toolbarHeight: 65,
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, child) {
                        return GestureDetector(
                          child: AnimatedContainer(
                            width: (!_scrollController.hasClients ||
                                    _scrollController
                                            // ignore: invalid_use_of_protected_member
                                            .positions
                                            .length >
                                        1)
                                ? MediaQuery.of(context).size.width
                                : max(
                                    MediaQuery.of(context).size.width -
                                        _scrollController.offset
                                            .roundToDouble(),
                                    MediaQuery.of(context).size.width - 75,
                                  ),
                            height: 52.0,
                            duration: const Duration(
                              milliseconds: 150,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).cardColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  offset: Offset(1.5, 1.5),
                                )
                              ],
                            ),
                            child: Center(
                              child: TextField(
                                controller: controller,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  fillColor:
                                      Theme.of(context).colorScheme.secondary,
                                  prefixIcon: Icon(
                                    CupertinoIcons.search,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  suffixIcon: controller.text.isEmpty
                                      ? const SizedBox(
                                          height: 1,
                                          width: 1,
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              controller.clear();
                                              libraryVisibility = true;
                                              searchResponse = null;
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'clear',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!
                                      .searchText,
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.search,
                                onTap: () {
                                  setState(() {
                                    libraryVisibility = true;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                onSubmitted: (value) {
                                  onSubmitSearch(controller.text);
                                },
                              ),
                            ),
                          ),
                          // onTap: () => Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SearchPage(
                          //       query: '',
                          //       fromHome: true,
                          //       autofocus: true,
                          //     ),
                          //   ),
                          // ),
                        );
                      },
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  if (libraryVisibility)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isMyLibrary = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: !isMyLibrary
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        bottomLeft: Radius.circular(100),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'All of YogiTunes',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: isMyLibrary
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isMyLibrary = true;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: isMyLibrary
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(100),
                                          bottomRight: Radius.circular(100),
                                        )),
                                    child: Center(
                                      child: Text(
                                        'My Library',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: isMyLibrary
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primaryVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (controller.text.trim().isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListView.builder(
                              itemCount: lstKeywordSearch.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          onSubmitSearch(
                                              lstKeywordSearch[index]);
                                          controller.text =
                                              lstKeywordSearch[index + 1];
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.av_timer),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  lstKeywordSearch[index],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lstKeywordSearch.removeAt(index);
                                          searchCacheData!.put(
                                              "searchKeywordList",
                                              lstKeywordSearch);
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (searchResponse != null)
                    if (searchResponse!.data != null)
                      Column(
                        children: [
                          if (searchResponse!.data!.tracks != null)
                            if (searchResponse!.data!.tracks!.isNotEmpty)
                              HeaderTitle(
                                title: 'Tracks',
                                viewAllOnTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SearchViewAll(
                                        isMyLibrary: isMyLibrary,
                                        keyword: controller.text,
                                        title: 'Tracks',
                                        searchAllType: SearchAllType.tracks,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          if (searchResponse!.data!.tracks != null)
                            if (searchResponse!.data!.tracks!.isNotEmpty)
                              SizedBox(
                                height: boxSize / 2 + 10,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  itemCount:
                                      searchResponse!.data!.tracks!.length,
                                  itemBuilder: (context, index) {
                                    final Track item =
                                        searchResponse!.data!.tracks![index];
                                    final String itemImage = item.album != null
                                        ? ('${item.album!.cover!.imgUrl}/${item.album!.cover!.image}')
                                        : '';

                                    return SongItem(
                                      itemImage: itemImage,
                                      itemName: item.name!,
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
                                                .fetchSingleSongData(item.id!);
                                        Navigator.pop(context);
                                        if (radioStationsStreamResponse !=
                                            null) {
                                          if (radioStationsStreamResponse
                                                  .songItemModel !=
                                              null) {
                                            if (radioStationsStreamResponse
                                                .songItemModel!.isNotEmpty) {
                                              List<SongItemModel> lstSong = [];

                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  opaque: false,
                                                  pageBuilder: (_, __, ___) =>
                                                      PlayScreen(
                                                    songsList:
                                                        radioStationsStreamResponse
                                                            .songItemModel!,
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
                                      },
                                    );
                                  },
                                ),
                              ),
                          if (searchResponse!.data!.albums != null)
                            if (searchResponse!.data!.albums!.isNotEmpty)
                              HeaderTitle(
                                title: 'Albums',
                                viewAllOnTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SearchViewAll(
                                        isMyLibrary: isMyLibrary,
                                        keyword: controller.text,
                                        title: 'Album',
                                        searchAllType: SearchAllType.albums,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          if (searchResponse!.data!.albums != null)
                            if (searchResponse!.data!.albums!.isNotEmpty)
                              SizedBox(
                                height: boxSize / 2 + 10,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  itemCount:
                                      searchResponse!.data!.albums!.length,
                                  itemBuilder: (context, index) {
                                    final Album item =
                                        searchResponse!.data!.albums![index];
                                    final String itemImage = item.cover != null
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
                                              songListType: SongListType.album,
                                              playlistName: item.name!,
                                              playlistImage: itemImage,
                                              id: item.id,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          if (searchResponse!.data!.playlists != null)
                            if (searchResponse!.data!.playlists!.isNotEmpty)
                              HeaderTitle(
                                title: 'Playlists',
                                viewAllOnTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SearchViewAll(
                                        isMyLibrary: isMyLibrary,
                                        keyword: controller.text,
                                        title: 'Playlists',
                                        searchAllType: SearchAllType.playlists,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          if (searchResponse!.data!.playlists != null)
                            if (searchResponse!.data!.playlists!.isNotEmpty)
                              SizedBox(
                                height: boxSize / 2 + 10,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  itemCount:
                                      searchResponse!.data!.playlists!.length,
                                  itemBuilder: (context, index) {
                                    final Playlist item =
                                        searchResponse!.data!.playlists![index];
                                    final String itemImage = item
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
                                              songListType:
                                                  SongListType.playlist,
                                              playlistName: item.name!,
                                              playlistImage: itemImage,
                                              id: item.id,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          if (searchResponse!.data!.artists != null)
                            if (searchResponse!.data!.artists!.isNotEmpty)
                              HeaderTitle(
                                title: 'Artist',
                                viewAllOnTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                          SearchViewAll(
                                        isMyLibrary: isMyLibrary,
                                        keyword: controller.text,
                                        title: 'Artists',
                                        searchAllType: SearchAllType.artists,
                                      ),
                                    ),
                                  );
                                },
                              ),
                          if (searchResponse!.data!.artists != null)
                            if (searchResponse!.data!.artists!.isNotEmpty)
                              SizedBox(
                                height: boxSize / 2 + 10,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  itemCount:
                                      searchResponse!.data!.artists!.length,
                                  itemBuilder: (context, index) {
                                    final Artist item =
                                        searchResponse!.data!.artists![index];
                                    final String itemImage = item.cover != null
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
                                                ArtistData(
                                              id: item.id!,
                                              title: item.name!,
                                              image: itemImage,
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
                    else if (!isLoading)
                      Center(
                        child: Text('No data found!'),
                      ),
                ],
              ),
            ),
          ),
          Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
              child: Transform.rotate(
                angle: 22 / 7 * 2,
                child: IconButton(
                  icon: const Icon(
                    Icons.horizontal_split_rounded,
                  ),
                  // color: Theme.of(context).iconTheme.color,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
