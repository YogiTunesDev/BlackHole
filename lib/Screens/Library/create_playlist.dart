import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/copy_clipboard.dart';
import 'package:blackhole/model/single_playlist_response.dart'
    as singlePlaylistResponse;
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/model/tracks_by_bpm_response.dart';
import 'package:blackhole/model/trending_song_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({Key? key}) : super(key: key);

  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  List<Map<String, dynamic>> legend = [
    {
      'name': 'Ambient',
      'color': Colors.blue,
    },
    {
      'name': 'Slow',
      'color': Colors.yellow,
    },
    {
      'name': 'Medium',
      'color': Colors.orange,
    },
    {
      'name': 'Fast',
      'color': Colors.red,
    },
  ];

  List<String> selectedPlaylist = [];
  int pageNo = 1;
  bool isFinish = false;
  bool apiLoading = false;
  List<TracksBybpmData> lstSongBpm = [];
  final ScrollController _scrollController = ScrollController();
  bool loading = false;
  int mainDuration = 0;
  Future fetchData() async {
    try {
      apiLoading = true;
      setState(() {});
      final TracksBybpmResponse? playlistRes =
          await YogitunesAPI().fetchPlaylistSongData(pageNo);

      pageNo++;
      if (playlistRes != null) {
        if (playlistRes.status!) {
          if (playlistRes.data != null) {
            if (playlistRes.data!.data!.isNotEmpty) {
              lstSongBpm.addAll(playlistRes.data!.data!);
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
    } on Exception catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    } finally {
      apiLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    pageNo = 1;
    fetchData();
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Playlist'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              var res = await YogitunesAPI().editPlaylist(
                args['playlistId'].toString(),
                args['name'].toString(),
                selectedPlaylist,
              );
              setState(() {
                loading = true;
              });
              if (res['status'] as bool) {
                Navigator.pop(context);
              } else {
                final snackBar = SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(res['data']['data'].toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text(
              'Next',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                // fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      padding: const EdgeInsets.all(4),
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: const Text(
                        'Select songs for each phase of your practice.\nUse the filter to narrow down your songs to a specific yoga type of phase.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      padding: const EdgeInsets.all(4),
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Legend:',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              // fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: legend.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          color:
                                              legend[index]['color'] as Color,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        legend[index]['name'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          // fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Add songs below to see them populate the playlist here.',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          // fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total time: ${Duration(seconds: mainDuration).inHours}:${(Duration(seconds: mainDuration).inMinutes < 60) ? Duration(seconds: mainDuration).inMinutes : (Duration(seconds: mainDuration).inMinutes - (Duration(seconds: mainDuration).inHours * 60))}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lstSongBpm.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context1, int index) {
                        final TracksBybpmData item = lstSongBpm[index];
                        int? mDur;
                        if (item.duration != null) {
                          final String mDuration = item.duration!;
                          final List<String> lstTime = mDuration.split(':');
                          if (lstTime.length == 3) {
                            mDur = Duration(
                              hours: int.parse(
                                lstTime[0],
                              ),
                              minutes: int.parse(
                                lstTime[1],
                              ),
                              seconds: int.parse(
                                lstTime[2],
                              ),
                            ).inSeconds;
                          }
                        }

                        final bool selected =
                            selectedPlaylist.contains(item.id.toString());
                        // print(selected.toString() + "${item.id}");
                        String? imgUrl;
                        String? albumName;
                        String? bpmType;
                        if (item != null) {
                          if (item.album != null) {
                            if (item.album!.cover != null) {
                              if (item.album!.cover!.image != null) {
                                imgUrl =
                                    '${item.album!.cover!.imgUrl}/${item.album!.cover!.image}';
                              }
                            }
                          }
                          if (item.album != null) {
                            if (item.album!.profile != null) {
                              if (item.album!.profile!.name != null) {
                                albumName = item.album!.profile!.name;
                              }
                            }
                          }
                          if (item.bpm != null) {
                            if (item.bpm!.bpm != null) {
                              bpmType = item.bpm!.bpm;
                            }
                          }
                        }
                        return ListTile(
                          contentPadding: const EdgeInsets.only(left: 15.0),
                          title: Text(
                            item.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            albumName ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                side: BorderSide(
                                  color: getBpmColor(bpmType),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                errorWidget: (context, _, __) => const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/cover.jpg',
                                  ),
                                ),
                                imageUrl: imgUrl ?? '',
                                placeholder: (context, url) => const Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/cover.jpg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          trailing: selected
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      mainDuration -= mDur ?? 0;
                                      selectedPlaylist
                                          .remove(item.id.toString());
                                    });
                                    // print(selectedPlaylist);
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: Theme.of(this.context)
                                        .colorScheme
                                        .secondary,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      mainDuration += mDur ?? 0;
                                      selectedPlaylist.add(item.id.toString());
                                    });
                                    // print(selectedPlaylist.toString() +
                                    //     selected.toString());
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                        );
                      },
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
                  ],
                ),
              ),
      ),
    );
  }

  void _listScrollListener() {
    // if (lstPlaylistData.isNotEmpty) {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!isFinish & !apiLoading) {
        fetchData();
      }
    }
    // }
  }

  Color getBpmColor(String? bpm) {
    if (bpm != null) {
      if (bpm == 'Medium') {
        return Colors.orange;
      } else if (bpm == 'Ambient') {
        return Colors.blue;
      } else if (bpm == 'Slow') {
        return Colors.yellow;
      } else if (bpm == 'Fast') {
        return Colors.red;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }
}
