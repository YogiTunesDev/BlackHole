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
import 'package:blackhole/Services/download_service.dart';
import 'package:blackhole/Services/ext_storage_provider.dart';
import 'package:blackhole/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    // Deprecated: https://api.flutter.dev/flutter/dart-ui/Paint/enableDithering.html
    // Paint.enableDithering = true;

    final appSupportDir = await getApplicationSupportDirectory();
    final hivePath = Directory('${appSupportDir.path}/hive');

    if (!hivePath.existsSync()) {
      hivePath.createSync(recursive: true);
    }

    Hive.init(hivePath.path);

    // await Hive.initFlutter();

    await updateVersion();

    await openHiveBox('settings');

    await openHiveBox('downloads');

    await openHiveBox('Favorite Songs');

    await openHiveBox('cache', limit: true);

    await updatePathsInHive();

    DownloadService();

    if (Platform.isAndroid) {
      setOptimalDisplayMode();
    }

    await startService();

    // initialize the Intercom.
    // await Intercom.instance.initialize(
    //   'webp3ia',
    //   iosApiKey: 'ios_sdk-738cc4fe35c05c02d8327071864ab4cbc0d93304',
    //   androidApiKey: 'android_sdk-8e4b65d2a33865bb973ae7d40dc868bdf4528258',
    // );
    const fatalError = false;

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Non-async exceptions
    FlutterError.onError = (errorDetails) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    };

    // Async exceptions
    PlatformDispatcher.instance.onError = (error, stack) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      return true;
    };

    FirebaseCrashlytics.instance.setUserIdentifier('0');

    // Initialize Sentry SDK
    await SentryFlutter.init((options) {
      options.dsn =
          'https://aff50c0a1ec48db5dc356ea09ce1fddd@o4507455731269632.ingest.us.sentry.io/4507455736315904';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    });

    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);

    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

Future<void> updatePathsInHive() async {
  final currentSandboxPath =
      await ExtStorageProvider.getExtStorage(dirName: "downloads", writeAccess: false) ??
          '';

  final box = Hive.box('downloads');
  final keys = box.keys.toList();

  for (var key in keys) {
    final data = box.get(key) as Map<dynamic, dynamic>;

    if (data.containsKey('path') && data.containsKey('image')) {
      data['path'] = _replacePath(data['path'].toString(), currentSandboxPath);

      data['image'] = _replacePath(data['image'].toString(), currentSandboxPath);

      await box.put(key, data);
    }
  }
}

String _getFilename(String filePath) {
  return path.basename(filePath);
}

String _replacePath(String oldPath, String currentSandboxPath) {
  final filePath = _getFilename(oldPath);
  return path.join(currentSandboxPath, '', filePath);
}

Future<void> updateVersion() async {
  final prefs = await SharedPreferences.getInstance();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  final String versionName = '$version($buildNumber)';
  final String lastVersion = prefs.getString('last_version').toString();

  // print('Current Installed Version : $lastVersion');
  // print('Latest Upgrade Version : $versionName');

  if (versionName != lastVersion) {
    // await Hive.deleteFromDisk();
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

    final boxName = Hive.box("settings");

    // print('Settings Box: ${boxName.toMap()}');

    final boxNameDl = Hive.box("downloads");

    // print('Downloads Box: ${boxNameDl.toMap()}');

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
