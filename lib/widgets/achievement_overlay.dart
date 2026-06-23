import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import 'icon_mapper.dart';

/// Overlay de conquista exibido ao desbloquear um selo / concluir uma rota.
/// Anima o selo com o amarelo Rondônia e raios de luz.
class AchievementOverlay extends StatefulWidget {
  final String seloNome;
  final String icone;
  final int xp;
  final VoidCallback onClose;

  const AchievementOverlay({
    super.key,
    required this.seloNome,
    required this.icone,
    required this.xp,
    required this.onClose,
  });

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entrada;
  late final AnimationController _raios;

  @override
  void initState() {
    super.initState();
    _entrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _raios = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _entrada.dispose();
    _raios.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final escala = CurvedAnimation(
      parent: _entrada,
      curve: Curves.elasticOut,
    );
    final fade = CurvedAnimation(
      parent: _entrada,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    return Material(
      color: Colors.black.withValues(alpha: 0.78),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: fade,
                child: const Text(
                  'SELO DESBLOQUEADO!',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Raios de luz girando.
                    RotationTransition(
                      turns: _raios,
                      child: CustomPaint(
                        size: const Size(200, 200),
                        painter: _SunburstPainter(),
                      ),
                    ),
                    // Selo.
                    ScaleTransition(
                      scale: escala,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF6D43A), AppColors.accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 5),
                        ),
                        child: Icon(
                          iconeFromString(widget.icone),
                          size: 60,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ScaleTransition(
                scale: escala,
                child: Text(
                  widget.seloNome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: fade,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '+${widget.xp} XP',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FadeTransition(
                opacity: fade,
                child: ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    const raios = 12;
    final raio = size.width / 2;
    for (var i = 0; i < raios; i++) {
      final angulo = (i / raios) * 2 * math.pi;
      final path = Path();
      const largura = 0.12;
      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + raio * math.cos(angulo - largura),
        center.dy + raio * math.sin(angulo - largura),
      );
      path.lineTo(
        center.dx + raio * math.cos(angulo + largura),
        center.dy + raio * math.sin(angulo + largura),
      );
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
