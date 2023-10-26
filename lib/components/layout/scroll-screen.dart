import 'package:flutter/material.dart';
import 'package:test_project/components/layout/loader.dart';
import 'package:flutter/services.dart';

class ScrollScreen extends StatefulWidget {
  final List<Widget> children;
  final bool? center;
  final bool? ready;
  final EdgeInsets? padding;
  final bool? safeTop;
  final bool? safeLeft;
  final bool? safeRight;
  final bool? safeBottom;
  final bool? useScaffold;
  final bool? useGesture;
  final bool? useList;
  final bool? scrollable;
  final bool? avoidResize;
  final void Function()? onTap;

  const ScrollScreen({
    Key? key,
    this.ready,
    this.center,
    this.padding = const EdgeInsets.only(
      left: 30,
      top: 20,
      right: 30,
      bottom: 0,
    ),
    this.safeTop = true,
    this.safeLeft = true,
    this.safeRight = true,
    this.safeBottom = true,
    this.useScaffold = true,
    this.useGesture = false,
    this.useList = false,
    this.scrollable = true,
    this.avoidResize = false,
    this.onTap,
    required this.children,
  }) : super(key: key);

  @override
  _ScrollScreen createState() => _ScrollScreen();
}

class _ScrollScreen extends State<ScrollScreen> {
  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox.shrink();

    if (widget.ready == false) {
      body = const Loader(null);
    } else if (widget.scrollable == false) {
      body = Column(
        crossAxisAlignment: widget.center == true
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: widget.children,
      );
    } else if (widget.useList == true) {
      body = ListView(
        physics: const BouncingScrollPhysics(),
        children: widget.children,
      );
    } else {
      body = CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: widget.center == true
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ],
      );
    }

    body = SafeArea(
      top: widget.safeTop!,
      left: widget.safeLeft!,
      right: widget.safeRight!,
      bottom: widget.safeBottom!,
      child: body,
    );

    body = Container(
      padding: widget.padding,
      child: body,
    );

    final onTap = () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusManager.instance.primaryFocus?.unfocus();
      if (widget.onTap != null) widget.onTap!();
    };
    body = widget.useGesture == true
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: body,
          )
        : Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => onTap(),
            child: body,
          );

    if (widget.useScaffold == true)
      body = Scaffold(
        resizeToAvoidBottomInset: !widget.avoidResize!,
        body: body,
      );

    return body;
  }
}
