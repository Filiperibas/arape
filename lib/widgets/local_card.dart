import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import 'badges.dart';
import 'photo_carousel.dart';
import 'star_rating.dart';

/// Card grande do catálogo: carrossel de fotos + infos do local.
class LocalCard extends StatelessWidget {
  final Local local;
  final VoidCallback onTap;

  const LocalCard({super.key, required this.local, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PhotoCarousel(imagens: local.imagens, height: 190),
                if (local.verificado)
                  const Positioned(top: 12, left: 12, child: VerifiedBadge()),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.near_me_rounded,
                            size: 13, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(
                          local.distancia,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryBadge(
                        icone: local.icone,
                        label: local.categoriaLabel,
                        compact: true,
                      ),
                      const Spacer(),
                      StarRating(rating: local.avaliacaoMedia, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        local.avaliacaoMedia.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    local.nome,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    local.descricaoCurta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
