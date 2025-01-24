import 'package:flutter/material.dart';

void popDialog(BuildContext context, {dynamic arg}) {
  Navigator.of(context, rootNavigator: true).pop(arg);
}

void popScreen(BuildContext context, {dynamic arg}) {
  Navigator.of(context).pop(arg);
}

void pushScreen(BuildContext context, String routeName, {dynamic arg}) {
  Navigator.pushNamed(context, routeName, arguments: arg);
}

void pushReplacementScreen(BuildContext context, String routeName,
    {dynamic arg}) {
  Navigator.pushReplacementNamed(context, routeName, arguments: arg);
}

PageRouteBuilder customRoute(StatefulWidget screen) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginEnter = Offset(1, 0);
      const beginExit = Offset(-1, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var enterTween =
          Tween(begin: beginEnter, end: end).chain(CurveTween(curve: curve));
      var exitTween =
          Tween(begin: end, end: beginExit).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(enterTween),
        child: SlideTransition(
          position: secondaryAnimation.drive(exitTween),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return screen;
    },
  );
}
