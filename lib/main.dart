import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:masterstudy_app/core/constants/preferences_name.dart';
import 'package:masterstudy_app/core/env.dart';
import 'package:masterstudy_app/core/routes/app_routes.dart';
import 'package:masterstudy_app/core/services/local_notifications_service.dart';
import 'package:masterstudy_app/core/services/localization_service.dart';
import 'package:masterstudy_app/firebase_options.dart';
import 'package:masterstudy_app/presentation/bloc/course/course_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/courses/user_courses_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/home/home_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/home_simple/home_simple_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/languages/languages_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:masterstudy_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/presentation/screens/auth/components/google_signin.dart';
import 'package:masterstudy_app/presentation/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/theme/app_theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

LocalNotificationService localNotificationService = LocalNotificationService();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await localNotificationService.initialize();

  localNotificationService.showNotification(message);
  if (kDebugMode) {
    print('Handling a background message ${message.notification!.title}');
  }
}

bool dripContentEnabled = false;
bool? demoEnabled = false;
bool? googleOauth = false;
bool? facebookOauth = false;
bool appView = false;

/// This variable use when we want to publish app to AppStore
/// Because AppStore dont like apps, where app don't have IAP
/// That's why we use this variables from API, when [isFree] == true
/// All courses are free
bool isFree = false;

class DownloadClass {
  static void callback(String id, int status, int progress) {
    log('Download status: $status');
    log('Download progress: $progress');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true, // option: set to false to disable working with http links (default: false)
  );

  FlutterDownloader.registerCallback(DownloadClass.callback);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.grey.withOpacity(0.4),
      statusBarIconBrightness: Brightness.light,
    ),
  );

  preferences = await SharedPreferences.getInstance();

  // Function for detect user have selected lang or not
  if (preferences.getString(PreferencesName.selectedLangAbbr) == null ||
      preferences.getString(PreferencesName.selectedLangAbbr) == '') {
    preferences.remove(PreferencesName.selectedLangAbbr);
  } else {
    preferences.setString(PreferencesName.selectedLangAbbr, preferences.getString(PreferencesName.selectedLangAbbr)!);
  }

  GoogleSignInProvider().initializeGoogleSignIn();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  localNotificationService.initialize();

  // String? fcmToken = await FirebaseMessaging.instance.getToken();

  if (kDebugMode) {
    // print('FCM TOKEN: ${fcmToken}');
  }

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  appView = preferences.getBool(PreferencesName.appView) ?? false;

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      path: 'assets/localization/',
      assetLoader: LocalizationService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp() : super();

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => HomeBloc()..add(LoadHomeEvent()),
          ),
          BlocProvider<HomeSimpleBloc>(
            create: (BuildContext context) => HomeSimpleBloc()..add(LoadHomeSimpleEvent()),
          ),
          BlocProvider<FavoritesBloc>(
            create: (BuildContext context) => FavoritesBloc(),
          ),
          BlocProvider<UserCoursesBloc>(
            create: (BuildContext context) => UserCoursesBloc(),
          ),
          BlocProvider<EditProfileBloc>(
            create: (BuildContext context) => EditProfileBloc(),
          ),
          BlocProvider(
            create: (BuildContext context) => ProfileBloc(),
          ),
          BlocProvider<CourseBloc>(
            create: (BuildContext context) => CourseBloc(),
          ),
          BlocProvider<LanguagesBloc>(
            create: (BuildContext context) => LanguagesBloc()..add(LoadLanguagesEvent()),
          ),
        ],
        child: OverlaySupport(
          child: MaterialApp(
            title: 'Masterstudy',
            theme: AppTheme().themeLight,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            initialRoute: SplashScreen.routeName,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            onGenerateRoute: (RouteSettings settings) => AppRoutes().generateRoute(settings, context),
            onUnknownRoute: (RouteSettings settings) => AppRoutes().onUnknownRoute(settings, context),
          ),
        ),
      ),
    );
  }
}
