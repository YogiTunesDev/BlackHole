import 'dart:async';
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:blackhole/Helpers/image_downs.dart';
import 'package:blackhole/Helpers/lyrics.dart';
import 'package:blackhole/Services/ext_storage_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum DownloadedStatus { SongExists, Completed, Failed }

class Download {
  int? rememberOption;
  final ValueNotifier<bool> remember = ValueNotifier<bool>(false);
  String preferredDownloadQuality = Hive.box('settings')
      .get('downloadQuality', defaultValue: '320 kbps') as String;
  String downloadFormat = 'mp3';
  bool createDownloadFolder = Hive.box('settings')
      .get('createDownloadFolder', defaultValue: false) as bool;
  bool createYoutubeFolder = Hive.box('settings')
      .get('createYoutubeFolder', defaultValue: false) as bool;

  bool downloadLyrics =
      Hive.box('settings').get('downloadLyrics', defaultValue: false) as bool;

  Future<Either<String, List<String>>> getDownloadPaths(
    Map data, {
    bool createFolder = false,
    String? folderName,
  }) async {
    if (!Platform.isWindows) {
      PermissionStatus status = await Permission.storage.status;
      if (status.isDenied) {
        await [
          Permission.storage,
          Permission.accessMediaLocation,
          Permission.mediaLibrary,
        ].request();
      }
      status = await Permission.storage.status;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }

    final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
    data['title'] = data['title'].toString().split('(From')[0].trim();
    String filename = '${data["title"]} - ${data["artist"]}';
    String dlPath =
        Hive.box('settings').get('downloadPath', defaultValue: '') as String;
    if (filename.length > 200) {
      final String temp = filename.substring(0, 200);
      final List tempList = temp.split(', ');
      tempList.removeLast();
      filename = tempList.join(', ');
    }

    filename = '${filename.replaceAll(avoid, "").replaceAll("  ", " ")}.mp3';
    if (dlPath == '') {
      final String? temp =
          await ExtStorageProvider.getExtStorage(dirName: 'Music');
      dlPath = temp!;
    }
    if (data['url'].toString().contains('google') && createYoutubeFolder) {
      dlPath = '$dlPath/YouTube';
      if (!await Directory(dlPath).exists()) {
        await Directory(dlPath).create();
      }
    }

    if (createFolder && createDownloadFolder && folderName != null) {
      final String foldername = folderName.replaceAll(avoid, '');
      dlPath = '$dlPath/$foldername';
      if (!await Directory(dlPath).exists()) {
        await Directory(dlPath).create();
      }
    }

    final bool exists = await File('$dlPath/$filename').exists();
    if (exists) {
      return const Left('Song Already Exists');
    } else {
      return Right([dlPath, filename]);
    }
  }

  // Future<DownloadedStatus> prepareDownload(
  //   Map data, {
  //   bool createFolder = false,
  //   String? folderName,
  // }) async {
  //   download = true;
  //   if (!Platform.isWindows) {
  //     PermissionStatus status = await Permission.storage.status;
  //     if (status.isDenied) {
  //       await [
  //         Permission.storage,
  //         Permission.accessMediaLocation,
  //         Permission.mediaLibrary,
  //       ].request();
  //     }
  //     status = await Permission.storage.status;
  //     if (status.isPermanentlyDenied) {
  //       await openAppSettings();
  //     }
  //   }
  //   final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
  //   data['title'] = data['title'].toString().split('(From')[0].trim();
  //   String filename = '${data["title"]} - ${data["artist"]}';
  //   String dlPath =
  //       Hive.box('settings').get('downloadPath', defaultValue: '') as String;
  //   if (filename.length > 200) {
  //     final String temp = filename.substring(0, 200);
  //     final List tempList = temp.split(', ');
  //     tempList.removeLast();
  //     filename = tempList.join(', ');
  //   }

  //   filename = '${filename.replaceAll(avoid, "").replaceAll("  ", " ")}.mp3';
  //   if (dlPath == '') {
  //     final String? temp =
  //         await ExtStorageProvider.getExtStorage(dirName: 'Music');
  //     dlPath = temp!;
  //   }
  //   if (data['url'].toString().contains('google') && createYoutubeFolder) {
  //     dlPath = '$dlPath/YouTube';
  //     if (!await Directory(dlPath).exists()) {
  //       await Directory(dlPath).create();
  //     }
  //   }

