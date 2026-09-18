import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/theme/kanji_palette.dart';
import '../../../../core/utils/date_index_selector.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/washi_background.dart';
import '../../../daily_kanji/data/daily_kanji_cache.dart';
import '../../../daily_quote/data/quote_cache.dart';
import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';
import '../../domain/entities/widget_target.dart';
import '../bloc/widget_config_bloc.dart';
import '../bloc/widget_config_event.dart';
import '../bloc/widget_config_state.dart';
import '../widgets/color_swatch_row.dart';
import '../widgets/font_selector.dart';
import '../widgets/kanji_clock_face.dart';
import '../widgets/option_controls.dart';
import '../widgets/placed_widget_row.dart';
import '../widgets/preview_stage.dart';
import '../widgets/template_picker.dart';

class WidgetCustomisePage extends StatefulWidget {
  final WidgetTarget target;
  final bool isConfiguring;

  const WidgetCustomisePage({
    super.key,
    required this.target,
    this.isConfiguring = false,
  });

  @override
  State<WidgetCustomisePage> createState() => _WidgetCustomisePageState();
}

class _WidgetCustomisePageState extends State<WidgetCustomisePage> {
  late Timer _ticker;
  DateTime _now = DateTime.now();
  List<WidgetTarget> _placed = const [];

  @override
  void initState() {
    super.initState();
    context.read<WidgetConfigBloc>().add(WidgetTargetOpened(widget.target));
    if (widget.target.isTemplate) _loadPlaced();
    if (DailyKanjiCache.entries == null) {
      DailyKanjiCache.warm().then((_) {
        if (mounted) setState(() {});
      });
    }
    if (QuoteCache.entries == null) {
      QuoteCache.warm().then((_) {
        if (mounted) setState(() {});
      });
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  Future<void> _loadPlaced() async {
    final installed = await HomeWidget.getInstalledWidgets();
    if (!mounted) return;

    final targets = installed
        .where(
          (info) =>
              info.androidWidgetId != null &&
              widget.target.kind.matchesAndroidClass(info.androidClassName),
        )
        .map(
          (info) =>
              WidgetTarget(widget.target.kind, widgetId: info.androidWidgetId),
        )
        .toList();

    setState(() => _placed = targets);

    final bloc = context.read<WidgetConfigBloc>();
    for (final target in targets) {
      bloc.add(WidgetTargetOpened(target));
    }
  }

  Future<void> _editPlaced(WidgetTarget target) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WidgetCustomisePage(target: target),
      ),
    );
    await _loadPlaced();
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  void _update(WidgetConfig config) {
    context.read<WidgetConfigBloc>().add(
      WidgetConfigChanged(widget.target, config),
    );
  }

  int? _contentLength() => switch (widget.target.kind) {
    WidgetKind.dailyKanji => DailyKanjiCache.entries?.length,
    WidgetKind.quote => QuoteCache.entries?.length,
    WidgetKind.clock => null,
  };

  void _shuffleContent(WidgetConfig config) {
    final length = _contentLength();
    if (length == null || length < 2) return;

    final today = dateKey(_now);
    final currentIndex = activeOverrideIndex(
      config.contentOverrideDate,
      config.contentOverrideIndex,
      _now,
    );

    var nextIndex = currentIndex ?? dailyIndexFor(_now, length);
    while (nextIndex == (currentIndex ?? dailyIndexFor(_now, length))) {
      nextIndex = Random().nextInt(length);
    }

    _update(
      config.copyWith(
        contentOverrideDate: today,
        contentOverrideIndex: nextIndex,
      ),
    );
  }

  Future<void> _finishConfiguring() async {
    await HomeWidget.finishHomeWidgetConfigure();
  }

  Future<void> _pinWidget() async {
    final provider = widget.target.kind.androidProvider;
    final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
    if (!mounted) return;

    if (!supported) {
      _showAddInstructions();
      return;
    }
    await HomeWidget.requestPinWidget(qualifiedAndroidName: provider);
  }

