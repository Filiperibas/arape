import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/app_network_image.dart';
import '../widgets/badges.dart';
import '../widgets/photo_carousel.dart';
import '../widgets/star_rating.dart';
import '../widgets/transitions.dart';
import 'navigation_screen.dart';

/// Tela 3 — Detalhe do local.
class DetailScreen extends StatelessWidget {
  final Local local;

  const DetailScreen({super.key, required this.local});

  Future<void> _falarComProprietario() async {
    final texto = Uri.encodeComponent(
      'Olá! Vi o ${local.nome} no app Arape e gostaria de mais informações.',
    );
    final uri = Uri.parse('https://wa.me/${local.whatsapp}?text=$texto');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _comoChegar(BuildContext context) {
    Navigator.of(context).push(
      slideUpRoute(NavigationScreen.destinoUnico(local: local)),
    );
  }

  void _abrirAvaliar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AvaliarSheet(local: local),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>(); // rebuild ao adicionar avaliação
    final altura = MediaQuery.of(context).size.height;
    final temProdutos = local.produtos.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: altura * 0.40,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            leading: const _CircleBackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PhotoCarousel(imagens: local.imagens, height: altura * 0.40),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CategoryBadge(
                          icone: local.icone, label: local.categoriaLabel),
                      const SizedBox(width: 8),
                      if (local.verificado) const VerifiedBadge(),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    local.nome,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 26, height: 1.15),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StarRating(rating: local.avaliacaoMedia, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        local.avaliacaoMedia.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${local.totalAvaliacoes} avaliações)',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    local.descricaoCompleta,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _InfoBlock(local: local),
                  if (temProdutos) ...[
                    const SizedBox(height: 28),
                    _SectionTitle(
                      icon: Icons.shopping_bag_rounded,
                      title: 'Produtos da casa',
                      subtitle: 'Direto de quem produz',
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 188,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: local.produtos.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            _ProdutoCard(produto: local.produtos[i]),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _SectionTitle(
                          icon: Icons.reviews_rounded,
                          title: 'Avaliações',
                          subtitle: '${local.avaliacoes.length} comentários',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _abrirAvaliar(context),
                        icon: const Icon(Icons.rate_review_outlined, size: 18),
                        label: const Text('Avaliar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...local.avaliacoes.map((a) => _AvaliacaoTile(avaliacao: a)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _ActionBar(
        onComoChegar: () => _comoChegar(context),
        onWhatsApp: _falarComProprietario,
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final Local local;
  const _InfoBlock({required this.local});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.schedule_rounded, label: 'Horário', valor: local.horario),
          const Divider(height: 22),
          _InfoRow(
              icon: Icons.payments_rounded, label: 'Valor', valor: local.valor),
          const Divider(height: 22),
          _InfoRow(
              icon: Icons.info_outline_rounded,
              label: 'O que esperar',
              valor: local.oQueEsperar),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _InfoRow({required this.icon, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 22),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 18)),
            Text(subtitle,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12.5)),
          ],
        ),
      ],
    );
  }
}

class _ProdutoCard extends StatelessWidget {
  final Produto produto;
  const _ProdutoCard({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(url: produto.imagem, height: 100, width: 150),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  produto.preco,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvaliacaoTile extends StatelessWidget {
  final Avaliacao avaliacao;
  const _AvaliacaoTile({required this.avaliacao});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  avaliacao.autor.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  avaliacao.autor,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              StarRating(rating: avaliacao.estrelas.toDouble(), size: 14),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            avaliacao.comentario,
            style: const TextStyle(
                color: AppColors.textPrimary, height: 1.45, fontSize: 14),
          ),
          if (avaliacao.resposta != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border(
                  left: BorderSide(color: AppColors.primary, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.storefront_rounded,
                          size: 14, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Resposta do proprietário',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    avaliacao.resposta!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.4,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final VoidCallback onComoChegar;
  final VoidCallback onWhatsApp;

  const _ActionBar({required this.onComoChegar, required this.onWhatsApp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onComoChegar,
                icon: const Icon(Icons.navigation_rounded),
                label: const Text('Como chegar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 56,
              height: 52,
              child: ElevatedButton(
                onPressed: onWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: const Icon(Icons.chat_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvaliarSheet extends StatefulWidget {
  final Local local;
  const _AvaliarSheet({required this.local});

  @override
  State<_AvaliarSheet> createState() => _AvaliarSheetState();
}

class _AvaliarSheetState extends State<_AvaliarSheet> {
  int _estrelas = 5;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enviar() {
    context
        .read<AppState>()
        .adicionarAvaliacao(widget.local, _estrelas, _controller.text);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avaliação enviada. Obrigado! 🌿'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            const SizedBox(height: 20),
            Text('Avaliar ${widget.local.nome}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
            const SizedBox(height: 6),
            const Text(
              'Como foi a sua experiência?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            StarSelector(
              value: _estrelas,
              onChanged: (v) => setState(() => _estrelas = v),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Conte como foi a visita (opcional)',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enviar,
                child: const Text('Enviar avaliação'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
