import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/miniplayer.dart';
import 'package:blackhole/model/artist_data_response.dart';
import 'package:flutter/material.dart';

class Artist extends StatefulWidget {
  Artist({Key? key, required this.id, this.image, required this.title})
      : super(key: key);

  final int id;
  final String? image;
  final String title;

  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<Artist> {
  final ScrollController _scrollController = ScrollController();
  bool apiLoading = false;
  ArtistDataResponse? artistDataResponse;

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  Future fetchData() async {
    setState(() {
      apiLoading = true;
    });

    artistDataResponse = await YogitunesAPI().artistData(widget.id);

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
                        'widget.title',
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
