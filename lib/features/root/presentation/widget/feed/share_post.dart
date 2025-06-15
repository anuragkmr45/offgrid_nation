import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/feed/share_on_chat_modal.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/core/widgets/custom_modal.dart';
// import 'package:offgrid_nation_app/core/utils/debouncer.dart';

class ShareHelper {
  static void showShareOptions(
    BuildContext context, {
    required String content,
    required List<String> mediaUrls,
  }) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder:
            (context) => CupertinoActionSheet(
              title: const Text('Share Post'),
              message: const Text('Choose a share option'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _showShareOnChatModal(context);
                  },
                  child: const Text('Share on Chat'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _shareToAll(content, mediaUrls);
                  },
                  child: const Text('Share via Apps'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _copyToClipboard(content);
                  },
                  child: const Text('Copy Content'),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Share on Chat'),
                  onTap: () {
                    Navigator.pop(context);
                    _showShareOnChatModal(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share via Apps'),
                  onTap: () {
                    Navigator.pop(context);
                    _shareToAll(content, mediaUrls);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Copy Content'),
                  onTap: () {
                    Navigator.pop(context);
                    _copyToClipboard(content);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static void _showShareOnChatModal(BuildContext context) {
    CustomModal.show(
      context: context,
      title: 'Share on Chat',
      content: ShareOnChatModal(),
    );
  }

  static void _shareToAll(String content, List<String> mediaUrls) {
    if (mediaUrls.isNotEmpty) {
      Share.share('$content\n\n${mediaUrls.join("\n")}');
    } else {
      Share.share(content);
    }
  }

  static void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
