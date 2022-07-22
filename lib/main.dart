import 'package:auto_route/auto_route.dart';
import 'package:cinema_guess/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'logic/provider_list.dart';
import 'routes/my_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final info = await PackageInfo.fromPlatform();

  //print(info.appName);

  final FirebaseApp app = await Firebase.initializeApp(
      options: info.appName.contains("Dev")
          ? DefaultFirebaseOptions.currentPlatform
          : null);
  // await FirebaseAppCheck.instance.activate();
  runApp(
    ProviderScope(
      overrides: [
        firebaseAppProvider.overrideWithValue(app),
      ],
      child: const MyApp(),
    ),
  );
}

final myRouter = MyRoute();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  //static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  //static FirebaseAnalyticsObserver observer =
  //    FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        tabBarTheme: TabBarTheme(
            labelStyle: GoogleFonts.poppins(),
            labelColor: Colors.blue.shade900,
            unselectedLabelStyle: GoogleFonts.poppins(color: Colors.grey),
            unselectedLabelColor: Colors.grey),
      ),
      routeInformationParser: myRouter.defaultRouteParser(),
      routerDelegate: AutoRouterDelegate.declarative(
        myRouter,
        routes: (handler) {
          print(handler.initialPendingRoutes);
          return [
            ref.watch(userCheckProvider).maybeWhen(
                  orElse: () => const SplashRoute(),
                  error: (_, __) => const SplashRoute(),
                  data: (check) =>
                      !check ? const WelcomeRoute() : const AppStackRoute(),
                )
          ];
        },
        // navigatorObservers: () => <NavigatorObserver>[observer],
      ),
    );
  }
}

class AppStackPage extends StatelessWidget {
  const AppStackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const EmptyRouterScreen();
}
