import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vista_flicks/firebase/firebase_options.dart';
import 'package:vista_flicks/framework/controller/dynamic_link_controller.dart';
import 'package:vista_flicks/notification_service.dart';
import 'package:vista_flicks/ui/routing/delegate.dart';
import 'package:vista_flicks/ui/routing/parser.dart';
import 'package:vista_flicks/ui/routing/stack.dart';
import 'package:vista_flicks/ui/utils/const/app_constants.dart';
import 'package:vista_flicks/ui/utils/const/global_context_manager.dart';
import 'package:vista_flicks/ui/utils/no_thumb_scroll_indicator.dart';
import 'package:vista_flicks/ui/utils/theme/theme_style.dart';

import 'framework/dependency_injection/inject.dart';
import 'ui/utils/theme/app_colors.dart';

final screenUtilProvider = Provider<ScreenUtil>((ref) {
  throw UnimplementedError(); // Will be overridden in MyApp
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  /// Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(hiveSessionBox);

  /// Initialize Localization
  await EasyLocalization.ensureInitialized();

  await configureMainDependencies(environment: Env.prod);

  /// Set URL Strategy for Web
  setPathUrlStrategy();

  /// Theme For Status Bar & Navigation Bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.white,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  /// Lock Orientation to Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Ensure Screen Size for FlutterScreenUtil
  await ScreenUtil.ensureScreenSize();
  // await FlutterBranchSdk.init(
  //     enableLogging: true, branchAttributionLevel: BranchAttributionLevel.FULL);
  // FlutterBranchSdk.setConsumerProtectionAttributionLevel(
  //     BranchAttributionLevel.FULL);
  FlutterBranchSdk.init().then((_) {
    // Now safe to call
    FlutterBranchSdk.disableTracking(false);
  });
// BEFORE FlutterBranchSdk.init()
  await FlutterBranchSdk.init(); // Then init manually

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const <Locale>[Locale('en')],
        useOnlyLangCode: true,
        path: 'assets/lang',
        child: const MyApp(),
      ),
    ),
  );
}

Future<void> initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      // Optional: Log that Firebase was already initialized
      debugPrint('Firebase already initialized.');
    }
  } catch (e) {
    if (e
        .toString()
        .contains('A Firebase App named "[DEFAULT]" already exists')) {
      debugPrint('Caught duplicate Firebase app init. Skipping re-init.');
    } else {
      rethrow; // Let other errors surface
    }
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Initialize dynamic links
      ref.read(dynamicLinkControllerProvider.notifier).listenDynamicLinks();
    });

    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context, ref);
    notificationServices.setupInteractMessage(context, ref);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        log('device token');
        log(value);
      }
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Background color
        statusBarIconBrightness: Brightness.light, // Android
        statusBarBrightness: Brightness.dark, // iOS
      ),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // Handle any pending navigation when app comes to foreground
  //     ref
  //         .read(dynamicLinkControllerProvider.notifier)
  //         .handlePendingNavigation();
  //     // Check for deep links when app comes to foreground
  //     ref.read(dynamicLinkControllerProvider.notifier).listenDynamicLinks();
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    /// Compact and close Hive properly
    Hive.box(hiveSessionBox).compact().then((_) => Hive.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setGlobalContext(context);

    /// Initialize ScreenUtil with context
    final screenUtil = ScreenUtil();
    ScreenUtil.init(context); // Set the system UI overlay style globally

    return ProviderScope(
      overrides: [
        screenUtilProvider.overrideWithValue(screenUtil),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp.router(
          title: appName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
          // theme: ThemeStyle.themeData(AppColors.isDarkMode, context),
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
            ),
          ),
          darkTheme: ThemeStyle.themeData(AppColors.isDarkMode, context),
          themeMode: ThemeMode.system,
          routerDelegate: getIt<MainRouterDelegate>(
              param1: ref.read(navigationStackController)),
          routeInformationParser:
              getIt<MainRouterInformationParser>(param1: ref, param2: context),
        ),
      ),
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:url_strategy/url_strategy.dart';
// import 'package:vista_flicks/ui/routing/delegate.dart';
// import 'package:vista_flicks/ui/routing/parser.dart';
// import 'package:vista_flicks/ui/routing/stack.dart';
// import 'package:vista_flicks/ui/utils/const/app_constants.dart';
// import 'package:vista_flicks/ui/utils/const/global_context_manager.dart';
// import 'package:vista_flicks/ui/utils/no_thumb_scroll_indicator.dart';
// import 'package:vista_flicks/ui/utils/theme/theme_style.dart';
//
// import 'framework/dependency_injection/inject.dart';
// import 'ui/utils/theme/app_colors.dart';
//
// Future<void> main() async {
//   await Hive.initFlutter();
//   await Hive.openBox(hiveSessionBox);
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await configureMainDependencies(environment: Env.prod);
//   setPathUrlStrategy();
//
//   /// Theme For Status Bar & Navigation Bar
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.dark,
//     statusBarBrightness: Brightness.dark,
//     systemNavigationBarColor: AppColors.black,
//     systemNavigationBarIconBrightness: Brightness.dark,
//   ));
//
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   await ScreenUtil.ensureScreenSize();
//
//   runApp(
//     ProviderScope(
//       child: EasyLocalization(
//         supportedLocales: const <Locale>[
//           Locale('en'),
//         ],
//         useOnlyLangCode: true,
//         path: 'assets/lang',
//         child: const MyApp(),
//       ),
//     ),
//   );
// }
//
// class MyApp extends ConsumerStatefulWidget {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();
//
//   const MyApp({super.key});
//
//   @override
//   ConsumerState<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends ConsumerState<MyApp> {
//   @override
//   void dispose() {
//     Hive.box(hiveSessionBox).compact();
//     Hive.close();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//       globalRef = ref;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     setGlobalContext(context);
//     return MaterialApp.router(
//       title: appName,
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       debugShowCheckedModeBanner: false,
//       scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
//       theme: ThemeStyle.themeData(AppColors.isDarkMode, context),
//       darkTheme: ThemeStyle.themeData(AppColors.isDarkMode, context),
//       themeMode: ThemeMode.system,
//       routerDelegate: getIt<MainRouterDelegate>(
//           param1: ref.read(navigationStackController)),
//       routeInformationParser:
//           getIt<MainRouterInformationParser>(param1: ref, param2: context),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;/Users/ohogar/Desktop/vistaflicks-mobileapp/vista_flicks/lib

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
