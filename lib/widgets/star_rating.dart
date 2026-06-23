import 'package:flutter/material.dart';
import '../theme.dart';

/// Exibe uma avaliação em estrelas (suporta meia estrela).
class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 16,
    this.color = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final pos = i + 1;
        IconData icon;
        if (rating >= pos) {
          icon = Icons.star_rounded;
        } else if (rating >= pos - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}

/// Seletor interativo de estrelas (1 a 5) para o modal de avaliação.
class StarSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  const StarSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final pos = i + 1;
        return IconButton(
          onPressed: () => onChanged(pos),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          constraints: const BoxConstraints(),
          icon: Icon(
            pos <= value ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: AppColors.accent,
          ),
        );
      }),
    );
  }
}
