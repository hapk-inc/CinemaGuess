import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../ui/dashboard.dart';
import '../ui/game.dart';
import '../ui/splash.dart';
import '../ui/welcome.dart';

part 'my_route.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: WelcomePage),
    AutoRoute(page: SplashPage),
    AutoRoute(page: ErrorPage),
    AutoRoute(
      page: AppStackPage,
      path: '/',
      children: [
        AutoRoute(path: '', page: DashboardPage),
        AutoRoute(path: 'game', page: GamePage),
        //AutoRoute(path: 'info',page: InfoDialogPage,fullscreenDialog: true)
      ],
    ),
  ],
)
class MyRoute extends _$MyRoute {}