  void _showAddInstructions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(KanjiPalette.kinari),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(label: 'How to add'),
            for (final step in const [
              '1.  Long-press an empty area on your home screen',
              '2.  Tap "Widgets"',
              '3.  Find "Koyomi", then drag it onto the home screen',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(step, style: const TextStyle(fontSize: 15)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final target = widget.target;

    return WashiBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.isConfiguring ? 'Set up widget' : target.kind.title,
          ),
          automaticallyImplyLeading: !widget.isConfiguring,
        ),
        body: BlocBuilder<WidgetConfigBloc, WidgetConfigState>(
          builder: (context, state) {
            final config = state.configFor(target);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
              children: [
                if (!target.isTemplate)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      'Editing this widget only — other widgets keep their own '
                      'look.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: scheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ),
                PreviewStage(kind: target.kind, config: config, now: _now),
                const SizedBox(height: 26),
                if (_placed.isNotEmpty) ...[
                  SettingsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          label: 'Your widgets',
                          trailing: '${_placed.length} placed',
                        ),
                        Text(
                          'Already on your home screen. Tap one to restyle '
                          'just that widget.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: scheme.onSurface.withAlpha(140),
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (final (index, placed) in _placed.indexed)
                          PlacedWidgetRow(
                            kind: placed.kind,
                            config: state.configFor(placed),
                            now: _now,
                            label: '${placed.kind.title} ${index + 1}',
                            onTap: () => _editPlaced(placed),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(label: 'Templates'),
                      Text(
                        'Apply a ready-made look — font, text colour and '
                        'background all at once.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: scheme.onSurface.withAlpha(140),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TemplatePicker(
                        config: config,
                        onSelected: (template) =>
                            _update(template.applyTo(config)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (target.kind != WidgetKind.clock) ...[
                  SettingsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          label: target.kind == WidgetKind.dailyKanji
                              ? "Today's kanji"
                              : "Today's quote",
                        ),
                        if (target.kind == WidgetKind.quote) ...[
                          Builder(
                            builder: (context) {
                              final entry = QuoteCache.entryFor(
                                _now,
                                overrideIndex: activeOverrideIndex(
                                  config.contentOverrideDate,
                                  config.contentOverrideIndex,
                                  _now,
                                ),
                              );
                              if (entry == null) return const SizedBox();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.japanese,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.english,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: scheme.onSurface.withAlpha(180),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                        Text(
                          'Changes daily on its own. Not feeling this one? '
                          "Shuffle for another — it'll still change "
                          'automatically again tomorrow.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: scheme.onSurface.withAlpha(140),
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () => _shuffleContent(config),
                          icon: const Icon(Icons.shuffle, size: 18),
                          label: const Text('Shuffle'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(label: 'Font'),
                      FontSelector(
                        selected: config.font,
                        onSelected: (font) =>
                            _update(config.copyWith(font: font)),
                      ),
                      const SizedBox(height: 22),
                      const SectionHeader(label: 'Size'),
                      SegmentedChoice<WidgetSize>(
                        values: WidgetSize.values,
                        selected: config.size,
                        labelOf: (value) => widgetSizeLabels[value]!,
                        onSelected: (size) =>
                            _update(config.copyWith(size: size)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sets the starting look. Once the widget is on your '
                        "home screen, drag its edges to resize it there — "
                        "the content scales to fit whatever size you set.",
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: scheme.onSurface.withAlpha(140),
                        ),
                      ),
                      const SizedBox(height: 22),
                      OptionSwitch(
                        title: 'Bold text',
                        subtitle: 'Thicker strokes, easier to read at a glance',
                        value: config.boldText,
                        onChanged: (value) =>
                            _update(config.copyWith(boldText: value)),
                      ),
                    ],
                  ),
                ),
                if (target.kind == WidgetKind.clock) ...[
                  const SizedBox(height: 16),
                  SettingsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(label: 'Clock format'),
                        SegmentedChoice<NumeralStyle>(
                          values: NumeralStyle.values,
                          selected: config.numeralStyle,
                          labelOf: (value) => value == NumeralStyle.kanji
                              ? 'Kanji  十時'
                              : 'Numbers  10時',
                          onSelected: (style) =>
                              _update(config.copyWith(numeralStyle: style)),
                        ),
                        const SizedBox(height: 12),
                        SegmentedChoice<bool>(
                          values: const [true, false],
                          selected: config.use24HourFormat,
                          labelOf: (value) => value ? '24-hour' : '12-hour',
                          onSelected: (value) =>
                              _update(config.copyWith(use24HourFormat: value)),
                        ),
                        const SizedBox(height: 16),
                        OptionSwitch(
                          title: 'Show date',
                          subtitle: 'Second line with the month and day',
                          value: config.showDate,
                          onChanged: (value) =>
                              _update(config.copyWith(showDate: value)),
                        ),
                        OptionSwitch(
                          title: 'Show weekday',
                          subtitle: 'Adds the day of the week, e.g. （水）',
                          value: config.showWeekday,
                          onChanged: (value) =>
                              _update(config.copyWith(showWeekday: value)),
                        ),
                        OptionSwitch(
                          title: 'Show seconds',
                          subtitle:
                              'Live in this preview. On the home screen Android '
                              'only lets widgets refresh once a minute, so the '
                              'seconds there update every minute.',
                          value: config.showSeconds,
                          onChanged: (value) =>
                              _update(config.copyWith(showSeconds: value)),
                        ),
                      ],
                    ),
                  ),
                ],
                if (target.kind == WidgetKind.quote) ...[
                  const SizedBox(height: 16),
                  SettingsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(label: 'Quote'),
                        OptionSwitch(
                          title: 'Show translation',
                          subtitle:
                              'Show the English meaning under the Japanese '
                              'quote. Turn off for Japanese only.',
                          value: config.showTranslation,
                          onChanged: (value) => _update(
                            config.copyWith(showTranslation: value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        label: 'Text colour',
                        trailing: KanjiPalette.nameOf(config.textColor),
                      ),
                      ColorSwatchRow(
                        options: KanjiPalette.texts,
                        selected: config.textColor,
                        onSelected: (color) =>
                            _update(config.copyWith(textColor: color)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        label: 'Background',
                        trailing: config.showBackground
                            ? KanjiPalette.nameOf(config.backgroundColor)
                            : 'Transparent',
                      ),
                      OptionSwitch(
                        title: 'Show background',
                        subtitle: 'Turn off for a transparent widget',
                        value: config.showBackground,
                        onChanged: (value) =>
                            _update(config.copyWith(showBackground: value)),
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: config.showBackground
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: ColorSwatchRow(
                            options: KanjiPalette.backgrounds,
                            selected: config.backgroundColor,
                            onSelected: (color) =>
                                _update(config.copyWith(backgroundColor: color)),
                          ),
                        ),
                        secondChild: const SizedBox(width: double.infinity),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                if (widget.isConfiguring)
                  FilledButton(
                    onPressed: _finishConfiguring,
                    child: const Text('Done'),
                  )
                else if (target.isTemplate) ...[
                  FilledButton(
                    onPressed: _pinWidget,
                    child: const Text('Add to Home Screen'),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: _showAddInstructions,
                      child: Text(
                        'Add it manually instead',
                        style: TextStyle(color: scheme.onSurface.withAlpha(150)),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
