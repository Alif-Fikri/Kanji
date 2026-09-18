import 'package:flutter/material.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_template.dart';
import 'kanji_clock_face.dart';

class TemplatePicker extends StatelessWidget {
  final WidgetConfig config;
  final ValueChanged<WidgetTemplate> onSelected;

  const TemplatePicker({
    super.key,
    required this.config,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: WidgetTemplates.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final template = WidgetTemplates.all[index];
          final selected = template.matches(config);
          final bg = Color(template.backgroundColor);
          final fg = Color(template.textColor);

          return GestureDetector(
            onTap: () => onSelected(template),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? scheme.primary
                          : scheme.onSurface.withAlpha(36),
                      width: selected ? 3 : 1,
                    ),
                  ),
                  child: Text(
                    kanjiFontSampleText,
                    style: TextStyle(
                      fontFamily: kanjiFontFamilies[template.font],
                      fontWeight: template.boldText
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 22,
                      color: fg,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  template.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: scheme.onSurface.withAlpha(selected ? 220 : 140),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
