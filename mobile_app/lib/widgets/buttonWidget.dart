import 'package:flutter/material.dart';
import 'package:mobile_app/globals.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;

  ButtonWidget({
    this.title,
    this.hasBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: hasBorder ? Global.white : Global.greenDark,
          borderRadius: BorderRadius.circular(10),
          border: hasBorder
              ? Border.all(
                  color: Global.greenDark,
                  width: 1.0,
                )
              : Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60.0,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: hasBorder ? Global.greenDark : Global.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

