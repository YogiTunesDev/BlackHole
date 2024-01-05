import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Services/download.dart';
import 'package:blackhole/domain/providers/download_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class DownloadButton extends ConsumerStatefulWidget {
  final Map data;
  final String? icon;
  final double? size;
  const DownloadButton({
    Key? key,
    required this.data,
    this.icon,
    this.size,
  }) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends ConsumerState<DownloadButton> {
  Download down = Download();
  final Box downloadsBox = Hive.box('downloads');
  final ValueNotifier<bool> showStopButton = ValueNotifier<bool>(false);

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ref
          .read(
              downloadStatusProvier.call(widget.data['id'].toString()).notifier)
          .checkIfAlreadyDownloaded([widget.data]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final downloadState =
        ref.watch(downloadStatusProvier.call(widget.data['id'].toString()));
    final provider = ref.read(
        downloadStatusProvier.call(widget.data['id'].toString()).notifier);
    return SizedBox.square(
      dimension: 50,
      child: Center(
        child: downloadState.state == DownloadStatus.Completed
            ? IconButton(
                icon: const Icon(Icons.download_done_rounded),
                tooltip: 'Download Done',
                color: Theme.of(context).colorScheme.secondary,
                iconSize: widget.size ?? 24.0,
                onPressed: () {},
              )
            : downloadState.state == DownloadStatus.NotStarted
                ? IconButton(
                    icon: Icon(
                      widget.icon == 'download'
                          ? Icons.download_rounded
                          : Icons.save_alt,
                    ),
                    iconSize: widget.size ?? 24.0,
                    color: Theme.of(context).iconTheme.color,
                    tooltip: 'Download',
                    onPressed: () async {
                      await provider.singleDownload(widget.data);
                      ShowSnackBar().showSnackBar(
                        context,
                        'Song ${AppLocalizations.of(context)!.downed}',
                      );
                    },
                  )
                : GestureDetector(
                    child: Stack(
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            value: downloadState.progress == 1
                                ? null
                                : downloadState.progress,
                          ),
                        ),
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: showStopButton,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                ),
                                iconSize: 25.0,
                                color: Theme.of(context).iconTheme.color,
                                tooltip: AppLocalizations.of(
                                  context,
                                )!
                                    .stopDown,
                                onPressed: () {
                                  // down.download = false;
                                },
                              ),
                            ),
                            builder: (
                              BuildContext context,
                              bool showValue,
                              Widget? child,
                            ) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: !showValue,
                                      child: Center(
                                        child: Text(
                                          '${(100 * downloadState.progress).round()}%',
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: showValue,
                                      child: child!,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      showStopButton.value = true;
                      Future.delayed(const Duration(seconds: 2), () async {
                        showStopButton.value = false;
                      });
                    },
                  ),
      ),
    );
  }
}

class MultiDownloadButton extends ConsumerStatefulWidget {
  final List data;
  final String playlistName;
  final int id;
  const MultiDownloadButton(
      {Key? key,
      required this.data,
      required this.playlistName,
      required this.id})
      : super(key: key);

  @override
  _MultiDownloadButtonState createState() => _MultiDownloadButtonState();
}

