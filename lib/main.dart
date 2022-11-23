import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:blackhole/Helpers/config.dart';
import 'package:blackhole/Helpers/handle_native.dart';
import 'package:blackhole/Helpers/route_handler.dart';
import 'package:blackhole/Screens/About/about.dart';
import 'package:blackhole/Screens/Home/home.dart';
import 'package:blackhole/Screens/Library/create_playlist.dart';
import 'package:blackhole/Screens/Library/downloads.dart';
import 'package:blackhole/Screens/Library/nowplaying.dart';
import 'package:blackhole/Screens/Library/playlists.dart';
import 'package:blackhole/Screens/Library/recent.dart';
import 'package:blackhole/Screens/Login/auth.dart';
import 'package:blackhole/Screens/Login/forgot_password_verification.dart';
import 'package:blackhole/Screens/Login/login.dart';
import 'package:blackhole/Screens/Login/pref.dart';
import 'package:blackhole/Screens/Login/reset_password.dart';
import 'package:blackhole/Screens/Login/signup.dart';
import 'package:blackhole/Screens/Player/audioplayer.dart';
import 'package:blackhole/Screens/Settings/setting.dart';
import 'package:blackhole/Screens/Settings/subscription.dart';
import 'package:blackhole/Screens/splash_screen.dart';
import 'package:blackhole/Services/audio_service.dart';
import 'package:blackhole/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Paint.enableDithering = true;

    await Hive.initFlutter();
    await updateVersion();
    await openHiveBox('settings');
    await openHiveBox('downloads');
    await openHiveBox('Favorite Songs');
    await openHiveBox('cache', limit: true);
    if (Platform.isAndroid) {
      setOptimalDisplayMode();
    }
    await startService();
    // initialize the Intercom.
    await Intercom.instance.initialize('ebyep3ia',
        iosApiKey: 'ios_sdk-738cc4fe35c05c02d8327071864ab4cbc0d93304',
        androidApiKey: 'android_sdk-8e4b65d2a33865bb973ae7d40dc868bdf4528258');

    await Firebase.initializeApp();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> updateVersion() async {
  final prefs = await SharedPreferences.getInstance();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;
  debugPrint('Version : $version($buildNumber)');
  final String versionName = '$version($buildNumber)';
  final String lastVersion = prefs.getString('last_version').toString();
  if(versionName != lastVersion){
    debugPrint('Version : $versionName');
    await Hive.deleteFromDisk();
    await prefs.setString('last_version', versionName);
  }
}

Future<void> setOptimalDisplayMode() async {
  final List<DisplayMode> supported = await FlutterDisplayMode.supported;
  final DisplayMode active = await FlutterDisplayMode.active;

  final List<DisplayMode> sameResolution = supported
      .where(
        (DisplayMode m) => m.width == active.width && m.height == active.height,
      )
      .toList()
    ..sort(
      (DisplayMode a, DisplayMode b) => b.refreshRate.compareTo(a.refreshRate),
    );
  final DisplayMode mostOptimalMode =
      sameResolution.isNotEmpty ? sameResolution.first : active;
  await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
}

Future<void> startService() async {
  final AudioPlayerHandler audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.app.yogitunes.channel.audio',
      androidNotificationChannelName: 'Yogitunes',
      androidNotificationOngoing: true,
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidShowNotificationBadge: true,
      // androidStopForegroundOnPause: Hive.box('settings')
      // .get('stopServiceOnPause', defaultValue: true) as bool,
      notificationColor: Colors.grey[900],
    ),
  );
  GetIt.I.registerSingleton<AudioPlayerHandler>(audioHandler);
  GetIt.I.registerSingleton<MyTheme>(MyTheme());
}

late Box<String?> apiTokenBox;

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  apiTokenBox = await Hive.openBox('api-token');
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    final File dbFile = File('$dirPath/$boxName.hive');
    final File lockFile = File('$dirPath/$boxName.lock');
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');

  @override
  void initState() {
    super.initState();
    callIntent();
    final String lang =
        Hive.box('settings').get('lang', defaultValue: 'English') as String;
    final Map<String, String> codes = {
      'English': 'en',
      'Russian': 'ru',
      'Portuguese': 'pt',
      'Indonesia': 'id',
      'French': 'fr',
    };
    _locale = Locale(codes[lang]!);

    AppTheme.currentTheme.addListener(() {
      setState(() {});
    });
  }

  Future<void> callIntent() async {
    await NativeMethod.handleIntent();
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black38,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // debugInvertOversizedImages = true;

    return MaterialApp(
      title: 'Yogitunes',
      restorationScopeId: 'Yogitunes',
      debugShowCheckedModeBanner: false,
      themeMode: AppTheme.themeMode,
      theme: AppTheme.lightTheme(
        context: context,
      ),
      darkTheme: AppTheme.darkTheme(
        context: context,
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ru', ''), // Russian
        Locale('pt', ''), // Portuguese, no country code
        Locale('id', ''), // Indonesia, no country code
        Locale('fr', ''), // French
      ],
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => const AuthScreen(),
        '/loginmain': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        // '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/forgotPasswordVerification': (context) =>
            const ForgotPasswordVerificationScreen(),
        '/resetPassword': (context) => const ResetPasswordScreen(),
        '/home': (context) => HomePage(),
        '/subscription': (context) => SubscriptionScreen(),
        '/pref': (context) => const PrefScreen(),
        '/setting': (context) => const SettingPage(),
        '/about': (context) => AboutScreen(),
        '/playlists': (context) => PlaylistScreen(),
        '/createPlaylist': (context) => CreatePlaylist(),
        '/nowplaying': (context) => NowPlaying(),
        '/recent': (context) => RecentlyPlayed(),
        '/downloads': (context) => const Downloads(),
        '/subscribe': (context) => const SubscriptionScreen(),
        // '/featured':
      },
      onGenerateRoute: (RouteSettings settings) {
        return HandleRoute().handleRoute(settings.name);
      },
    );
  }
}
