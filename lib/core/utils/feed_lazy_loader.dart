import 'package:flutter/material.dart';

typedef OnBottomReached = void Function();

class FeedLazyLoader extends StatefulWidget {
  final ScrollController controller;
  final OnBottomReached onBottomReached;
  final bool Function() canFetchMore;
  final double triggerOffset;

  const FeedLazyLoader({
    Key? key,
    required this.controller,
    required this.onBottomReached,
    required this.canFetchMore,
    this.triggerOffset = 300.0,
  }) : super(key: key);

  @override
  State<FeedLazyLoader> createState() => _FeedLazyLoaderState();
}

class _FeedLazyLoaderState extends State<FeedLazyLoader> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.controller.position.pixels >
            widget.controller.position.maxScrollExtent - widget.triggerOffset &&
        widget.canFetchMore()) {
      widget.onBottomReached();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Invisible widget
  }
}
