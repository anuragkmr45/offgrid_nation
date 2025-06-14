// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_content_card.dart';

// const bool showSimpleText = false;

// class PremiumScreen extends StatelessWidget {
//   const PremiumScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: showSimpleText
//           ? const Center(
//               child: Text(
//                 'This is Simple Text',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             )
//           : Stack(
//               children: [
//                 BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(color: Colors.black.withOpacity(0.3)),
//                 ),
//                 const Center(child: PremiumContentCard()),
//               ],
//             ),
//     );
//   }
// }


import 'dart:ui';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/premium/webview_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_content_card.dart';
import 'package:offgrid_nation_app/injection_container.dart';

const bool showSimpleText = false;

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PremiumBloc>(),
      child: BlocConsumer<PremiumBloc, PremiumState>(
        listener: (context, state) {
          if (state is CreateCheckoutSessionFailure) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                context: context,
                builder: (_) => CupertinoAlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          } else if (state is CreateCheckoutSessionSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WebViewScreen(url: state.checkoutUrl),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: showSimpleText
                ? const Center(
                    child: Text(
                      'This is Simple Text',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(color: Colors.black.withOpacity(0.3)),
                      ),
                      Center(
                        child: PremiumContentCard(
                          onPayTap: () {
                            context.read<PremiumBloc>().add(CreateCheckoutSessionRequested());
                          },
                          isLoading: state is CreateCheckoutSessionLoading,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
