import 'package:blackhole/Services/download.dart';
import 'package:riverpod/riverpod.dart';

enum DownloadStatus { NotStarted, InProgress, Completed }

class DownloadState {
  final DownloadStatus state;
  final double progress;
  final int? downloadedItems;
  const DownloadState(this.progress, this.state, {this.downloadedItems});

  factory DownloadState.initital() =>
      const DownloadState(0, DownloadStatus.NotStarted);
  factory DownloadState.completed() =>
      const DownloadState(0, DownloadStatus.Completed);
  factory DownloadState.downloading(double inProgress, int downloadedItems) =>
      DownloadState(inProgress, DownloadStatus.InProgress,
          downloadedItems: downloadedItems);
}

final downloadStatusProvier =
    StateNotifierProvider.family<DownloadStatusProvider, DownloadState, String>(
        (ref, id) =>
            DownloadStatusProvider(DownloadState.initital(), ref.read));

class DownloadStatusProvider extends StateNotifier<DownloadState> {
  final Download down = Download();
  final Reader _ref;
  DownloadStatusProvider(DownloadState state, this._ref) : super(state);

  void checkIfAlreadyDownloaded(List<dynamic> data) {
    if (state.state == DownloadStatus.InProgress) return;
    final downloaded = down
        .checkIfAllSongsDownloaded(
            data.map<String>((e) => e['id'].toString()).toList())
        .isEmpty;
    if (downloaded) state = DownloadState.completed();
  }

  Future<void> singleDownload(dynamic data) async {
    final _result = await down.getDownloadPaths(
      data as Map,
    );
    await _result.fold((l) => null, (r) async {
      final _controller = await down.downloadSong(r[0], r[1], data);

      _controller.stream.listen((event) {
        state = DownloadState.downloading(event, 0);
      });
      await _controller.done;
    });
    state = DownloadState.completed();
  }

  Future<void> downloadFiles(List<dynamic> data,
      {bool createFolder = false, String? folderName}) async {
    int i = 0;
    for (final items in data) {
      final _result = await down.getDownloadPaths(items as Map,
          folderName: folderName, createFolder: createFolder);
      await _result.fold((l) => null, (r) async {
        final _controller = await down.downloadSong(r[0], r[1], items);
        i++;
        _controller.stream.listen((event) {
          state = DownloadState.downloading(event, i);
        });
        await _controller.done;

        Future.delayed(const Duration(seconds: 1)).then((value) =>
            _ref(downloadStatusProvier.call(items['id'].toString()).notifier)
                .checkIfAlreadyDownloaded([items]));
      });
    }

    state = DownloadState.completed();
  }
}
