import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kanji_palette.dart';

const String displayFontFamily = 'ZenOldMincho';
const String bodyFontFamily = 'NotoSansJP';

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

  final base = ThemeData(colorScheme: scheme);

  return base.copyWith(
    scaffoldBackgroundColor: surface,
    splashFactory: InkSparkle.splashFactory,
    textTheme: base.textTheme.apply(fontFamily: bodyFontFamily).copyWith(
          displayLarge: TextStyle(
            fontFamily: displayFontFamily,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
          headlineMedium: TextStyle(
            fontFamily: displayFontFamily,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
          titleLarge: TextStyle(
            fontFamily: displayFontFamily,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      titleTextStyle: TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
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
