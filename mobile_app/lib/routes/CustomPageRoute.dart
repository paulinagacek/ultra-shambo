import 'package:flutter/material.dart';
import 'package:mobile_app/homeModel.dart';
import 'package:provider/provider.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
// https://api.flutter.dev/flutter/widgets/SlideTransition-class.html
  CustomPageRoute({this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 100),
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
        position: Tween<Offset>(
                begin: Offset(-1, 0), // start on left
                end: Offset(0, 0))
            .animate(animation),
        child: child);
  }
}
