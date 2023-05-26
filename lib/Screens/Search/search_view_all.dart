import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_back_button.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Home/saavn.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/Screens/Search/artist_data.dart';
import 'package:blackhole/model/custom_playlist_response.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/search_all_album_response.dart';
import 'package:blackhole/model/search_all_artists_response.dart';
import 'package:blackhole/model/search_all_playlists_response.dart';
import 'package:blackhole/model/search_all_track_response.dart';
import 'package:blackhole/model/see_all_library_albums_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SearchAllType { albums, playlists, tracks, artists, recent }

class SearchViewAll extends StatefulWidget {
  const SearchViewAll({
    Key? key,
    required this.title,
    this.keyword,
    this.isMyLibrary,
    required this.searchAllType,
    this.isFromLibrary = false,
  }) : super(key: key);
  final String title;
  final String? keyword;
  final bool? isMyLibrary;
  final SearchAllType searchAllType;
  final bool isFromLibrary;
  @override
  _SearchViewAllState createState() => _SearchViewAllState();
}

class _SearchViewAllState extends State<SearchViewAll> {
  SearchAllType? searchAllType;
  final ScrollController _scrollController = ScrollController();
  SearchAllAlbumResponse? searchAllAlbumResponse;
  SearchAllTracksResponse? searchAllTracksResponse;
  SearchAllPlaylistsResponse? searchAllPlaylistsResponse;
  SearchAllArtistsResponse? searchAllArtistsResponse;
  CustomPlaylistResponse? customPlaylistResponse;
  SeeAllLibraryAlbumsResponse? seeAllLibraryAlbumsResponse;
  // MyRecentlyPlayedSongResponse? myRecentlyPlayedSongResponse;
  bool apiLoading = false;

  @override
  void initState() {
    super.initState();
    searchAllType = widget.searchAllType;
    fetchData();
    // _scrollController.addListener(_listScrollListener);
  }