class _MultiDownloadButtonState extends ConsumerState<MultiDownloadButton> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ref
          .read(downloadStatusProvier.call(widget.playlistName).notifier)
          .checkIfAlreadyDownloaded(widget.data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final downloadState =
        ref.watch(downloadStatusProvier.call(widget.playlistName));
    final provider =
        ref.read(downloadStatusProvier.call(widget.playlistName).notifier);
    return SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: downloadState.state == DownloadStatus.Completed
              ? IconButton(
                  icon: const Icon(
                    Icons.download_done_rounded,
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                  iconSize: 25.0,
                  tooltip: AppLocalizations.of(context)!.downDone,
                  onPressed: () {},
                )
              : downloadState.state == DownloadStatus.NotStarted
                  ? Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.download_rounded,
                        ),
                        iconSize: 25.0,
                        // color: Theme.of(context).iconTheme.color,
                        tooltip: AppLocalizations.of(context)!.down,
                        onPressed: () async {
                          await provider.downloadFiles(widget.data,
                              createFolder: true,
                              folderName: widget.playlistName);
                          ShowSnackBar().showSnackBar(
                            context,
                            '"${widget.playlistName}" ${AppLocalizations.of(context)!.downed}',
                          );
                          await YogitunesAPI()
                              .playlistAddToLibrary(widget.id, context);
                        },
                      ),
                    )
                  : Stack(
                      children: [
                        Center(
                          child: Text(
                            '${(100 * downloadState.progress).round()}%',
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 35,
                            width: 35,
                            child: CircularProgressIndicator(
                              value: downloadState.progress == 1
                                  ? null
                                  : downloadState.progress,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              value: (downloadState.downloadedItems ?? 0) /
                                  widget.data.length,
                            ),
                          ),
                        ),
                      ],
                    ),
        ));
  }
}

class AlbumDownloadButton extends ConsumerStatefulWidget {
  final String albumId;
  final String albumName;
  const AlbumDownloadButton({
    Key? key,
    required this.albumId,
    required this.albumName,
  }) : super(key: key);

  @override
  _AlbumDownloadButtonState createState() => _AlbumDownloadButtonState();
}

class _AlbumDownloadButtonState extends ConsumerState<AlbumDownloadButton> {
  List<dynamic>? data;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      checkIfAlreadyDownloaded();
    });
  }

  Future<void> checkIfAlreadyDownloaded() async {
    final data = await YogitunesAPI().fetchAlbumSongs(widget.albumId);
    ref
        .read(downloadStatusProvier.call(widget.albumName).notifier)
        .checkIfAlreadyDownloaded(data);
    // ref
    //     .read(downloadStatusProvier.call(widget.albumId).notifier)
    //     .addListener((state) {
    //   if (state.state == DownloadStatus.Completed) {
    // ShowSnackBar().showSnackBar(
    //   context,
    //   '"${widget.albumName}" ${AppLocalizations.of(context)!.downed}',
    // );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final downloadState = ref.watch(downloadStatusProvier.call(widget.albumId));
    final provider =
        ref.read(downloadStatusProvier.call(widget.albumId).notifier);
    return data == null
        ? const SizedBox.shrink()
        : SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: downloadState.state == DownloadStatus.Completed
                  ? IconButton(
                      icon: const Icon(
                        Icons.download_done_rounded,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      iconSize: 25.0,
                      tooltip: AppLocalizations.of(context)!.downDone,
                      onPressed: () {},
                    )
                  : downloadState.state == DownloadStatus.NotStarted
                      ? Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.download_rounded,
                            ),
                            iconSize: 25.0,
                            color: Theme.of(context).iconTheme.color,
                            tooltip: AppLocalizations.of(context)!.down,
                            onPressed: () async {
                              ShowSnackBar().showSnackBar(
                                context,
                                '${AppLocalizations.of(context)!.downingAlbum} "${widget.albumName}"',
                              );
                              await provider.downloadFiles(
                                data!,
                                createFolder: true,
                                folderName: widget.albumName,
                              );
                              ShowSnackBar().showSnackBar(
                                context,
                                '"${widget.albumName}" ${AppLocalizations.of(context)!.downed}',
                              );
                            },
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: Text(
                                '${(100 * downloadState.progress).round()}%',
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 35,
                                width: 35,
                                child: CircularProgressIndicator(
                                  value: downloadState.progress == 1
                                      ? null
                                      : downloadState.progress,
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  value: data == null
                                      ? 0
                                      : data!.isEmpty
                                          ? 0
                                          : (downloadState.downloadedItems ??
                                                  0) /
                                              data!.length,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          );
  }
}
