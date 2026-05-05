import 'package:flutter/material.dart';

/// Utility to show a fullscreen loading spinner blocking user interaction.
class LoadingOverlay {
  static OverlayEntry? _overlay;

  static void show(BuildContext context, {String message = 'Loading...'}) {
    if (_overlay != null) return;

    final theme = Theme.of(context);
    _overlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(message, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  static void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}
