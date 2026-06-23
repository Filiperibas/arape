import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/arape_logo.dart';
import '../widgets/category_chips.dart';
import '../widgets/map_markers.dart';
import '../widgets/transitions.dart';
import 'detail_screen.dart';
import 'routes_list_screen.dart';

/// Tela 1 — Mapa (herói). Centralizado em Ariquemes.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _centro = LatLng(-9.913, -63.040);
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Tocar num pin centraliza o mapa naquele local e abre a tela de detalhe.
  void _abrirDetalhe(Local local) {
    _mapController.move(local.latLng, 13.5);
    Navigator.of(context).push(slideUpRoute(DetailScreen(local: local)));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final locais = state.locaisFiltrados;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _centro,
              initialZoom: 12,
              minZoom: 4,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.arape.app',
              ),
              // Aventureiros próximos (efeito Waze).
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
              // Pins de locais: foto de capa + badge da categoria.
              MarkerLayer(
                markers: [
                  for (final l in locais)
                    Marker(
                      point: l.latLng,
                      width: 64,
                      height: 64,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _abrirDetalhe(l),
                        child: PhotoPin(
                          imageUrl: l.imagens.first,
                          icone: l.icone,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Cabeçalho: logo + chips de filtro.
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            ArapeLogo.emblem(height: 30),
                            SizedBox(width: 8),
                            ArapeLogo.wordmark(height: 20),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.soft,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 16, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            Text(
                              'Ariquemes, RO',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const CategoryChips(),
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(slideUpRoute(const RoutesListScreen()));
        },
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textPrimary,
        icon: const Icon(Icons.route_rounded),
        label: const Text(
          'Rotas sugeridas',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
