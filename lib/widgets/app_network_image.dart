import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme.dart';

/// Imagem de rede com cache, shimmer enquanto carrega e fallback de erro.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, _) => _shimmer(),
      errorWidget: (context, _, _) => Container(
        width: width,
        height: height,
        color: AppColors.primary.withValues(alpha: 0.08),
        child: const Icon(
          Icons.landscape_outlined,
          color: AppColors.muted,
          size: 40,
        ),
      ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E2),
      highlightColor: const Color(0xFFF5F5F0),
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
