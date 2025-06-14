import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/media_carousel/media_carousel.dart';

class ProductImageCarousel extends StatelessWidget {
  final List<String> mediaUrls;

  const ProductImageCarousel({super.key, required this.mediaUrls});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullScreenViewer(context),
      child: MediaCarousel(mediaUrls: mediaUrls),
    );
  }

  void _openFullScreenViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(mediaUrls: mediaUrls),
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> mediaUrls;

  const FullScreenImageViewer({super.key, required this.mediaUrls});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.mediaUrls.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.mediaUrls[index],
                fit: BoxFit.contain,
                placeholder:
                    (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                errorWidget:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 60),
              ),
            ),
          );
        },
      ),
    );
  }
}
