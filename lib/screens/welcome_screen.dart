import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';
import '../widgets/app_network_image.dart';
import '../widgets/arape_logo.dart';
import 'main_shell.dart';

/// Tela 0 — Boas-vindas. Primeira tela ao abrir o app; leva à aba Mapa.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _entrar(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const MainShell(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _abrirProprietario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ProprietarioSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo: paisagem amazônica.
          const AppNetworkImage(
            url:
                'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?w=1200',
            fit: BoxFit.cover,
          ),
          // Overlay escuro para legibilidade.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDark.withValues(alpha: 0.35),
                  AppColors.primaryDark.withValues(alpha: 0.55),
                  const Color(0xFF06140C).withValues(alpha: 0.92),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),
                  const ArapeLogo.emblem(height: 128),
                  const SizedBox(height: 18),
                  const ArapeLogo.wordmarkWhite(height: 46),
                  const SizedBox(height: 28),
                  Text(
                    'Caminhos que conectam\npessoas e lugares.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          fontSize: 30,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Descubra a Amazônia que você não conhecia.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(flex: 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _entrar(context),
                      icon: const Icon(Icons.explore_rounded),
                      label: const Text('Explore a Amazônia'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => _abrirProprietario(context),
                      child: Text(
                        'Sou proprietário',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProprietarioSheet extends StatelessWidget {
  const _ProprietarioSheet();

  Future<void> _abrirWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/5569999990000?text=${Uri.encodeComponent('Olá! Sou proprietário e quero cadastrar meu local no Arape.')}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.store_mall_directory_rounded,
                color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 18),
          Text(
            'Tem um local para receber visitantes?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 10),
          const Text(
            'Você pode cadastrar sua propriedade, cachoeira, agroindústria ou '
            'experiência diretamente pelo app — ou com a ajuda da nossa equipe '
            'pelo WhatsApp. Vamos colocar o seu lugar no mapa do Arape.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _abrirWhatsApp,
              icon: const Icon(Icons.chat_rounded),
              label: const Text('Falar com a equipe no WhatsApp'),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Agora não',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}
