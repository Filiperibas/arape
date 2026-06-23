import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/app_network_image.dart';
import '../widgets/icon_mapper.dart';

/// Tela 5 — Perfil.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final perfil = state.perfil;
    if (perfil == null) return const SizedBox.shrink();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header(perfil: perfil)),
          SliverToBoxAdapter(child: _Metricas(perfil: perfil)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: AppColors.accent, size: 22),
                  const SizedBox(width: 8),
                  Text('Selos',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18)),
                  const Spacer(),
                  Text(
                    '${perfil.selos.where((s) => s.conquistado).length}/${perfil.selos.length}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _SeloCard(selo: perfil.selos[i]),
                childCount: perfil.selos.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 10),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded,
                      color: AppColors.secondary, size: 22),
                  const SizedBox(width: 8),
                  Text('Histórico de visitas',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _HistoricoTile(item: perfil.historico[i]),
                childCount: perfil.historico.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Perfil perfil;
  const _Header({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(AppRadius.lg)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 3),
              ),
              child: ClipOval(
                child: AppNetworkImage(
                  url: perfil.avatar,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              perfil.nome,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded,
                      size: 16, color: AppColors.primaryDark),
                  const SizedBox(width: 4),
                  Text(
                    perfil.nivel,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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

class _Metricas extends StatelessWidget {
  final Perfil perfil;
  const _Metricas({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            _Metrica(
                valor: '${perfil.locaisVisitados}',
                label: 'Locais\nvisitados'),
            _divisor(),
            _Metrica(
                valor: '${perfil.rotasCompletas}',
                label: 'Rotas\ncompletas'),
            _divisor(),
            _Metrica(valor: '${perfil.xp}', label: 'XP\ntotal', destaque: true),
          ],
        ),
      ),
    );
  }

  Widget _divisor() => Container(
        width: 1,
        height: 40,
        color: AppColors.muted.withValues(alpha: 0.4),
      );
}

class _Metrica extends StatelessWidget {
  final String valor;
  final String label;
  final bool destaque;

  const _Metrica({
    required this.valor,
    required this.label,
    this.destaque = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            valor,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: destaque ? AppColors.accent : AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeloCard extends StatelessWidget {
  final Selo selo;
  const _SeloCard({required this.selo});

  @override
  Widget build(BuildContext context) {
    final conquistado = selo.conquistado;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: conquistado ? AppShadows.soft : null,
        border: conquistado
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.6))
            : Border.all(color: AppColors.muted.withValues(alpha: 0.4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: conquistado
                  ? const LinearGradient(
                      colors: [Color(0xFFF6D43A), AppColors.accent])
                  : null,
              color: conquistado ? null : AppColors.muted.withValues(alpha: 0.3),
            ),
            child: Icon(
              conquistado ? iconeFromString(selo.icone) : Icons.lock_rounded,
              color: conquistado ? AppColors.primaryDark : AppColors.muted,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selo.nome,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.15,
              color:
                  conquistado ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoricoTile extends StatelessWidget {
  final HistoricoItem item;
  const _HistoricoTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.place_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.local,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ),
          Text(
            item.data,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
