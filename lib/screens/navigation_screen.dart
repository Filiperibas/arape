import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/achievement_overlay.dart';
import '../widgets/map_markers.dart';

/// Tela de Navegação (rota tipo Waze) — compartilhada.
/// Modo destino único (vindo do detalhe) ou modo rota multi-paradas.
class NavigationScreen extends StatefulWidget {
  final List<Local> paradas;
  final Rota? rota;

  const NavigationScreen._({required this.paradas, this.rota});

  factory NavigationScreen.destinoUnico({required Local local}) {
    return NavigationScreen._(paradas: [local]);
  }

  factory NavigationScreen.rota({
    required Rota rota,
    required List<Local> paradas,
  }) {
    return NavigationScreen._(paradas: paradas, rota: rota);
  }

  bool get ehRota => rota != null;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  /// Posição mockada do usuário ("você"), em Ariquemes.
  static const _voce = LatLng(-9.913, -63.040);
  static const _distance = Distance();

  final _mapController = MapController();
  int _index = 0;

  Local get _alvo => widget.paradas[_index];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ajustarCamera());
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Pontos da polilinha: de "você" passando por todas as paradas.
  List<LatLng> get _pontosRota => [_voce, ...widget.paradas.map((p) => p.latLng)];

  void _ajustarCamera() {
    _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: _pontosRota,
        padding: const EdgeInsets.fromLTRB(60, 160, 60, 220),
      ),
    );
  }

  double get _kmAteAlvo {
    final origem = _index == 0 ? _voce : widget.paradas[_index - 1].latLng;
    return _distance.as(LengthUnit.Kilometer, origem, _alvo.latLng);
  }

  void _cheguei() {
    final state = context.read<AppState>();
    state.registrarVisita(_alvo);

    final ehUltima = _index == widget.paradas.length - 1;

    if (!widget.ehRota) {
      _dialogChegada(_alvo, fecharTela: true);
      return;
    }

    if (!ehUltima) {
      setState(() => _index += 1);
      _ajustarCamera();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Parada concluída! Próxima: ${_alvo.nome}'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Última parada da rota: conclui e dispara a conquista.
      state.concluirRota(widget.rota!);
      _mostrarConquista();
    }
  }

  void _dialogChegada(Local local, {required bool fecharTela}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration_rounded,
                  color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Você chegou em ${local.nome}!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Visita registrada 🎉',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (fecharTela) Navigator.of(context).pop();
              },
              child: const Text('Ótimo!'),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarConquista() {
    final rota = widget.rota!;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'conquista',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => AchievementOverlay(
        seloNome: rota.seloRecompensa,
        icone: widget.paradas.last.icone,
        xp: rota.xpRecompensa,
        onClose: () {
          Navigator.of(context).pop(); // fecha overlay
          Navigator.of(context).pop(); // fecha navegação
        },
      ),
      transitionBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tempoMin = (_kmAteAlvo / 40 * 60).clamp(2, 999).round();
    final ehUltima = _index == widget.paradas.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _voce,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.arape.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _pontosRota,
                    strokeWidth: 5,
                    color: AppColors.secondary,
                    borderStrokeWidth: 2,
                    borderColor: Colors.white,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  for (final a in state.aventureiros)
                    Marker(
                      point: a.latLng,
                      width: 30,
                      height: 30,
                      child: AdventurerMarker(avatarUrl: a.avatar),
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  const Marker(
                    point: _voce,
                    width: 26,
                    height: 26,
                    child: UserLocationMarker(),
                  ),
                  for (var i = 0; i < widget.paradas.length; i++)
                    Marker(
                      point: widget.paradas[i].latLng,
                      width: 40,
                      height: 40,
                      child: widget.ehRota
                          ? NumberedPin(
                              numero: i + 1,
                              color: i == _index
                                  ? AppColors.primary
                                  : (i < _index
                                      ? AppColors.muted
                                      : AppColors.primaryDark),
                            )
                          : CategoryPin(
                              icone: widget.paradas[i].icone,
                              selecionado: true,
                            ),
                    ),
                ],
              ),
            ],
          ),

          // Cartão superior: destino + distância/tempo (mockados).
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppShadows.card,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ehRota
                                ? 'Parada ${_index + 1} de ${widget.paradas.length}'
                                : 'Indo para',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _alvo.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${_kmAteAlvo.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '~$tempoMin min',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botão inferior "Cheguei" / "Próxima parada".
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _cheguei,
                    icon: Icon(
                      ehUltima || !widget.ehRota
                          ? Icons.flag_rounded
                          : Icons.skip_next_rounded,
                    ),
                    label: Text(
                      !widget.ehRota
                          ? 'Cheguei'
                          : (ehUltima ? 'Concluir rota' : 'Cheguei · Próxima parada'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor:
                          ehUltima && widget.ehRota ? AppColors.accent : AppColors.primary,
                      foregroundColor: ehUltima && widget.ehRota
                          ? AppColors.textPrimary
                          : Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
