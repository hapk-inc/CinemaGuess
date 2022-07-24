import 'package:auto_route/auto_route.dart';
import 'package:cinema_guess/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic/provider_list.dart';
import 'routes/my_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp app = await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null);

  runApp(
    ProviderScope(
      overrides: [firebaseAppProvider.overrideWithValue(app)],
      child: const MyApp(),
    ),
  );
}

final myRouter = MyRoute();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

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
          return [
            ref.watch(userCheckProvider).when(
                  loading: () => const SplashRoute(),
                  error: (Object e, StackTrace? s) {
                    print(e);
                    print(s);
                    return ErrorRoute(e: e, trace: s!);
                  },
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
