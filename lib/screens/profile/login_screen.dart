import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ds/app_card.dart';
import '../../widgets/ds/app_top_bar.dart';
import '../../widgets/duolingo_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _createAccount = false;
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar.page(
        title: _createAccount
            ? context.t('login.new_account')
            : context.t('login.welcome_back'),
        subtitle: context.t('login.subtitle'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: EdgeInsets.all(tablet ? AppSpacing.xxl : AppSpacing.lg),
              children: [
                Text(
                  _createAccount
                      ? context.t('login.create_account_title')
                      : context.t('login.welcome_back'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 23,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                Text(
                    context.t('login.parent_email_hint'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 13, height: 1.5)),
                const SizedBox(height: 24),
                AppCard(
                  borderColor: AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: context.t('login.parent_email_label'),
                          prefixIcon: const Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: context.t('login.password_label'),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: Duolingo3DButton(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  context.t('login.service_unavailable_snack'))),
                        ),
                        text: _createAccount
                            ? context.t('login.create_account_button')
                            : context.t('login.login_button'),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _createAccount = !_createAccount),
                      child: Text(_createAccount
                          ? context.t('login.already_have_account')
                          : context.t('login.need_new_account')),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF0D1),
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    context.t('login.preview_notice'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF795A16), fontSize: 11, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
