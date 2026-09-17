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
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 11,
      runSpacing: 11,
      children: options.map((option) {
        final isSelected = option.value == selected;
        final tickColor = option.color.computeLuminance() > 0.55
            ? const Color(KanjiPalette.sumi)
            : Colors.white;

        return GestureDetector(
          onTap: () => onSelected(option.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: option.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? scheme.primary
                    : scheme.onSurface.withAlpha(38),
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected
                ? Icon(Icons.check_rounded, size: 19, color: tickColor)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
