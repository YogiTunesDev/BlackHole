import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:blackhole/CustomWidgets/snackbar.dart';
import 'package:blackhole/Helpers/format.dart';
import 'package:blackhole/main.dart';
import 'package:blackhole/model/album_response.dart';
import 'package:blackhole/model/artist_data_response.dart';
import 'package:blackhole/model/custom_playlist_response.dart';
import 'package:blackhole/model/forgot_password_response.dart';
import 'package:blackhole/model/forgot_password_verification_response.dart';
import 'package:blackhole/model/genres_response.dart';
import 'package:blackhole/model/home_model.dart';
import 'package:blackhole/model/login_response.dart';
import 'package:blackhole/model/my_library_track_response.dart';
import 'package:blackhole/model/my_recently_played_song_response.dart';
import 'package:blackhole/model/playlist_response.dart';
import 'package:blackhole/model/radio_station_stream_response.dart';
import 'package:blackhole/model/radio_stations_response.dart';
import 'package:blackhole/model/reset_password_response.dart';
import 'package:blackhole/model/search_all_album_response.dart';
import 'package:blackhole/model/search_all_artists_response.dart';
import 'package:blackhole/model/search_all_playlists_response.dart';
import 'package:blackhole/model/search_all_track_response.dart';
import 'package:blackhole/model/search_response.dart';
import 'package:blackhole/model/see_all_library_albums_response.dart';
import 'package:blackhole/model/signup_response.dart';
import 'package:blackhole/model/single_album_response.dart';
import 'package:blackhole/model/single_playlist_response.dart';
import 'package:blackhole/model/subscription_status_response.dart';
import 'package:blackhole/model/tracks_by_bpm_response.dart';
import 'package:blackhole/model/trending_song_response.dart';
import 'package:blackhole/model/user_info_response.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class YogitunesAPI {
  List preferredLanguages = Hive.box('settings')
      .get('preferredLanguage', defaultValue: ['Hindi']) as List;
  Map<String, String> headers = {};
  String baseUrl = 'https://api2.yogi-tunes.com/';
  String apiStr = 'api/';
  Box settingsBox = Hive.box('settings');
  Map<String, String> endpoints = {
    'login': 'users/login',
    'userInfo': 'users/info',
    'logincheck': 'users/check-email',
    'signup': 'users/signup',
    'forgotPassword': 'users/request-verification-code',
    'forgotPasswordVerification': 'users/validate-verification-code',
    'resetPassword': 'users/reset-password',
    'homeData': 'browse/',
    'playSong': 'play',
    'radioStations': 'browse/radio_stations',
    'playlists': 'my-library/playlists',
    'createPlaylist': 'my-library/playlists/create',
    'editPlaylist': 'my-library/playlists/edit',
    'deletePlaylist': 'my-library/playlists/delete',
    'playlistSongsList': 'browse/tracks-by-bpm',
    'search': 'search',
    'getSingleSong': 'browse/tracks',
    'getArtist': 'browse/artists',
    'recentSongsViewAll': 'browse/main/my-recently-played-songs',
    'playlistAddToLibrary': 'my-library/playlists/add',
    'albumAddToLibrary': 'my-library/albums/add',
    'tracksAddToLibrary': 'my-library/tracks/add',
    'seeAllTracksLibrary': 'my-library/tracks',
    'seeAllPlaylistsLibrary': 'my-library/playlists',
    'seeAllAlbumsLibrary': 'my-library/albums',
    'seeAllArtistLibrary': 'my-library/artists',
    'albumRemoveFromLibrary': 'my-library/albums/delete',
    'trackRemoveFromLibrary': 'my-library/tracks/delete',
    'subscriptionStatus': 'users/subscription-status',
    'paymentSuccess': 'users/payment-success/google',
    'removeAccount': 'users/remove-account',
    // 'topSearches': '__call=content.getTopSearches',
    // 'fromToken': '__call=webapi.get',
    // 'featuredRadio': '__call=webradio.createFeaturedStation',
    // 'artistRadio': '__call=webradio.createArtistStation',
    // 'entityRadio': '__call=webradio.createEntityStation',
    // 'radioSongs': '__call=webradio.getSong',
    // 'songDetails': '__call=song.getDetails',
    // 'playlistDetails': '__call=playlist.getDetails',
    // 'albumDetails': '__call=content.getAlbumDetails',
    // 'getResults': '__call=search.getResults',
    // 'albumResults': '__call=search.getAlbumResults',
    // 'artistResults': '__call=search.getArtistResults',
    // 'playlistResults': '__call=search.getPlaylistResults',
    // 'getReco': '__call=reco.getreco',
    // 'getAlbumReco': '__call=reco.getAlbumReco', // still not used
    // 'artistOtherTopSongs':
    //     '__call=search.artistOtherTopSongs', // still not used
  };

  Future<Response> getResponse(
    String params, {
    bool usev4 = true,
    bool useProxy = false,
  }) async {
    Uri url;
    if (!usev4) {
      url = Uri.https(
        baseUrl,
        '$apiStr$params',
      );
    } else {
      url = Uri.parse('$baseUrl$apiStr$params');
    }

    final String? apiToken = apiTokenBox.get('token');
    if (apiToken == null && apiToken == '') {
      return Response('No Token Found', 404);
    }
    headers = {
      'Authorization': 'Bearer $apiToken',
      'Accept': 'application/json'
    };

    // if (useProxy && settingsBox.get('useProxy', defaultValue: false) as bool) {
    //   final proxyIP = settingsBox.get('proxyIp');
    //   final proxyPort = settingsBox.get('proxyPort');
    //   final HttpClient httpClient = HttpClient();
    //   httpClient.findProxy = (uri) {
    //     return 'PROXY $proxyIP:$proxyPort;';
    //   };
    //   httpClient.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => Platform.isAndroid;
    //   final IOClient myClient = IOClient(httpClient);
    //   return myClient.get(url, headers: headers);
    // }

    return get(url, headers: headers).onError((error, stackTrace) {
      return Response('', 405);
    });
  }

  /// This function is used for check login api calling
  Future<bool?> logincheck(String email) async {
    LoginResponse? result;
    try {
      final url = "$baseUrl$apiStr${endpoints['logincheck']}";

      final res = await http.post(Uri.parse(url), body: {
        'email': email,
      });

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        // result = LoginResponse?.fromMap(data as Map<String, dynamic>);
        if (data['data']['status'] == true) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      log('Error in logincheck: $e');
    }
  }

  /// This function is used to call login api
  Future<LoginResponse?> login(String email, String password) async {
    LoginResponse? result;
    try {
      final url = "$baseUrl$apiStr${endpoints['login']}";

      final res = await http.post(Uri.parse(url), body: {
        'email': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        result = LoginResponse?.fromMap(data as Map<String, dynamic>);

        apiTokenBox.put('token', result.apiToken);
      }
    } catch (e) {
      log('Error in login: $e');
    }
    return result;
  }

  /// This function is used to call signup api
  Future<SignupResponse?> signup(String name, String email, String password,
      bool isNewsLetterChecked) async {
    SignupResponse? result;
    try {
      final url = "$baseUrl$apiStr${endpoints['signup']}";

      final res = await http.post(Uri.parse(url), body: {
        'name': name,
        'email': email,
        'password': password,
        'newsletter': isNewsLetterChecked.toString(),
        'initial_platform': Platform.isIOS ? 'ios' : 'Android',
      }, headers: {
        'Accept': 'application/json',
        'User-Agent': Platform.isIOS ? 'test/iOS' : 'test/Android',
      });
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;

        result = SignupResponse?.fromMap(data as Map<String, dynamic>);

        apiTokenBox.put('token', result.apiToken);
      }
    } catch (e) {
      log('Error in signup: $e');
    }
    return result;
  }

  /// This function is used to call forgot password api
  Future<ForgotPasswordResponse?> forgotPassword(String email) async {
    ForgotPasswordResponse? result;
    try {
      final url = "$baseUrl$apiStr${endpoints['forgotPassword']}";

      final res = await http.post(Uri.parse(url), body: {
        'email': email,
      });
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;

        result = ForgotPasswordResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in forgotPassword: $e');
    }
    return result;
  }

  /// This function is used to call forgot password verification api
  Future<ForgotPasswordVerificationResponse?> forgotPasswordVerification(
      String email, String code) async {
    ForgotPasswordVerificationResponse? result;
    try {
      final url = "$baseUrl$apiStr${endpoints['forgotPasswordVerification']}";
      final res = await http.post(Uri.parse(url), body: {
        'email': email,
        'verification_code': code,
      });

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;

        result = ForgotPasswordVerificationResponse?.fromMap(
            data as Map<String, dynamic>);

        apiTokenBox.put('token', result.apiToken);
      }
    } catch (e) {
      log('Error in forgotPasswordVerification: $e');
    }
    return result;
  }

  /// This function is used to call reset password api
  Future<ResetPasswordResponse?> resetPassword(String password) async {
    ResetPasswordResponse? result;

    final String? apiToken = apiTokenBox.get('token');

    try {
      final url =
          "$baseUrl$apiStr${endpoints['resetPassword']}?password=$password";

      final res = await http.post(Uri.parse(url), headers: {
        'Authorization': 'Bearer $apiToken',
      });

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;

        result = ResetPasswordResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in resetPassword: $e');
    }
    return result;
  }

  /// This function is used to get home page data api
  Future<HomeResponse?> fetchHomePageData() async {
    HomeResponse? result;
    try {
      final res = await getResponse(endpoints['homeData']!);
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatHomePageData(
          HomeResponse?.fromMap(data as Map<String, dynamic>),
        );
      }
    } catch (e) {
      log('Error in fetchHomePageData: $e');
    }
    return result;
  }

  Future<void> updatePlaySong(String id, String endOffset) async {
    try {
      List<Map<String, dynamic>> lstmap = [];
      lstmap.add({
        'source_type': '',
        'source_id': '',
        'track_id': id,
        'start_offset': 0,
        'end_offset': endOffset,
      });

      final String apiToken = apiTokenBox.get('token').toString();

      final Map<String, String> headers = {
        'Authorization': 'Bearer $apiToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      final mapData = {
        'tracks': lstmap,
      };
      final res = await http.post(
        Uri.parse('$baseUrl${apiStr}play'),
        headers: headers,
        // lstMap.ls
        body: json
            .encode(mapData), //json.decode(json.encode(mapData).toString()),
      );
    } catch (e, stack) {
      log('Error in updatePlaySong: $e');
    }
  }

  Future<RadioStationsResponse?> fetchYogiRadioStationPageData(
      int pageNo) async {
    RadioStationsResponse? result;
    try {
      final res =
          await getResponse('${endpoints['radioStations']!}?page=$pageNo');
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = RadioStationsResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in fetchHomePageData: $e');
    }
    return result;
  }

  /// This function is used to check subscription status
  Future<SubscriptionStatusResponse?> subscriptionStatus() async {
    SubscriptionStatusResponse? result;
    try {
      final res = await getResponse(endpoints['subscriptionStatus']!);

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result =
            SubscriptionStatusResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
    }
    return result;
  }

  /// This function is used to check payment success
  Future<SubscriptionStatusResponse?> paymentSuccess(
      {required String paymentId,
      required String subscriptionId,
      required String paymentDate}) async {
    SubscriptionStatusResponse? paymentSuccessResponse;
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['paymentSuccess']}";
      final Map<String, String> headers = {
        'Authorization': 'Bearer $apiToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      final mapData = {
        'payment_id': paymentId,
        'subscription_id': subscriptionId,
        'payment_date': paymentDate,
        'payment_token': '',
      };

      final res = await http.post(
        Uri.parse(url),
        body: json.encode(mapData),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;

        paymentSuccessResponse = await SubscriptionStatusResponse?.fromMap(
            data as Map<String, dynamic>);

        return paymentSuccessResponse;
      }
    } catch (e) {
      log('Error in paymentSuccess: $e');
    }
  }

  Future<RadioStationsStreamResponse?> fetchYogiRadioStationStreamData(
      int id) async {
    RadioStationsStreamResponse? result;
    try {
      final res =
          await getResponse('${endpoints['radioStations']!}/$id/stream');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatYogiRadioStationStreamData(
            RadioStationsStreamResponse?.fromMap(data as Map<String, dynamic>));
      }
    } catch (e) {
      log('Error in fetchHomePageData: $e');
    }
    return result;
  }

  /// This function is used to call single song data api
  Future<RadioStationsStreamResponse?> fetchSingleSongData(int id) async {
    RadioStationsStreamResponse? result;
    try {
      final res =
          await getResponse('${endpoints['getSingleSong']!}/$id/stream');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatYogiRadioStationStreamData(
            RadioStationsStreamResponse?.fromMap(data as Map<String, dynamic>));
      }
    } catch (e) {
      log('Error in fetchHomePageData: $e');
    }
    return result;
  }

  /// This function is used to call user data api
  Future<UserInfoResponse?> fetchUserData() async {
    UserInfoResponse? result;
    try {
      final res = await getResponse('${endpoints['userInfo']}');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = UserInfoResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in fetchHomePageData: $e');
    }
    return result;
  }

  /// This function is used to get yogi playlist data api
  Future<PlaylistResponse?> fetchYogiPlaylistData(String url, int pageNo,
      String sort, String durationFilter, String selectedType) async {
    PlaylistResponse? result;
    try {
      final res = await getResponse('$url?page=$pageNo$sort' +
          (durationFilter == null || durationFilter == ''
              ? ''
              : '&duration=$durationFilter') +
          (selectedType == null || selectedType == ''
              ? ''
              : '&yoga_type=$selectedType'));

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatYogiPlaylistData(
            PlaylistResponse?.fromMap(data as Map<String, dynamic>));
      }
    } catch (e) {
      log('Error in fetchYogiPlaylistData: $e');
    }
    return result;
  }

  /// This function is used to get yogi album data api
  Future<AlbumResponse?> fetchYogiAlbumData(
    String url,
    int pageNo,
    String sort,
  ) async {
    AlbumResponse? result;
    try {
      final res = await getResponse('$url?page=$pageNo$sort');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = AlbumResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  /// This function is used to get yogi genres data api
  Future<GenresResponse?> fetchYogiGenresData(
    String url,
  ) async {
    GenresResponse? result;
    try {
      final res = await getResponse('$url');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = GenresResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  /// This function is used to get yogi genres album data api
  Future<AlbumResponse?> fetchYogiGenresAlbumData(
    String url,
    int id,
    int pageNo,
  ) async {
    AlbumResponse? result;
    try {
      final res = await getResponse('$url/$id?page=$pageNo');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = AlbumResponse?.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  /// This function is used to get yogi single album data api
  Future<SingleAlbumResponse?> fetchYogiSingleAlbumData(
    int id,
  ) async {
    SingleAlbumResponse? result;
    try {
      final res = await getResponse('browse/albums/$id');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatYogiSingleALbumData(
          SingleAlbumResponse?.fromMap(data as Map<String, dynamic>),
        );
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  /// This function is used to get yogi single playlist data api
  Future<SinglePlaylistResponse?> fetchYogiSinglePlaylistData(
    int id,
  ) async {
    SinglePlaylistResponse? result;
    try {
      final res = await getResponse('browse/playlists/$id');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatYogiSinglePlaylistData(
          SinglePlaylistResponse?.fromMap(data as Map<String, dynamic>),
        );
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  /// This function is used to get yogi trending song data api
  Future<TrendingSongResponse?> fetchYogiTrendingSongData(
      String url, int pageNo, String sort) async {
    TrendingSongResponse? result;
    try {
      final res = await getResponse('$url?page=$pageNo$sort');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatYogiTrendingSongData(
          TrendingSongResponse?.fromMap(data as Map<String, dynamic>),
        );
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  Future<Map> getSongFromToken(String token, String type) async {
    final String params = "token=$token&type=$type&${endpoints['fromToken']}";
    try {
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final Map getMain = json.decode(res.body) as Map;
        if (type == 'album' || type == 'playlist') return getMain;
        final List responseList = getMain['songs'] as List;
        return {
          'songs': await FormatResponse.formatSongsResponse(responseList, type)
        };
      }
    } catch (e) {
      log('Error in getSongFromToken: $e');
    }
    return {'songs': List.empty()};
  }

  Future<List> getReco(String pid) async {
    final String params = "${endpoints['getReco']}&pid=$pid";
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final List getMain = json.decode(res.body) as List;
      return FormatResponse.formatSongsResponse(getMain, 'song');
    }
    return List.empty();
  }

  Future<String?> createRadio(
    String name,
    String language,
    String stationType,
  ) async {
    String? params;
    if (stationType == 'featured') {
      params = "name=$name&language=$language&${endpoints['featuredRadio']}";
    }
    if (stationType == 'artist') {
      params =
          "name=$name&query=$name&language=$language&${endpoints['artistRadio']}";
    }

    final res = await getResponse(params!);
    if (res.statusCode == 200) {
      final Map getMain = json.decode(res.body) as Map;
      return getMain['stationid']?.toString();
    }
    return null;
  }

  Future<List> getRadioSongs(String stationId, {int count = 20}) async {
    final String params =
        "stationid=$stationId&k=$count&${endpoints['radioSongs']}";
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final Map getMain = json.decode(res.body) as Map;
      final List responseList = [];
      for (int i = 0; i < count; i++) {
        responseList.add(getMain[i.toString()]['song']);
      }
      return FormatResponse.formatSongsResponse(responseList, 'song');
    }
    return [];
  }

  /// This function is used to get search api data
  Future<SearchResponse?> search(String keyword, bool isMyLibrary) async {
    SearchResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['search']!}?keyword=$keyword&my_library=$isMyLibrary');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SearchResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in search: $e');
    }
    return result;
  }

  /// This function is used to get view all recent tracks api data
  Future<MyRecentlyPlayedSongResponse?> viewAllRecentTrack(
    String url, {
    int pageNo = 1,
  }) async {
    MyRecentlyPlayedSongResponse? result;
    try {
      final res = await getResponse('$url?page=$pageNo');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = MyRecentlyPlayedSongResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in viewAllRecentTrack: $e');
    }
    return result;
  }

  /// This function is used to get search all albums api data
  Future<SearchAllAlbumResponse?> searchAllAlbum(
      String keyword, bool isMyLibrary) async {
    SearchAllAlbumResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['search']!}/albums?keyword=$keyword&my_library=$isMyLibrary');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SearchAllAlbumResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in searchAllAlbum: $e');
    }
    return result;
  }

  /// This function is used to get search all tracks api data
  Future<SearchAllTracksResponse?> searchAllTrack(
      String keyword, bool isMyLibrary) async {
    SearchAllTracksResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['search']!}/tracks?keyword=$keyword&my_library=$isMyLibrary');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SearchAllTracksResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in searchAllTrack: $e');
    }
    return result;
  }

  /// This function is used to get search all playlist api data
  Future<SearchAllPlaylistsResponse?> searchAllPlaylist(
      String keyword, bool isMyLibrary) async {
    SearchAllPlaylistsResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['search']!}/playlists?keyword=$keyword&my_library=$isMyLibrary');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SearchAllPlaylistsResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in searchAllPlaylist: $e');
    }
    return result;
  }

  /// This function is used to get search all artist api data
  Future<SearchAllArtistsResponse?> searchAllArtists(
      String keyword, bool isMyLibrary) async {
    SearchAllArtistsResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['search']!}/artists?keyword=$keyword&my_library=$isMyLibrary');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SearchAllArtistsResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in searchAllArtists: $e');
    }
    return result;
  }

  /// This function is used to get artist api data
  Future<ArtistDataResponse?> artistData(int id) async {
    ArtistDataResponse? result;
    try {
      final res = await getResponse('${endpoints['getArtist']!}/$id');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = ArtistDataResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in searchAllArtists: $e');
    }
    return result;
  }

  /// This function is used to get edit playlist api data
  Future<dynamic> editPlaylist(String playlistId, String name, List<String> lst,
      {bool isAdd = false}) async {
    List<Map> dataList = [];

    for (int i = 0; i < lst.length; i++) {
      dataList.insert(i, {'id': lst[i], 'order': isAdd ? 0 : (i + 1)});
    }

    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['editPlaylist']}/$playlistId";
      final Map<String, String> headers = {
        'Authorization': 'Bearer $apiToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      final mapData = {
        'name': name,
        'tracks': dataList,
      };
      if (isAdd) {
        mapData['track_sync'] = "add";
        mapData['byop'] = false;
      }

      final res = await http.post(
        Uri.parse(url),
        body: json.encode(mapData),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;

        return data;
      }
    } catch (e) {
      log('Error in editPlaylist: $e');
    }
  }

  /// This function is used to get playlist song api data
  Future<TracksBybpmResponse?> fetchPlaylistSongData(
    String? vocals,
    String? tempo,
    String? style,
    bool isMyLibrary,
    int pageNo,
  ) async {
    TracksBybpmResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['playlistSongsList']!}/${tempo != null && tempo != '' ? tempo : 'All'}?page=${pageNo}&my_library=$isMyLibrary${vocals != null ? '&filter_vocal=${vocals.trim().replaceAll(" ", "-").toLowerCase()}' : ''}${style != null ? '&filter_style=${style.replaceAll('Electro acoustic', 'acoustic').toLowerCase()}' : ''}');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await TracksBybpmResponse.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in fetchYogiAlbumData: $e');
    }
    return result;
  }

  /// This function is used to get playlist api data
  Future<CustomPlaylistResponse?> fetchPlaylistData() async {
    CustomPlaylistResponse? result;
    try {
      final res = await getResponse(endpoints['playlists']!);
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        result = CustomPlaylistResponse.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      log('Error in fetchPlaylistData: $e');
    }
    return result;
  }

  /// This function is used to get playlist add to library api data
  Future<String?> playlistAddToLibrary(int id, BuildContext context) async {
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['playlistAddToLibrary']}/$id";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        if (data['status'] as bool) {
          ShowSnackBar().showSnackBar(context, 'Playlist added to library');
          return data['data'].toString();
        } else {
          ShowSnackBar().showSnackBar(context, data['data'].toString());
          return null;
        }
      }
    } catch (e) {
      ShowSnackBar().showSnackBar(context, e.toString());
      log('Error in playlistAddToLibrary: $e');
    }
  }

  /// This function is used to get album remove from library api data
  Future<String?> albumRemoveFromLibrary(int id, BuildContext context) async {
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['albumRemoveFromLibrary']}/$id";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        if (data['status'] as bool) {
          ShowSnackBar().showSnackBar(context, 'Album remove from library');
          return data['data'].toString();
        } else {
          ShowSnackBar().showSnackBar(context, data['data'].toString());
          return null;
        }
      }
    } catch (e) {
      ShowSnackBar().showSnackBar(context, e.toString());
      log('Error in albumRemoveFromLibrary: $e');
    }
  }

  /// This function is used to get album add to library api data
  Future<String?> albumAddToLibrary(int id, BuildContext context) async {
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['albumAddToLibrary']}/$id";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        if (data['status'] as bool) {
          ShowSnackBar().showSnackBar(context, 'Album added to library');
          return data['data'].toString();
        } else {
          ShowSnackBar().showSnackBar(context, data['data'].toString());
          return null;
        }
      }
    } catch (e) {
      ShowSnackBar().showSnackBar(context, e.toString());
      log('Error in albumAddToLibrary: $e');
    }
  }

  /// This function is used to get track remove from library api data
  Future<String?> trackRemoveFromLibrary(
      int id, int libraryId, BuildContext context) async {
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url =
          "$baseUrl$apiStr${endpoints['trackRemoveFromLibrary']}/$id/$libraryId";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        if (data['status'] as bool) {
          ShowSnackBar().showSnackBar(context, 'Track removed from library');
          return data['data'].toString();
        } else {
          ShowSnackBar().showSnackBar(context, data['data'].toString());
          return null;
        }
      }
    } catch (e) {
      ShowSnackBar().showSnackBar(context, e.toString());
      log('Error in trackRemoveFromLibrary: $e');
    }
  }

  /// This function is used to get track add to library api data
  Future<String?> trackAddToLibrary(int id, BuildContext context) async {
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['tracksAddToLibrary']}/$id";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        if (data['status'] as bool) {
          ShowSnackBar().showSnackBar(context, 'Track added to library');
          return data['data'].toString();
        } else {
          ShowSnackBar().showSnackBar(context, data['data'].toString());
          return null;
        }
      }
    } catch (e) {
      ShowSnackBar().showSnackBar(context, e.toString());
      log('Error in trackAddToLibrary: $e');
    }
  }

  /// This function is used to get all library album api data
  Future<SeeAllLibraryAlbumsResponse?> seeAllLibraryAlbum() async {
    SeeAllLibraryAlbumsResponse? result;
    try {
      final res = await getResponse(endpoints['seeAllAlbumsLibrary']!);

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SeeAllLibraryAlbumsResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in seeAllLibraryAlbum: $e');
    }
    return result;
  }

  /// This function is used to get all library artist api data
  Future<SearchAllArtistsResponse?> seeAllLibraryArtist() async {
    SearchAllArtistsResponse? result;
    try {
      final res = await getResponse(endpoints['seeAllArtistLibrary']!);

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = SearchAllArtistsResponse?.fromMap(
          data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      log('Error in seeAllLibraryArtist: $e');
    }
    return result;
  }

  /// This function is used to get all library tracks api data
  Future<MyLibraryTrackResponse?> seeAllLibraryTracks(int pageNo) async {
    MyLibraryTrackResponse? result;
    try {
      final res = await getResponse(
          '${endpoints['seeAllTracksLibrary']!}?page=$pageNo');

      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        result = await FormatResponse.formatMyLibraryTrackSong(
          MyLibraryTrackResponse?.fromMap(data as Map<String, dynamic>),
        );
      }
    } catch (e) {
      log('Error in seeAllLibraryArtist: $e');
    }
    return result;
  }

  /// This function is used to call create playlist api
  Future<String?> createPlaylist(String name, BuildContext context) async {
    try {
      final box = await Hive.openBox('api-token');

      final String apiToken = box.get('token').toString();

      final url = "$baseUrl$apiStr${endpoints['createPlaylist']}?name=$name";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        if (data['status'] as bool) {
          return data['data'].toString();
        } else {
          final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(data['data'].toString(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return null;
        }
      }
    } catch (e) {
      log('Error in createPlaylist: $e');
    }
  }

  /// This function is used to call delete playlist api
  Future deletePlylist(String plylistId, BuildContext context) async {
    var result;
    try {
      final res =
          await getResponse('${endpoints['deletePlaylist']!}/$plylistId');
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map<String, dynamic>;
        // result = CustomPlaylistResponse.fromMap(data as Map<String, dynamic>);

        if (data['status'] as bool) {
          ShowSnackBar().showSnackBar(
            context,
            'Playlist deleted Successfully!',
          );
        } else {
          ShowSnackBar().showSnackBar(
            context,
            data['data'].toString(),
          );
        }
      }
    } catch (e) {
      log('Error in deletePlylist: $e');
    }
    // return result;
  }

  /// This function is used to get top searches api data
  Future<List<String>> getTopSearches() async {
    try {
      final res = await getResponse(endpoints['topSearches']!, useProxy: true);
      if (res.statusCode == 200) {
        final List getMain = json.decode(res.body) as List;
        return getMain.map((element) {
          return element['title'].toString();
        }).toList();
      }
    } catch (e) {
      log('Error in getTopSearches: $e');
    }
    return List.empty();
  }

  /// This function is used to get search results api data
  Future<List> fetchSongSearchResults({
    required String searchQuery,
    int count = 20,
    int page = 1,
  }) async {
    final String params =
        "p=$page&q=$searchQuery&n=$count&${endpoints['getResults']}";

    try {
      final res = await getResponse(params, useProxy: true);
      if (res.statusCode == 200) {
        final Map getMain = json.decode(res.body) as Map;
        final List responseList = getMain['results'] as List;
        return await FormatResponse.formatSongsResponse(responseList, 'song');
      }
    } catch (e) {
      log('Error in fetchSongSearchResults: $e');
    }
    return List.empty();
  }

  Future<List<Map>> fetchSearchResults(String searchQuery) async {
    final Map<String, List> result = {};
    final Map<int, String> position = {};
    List searchedAlbumList = [];
    List searchedPlaylistList = [];
    List searchedArtistList = [];
    List searchedTopQueryList = [];
    // List searchedShowList = [];
    // List searchedEpisodeList = [];

    final String params =
        '__call=autocomplete.get&cc=in&includeMetaTags=1&query=$searchQuery';

    final res = await getResponse(params, usev4: false, useProxy: true);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List albumResponseList = getMain['albums']['data'] as List;
      position[getMain['albums']['position'] as int] = 'Albums';

      final List playlistResponseList = getMain['playlists']['data'] as List;
      position[getMain['playlists']['position'] as int] = 'Playlists';

      final List artistResponseList = getMain['artists']['data'] as List;
      position[getMain['artists']['position'] as int] = 'Artists';

      // final List showResponseList = getMain['shows']['data'] as List;
      // position[getMain['shows']['position'] as int] = 'Podcasts';

      // final List episodeResponseList = getMain['episodes']['data'] as List;
      // position[getMain['episodes']['position'] as int] = 'Episodes';

      final List topQuery = getMain['topquery']['data'] as List;

      searchedAlbumList =
          await FormatResponse.formatAlbumResponse(albumResponseList, 'album');
      if (searchedAlbumList.isNotEmpty) {
        result['Albums'] = searchedAlbumList;
      }

      searchedPlaylistList = await FormatResponse.formatAlbumResponse(
        playlistResponseList,
        'playlist',
      );
      if (searchedPlaylistList.isNotEmpty) {
        result['Playlists'] = searchedPlaylistList;
      }

      // searchedShowList =
      //     await FormatResponse().formatAlbumResponse(showResponseList, 'show');
      // if (searchedShowList.isNotEmpty) {
      //   result['Podcasts'] = searchedShowList;
      // }

      // searchedEpisodeList = await FormatResponse()
      //     .formatAlbumResponse(episodeResponseList, 'episode');
      // if (searchedEpisodeList.isNotEmpty) {
      //   result['Episodes'] = searchedEpisodeList;
      // }

      searchedArtistList = await FormatResponse.formatAlbumResponse(
        artistResponseList,
        'artist',
      );
      if (searchedArtistList.isNotEmpty) {
        result['Artists'] = searchedArtistList;
      }

      if (topQuery.isNotEmpty &&
          (topQuery[0]['type'] != 'playlist' ||
              topQuery[0]['type'] == 'artist' ||
              topQuery[0]['type'] == 'album')) {
        position[getMain['topquery']['position'] as int] = 'Top Result';
        position[getMain['songs']['position'] as int] = 'Songs';

        switch (topQuery[0]['type'] as String) {
          case 'artist':
            searchedTopQueryList =
                await FormatResponse.formatAlbumResponse(topQuery, 'artist');
            break;
          case 'album':
            searchedTopQueryList =
                await FormatResponse.formatAlbumResponse(topQuery, 'album');
            break;
          case 'playlist':
            searchedTopQueryList =
                await FormatResponse.formatAlbumResponse(topQuery, 'playlist');
            break;
          default:
            break;
        }
        if (searchedTopQueryList.isNotEmpty) {
          result['Top Result'] = searchedTopQueryList;
        }
      } else {
        if (topQuery.isNotEmpty && topQuery[0]['type'] == 'song') {
          position[getMain['topquery']['position'] as int] = 'Songs';
        } else {
          position[getMain['songs']['position'] as int] = 'Songs';
        }
      }
    }
    return [result, position];
  }

  /// This function is used to get all library album api data
  Future<List<Map>> fetchAlbums({
    required String searchQuery,
    required String type,
    int count = 20,
    int page = 1,
  }) async {
    String? params;
    if (type == 'playlist') {
      params =
          'p=$page&q=$searchQuery&n=$count&${endpoints["playlistResults"]}';
    }
    if (type == 'album') {
      params = 'p=$page&q=$searchQuery&n=$count&${endpoints["albumResults"]}';
    }
    if (type == 'artist') {
      params = 'p=$page&q=$searchQuery&n=$count&${endpoints["artistResults"]}';
    }

    final res = await getResponse(params!);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      List responseList = [];
      if (getMain['results'] != null) {
        responseList = getMain['results'] as List;
      }

      return FormatResponse.formatAlbumResponse(responseList, type);
    }
    return List.empty();
  }

  /// This function is used to get album songs api data
  Future<List> fetchAlbumSongs(String albumId) async {
    final String params = '${endpoints['albumDetails']}&cc=in&albumid=$albumId';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['list'] as List;
      return FormatResponse.formatSongsResponse(responseList, 'album');
    }
    return List.empty();
  }

  /// This function is used to get artist song api data
  Future<Map<String, List>> fetchArtistSongs({
    required String artistToken,
    String category = '',
    String sortOrder = '',
  }) async {
    final Map<String, List> data = {};
    final String params =
        '${endpoints["fromToken"]}&type=artist&p=&n_song=50&n_album=50&sub_type=&category=$category&sort_order=$sortOrder&includeMetaTags=0&token=$artistToken';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body) as Map;
      final List topSongsResponseList = getMain['topSongs'] as List;
      final List latestReleaseResponseList = getMain['latest_release'] as List;
      final List topAlbumsResponseList = getMain['topAlbums'] as List;
      final List singlesResponseList = getMain['singles'] as List;
      final List dedicatedResponseList =
          getMain['dedicated_artist_playlist'] as List;
      final List featuredResponseList =
          getMain['featured_artist_playlist'] as List;
      final List similarArtistsResponseList = getMain['similarArtists'] as List;

      final List topSongsSearchedList =
          await FormatResponse.formatSongsResponse(
        topSongsResponseList,
        'song',
      );
      if (topSongsSearchedList.isNotEmpty) {
        data[getMain['modules']?['topSongs']?['title']?.toString() ??
            'Top Songs'] = topSongsSearchedList;
      }

      final List latestReleaseSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        latestReleaseResponseList,
      );
      if (latestReleaseSearchedList.isNotEmpty) {
        data[getMain['modules']?['latest_release']?['title']?.toString() ??
            'Latest Releases'] = latestReleaseSearchedList;
      }

      final List topAlbumsSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        topAlbumsResponseList,
      );
      if (topAlbumsSearchedList.isNotEmpty) {
        data[getMain['modules']?['topAlbums']?['title']?.toString() ??
            'Top Albums'] = topAlbumsSearchedList;
      }

      final List singlesSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        singlesResponseList,
      );
      if (singlesSearchedList.isNotEmpty) {
        data[getMain['modules']?['singles']?['title']?.toString() ??
            'Singles'] = singlesSearchedList;
      }

      final List dedicatedSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        dedicatedResponseList,
      );
      if (dedicatedSearchedList.isNotEmpty) {
        data[getMain['modules']?['dedicated_artist_playlist']?['title']
                ?.toString() ??
            'Dedicated Playlists'] = dedicatedSearchedList;
      }

      final List featuredSearchedList =
          await FormatResponse.formatArtistTopAlbumsResponse(
        featuredResponseList,
      );
      if (featuredSearchedList.isNotEmpty) {
        data[getMain['modules']?['featured_artist_playlist']?['title']
                ?.toString() ??
            'Featured Playlists'] = featuredSearchedList;
      }

      final List similarArtistsSearchedList =
          await FormatResponse.formatSimilarArtistsResponse(
        similarArtistsResponseList,
      );
      if (similarArtistsSearchedList.isNotEmpty) {
        data[getMain['modules']?['similarArtists']?['title']?.toString() ??
            'Similar Artists'] = similarArtistsSearchedList;
      }
    }
    return data;
  }

  /// This function is used to get all library album api data
  Future<List> fetchPlaylistSongs(String playlistId) async {
    final String params =
        '${endpoints["playlistDetails"]}&cc=in&listid=$playlistId';
    final res = await getResponse(params);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['list'] as List;
      return FormatResponse.formatSongsResponse(responseList, 'playlist');
    }
    return List.empty();
  }

  /// This function is used to get top search result api data
  Future<List> fetchTopSearchResult(String searchQuery) async {
    final String params = 'p=1&q=$searchQuery&n=10&${endpoints["getResults"]}';
    final res = await getResponse(params, useProxy: true);
    if (res.statusCode == 200) {
      final getMain = json.decode(res.body);
      final List responseList = getMain['results'] as List;
      return [
        await FormatResponse.formatSingleSongResponse(responseList[0] as Map)
      ];
    }
    return List.empty();
  }

  /// This function is used to get song details api data
  Future<Map> fetchSongDetails(String songId) async {
    final String params = 'pids=$songId&${endpoints["songDetails"]}';
    try {
      final res = await getResponse(params);
      if (res.statusCode == 200) {
        final Map data = json.decode(res.body) as Map;
        return await FormatResponse.formatSingleSongResponse(
          data['songs'][0] as Map,
        );
      }
    } catch (e) {
      log('Error in fetchSongDetails: $e');
    }
    return {};
  }

  /// Used to delete user account
  Future<bool> deleteAccount(String userId) async {
    final url = '$baseUrl$apiStr${endpoints['removeAccount']}';

    final box = await Hive.openBox('api-token');
    final String apiToken = box.get('token').toString();

    final mapData = {
      'user_id': userId,
    };

    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final res = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(mapData),
    );
    if (res.statusCode == 200) {
      final Map data = json.decode(res.body) as Map<String, dynamic>;
      if (data['status'] as bool) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