  fetchData() async {
    setState(() {
      apiLoading = true;
    });
    if (widget.isFromLibrary) {
      if (searchAllType == SearchAllType.albums) {
        seeAllLibraryAlbumsResponse = await YogitunesAPI().seeAllLibraryAlbum();
      } else if (searchAllType == SearchAllType.artists) {
        searchAllArtistsResponse = await YogitunesAPI().seeAllLibraryArtist();
      }
    } else {
      if (searchAllType == SearchAllType.tracks) {
        searchAllTracksResponse = await YogitunesAPI()
            .searchAllTrack(widget.keyword!, widget.isMyLibrary!);
      } else if (searchAllType == SearchAllType.albums) {
        searchAllAlbumResponse = await YogitunesAPI()
            .searchAllAlbum(widget.keyword!, widget.isMyLibrary!);
      } else if (searchAllType == SearchAllType.playlists) {
        searchAllPlaylistsResponse = await YogitunesAPI()
            .searchAllPlaylist(widget.keyword!, widget.isMyLibrary!);
      } else if (searchAllType == SearchAllType.artists) {
        searchAllArtistsResponse = await YogitunesAPI()
            .searchAllArtists(widget.keyword!, widget.isMyLibrary!);
      }
      // else if (searchAllType == SearchAllType.recent) {
      //   myRecentlyPlayedSongResponse = await YogitunesAPI().viewAllRecentTrack();
      // }
    }
    setState(() {
      apiLoading = false;
    });
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
                    leading: const GradientBackButton(),
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,

                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        widget.title,
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
                  if (widget.isFromLibrary)
                    SliverList(
                      delegate: SliverChildListDelegate([
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
                        //(myRecentlyPlayedSongResponse == null &&
                        // searchAllType == SearchAllType.recent) ||
                        else if (((seeAllLibraryAlbumsResponse?.data == null &&
                                    searchAllType == SearchAllType.albums) ||
                                (searchAllArtistsResponse?.data == null &&
                                    searchAllType == SearchAllType.artists)) &&
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
                        else if (searchAllType == SearchAllType.albums &&
                            seeAllLibraryAlbumsResponse != null)
                          if (seeAllLibraryAlbumsResponse!.data!.isEmpty)
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
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount:
                                  seeAllLibraryAlbumsResponse!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final SeeAllLibraryAlbumsResponseData item =
                                    seeAllLibraryAlbumsResponse!.data![index];

                                String itemImage = "";
                                if (item.album != null) {
                                  if (item.album!.cover != null) {
                                    itemImage =
                                        '${item.album!.cover!.imgUrl!}/${item.album!.cover!.image!}';
                                  }
                                }
                                return SongItem(
                                  itemImage: [itemImage],
                                  itemName: item.album!.name!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            SongsListPage(
                                          isFromLibrary: widget.isFromLibrary,
                                          songListType: SongListType.album,
                                          playlistName: item.album!.name!,
                                          playlistImage: [itemImage],
                                          id: item.album!.id,
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        fetchData();
                                      });
                                    });
                                  },
                                );
                              },
                            )
                        else if (searchAllType == SearchAllType.artists &&
                            searchAllArtistsResponse != null)
                          if (searchAllArtistsResponse!.data!.isEmpty)
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
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: searchAllArtistsResponse!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final SearchAllArtistsResponseData item =
                                    searchAllArtistsResponse!.data![index];
                                String itemImage = '';
                                if (item.cover != null) {
                                  if (item.cover!.imgUrl != null) {
                                    if (item.cover!.image != null) {
                                      itemImage =
                                          '${item.cover!.imgUrl!}/${item.cover!.image!}';
                                    }
                                  }
                                }
                                return SongItem(
                                  itemImage: [itemImage],
                                  itemName: item.name!,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) => ArtistData(
                                          id: item.id!,
                                          title: item.name!,
                                          image: itemImage,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                      ]),
                    )
                  else
                    SliverList(
                      delegate: SliverChildListDelegate([
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
                        //(myRecentlyPlayedSongResponse == null &&
                        // searchAllType == SearchAllType.recent) ||
                        else if (((searchAllTracksResponse?.data == null &&
                                    searchAllType == SearchAllType.tracks) ||
                                (searchAllAlbumResponse?.data == null &&
                                    searchAllType == SearchAllType.albums) ||
                                (searchAllPlaylistsResponse?.data == null &&
                                    searchAllType == SearchAllType.playlists) ||
                                (searchAllArtistsResponse?.data == null &&
                                    searchAllType == SearchAllType.artists) ||
                                (seeAllLibraryAlbumsResponse == null &&
                                    searchAllType == SearchAllType.albums)) &&
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
                        else if (searchAllType == SearchAllType.tracks &&
                            searchAllTracksResponse != null)
                          if (searchAllTracksResponse!.data!.isEmpty)
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
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: searchAllTracksResponse!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final SearchAllTracksResponseData item =
                                    searchAllTracksResponse!.data![index];
                                String itemImage = item.album != null
                                    ? ('${item.album!.cover!.imgUrl}/${item.album!.cover!.image}')
                                    : '';
                                return SongItem(
                                  itemImage: [itemImage],
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
                                    if (radioStationsStreamResponse != null) {
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
                            )
                        else if (searchAllType == SearchAllType.albums &&
                            searchAllAlbumResponse?.data != null)
                          if (searchAllAlbumResponse!.data!.isEmpty)
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
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: searchAllAlbumResponse!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final SearchAllAlbumResponseData item =
                                    searchAllAlbumResponse!.data![index];
                                String itemImage = item.cover != null
                                    ? ('${item.cover!.imgUrl}/${item.cover!.image}')
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
                            )
                        else if (searchAllType == SearchAllType.playlists &&
                            searchAllPlaylistsResponse != null)
                          if (searchAllPlaylistsResponse!.data!.isEmpty)
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
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount:
                                  searchAllPlaylistsResponse!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final SearchAllPlaylistsResponseData item =
                                    searchAllPlaylistsResponse!.data![index];
                                String itemImage = item.quadImages!.isNotEmpty
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
                            )
                        else if (searchAllType == SearchAllType.artists &&
                            searchAllArtistsResponse != null)
                          if (searchAllArtistsResponse!.data!.isEmpty)
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
                            GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: searchAllArtistsResponse!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final SearchAllArtistsResponseData item =
                                    searchAllArtistsResponse!.data![index];
                                String itemImage = item.cover != null
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
                                        pageBuilder: (_, __, ___) => ArtistData(
                                          id: item.id!,
                                          title: item.name!,
                                          image: itemImage,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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
