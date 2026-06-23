import 'package:flutter/material.dart';
import '../theme.dart';
import 'app_network_image.dart';
import 'icon_mapper.dart';

/// Pin de local no mapa com a **foto de capa** do local + badge de categoria.
/// Foto circular com borda branca; pequeno selo no canto com o ícone da
/// categoria (água, trilha, agroindústria, etc.). Cresce e troca a borda para
/// amarelo quando selecionado.
class PhotoPin extends StatelessWidget {
  final String imageUrl;
  final String icone;
  final bool selecionado;

  const PhotoPin({
    super.key,
    required this.imageUrl,
    required this.icone,
    this.selecionado = false,
  });

  @override
  Widget build(BuildContext context) {
    final photoSize = selecionado ? 52.0 : 44.0;
    const badgeSize = 22.0;
    final boxSize = photoSize + badgeSize / 2;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: photoSize,
            height: photoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(
                color: selecionado ? AppColors.accent : Colors.white,
                width: selecionado ? 3.5 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: AppNetworkImage(url: imageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: selecionado ? AppColors.accent : AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                iconeFromString(icone),
                color: selecionado ? AppColors.primaryDark : Colors.white,
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pin de local no mapa: gota verde com o ícone da categoria.
/// Cresce levemente quando selecionado (feedback ao tocar).
class CategoryPin extends StatelessWidget {
  final String icone;
  final bool selecionado;

  const CategoryPin({
    super.key,
    required this.icone,
    this.selecionado = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = selecionado ? 48.0 : 40.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selecionado ? AppColors.primaryDark : AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        iconeFromString(icone),
        color: Colors.white,
        size: selecionado ? 24 : 20,
      ),
    );
  }
}

/// Pin numerado para paradas de rota.
class NumberedPin extends StatelessWidget {
  final int numero;
  final Color color;

  const NumberedPin({super.key, required this.numero, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$numero',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

/// Avatar discreto de aventureiro próximo (efeito "Waze").
class AdventurerMarker extends StatelessWidget {
  final String avatarUrl;

  const AdventurerMarker({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: AppNetworkImage(url: avatarUrl, fit: BoxFit.cover),
      ),
    );
  }
}

/// Marcador da posição atual do usuário ("você").
class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
