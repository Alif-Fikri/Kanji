import 'package:flutter/material.dart';

import '../../domain/entities/widget_config.dart';
import 'kanji_clock_face.dart';

class FontSelector extends StatelessWidget {
  final KanjiFont selected;
  final ValueChanged<KanjiFont> onSelected;

  const FontSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: KanjiFont.values.map((font) {
        final isSelected = font == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => onSelected(font),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? scheme.primary.withAlpha(24)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary
                        : scheme.onSurface.withAlpha(36),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      kanjiFontSampleText,
                      style: TextStyle(
                        fontFamily: kanjiFontFamilies[font],
                        fontSize: 22,
                        color: isSelected ? scheme.primary : scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      kanjiFontLabels[font]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.2,
                        color: scheme.onSurface.withAlpha(isSelected ? 200 : 130),
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SizeSelector extends StatelessWidget {
  final WidgetSize selected;
  final ValueChanged<WidgetSize> onSelected;

  const SizeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.onSurface.withAlpha(14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: WidgetSize.values.map((size) {
          final isSelected = size == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? scheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  widgetSizeLabels[size]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : scheme.onSurface.withAlpha(150),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
