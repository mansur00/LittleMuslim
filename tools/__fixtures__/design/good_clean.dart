import 'package:flutter/material.dart';
import 'package:little_muslim/widgets/ds/ds.dart';

Widget buildGoodTokenUsage(BuildContext context) {
  return AppCard(
    margin: AppSpacing.insetMd,
    child: Text(
      'Clean',
      style: AppTextStyles.body(context, color: AppColors.textPrimary),
    ),
  );
}
