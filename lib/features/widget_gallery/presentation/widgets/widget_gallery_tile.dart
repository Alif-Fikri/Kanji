import 'package:flutter/material.dart';

import '../../../widget_config/domain/entities/widget_config.dart';
import '../../../widget_config/domain/entities/widget_kind.dart';
import '../../../widget_config/presentation/widgets/widget_face.dart';

class WidgetGalleryTile extends StatelessWidget {
  final WidgetKind kind;
  final WidgetConfig config;
  final DateTime now;
  final VoidCallback? onTap;

  const WidgetGalleryTile({
    super.key,
    required this.kind,
    required this.config,
    required this.now,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final available = kind.isAvailable;

    return Opacity(
      opacity: available ? 1 : 0.55,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2B3A52), Color(0xFF14181F)],
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    height: 104,
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
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    kind.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (available)
                  Icon(Icons.chevron_right,
                      color: scheme.onSurface.withAlpha(110))
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.onSurface.withAlpha(18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'SOON',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface.withAlpha(140),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              kind.description,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: scheme.onSurface.withAlpha(130),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
