import 'package:flutter/material.dart';

class AlignCenter extends StatefulWidget {
  final List<Widget> children;

  const AlignCenter({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  _AlignCenter createState() => _AlignCenter();
}

class _AlignCenter extends State<AlignCenter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
