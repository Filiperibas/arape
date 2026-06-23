import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

/// Marca do Arape, derivada do logo oficial em `assets/images/`.
///
/// - [ArapeLogo.emblem]: o emblema circular (colorido) — funciona em qualquer fundo.
/// - [ArapeLogo.wordmark]: a palavra "arape" colorida — para fundos claros.
/// - [ArapeLogo.wordmarkWhite]: a palavra "arape" em branco — para fundos escuros.
///
/// Se o asset não existir, cai num texto "arape" em Poppins (a=azul, rape=verde).
class ArapeLogo extends StatelessWidget {
  final String _asset;
  final double height;
  final bool light;

  const ArapeLogo.emblem({super.key, this.height = 48})
      : _asset = 'assets/images/logo_emblem.png',
        light = false;

  const ArapeLogo.wordmark({super.key, this.height = 32})
      : _asset = 'assets/images/logo_wordmark.png',
        light = false;

  const ArapeLogo.wordmarkWhite({super.key, this.height = 40})
      : _asset = 'assets/images/logo_wordmark_white.png',
        light = true;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _asset,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, _, _) => _textoFallback(),
    );
  }

  Widget _textoFallback() {
    final restoColor = light ? Colors.white : AppColors.primary;
    final aColor = light ? AppColors.accent : AppColors.secondary;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: height * 0.82,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(text: 'a', style: TextStyle(color: aColor)),
          TextSpan(text: 'rape', style: TextStyle(color: restoColor)),
        ],
      ),
    );
  }
}
