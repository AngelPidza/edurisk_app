import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Piezas de orientación compartidas por todas las pantallas: un recuadro
/// de ayuda plegable, un indicador de pasos, estados vacíos y leyendas.

/// Recuadro «¿Cómo usar esta pantalla?». Empieza abierto; si el usuario lo
/// oculta, queda como un enlace pequeño para volver a abrirlo, de modo que la
/// ayuda nunca desaparece del todo. El estado dura lo que dura la sesión.
class HelpBanner extends StatefulWidget {
  /// Identifica la pantalla para recordar si el usuario ocultó la ayuda.
  final String id;
  final String title;
  final List<String> steps;

  const HelpBanner({
    super.key,
    required this.id,
    required this.steps,
    this.title = '¿Cómo usar esta pantalla?',
  });

  static final Set<String> _hidden = {};

  @override
  State<HelpBanner> createState() => _HelpBannerState();
}

class _HelpBannerState extends State<HelpBanner> {
  bool get _open => !HelpBanner._hidden.contains(widget.id);

  void _toggle() => setState(() {
    if (_open) {
      HelpBanner._hidden.add(widget.id);
    } else {
      HelpBanner._hidden.remove(widget.id);
    }
  });

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _toggle,
          icon: const Icon(Icons.help_outline_rounded, size: 15),
          label: const Text('Mostrar ayuda de esta pantalla'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              size: 18,
              color: AppTheme.accentBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.steps.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBlue.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${e.key + 1}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentBlue,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Ocultar ayuda',
            onPressed: _toggle,
            icon: const Icon(Icons.close_rounded, size: 16),
            color: AppTheme.textMuted,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

/// Un paso dentro de [StepIndicator].
class GuideStep {
  final String label;
  final bool done;
  const GuideStep(this.label, {required this.done});
}

/// Muestra en qué paso de un proceso está el usuario. El primer paso sin
/// completar se resalta como el actual.
class StepIndicator extends StatelessWidget {
  final List<GuideStep> steps;
  const StepIndicator({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final current = steps.indexWhere((s) => !s.done);
    final children = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isCurrent = i == current;
      final color = step.done
          ? AppTheme.accentGreen
          : isCurrent
          ? AppTheme.accentBlue
          : AppTheme.textMuted;

      children.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: step.done || isCurrent
                    ? color.withOpacity(0.18)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              alignment: Alignment.center,
              child: step.done
                  ? Icon(Icons.check_rounded, size: 13, color: color)
                  : Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
            ),
            const SizedBox(width: 7),
            Text(
              step.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                color: step.done || isCurrent
                    ? AppTheme.textPrimary
                    : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      );
      if (i < steps.length - 1) {
        children.add(
          Container(
            width: 28,
            height: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: step.done ? AppTheme.accentGreen : AppTheme.border,
          ),
        );
      }
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      children: children,
    );
  }
}

/// Pantalla o recuadro sin datos que explica qué falta y, si corresponde,
/// ofrece el siguiente paso.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.bgInput,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 26, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.arrow_forward_rounded, size: 15),
              label: Text(actionLabel!),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accentBlue,
                textStyle: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Una entrada de leyenda: punto de color, nombre y qué significa.
class LegendEntry {
  final Color color;
  final String label;
  final String meaning;
  const LegendEntry(this.color, this.label, this.meaning);
}

/// Leyenda horizontal que explica qué significa cada color de la pantalla.
class ColorLegend extends StatelessWidget {
  final List<LegendEntry> entries;
  const ColorLegend({super.key, required this.entries});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 18,
    runSpacing: 6,
    children: entries
        .map(
          (e) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: e.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: e.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    TextSpan(text: ': ${e.meaning}'),
                  ],
                ),
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        )
        .toList(),
  );
}

/// Enlace de «siguiente paso» que lleva a otra pantalla, con su motivo.
class NextStepTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const NextStepTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 17, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    ),
  );
}
