import 'package:test_project/components/layout/align-center.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  final String? title;
  final Color? color;

  const Loader(
    this.title, {
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  _Loader createState() => _Loader();
}

class _Loader extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return AlignCenter(
      children: [
        CircularProgressIndicator(
          color: widget.color == null ? Colors.black : widget.color,
          strokeWidth: 5,
        ),
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(widget.title!),
          ),
      ],
    );
  }
}
