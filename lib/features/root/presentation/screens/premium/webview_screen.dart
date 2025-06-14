// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'payment_success_screen.dart';
// import 'payment_failure_screen.dart';

// class WebViewScreen extends StatefulWidget {
//   final String url;

//   const WebViewScreen({super.key, required this.url});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onPageStarted: (url) {
//                 if (url.contains('/success')) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const PaymentSuccessScreen(),
//                     ),
//                   );
//                 } else if (url.contains('/cancel')) {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const PaymentFailureScreen(),
//                     ),
//                   );
//                 }
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Checkout')),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './payment_failure_screen.dart';
import './payment_success_screen.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('/success')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CheckoutSuccessScreen(),
                ),
              );
              return NavigationDecision.prevent;
            }

            if (url.contains('/cancel')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CheckoutFailureScreen(),
                ),
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Platform.isIOS
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.back),
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        title: const Text('Secure Checkout'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
