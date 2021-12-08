import 'package:flutter/material.dart';

enum AlbumListType {
  yogaPlaylist,
  otherActivity,
  featuredAlbums,
  popularPlaylist,
  newRelease,
  popularAlbum,
  genresMoods,
}

class AlbumList extends StatefulWidget {
  final AlbumListType albumListType;
  const AlbumList({
    Key? key,
    required this.albumListType,
  }) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  void initState() {
    super.initState();
    final String? finalUrl = getListUrl();
    if (finalUrl == null) {
      Navigator.pop(context);
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  String? getListUrl() {
    final AlbumListType albumListType = widget.albumListType;
    if (albumListType == AlbumListType.yogaPlaylist) {
      return 'https://api2.yogi-tunes.com/api/browse/popular_yoga_playlists';
    } else if (albumListType == AlbumListType.otherActivity) {
      return 'https://api2.yogi-tunes.com/api/browse/activities';
    } else if (albumListType == AlbumListType.featuredAlbums) {
      return 'https://api2.yogi-tunes.com/api/browse/featured_albums';
    } else if (albumListType == AlbumListType.popularPlaylist) {
      return 'https://api2.yogi-tunes.com/api/browse/popular_playlists';
    } else if (albumListType == AlbumListType.newRelease) {
      return 'https://api2.yogi-tunes.com/api/browse/new_releases';
    } else if (albumListType == AlbumListType.popularAlbum) {
      return 'https://api2.yogi-tunes.com/api/browse/trending_albums';
    } else if (albumListType == AlbumListType.genresMoods) {
      return 'https://api2.yogi-tunes.com/api/browse/genres_moods';
    }
  }
}
