import 'package:flutter/material.dart';

import '../../../../core/theme/kanji_palette.dart';

class ColorSwatchRow extends StatelessWidget {
  final List<KanjiColor> options;
  final int selected;
  final ValueChanged<int> onSelected;

  const ColorSwatchRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: options.map((option) {
        final isSelected = option.value == selected;
        return GestureDetector(
          onTap: () => onSelected(option.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: option.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : onSurface.withAlpha(36),
                    width: isSelected ? 3 : 1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                option.name,
                style: TextStyle(
                  fontSize: 11,
                  color: onSurface.withAlpha(isSelected ? 220 : 120),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
