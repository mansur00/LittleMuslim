import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'duolingo_appbar.dart';

/// Standardized loading indicator widget with child-friendly branding.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({
    super.key,
    this.message = 'তথ্য লোড হচ্ছে…',
    this.detail,
  });

  final String message;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            LocalizedText(
              message,
              style: const TextStyle(
                color: AppTheme.darkText,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...[
              const SizedBox(height: 6),
              LocalizedText(
                detail!,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Standardized empty state presentation widget.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DuolingoCard(
          accentColor: AppTheme.primaryGreen,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: AppTheme.primaryGreen),
              const SizedBox(height: 12),
              LocalizedText(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              LocalizedText(
                detail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: LocalizedText(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Standardized error recovery state widget.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.title,
    required this.detail,
    this.retryLabel = 'আবার চেষ্টা করো',
    this.onRetry,
  });

  final String title;
  final String detail;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DuolingoCard(
          accentColor: AppTheme.accentCoral,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppTheme.accentCoral,
              ),
              const SizedBox(height: 12),
              LocalizedText(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              LocalizedText(
                detail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: LocalizedText(retryLabel),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accentCoral,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
