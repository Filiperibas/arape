import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/category_chips.dart';
import '../widgets/local_card.dart';
import '../widgets/transitions.dart';
import 'detail_screen.dart';

/// Tela 2 — Catálogo. Lista vertical de cards grandes com filtros.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final locais = state.locaisFiltrados;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explorar',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 28),
                    ),
                    Text(
                      '${locais.length} ${locais.length == 1 ? 'lugar' : 'lugares'} para descobrir',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const CategoryChips(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: locais.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final local = locais[i];
                  return LocalCard(
                    local: local,
                    onTap: () => Navigator.of(context)
                        .push(slideUpRoute(DetailScreen(local: local))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
