import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/app_state.dart';
import 'app_button.dart';

/// An unforgeable authorization token required to elevate user role to admin.
/// Its constructor is library-private so only [ParentalGate] can mint it.
class AdminElevationToken {
  const AdminElevationToken._();
}

/// ParentalGateDialog: Modal barrier requiring parents to solve a randomized
/// arithmetic challenge before entering Admin Mode. Enforces lockout after 3 failures.
class ParentalGateDialog extends StatefulWidget {
  const ParentalGateDialog({
    super.key,
    this.challengeNum1,
    this.challengeNum2,
  });

  final int? challengeNum1;
  final int? challengeNum2;

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late int _num1;
  late int _num2;
  late int _expectedSum;
  final TextEditingController _controller = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _generateChallenge();
  }

  void _generateChallenge() {
    final random = math.Random();
    _num1 = widget.challengeNum1 ?? (random.nextInt(7) + 3); // 3 to 9
    _num2 = widget.challengeNum2 ?? (random.nextInt(7) + 3); // 3 to 9
    _expectedSum = _num1 + _num2;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _verify() {
    final appState = context.read<AppState>();
    if (appState.isGateLockedOut) return;

    final text = _controller.text.trim();
    final answer = int.tryParse(AppFormatters.toLatinDigits(text));
    if (answer == _expectedSum) {
      appState.recordGateSuccess();
      Navigator.of(context).pop(const AdminElevationToken._());
    } else {
      appState.recordGateFailure();
      setState(() {
        _hasError = true;
        if (widget.challengeNum1 == null && widget.challengeNum2 == null) {
          _generateChallenge(); // Re-randomize challenge on mistake
        }
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isLockedOut = appState.isGateLockedOut;

    return Dialog(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderXl,
        side: BorderSide(color: AppColors.border, width: AppStroke.regular),
      ),
      child: Padding(
        padding: AppSpacing.insetXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Icon(
                isLockedOut ? Icons.lock_clock_rounded : Icons.admin_panel_settings_rounded,
                size: AppSizes.iconXl,
                color: isLockedOut ? AppColors.error : AppColors.amber600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.t('admin.parental_gate_title'),
              style: AppTextStyles.title(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isLockedOut
                  ? context.t('admin.parental_gate_lockout', params: {
                      'seconds': context.formatDigits('${appState.gateLockoutSecondsRemaining}'),
                    })
                  : context.t('admin.parental_gate_prompt'),
              style: AppTextStyles.caption(context).copyWith(
                color: isLockedOut ? AppColors.error : AppColors.textSecondary,
                fontWeight: isLockedOut ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (!isLockedOut) ...[
              Container(
                padding: AppSpacing.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.amber100.withValues(alpha: 0.35),
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(
                    color: AppColors.amber500.withValues(alpha: 0.4),
                    width: AppStroke.hairline,
                  ),
                ),
                child: Text(
                  context.t('admin.parental_gate_question', params: {
                    'num1': context.formatDigits('$_num1'),
                    'num2': context.formatDigits('$_num2'),
                  }),
                  style: AppTextStyles.title(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.amber800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                textAlign: TextAlign.center,
                style: AppTextStyles.title(context),
                onSubmitted: (_) => _verify(),
                decoration: InputDecoration(
                  hintText: context.t('admin.parental_gate_hint'),
                  errorText: _hasError ? context.t('admin.parental_gate_error') : null,
                  contentPadding: AppSpacing.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: AppRadius.borderMd,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.t('admin.parental_gate_cancel'),
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                ),
                if (!isLockedOut) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: context.t('admin.parental_gate_confirm'),
                      variant: AppButtonVariant.primary,
                      onPressed: _verify,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper to trigger the parental verification dialog and mint unforgeable tokens.
class ParentalGate {
  /// Solves or shows the arithmetic challenge and returns an [AdminElevationToken]
  /// if verified, or null otherwise.
  static Future<AdminElevationToken?> verify(BuildContext context, {int? num1, int? num2}) async {
    final appState = context.read<AppState>();
    if (appState.isGateLockedOut) {
      // Show dialog indicating lockout countdown
      await showDialog<AdminElevationToken?>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => const ParentalGateDialog(),
      );
      return null;
    }

    final result = await showDialog<AdminElevationToken?>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => ParentalGateDialog(
        challengeNum1: num1,
        challengeNum2: num2,
      ),
    );
    return result;
  }

  /// Exclusively available for unit and widget tests to mint an authorized token.
  @visibleForTesting
  static AdminElevationToken mintForTesting() => const AdminElevationToken._();
}
