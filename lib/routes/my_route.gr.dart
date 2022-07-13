// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'my_route.dart';

class _$MyRoute extends RootStackRouter {
  _$MyRoute([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    WelcomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const WelcomePage());
    },
    SplashRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SplashPage());
    },
    AppStackRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const AppStackPage());
    },
    DashboardRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DashboardPage());
    },
    GameRoute.name: (routeData) {
      final args = routeData.argsAs<GameRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData, child: GamePage(args.movie, key: args.key));
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(WelcomeRoute.name, path: '/welcome-page'),
        RouteConfig(SplashRoute.name, path: '/splash-page'),
        RouteConfig(AppStackRoute.name, path: '/', children: [
          RouteConfig(DashboardRoute.name,
              path: '', parent: AppStackRoute.name),
          RouteConfig(GameRoute.name, path: 'game', parent: AppStackRoute.name)
        ])
      ];
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute() : super(WelcomeRoute.name, path: '/welcome-page');

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/splash-page');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [AppStackPage]
class AppStackRoute extends PageRouteInfo<void> {
  const AppStackRoute({List<PageRouteInfo>? children})
      : super(AppStackRoute.name, path: '/', initialChildren: children);

  static const String name = 'AppStackRoute';
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: '');

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [GamePage]
class GameRoute extends PageRouteInfo<GameRouteArgs> {
  GameRoute({required Movie movie, Key? key})
      : super(GameRoute.name,
            path: 'game', args: GameRouteArgs(movie: movie, key: key));

  static const String name = 'GameRoute';
}

class GameRouteArgs {
  const GameRouteArgs({required this.movie, this.key});

  final Movie movie;

  final Key? key;

  @override
  String toString() {
    return 'GameRouteArgs{movie: $movie, key: $key}';
  }
}
