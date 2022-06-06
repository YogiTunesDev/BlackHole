import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/model/tracks_by_bpm_response.dart';
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

  List<Map<String, dynamic>> legendGraph = [
    // {
    //   'duration': 10,
    //   'color': Colors.blue,
    // },
    // {
    //   'duration': 5,
    //   'color': Colors.yellow,
    // },
    // {
    //   'duration': 4,
    //   'color': Colors.orange,
    // },
    // {
    //   'duration': 1,
    //   'color': Colors.red,
    // },
  ];

  List<Map<String, dynamic>> legendGraphTemp = [
    // {
    //   'duration': 10,
    //   'color': Colors.blue,
    // },
    // {
    //   'duration': 5,
    //   'color': Colors.yellow,
    // },
    // {
    //   'duration': 4,
    //   'color': Colors.orange,
    // },
    // {
    //   'duration': 1,
    //   'color': Colors.red,
    // },
  ];

  int totalMinutes = 20;
  List<String> selectedPlaylist = [];
  int pageNo = 1;
  bool isFinish = false;
  bool apiLoading = false;
  List<TracksBybpmData> lstSongBpm = [];
  final ScrollController _scrollController = ScrollController();
  bool loading = false;
  int mainDuration = 0;

  String? tempo;
  String? vocals;
  String? style;
  bool isMyLibrary = false;

  Future fetchData() async {
    try {
      apiLoading = true;
      setState(() {});
      final TracksBybpmResponse? playlistRes = await YogitunesAPI()
          .fetchPlaylistSongData(vocals, tempo, style, isMyLibrary, pageNo);

      pageNo++;
      if (playlistRes != null) {
        if (playlistRes.status!) {
          if (playlistRes.data != null) {
            if (playlistRes.data!.data!.isNotEmpty) {
              lstSongBpm.addAll(playlistRes.data!.data!);
              // print(
              //     "lstSongBpm.reversed.toList() :: ${lstSongBpm.reversed.toList()}");
              // lstSongBpm.reversed;
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
    final double width = MediaQuery.of(context).size.width;
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
                  content: Text(
                    res['data']['data'].toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text(
              'Next',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                // fontSize: 18,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
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
                        vertical: 10,
                        horizontal: 30,
                      ),
                      padding: const EdgeInsets.all(4),
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: const Text(
                        'Select songs for each phase of your practice.\nUse the filter to narrow down your songs to a specific yoga type of phase.',
                        style: TextStyle(
                            // color: Colors.white,
                            ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
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
                      height: 20,
                    ),
                    if (mainDuration != 0)
                      SizedBox(
                        height: 50,
                        width: width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: legendGraphTemp.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final double w = (width / mainDuration) *
                                int.parse(
                                  legendGraphTemp[index]['duration'].toString(),
                                );
                            return Container(
                              height: 50,
                              width: w,
                              color: legendGraphTemp[index]['color'] as Color,
                              child: Center(
                                child: w > 20
                                    ? Text(
                                        '${Duration(seconds: int.parse(legendGraphTemp[index]['duration'].toString())).inMinutes}M',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 20,
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
                          Expanded(
                            child: Text(
                              'Total time: ${Duration(seconds: mainDuration).inHours}:${(Duration(seconds: mainDuration).inMinutes < 60) ? Duration(seconds: mainDuration).inMinutes : (Duration(seconds: mainDuration).inMinutes - (Duration(seconds: mainDuration).inHours * 60))}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                builder: (BuildContext contex) {
                                  return Filters(
                                    tempo: tempo,
                                    myLibrary: isMyLibrary,
                                    style: style,
                                    vocal: vocals,
                                  );
                                },
                              ).then((value) {
                                lstSongBpm = [];
                                if (value != null) {
                                  if (value is Map) {
                                    pageNo = 1;
                                    if (value['tempo'] is String?) {
                                      tempo = value['tempo'] as String?;
                                    } else {
                                      tempo = null;
                                    }

                                    if (value['vocals'] is String?) {
                                      vocals = value['vocals'] as String?;
                                    } else {
                                      vocals = null;
                                    }

                                    if (value['style'] is String?) {
                                      style = value['style'] as String?;
                                    } else {
                                      style = null;
                                    }

                                    if (value['isMyLibrary'] is bool) {
                                      isMyLibrary =
                                          value['isMyLibrary'] as bool;
                                    } else {
                                      isMyLibrary = false;
                                    }
                                  } else {
                                    tempo = null;
                                    vocals = null;
                                    style = null;
                                    isMyLibrary = false;
                                  }
                                  fetchData();
                                }
                              });
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.filter_alt_rounded),
                                Text(
                                  'Filter',
                                ),
                              ],
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
                                      legendGraph.removeWhere(
                                        (element) => element['id'] == item.id,
                                      );

                                      legendGraphTemp = [];

                                      if (legendGraph.isNotEmpty) {
                                        for (int i = 0;
                                            i < legendGraph.length;
                                            i++) {
                                          if (legendGraphTemp.isNotEmpty) {
                                            if (legendGraphTemp.last['color'] ==
                                                legendGraph[i]['color']) {
                                              print(1);
                                              var duration = legendGraphTemp
                                                  .last['duration'];
                                              print(2);
                                              legendGraphTemp.removeLast();
                                              print(3);
                                              legendGraphTemp.add({
                                                'duration': int.parse(
                                                      legendGraph[i]['duration']
                                                          .toString(),
                                                    ) +
                                                    int.parse(
                                                      duration.toString(),
                                                    ),
                                                'color': legendGraph[i]
                                                    ['color'],
                                              });
                                              print(5);
                                            } else {
                                              legendGraphTemp
                                                  .add(legendGraph[i]);
                                            }
                                          } else {
                                            legendGraphTemp.add(legendGraph[i]);
                                          }
                                        }
                                      }
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
                                      legendGraph.add({
                                        'id': item.id,
                                        'duration': mDur ?? 0,
                                        'color': getBpmColor(bpmType),
                                      });

                                      legendGraphTemp = [];

                                      if (legendGraph.isNotEmpty) {
                                        for (int i = 0;
                                            i < legendGraph.length;
                                            i++) {
                                          if (legendGraphTemp.isNotEmpty) {
                                            if (legendGraphTemp.last['color'] ==
                                                legendGraph[i]['color']) {
                                              print(1);
                                              var duration = legendGraphTemp
                                                  .last['duration'];
                                              print(2);
                                              legendGraphTemp.removeLast();
                                              print(3);
                                              legendGraphTemp.add({
                                                'duration': int.parse(
                                                      legendGraph[i]['duration']
                                                          .toString(),
                                                    ) +
                                                    int.parse(
                                                      duration.toString(),
                                                    ),
                                                'color': legendGraph[i]
                                                    ['color'],
                                              });
                                              print(5);
                                            } else {
                                              legendGraphTemp
                                                  .add(legendGraph[i]);
                                            }
                                          } else {
                                            legendGraphTemp.add(legendGraph[i]);
                                          }
                                        }
                                      }
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

class Filters extends StatefulWidget {
  const Filters({
    Key? key,
    this.vocal,
    this.tempo,
    this.style,
    this.myLibrary = false,
  }) : super(key: key);

  final String? vocal;
  final String? tempo;
  final String? style;
  final bool myLibrary;

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  String? selectedVocal;
  String? selectedTempo;
  String? selectedStyle;
  int selectedCategory = 0;

  List<Map<String, dynamic>> vocals = [
    {
      'key': 'lyrics',
      'val': 'Lyrics',
    },
    {
      'key': 'no_lyrics',
      'val': 'No Lyrics',
    },
  ];

  List<Map<String, dynamic>> tempo = [
    {
      'key': 'Slow',
      'val': 'Slow',
    },
    {
      'key': 'Medium',
      'val': 'Medium',
    },
    {
      'key': 'Fast',
      'val': 'Fast',
    },
    {
      'key': 'Ambient',
      'val': 'Ambient',
    },
  ];

  List<Map<String, dynamic>> style = [
    {
      'key': 'electronic',
      'val': 'Electronic',
    },
    {
      'key': 'electro-acoustic',
      'val': 'Electro acoustic',
    },
    {
      'key': 'acoustic',
      'val': 'Acoustic',
    },
  ];

  @override
  void initState() {
    selectedVocal = widget.vocal;
    selectedTempo = widget.tempo;
    selectedStyle = widget.style;
    selectedCategory = widget.myLibrary ? 1 : 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      {
                        'tempo': selectedTempo != null ? selectedTempo! : null,
                        'style': selectedStyle != null ? selectedStyle! : null,
                        'vocals': selectedVocal != null ? selectedVocal! : null,
                        'isMyLibrary': selectedCategory == 0 ? false : true,
                      },
                    );
                  },
                  child: Center(
                    child: Text(
                      'view results',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = 0;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedCategory == 0
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.6),
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
                            color: Theme.of(context).brightness ==
                                        Brightness.light ||
                                    selectedCategory != 0
                                ? Colors.white
                                : Theme.of(context).colorScheme.primaryVariant,
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
                        selectedCategory = 1;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedCategory == 1
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'My Library',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Theme.of(context).brightness ==
                                        Brightness.light ||
                                    selectedCategory != 1
                                ? Colors.white
                                : Theme.of(context).colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'VOCALS',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              itemCount: vocals.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedVocal = vocals[index]['val'].toString();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: selectedVocal == vocals[index]['val'].toString()
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.6),
                    ),
                    child: Center(
                      child: Text(
                        vocals[index]['val'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).brightness ==
                                      Brightness.light ||
                                  selectedVocal !=
                                      vocals[index]['val'].toString()
                              ? Colors.white
                              : Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'TEMPO',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              itemCount: tempo.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTempo = tempo[index]['val'].toString();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: selectedTempo == tempo[index]['val'].toString()
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.6),
                    ),
                    child: Center(
                      child: Text(
                        tempo[index]['val'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).brightness ==
                                      Brightness.light ||
                                  selectedTempo !=
                                      tempo[index]['val'].toString()
                              ? Colors.white
                              : Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'STYLE',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              itemCount: style.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedStyle = style[index]['val'].toString();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: selectedStyle == style[index]['val'].toString()
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).brightness == Brightness.light
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.6),
                    ),
                    child: Center(
                      child: Text(
                        style[index]['val'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).brightness ==
                                      Brightness.light ||
                                  selectedStyle !=
                                      style[index]['val'].toString()
                              ? Colors.white
                              : Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  {},
                );
              },
              child: const Text(
                'clear filter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
