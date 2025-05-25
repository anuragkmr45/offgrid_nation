// import 'package:flutter/material.dart';
// import 'package:offgrid_nation_app/core/widgets/media_carousel/media_carousel.dart';

// class ProductImageCarousel extends StatelessWidget {
//   final List<String> mediaUrls;

//   const ProductImageCarousel({super.key, required this.mediaUrls});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openFullScreenViewer(context),
//       child: MediaCarousel(mediaUrls: mediaUrls),
//     );
//   }

//   void _openFullScreenViewer(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => FullScreenImageViewer(mediaUrls: mediaUrls),
//       ),
//     );
//   }
// }

// class FullScreenImageViewer extends StatefulWidget {
//   final List<String> mediaUrls;

//   const FullScreenImageViewer({super.key, required this.mediaUrls});

//   @override
//   State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
// }

// class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
//   late PageController _controller;
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = PageController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: PageView.builder(
//         controller: _controller,
//         itemCount: widget.mediaUrls.length,
//         onPageChanged: (i) => setState(() => _currentPage = i),
//         itemBuilder: (context, index) {
//           return InteractiveViewer(
//             child: Center(
//               child: Image.network(
//                 widget.mediaUrls[index],
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/media_carousel/media_carousel.dart';

class ProductImageCarousel extends StatelessWidget {
  final List<String> mediaUrls;

  const ProductImageCarousel({super.key, required this.mediaUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: PageView.builder(
        itemCount: mediaUrls.length,
        controller: PageController(viewportFraction: 0.95),
        itemBuilder: (context, index) {
          final url = mediaUrls[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageViewer(
                  mediaUrls: mediaUrls,
                  initialIndex: index,
                ),
              ),
            ),
            child: Hero(
              tag: url,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> mediaUrls;
  final int initialIndex;

  const FullScreenImageViewer({super.key, required this.mediaUrls, this.initialIndex = 0});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.mediaUrls.length,
        itemBuilder: (context, index) {
          final url = widget.mediaUrls[index];
          return InteractiveViewer(
            child: Center(
              child: Hero(
                tag: url,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
