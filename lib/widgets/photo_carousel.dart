import 'package:flutter/material.dart';
import '../theme.dart';
import 'app_network_image.dart';

/// Carrossel de fotos (PageView) com indicadores de página (dots).
class PhotoCarousel extends StatefulWidget {
  final List<String> imagens;
  final double height;
  final BorderRadius? borderRadius;

  const PhotoCarousel({
    super.key,
    required this.imagens,
    required this.height,
    this.borderRadius,
  });

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final _controller = PageController();
  int _atual = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.imagens.length,
            onPageChanged: (i) => setState(() => _atual = i),
            itemBuilder: (context, i) => AppNetworkImage(
              url: widget.imagens[i],
              fit: BoxFit.cover,
            ),
          ),
          if (widget.imagens.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imagens.length, (i) {
                  final ativo = i == _atual;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: ativo ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: ativo
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: content);
    }
    return content;
  }
}
