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
    ErrorRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ErrorPage(key: args.key, e: args.e, trace: args.trace));
    },
    AppStackRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const AppStackPage());
    },
    DashboardRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DashboardPage());
    },
    ProfileRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ProfilePage());
    },
    GameRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const GamePage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(WelcomeRoute.name, path: '/welcome-page'),
        RouteConfig(SplashRoute.name, path: '/splash-page'),
        RouteConfig(ErrorRoute.name, path: '/error-page'),
        RouteConfig(AppStackRoute.name, path: '/', children: [
          RouteConfig(DashboardRoute.name,
              path: '', parent: AppStackRoute.name),
          RouteConfig(ProfileRoute.name,
              path: 'profile', parent: AppStackRoute.name),
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
/// [ErrorPage]
class ErrorRoute extends PageRouteInfo<ErrorRouteArgs> {
  ErrorRoute({Key? key, required Object e, required StackTrace trace})
      : super(ErrorRoute.name,
            path: '/error-page',
            args: ErrorRouteArgs(key: key, e: e, trace: trace));

  static const String name = 'ErrorRoute';
}

class ErrorRouteArgs {
  const ErrorRouteArgs({this.key, required this.e, required this.trace});

  final Key? key;

  final Object e;

  final StackTrace trace;

  @override
  String toString() {
    return 'ErrorRouteArgs{key: $key, e: $e, trace: $trace}';
  }
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
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile');

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [GamePage]
class GameRoute extends PageRouteInfo<void> {
  const GameRoute() : super(GameRoute.name, path: 'game');

  static const String name = 'GameRoute';
}
