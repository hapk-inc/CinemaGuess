import 'package:auto_route/auto_route.dart';
import 'package:cinema_guess/firebase_options.dart';
//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic/provider_list.dart';
import 'routes/my_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        theme: ThemeData(
          tabBarTheme: TabBarTheme(
            labelStyle: GoogleFonts.poppins(),
            unselectedLabelStyle: GoogleFonts.poppins(),
          ),
        ),
        routeInformationParser: myRouter.defaultRouteParser(),
        routerDelegate: AutoRouterDelegate.declarative(
          myRouter,
          routes: (handler) => [
            ref.watch(userCheckProvider).maybeWhen(
                  orElse: () => const SplashRoute(),
                  error: (e, s) {
                    print(e);
                    print(s);
                    return const SplashRoute();
                  },
                  data: (check) =>
                      !check ? const WelcomeRoute() : const AppStackRoute(),
                )
          ],
        ),
        //home: const WelcomePage(),
      );
}

class AppStackPage extends StatelessWidget {
  const AppStackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const EmptyRouterScreen();
}
