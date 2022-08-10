import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../firebase_options.dart';
import 'logic/provider_list.dart';
import 'routes/my_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp app = await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);

  final FirebaseAnalytics analytics = FirebaseAnalytics.instanceFor(app: app);

  if (kIsWeb) {
    final User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        firebaseAppProvider.overrideWithValue(app),
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
        analyticsProvider.overrideWithValue(analytics)
      ],
      child: const MyApp(),
    ),
  );
}

final myRouter = MyRoute();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
/*
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);*/

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        //textTheme: GoogleFonts.poppinsTextTheme(),
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
          return [
            ref.watch(userCheckProvider).when(
                  loading: () => const SplashRoute(),
                  error: (Object e, StackTrace? s) {
                    print(s);
                    return ErrorRoute(e: e, trace: s!);
                  },
                  data: (check) =>
                      !check ? const WelcomeRoute() : const AppStackRoute(),
                )
          ];
        },
      ),
    );
  }
}

class AppStackPage extends StatelessWidget {
  const AppStackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const EmptyRouterScreen();
}
