import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/Screens/Common/popup_loader.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void keyboardHide(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void openSingleSongData(BuildContext context, int id,
    {bool popupVisible = true}) async {
  if (popupVisible) {
    popupLoader(
        context,
        AppLocalizations.of(
          context,
        )!
            .fetchingStream);
  }
  final RadioStationsStreamResponse? radioStationsStreamResponse =
      await YogitunesAPI().fetchSingleSongData(id);
  if (popupVisible) {
    Navigator.pop(context);
  }
  if (radioStationsStreamResponse != null) {
    if (radioStationsStreamResponse.songItemModel != null) {
      if (radioStationsStreamResponse.songItemModel!.isNotEmpty) {
        List<SongItemModel> lstSong = [];

        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => PlayScreen(
              songsList: radioStationsStreamResponse.songItemModel!,
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
}
