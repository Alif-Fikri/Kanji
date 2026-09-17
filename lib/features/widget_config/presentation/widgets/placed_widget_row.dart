import 'package:flutter/material.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';
import 'widget_face.dart';

class PlacedWidgetRow extends StatelessWidget {
  final WidgetKind kind;
  final WidgetConfig config;
  final DateTime now;
  final String label;
  final VoidCallback onTap;

  const PlacedWidgetRow({
    super.key,
    required this.kind,
    required this.config,
    required this.now,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 92,
                height: 56,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2B3A52), Color(0xFF14181F)],
                  ),
                ),
                child: SizedBox(
                  height: 40,
                  child: FittedBox(
                    child: buildWidgetFace(
                      kind: kind,
                      config: config,
                      now: now,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    config.summary,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurface.withAlpha(110)),
          ],
        ),
      ),
    );
  }
}