  //   if (createFolder && createDownloadFolder && folderName != null) {
  //     final String foldername = folderName.replaceAll(avoid, '');
  //     dlPath = '$dlPath/$foldername';
  //     if (!await Directory(dlPath).exists()) {
  //       await Directory(dlPath).create();
  //     }
  //   }

  //   final bool exists = await File('$dlPath/$filename').exists();
  //   if (exists) {
  //     if (remember.value == true && rememberOption != null) {
  //       switch (rememberOption) {
  //         case 0:
  //           lastDownloadId = data['id'].toString();
  //           break;
  //         case 1:
  //           downloadSong(dlPath, filename, data);
  //           break;
  //         case 2:
  //           while (await File('$dlPath/$filename').exists()) {
  //             filename = filename.replaceAll('.mp3', ' (1).mp3');
  //           }
  //           break;
  //         default:
  //           lastDownloadId = data['id'].toString();
  //           break;
  //       }
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //             title: Text(
  //               AppLocalizations.of(context)!.alreadyExists,
  //               style:
  //                   TextStyle(color: Theme.of(context).colorScheme.secondary),
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   '"${data['title']}" ${AppLocalizations.of(context)!.downAgain}',
  //                   softWrap: true,
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               Column(
  //                 children: [
  //                   ValueListenableBuilder(
  //                     valueListenable: remember,
  //                     builder: (
  //                       BuildContext context,
  //                       bool rememberValue,
  //                       Widget? child,
  //                     ) {
  //                       return Row(
  //                         children: [
  //                           Checkbox(
  //                             activeColor:
  //                                 Theme.of(context).colorScheme.secondary,
  //                             value: rememberValue,
  //                             onChanged: (bool? value) {
  //                               remember.value = value ?? false;
  //                             },
  //                           ),
  //                           Text(
  //                             AppLocalizations.of(context)!.rememberChoice,
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       TextButton(
  //                         style: TextButton.styleFrom(
  //                           primary:
  //                               Theme.of(context).brightness == Brightness.dark
  //                                   ? Colors.white
  //                                   : Colors.grey[700],
  //                         ),
  //                         onPressed: () {
  //                           lastDownloadId = data['id'].toString();
  //                           Navigator.pop(context);
  //                           rememberOption = 0;
  //                         },
  //                         child: Text(
  //                           AppLocalizations.of(context)!.no,
  //                           style: const TextStyle(color: Colors.white),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: TextButton(
  //                           style: TextButton.styleFrom(
  //                             primary: Theme.of(context).brightness ==
  //                                     Brightness.dark
  //                                 ? Colors.white
  //                                 : Colors.grey[700],
  //                           ),
  //                           onPressed: () async {
  //                             Navigator.pop(context);
  //                             Hive.box('downloads').delete(data['id']);
  //                             downloadSong(context, dlPath, filename, data);
  //                             rememberOption = 1;
  //                           },
  //                           child:
  //                               Text(AppLocalizations.of(context)!.yesReplace),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 5.0),
  //                       TextButton(
  //                         style: TextButton.styleFrom(
  //                           primary: Colors.white,
  //                           backgroundColor:
  //                               Theme.of(context).colorScheme.secondary,
  //                         ),
  //                         onPressed: () async {
  //                           Navigator.pop(context);
  //                           while (await File('$dlPath/$filename').exists()) {
  //                             filename =
  //                                 filename.replaceAll('.mp3', ' (1).mp3');
  //                           }
  //                           rememberOption = 2;
  //                           downloadSong(context, dlPath, filename, data);
  //                         },
  //                         child: Text(
  //                           AppLocalizations.of(context)!.yes,
  //                           style: TextStyle(
  //                             color: Theme.of(context).colorScheme.secondary ==
  //                                     Colors.white
  //                                 ? Colors.black
  //                                 : null,
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         width: 5,
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } else {
  //     downloadSong(dlPath, filename, data);
  //   }
  // }

  Future<StreamController<double>> downloadSong(
    String? dlPath,
    String fileName,
    Map data,
  ) async {
    String? filepath;
    late String filepath2;
    String? appPath;
    final List<int> _bytes = [];
    String lyrics;
    final artname = fileName.replaceAll('.mp3', '.jpg');
    if (!Platform.isWindows) {
      appPath = Hive.box('settings').get('tempDirPath')?.toString();
      appPath ??= (await getTemporaryDirectory()).path;
    } else {
      final Directory? temp = await getDownloadsDirectory();
      appPath = temp!.path;
    }
    // if (data['url'].toString().contains('google')) {
    // filename = filename.replaceAll('.m4a', '.opus');
    // }
    try {
      await File('$dlPath/$fileName')
          .create(recursive: true)
          .then((value) => filepath = value.path);
      // print('created audio file');

      await File('$appPath/$artname')
          .create(recursive: true)
          .then((value) => filepath2 = value.path);
    } catch (e) {
      await [
        Permission.manageExternalStorage,
      ].request();
      await File('$dlPath/$fileName')
          .create(recursive: true)
          .then((value) => filepath = value.path);
      // print('created audio file');
      await File('$appPath/$artname')
          .create(recursive: true)
          .then((value) => filepath2 = value.path);
    }
    // debugPrint('Audio path $filepath');
    // debugPrint('Image path $filepath2');

    final String kUrl = data['url'].toString().replaceAll(
          '_96.',
          "_${preferredDownloadQuality.replaceAll(' kbps', '')}.",
        );
    StreamController<double> _progressController = StreamController.broadcast();
    final client = Client();
    final response = await client.send(Request('GET', Uri.parse(kUrl)));
    final int total = response.contentLength ?? 0;
    int recieved = 0;
    response.stream.asBroadcastStream();
    response.stream.listen((value) {
      _bytes.addAll(value);

      recieved += value.length;
      _progressController.add(recieved / total);
    }).onDone(() async {
      final file = File(filepath!);
      await file.writeAsBytes(_bytes);

      final client = HttpClient();
      final HttpClientRequest request2 =
          await client.getUrl(Uri.parse(data['image'].toString()));
      final HttpClientResponse response2 = await request2.close();
      final bytes2 = await consolidateHttpClientResponseBytes(response2);
      final File file2 = File(filepath2);

      await file2.writeAsBytes(bytes2);
      try {
        lyrics = downloadLyrics
            ? await Lyrics.getLyrics(
                id: data['id'].toString(),
                title: data['title'].toString(),
                artist: data['artist'].toString(),
                saavnHas: data['has_lyrics'] == 'true',
              )
            : '';
      } catch (e) {
        // print('Error fetching lyrics: $e');
        lyrics = '';
      }

      // debugPrint('Started tag editing');
      final Tag tag = Tag(
        title: data['title'].toString(),
        artist: data['artist'].toString(),
        albumArtist: data['album_artist']?.toString() ??
            data['artist']?.toString().split(', ')[0],
        artwork: filepath2,
        album: data['album'].toString(),
        genre: data['language'].toString(),
        year: data['year'].toString(),
        lyrics: lyrics,
        comment: 'BlackHole',
      );
      try {
        final tagger = Audiotagger();
        await tagger.writeTags(
          path: filepath!,
          tag: tag,
        );
      } catch (e) {
        // print('Failed to edit tags');
      }
      client.close();
      _progressController.close();
      final songData = {
        'id': data['id'].toString(),
        'title': data['title'].toString(),
        'subtitle': data['subtitle'].toString(),
        'artist': data['artist'].toString(),
        'albumArtist': data['album_artist']?.toString() ??
            data['artist']?.toString().split(', ')[0],
        'album': data['album'].toString(),
        'genre': data['language'].toString(),
        'year': data['year'].toString(),
        'lyrics': lyrics,
        'duration': data['duration'],
        'release_date': data['release_date'].toString(),
        'album_id': data['album_id'].toString(),
        'perma_url': data['perma_url'].toString(),
        'quality': preferredDownloadQuality,
        'path': filepath,
        'image': filepath2,
        'image_url': data['image'].toString(),
        'from_yt': data['language'].toString() == 'YouTube',
        'dateAdded': DateTime.now().toString(),
      };
      if (data['mainPlaylistName'] != null) {
        songData['mainPlaylistName'] = data['mainPlaylistName'];
        data['mainPlaylistImages'] = songData['mainPlaylistImages'];
      }
      Hive.box('downloads').put(songData['id'], songData);
      getArtistImage(
        name: data['artist'].toString().split(', ').first,
        tempDirPath: appPath!,
      );
    });
    return _progressController;
  }

  List<String> checkIfAllSongsDownloaded(List<String> songIDs) {
    songIDs
        .removeWhere((element) => Hive.box('downloads').get(element) != null);
    return songIDs;
  }
}
