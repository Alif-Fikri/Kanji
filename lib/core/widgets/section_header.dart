import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String label;

  const SectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
              color: onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(height: 1, color: onSurface.withAlpha(28)),
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(214),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withAlpha(230)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4A32).withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
