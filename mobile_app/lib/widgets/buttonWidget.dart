import 'package:flutter/material.dart';
import 'package:mobile_app/globals.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final Function onPressed;
  final bool visible;

  ButtonWidget({this.title, this.hasBorder, this.onPressed, this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible==null ? true : visible,
        child: SizedBox(
            width: double.infinity, // <-- match_parent
            height: 50,
            child: OutlinedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                overlayColor: hasBorder
                    ? const MaterialStatePropertyAll<Color>(
                        Global.greenDarkTranparent)
                    : const MaterialStatePropertyAll<Color>(
                        Global.whiteTransparent),
                backgroundColor: hasBorder
                    ? const MaterialStatePropertyAll<Color>(Global.white)
                    : const MaterialStatePropertyAll<Color>(Global.greenDark),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: hasBorder ? Global.greenDark : Global.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            )));
  }
}
