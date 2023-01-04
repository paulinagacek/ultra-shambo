import 'package:flutter/material.dart';
import 'package:mobile_app/loginModel.dart';
import 'package:provider/provider.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
// https://api.flutter.dev/flutter/widgets/SlideTransition-class.html
  CustomPageRoute({this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 1000),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(0.5, 1.0),
        ),
      ),
      child: child,
    );
  }
}
