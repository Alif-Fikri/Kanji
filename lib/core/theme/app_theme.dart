import 'package:flutter/material.dart';

import 'kanji_palette.dart';

ThemeData buildKanjiTheme() {
  const surface = Color(KanjiPalette.kinari);
  const accent = Color(KanjiPalette.shu);
  const ink = Color(KanjiPalette.sumi);

  final scheme = ColorScheme.fromSeed(
    seedColor: accent,
    surface: surface,
  ).copyWith(
    primary: accent,
    onSurface: ink,
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: surface,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accent : null,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? accent.withAlpha(80) : null,
      ),
    ),
  );
}
