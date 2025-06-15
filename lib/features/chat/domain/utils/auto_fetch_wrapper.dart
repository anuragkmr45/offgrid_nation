import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';

class AutoFetchWrapper extends StatefulWidget {
  final Widget child;
  const AutoFetchWrapper({super.key, required this.child});

  @override
  State<AutoFetchWrapper> createState() => _AutoFetchWrapperState();
}

class _AutoFetchWrapperState extends State<AutoFetchWrapper> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const GetConversationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
