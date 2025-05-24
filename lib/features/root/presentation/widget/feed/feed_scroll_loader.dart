// lib/core/utils/feed_scroll_loader.dart
import 'package:flutter/widgets.dart';
import 'package:offgrid_nation_app/core/utils/debouncer.dart';

class FeedScrollLoader {
  static final _debouncer = Debouncer(milliseconds: 300); // ✅ Added Debouncer

  static void attachScrollListener({
    required ScrollController controller,
    required VoidCallback onBottomReached,
    required bool Function() canFetchMore,
  }) {
    controller.addListener(() {
      if (controller.position.pixels >=
              controller.position.maxScrollExtent - 300 &&
          canFetchMore()) {
        _debouncer.run(() {
          onBottomReached(); // ✅ Debounced call
        });
      }
    });
  }
}
