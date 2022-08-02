/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class Assets {
  Assets._();

  static const AssetGenImage gitHubLogo =
      AssetGenImage('assets/GitHub_Logo.png');
  static const AssetGenImage gitHubLogoWhite =
      AssetGenImage('assets/GitHub_Logo_White.png');
  static const AssetGenImage album = AssetGenImage('assets/album.png');
  static const AssetGenImage artist = AssetGenImage('assets/artist.png');
  static const AssetGenImage blackButton =
      AssetGenImage('assets/black-button.png');
  static const AssetGenImage cover = AssetGenImage('assets/cover.jpg');
  static const AssetGenImage gpayBlack = AssetGenImage('assets/gpay-black.png');
  static const AssetGenImage gpayWhite = AssetGenImage('assets/gpay-white.png');
  static const AssetGenImage gpayQR = AssetGenImage('assets/gpayQR.png');
  static const AssetGenImage headerDark =
      AssetGenImage('assets/header-dark.jpg');
  static const AssetGenImage headerDarkOld =
      AssetGenImage('assets/header-dark_old.jpg');
  static const AssetGenImage header = AssetGenImage('assets/header.jpg');
  static const AssetGenImage headerOld = AssetGenImage('assets/header_old.jpg');
  static const AssetGenImage icLauncherJpg =
      AssetGenImage('assets/ic_launcher.jpg');
  static const AssetGenImage icLauncherPng =
      AssetGenImage('assets/ic_launcher.png');
  static const AssetGenImage iconWhiteTrans =
      AssetGenImage('assets/icon-white-trans.png');

  static const AssetGenImage iconWhiteTransNew =
      AssetGenImage('assets/icon_white_trans_new.png');
  static const AssetGenImage lyrics = AssetGenImage('assets/lyrics.png');
  static const AssetGenImage song = AssetGenImage('assets/song.png');
  static const AssetGenImage splash = AssetGenImage('assets/splash.png');
  static const AssetGenImage splashWhite =
      AssetGenImage('assets/splash_white.png');
  static const AssetGenImage ytCover = AssetGenImage('assets/ytCover.png');
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
