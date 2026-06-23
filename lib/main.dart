import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const ArapeApp());
}

class ArapeApp extends StatelessWidget {
  const ArapeApp({super.key});

  /// Largura máxima do app em telas grandes (web desktop, tablets).
  /// Acima disso, "encaixotamos" o app num formato de celular centralizado —
  /// já que o Arape é mobile-first e em layout esticado fica estranho.
  static const double _maxMobileWidth = 460;

  /// Limiar acima do qual aplicamos o frame mobile (≈ tablet pequeno em diante).
  static const double _desktopBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..inicializar(),
      child: MaterialApp(
        title: 'Arape',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const WelcomeScreen(),
        builder: (context, child) {
          if (child == null) return const SizedBox.shrink();
          final mq = MediaQuery.of(context);
          final width = mq.size.width;
          // Em telas pequenas (celular real), nada muda.
          if (width <= _desktopBreakpoint) return child;
          // Em telas largas (desktop/tablet), travamos a largura no formato
          // de celular e mostramos o verde da marca atrás — preserva a
          // experiência mobile-first em qualquer browser.
          final phoneHeight =
              mq.size.height - 48 > 800 ? 880.0 : mq.size.height - 48;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  const Color(0xFF062818),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Container(
                width: _maxMobileWidth,
                height: phoneHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 60,
                      offset: const Offset(0, 24),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 40,
                      spreadRadius: -8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: MediaQuery(
                    // Atualizamos a Size pra que widgets internos enxerguem a
                    // largura constrita (importante pra SliverAppBar e afins).
                    data: mq.copyWith(
                      size: Size(_maxMobileWidth, phoneHeight),
                    ),
                    child: child,
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
