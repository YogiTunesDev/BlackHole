import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/empty_screen.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Common/song_list.dart';
import 'package:blackhole/Screens/Home/saavn.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/Screens/Search/search_view_all.dart';
import 'package:blackhole/model/artist_data_response.dart';
import 'package:blackhole/model/playlist_response.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ArtistData extends StatefulWidget {
  ArtistData({Key? key, required this.id, this.image, required this.title})
      : super(key: key);

  final int id;
  final String? image;
  final String title;

  @override
  _ArtistDataState createState() => _ArtistDataState();
}

class _ArtistDataState extends State<ArtistData> {
  final ScrollController _scrollController = ScrollController();
  bool apiLoading = false;
  ArtistDataResponse? artistDataResponse;
  String? mainImage;
  String? mainTitle;

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    if (widget.image != null) {
      if (widget.image!.isNotEmpty) {
        mainImage = widget.image;
      }
    }

    if (widget.title.isEmpty) {
      mainTitle = widget.title;
    }
    super.initState();
  }

  Future fetchData() async {
    setState(() {
      apiLoading = true;
    });

    artistDataResponse = await YogitunesAPI().artistData(widget.id);
    if (artistDataResponse != null) {
      if (artistDataResponse!.data != null) {
        mainImage ??= (artistDataResponse?.data?.cover?.imgUrl ?? '') +
            (artistDataResponse?.data?.cover?.imgUrl != null ? '/' : '') +
            (artistDataResponse?.data?.cover?.image ?? '');
        mainTitle = artistDataResponse?.data?.name;
      }
    }
    print('Artist Id ::: ${widget.id}');
    print('Artist Top Hits ::: ${artistDataResponse!.data!.topHits}');

    setState(() {
      apiLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double boxSize =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;

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
                        mainTitle ?? '',
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
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, _, __) => const Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/cover.jpg'),
                          ),
                          imageUrl: mainImage ?? '',
                          placeholder: (context, url) => const Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/cover.jpg'),
                          ),
                        ),

                        // const Image(
                        //   fit: BoxFit.cover,
                        //   image: AssetImage(
                        //     'assets/cover.jpg',
                        //   ),
                        // ),
                      ),
                    ),
                  ),
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
                      else if (artistDataResponse == null && !apiLoading)
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
                      else if (artistDataResponse!.data!.topHits!.isEmpty &&
                          artistDataResponse!.data!.playlists!.isEmpty &&
                          artistDataResponse!.data!.albums!.isEmpty &&
                          !apiLoading)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text('No Data Found'),
                          ),
                        )
                      else if (artistDataResponse != null)
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              if (artistDataResponse!.data!.topHits != null)
                                if (artistDataResponse!
                                    .data!.topHits!.isNotEmpty)
                                  const Header(
                                    title: 'Top Hits',
                                  ),
                              if (artistDataResponse!.data!.topHits != null)
                                if (artistDataResponse!
                                    .data!.topHits!.isNotEmpty)
                                  SizedBox(
                                    height: boxSize / 2 + 10,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      itemCount: artistDataResponse!
                                          .data!.topHits!.length,
                                      itemBuilder: (context, index) {
                                        final TracksOnly item =
                                            artistDataResponse!
                                                .data!.topHits![index];
                                        final String itemImage = item.album !=
                                                null
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
                                                    .fetchSingleSongData(
                                                        item.id!);
                                            Navigator.pop(context);
                                            if (radioStationsStreamResponse !=
                                                null) {
                                              if (radioStationsStreamResponse
                                                      .songItemModel !=
                                                  null) {
                                                if (radioStationsStreamResponse
                                                    .songItemModel!
                                                    .isNotEmpty) {
                                                  List<SongItemModel> lstSong =
                                                      [];

                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      opaque: false,
                                                      pageBuilder:
                                                          (_, __, ___) =>
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
                              if (artistDataResponse!.data!.albums != null)
                                if (artistDataResponse!
                                    .data!.albums!.isNotEmpty)
                                  const Header(
                                    title: 'Albums',
                                  ),
                              if (artistDataResponse!.data!.albums != null)
                                if (artistDataResponse!
                                    .data!.albums!.isNotEmpty)
                                  SizedBox(
                                    height: boxSize / 2 + 10,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      itemCount: artistDataResponse!
                                          .data!.albums!.length,
                                      itemBuilder: (context, index) {
                                        final Album item = artistDataResponse!
                                            .data!.albums![index];
                                        final String itemImage = item.cover !=
                                                null
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
                                                  songListType:
                                                      SongListType.album,
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
                              if (artistDataResponse!.data!.playlists != null)
                                if (artistDataResponse!
                                    .data!.playlists!.isNotEmpty)
                                  const Header(
                                    title: 'Playlists',
                                  ),
                              if (artistDataResponse!.data!.playlists != null)
                                if (artistDataResponse!
                                    .data!.playlists!.isNotEmpty)
                                  SizedBox(
                                    height: boxSize / 2 + 10,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      itemCount: artistDataResponse!
                                          .data!.playlists!.length,
                                      itemBuilder: (context, index) {
                                        final Playlist item =
                                            artistDataResponse!
                                                .data!.playlists![index];
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
                                                  songListType:
                                                      SongListType.playlist,
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
                            ],
                          ),
                        ),
                    ]),
                  ),
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
