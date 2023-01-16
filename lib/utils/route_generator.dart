import 'package:estacionei/screens/history_screen.dart';
import 'package:estacionei/screens/home_screen.dart';
import 'package:estacionei/screens/not_found_screen.dart';
import 'package:estacionei/utils/route_name.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route? generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case '/':
        return FadeRoute(name: settings.name!, page: const HomeScreen());

      case RouteName.ROUTE_HISTORY:
        return FadeRoute(name: settings.name!, page: const HistoryScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const NotFoundScreen();
        });
    }
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  final String name;

  FadeRoute({required this.page, required this.name})
      : super(
    settings: RouteSettings(name: name),
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          alwaysIncludeSemantics: true,
          child: child,
        ),
  );
}
