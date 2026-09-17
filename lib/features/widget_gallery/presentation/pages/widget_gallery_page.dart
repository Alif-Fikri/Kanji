import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/washi_background.dart';
import '../../../widget_config/domain/entities/widget_kind.dart';
import '../../../widget_config/domain/entities/widget_target.dart';
import '../../../widget_config/presentation/bloc/widget_config_bloc.dart';
import '../../../widget_config/presentation/bloc/widget_config_state.dart';
import '../../../widget_config/presentation/pages/widget_customise_page.dart';
import '../widgets/widget_gallery_tile.dart';

class WidgetGalleryPage extends StatefulWidget {
  final WidgetTarget? editTarget;

  const WidgetGalleryPage({super.key, this.editTarget});

  @override
  State<WidgetGalleryPage> createState() => _WidgetGalleryPageState();
}

class _WidgetGalleryPageState extends State<WidgetGalleryPage> {
  late Timer _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() => _now = DateTime.now());
    });

    final editTarget = widget.editTarget;
    if (editTarget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => WidgetCustomisePage(target: editTarget),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  void _openCustomise(WidgetKind kind) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WidgetCustomisePage(target: WidgetTarget(kind)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return WashiBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<WidgetConfigBloc, WidgetConfigState>(
            builder: (context, state) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '暦',
                          style: TextStyle(
                            fontFamily: 'ZenOldMincho',
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Koyomi',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontSize: 27, height: 1.15),
                            ),
                            Text(
                              'Choose a widget for your home screen',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: scheme.onSurface.withAlpha(140),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  for (final kind in WidgetKind.values) ...[
                    WidgetGalleryTile(
                      kind: kind,
                      config: state.configFor(WidgetTarget(kind)),
                      now: _now,
                      onTap: kind.isAvailable
                          ? () => _openCustomise(kind)
                          : null,
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
