import 'package:flutter/material.dart' hide BackButton;
import 'package:test_project/components/buttons/raw-button.dart';

class BackButton extends StatefulWidget {
  final EdgeInsets? padding;
  final bool? expanded;
  final Alignment? alignment;
  final Widget? child;

  const BackButton({
    Key? key,
    this.padding,
    this.expanded = true,
    this.alignment = null,
    this.child,
  }) : super(key: key);

  @override
  _BackButton createState() => _BackButton();
}

class _BackButton extends State<BackButton> {
  @override
  Widget build(BuildContext context) {
    return RawButton(
      padding: widget.padding,
      width: widget.expanded! ? double.infinity : null,
      alignment: widget.expanded! ? Alignment.centerLeft : widget.alignment,
      onPressed: () => Navigator.pop(context),
      child: widget.child != null
          ? widget.child!
          : Icon(
              Icons.arrow_back,
              color: Colors.black54,
              size: 30,
            ),
    );
  }
}
