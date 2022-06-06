import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/exit_dialog.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:flutter/material.dart';

class EditPlaylist extends StatefulWidget {
  final List<SongItemModel> data;
  final String title;
  final List<String> selectedPlaylist;
  final String playlistName;
  final int? playlistId;
  final VoidCallback? callback;
  const EditPlaylist({
    Key? key,
    required this.data,
    required this.title,
    required this.selectedPlaylist,
    required this.playlistName,
    required this.playlistId,
    this.callback,
  }) : super(key: key);

  @override
  State<EditPlaylist> createState() => _EditPlaylistState();
}

class _EditPlaylistState extends State<EditPlaylist> {
  List<SongItemModel>? songList = [];
  final TextEditingController _playlistTitleController =
      TextEditingController();
  final FocusNode _playlistTitleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _playlistTitleController.value = TextEditingValue(
      text: widget.title,
    );
    for (int i = 0; i < widget.data.length; i++) {
      songList!.insert(i, widget.data[i]);
      widget.selectedPlaylist.insert(i, widget.data[i].id.toString());
    }
  }

  bool _isPlaylistModified() {
    bool listModified = false;

    if (songList!.length != widget.selectedPlaylist.length ||
        widget.title != _playlistTitleController.text) {
      return true;
    }
    for (int i = 0; i < songList!.length; i++) {
      if (songList![i].id != widget.data[i].id) {
        listModified = true;
        break;
      }
    }
    if (listModified) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _playlistTitleController.dispose();
    _playlistTitleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: () async {
              _playlistTitleFocusNode.unfocus();
              if (_isPlaylistModified()) {
                return showDialog<void>(
                  context: context,
                  builder: (context) => EditPlaylistExitDialog(
                    title: 'CLOSE WITHOUT SAVING?',
                    subTitle: "If you close now, your changes won't be saved",
                    mainButtonText: 'Keep Editing',
                    secondaryButtonText: 'Close',
                    mainButtonCallback: () => Navigator.of(context).pop(),
                    secondaryButtonCallback: () => Navigator.of(context).pop(),
                  ),
                );
              }
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Edit Playlist'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                _playlistTitleFocusNode.unfocus();
                if (!_isPlaylistModified()) {
                  Navigator.of(context).pop();
                  return;
                }
                popupLoader(context, 'Loading');
                final res = await YogitunesAPI().editPlaylist(
                  widget.playlistId.toString(),
                  _playlistTitleController.text,
                  widget.selectedPlaylist,
                );
                Navigator.of(context).pop();
                if (res['status'] as bool) {
                  widget.callback!();
                  Navigator.of(context).pop(true);
                } else {
                  ShowSnackBar().showSnackBar(context, res['data'].toString());
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                child: TextField(
                  controller: _playlistTitleController,
                  focusNode: _playlistTitleFocusNode,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex = newIndex - 1;
                    }
                    final song = songList!.removeAt(oldIndex);
                    songList!.insert(newIndex, song);
                    widget.selectedPlaylist.removeAt(oldIndex);
                    widget.selectedPlaylist
                        .insert(newIndex, song.id.toString());
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: songList!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onLongPress: () {},
                    key: ValueKey('$index'),
                    contentPadding: const EdgeInsets.only(left: 15.0),
                    title: Text(
                      '${songList![index].title}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      songList![index].artist ?? 'Unkown',
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.remove_circle_outline_outlined),
                      onPressed: () async {
                        setState(() {
                          songList!.removeWhere(
                            (element) => element.id == songList![index].id,
                          );
                          widget.selectedPlaylist.removeWhere(
                            (element) =>
                                element == widget.selectedPlaylist[index],
                          );
                        });
                      },
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.menu),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
