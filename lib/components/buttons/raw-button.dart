import 'package:test_project/components/system/alert.dart';
import 'package:test_project/core/globals.dart';
import 'package:flutter/material.dart';

class RawButton extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Widget Function()? page;
  final Function()? onPageBack;
  final Function()? onPressed;
  final Function()? onTry;

  final bool? active;
  final bool? dev;
  final bool? glowing;
  final bool? shadow;

  final Alignment? alignment;
  final Color? color;
  final ShapeBorder? shape;

  final Widget child;

  const RawButton({
    Key? key,
    this.alignment,
    this.width,
    this.height,
    this.padding,
    this.page,
    this.onPageBack,
    this.onPressed,
    this.onTry,
    this.active = true,
    this.dev = false,
    this.glowing = true,
    this.color,
    this.shape = const StadiumBorder(),
    this.shadow = false,
    required this.child,
  }) : super(key: key);

  @override
  _RawButton createState() => _RawButton();
}

class _RawButton extends State<RawButton> {
  static void indev() {
    Alert.alert_(
      title: 'Information',
      text: 'This feature is not available as it is under development.',
      acceptLabel: 'Ok',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: widget.active! && !widget.dev! ? 1.0 : 0.3,
        child: RawMaterialButton(
          splashColor: widget.glowing == true ? null : Colors.transparent,
          highlightColor: widget.glowing == true ? null : Colors.transparent,
          onPressed: () {
            if (widget.onTry != null) widget.onTry!();
            if (widget.dev!) return indev();
            if (!widget.active!) return;
            if (widget.onPressed != null) return widget.onPressed!();
            if (widget.page == null) return;
            pushPage(context, widget.page!()).then((_) {
              if (widget.onPageBack != null) widget.onPageBack!();
            });
          },
          shape: widget.shape == null ? const StadiumBorder() : widget.shape!,
          fillColor: widget.color,
          child: Container(
            alignment: widget.alignment ?? null,
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            child: widget.child,
          ),
          elevation: widget.shadow! ? 4 : 0,
          highlightElevation: widget.shadow! ? 4 : 0,
          focusElevation: widget.shadow! ? 4 : 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          constraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ));
  }
}
