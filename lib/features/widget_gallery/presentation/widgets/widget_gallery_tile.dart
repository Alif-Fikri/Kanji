import 'package:flutter/material.dart';

import '../../../widget_config/domain/entities/widget_config.dart';
import '../../../widget_config/domain/entities/widget_kind.dart';
import '../../../widget_config/presentation/widgets/widget_face.dart';

class WidgetGalleryTile extends StatelessWidget {
  final WidgetKind kind;
  final WidgetConfig config;
  final DateTime now;
  final VoidCallback? onTap;
  final String? title;
  final String? subtitle;

  const WidgetGalleryTile({
    super.key,
    required this.kind,
    required this.config,
    required this.now,
    this.onTap,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
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
                    child: buildWidgetFace(kind: kind, config: config, now: now),
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
                  title ?? kind.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurface.withAlpha(110)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle ?? kind.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: scheme.onSurface.withAlpha(165),
            ),
          ),
        ],
      ),
    );
  }
}
