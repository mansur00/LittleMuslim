import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/vector_icons.dart';

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
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 22),
              children: [
                DuolingoPageHeader(
                  title: _createAccount ? 'নতুন account' : 'আবার স্বাগতম',
                  subtitle: 'অভিভাবকের account দিয়ে নিরাপদে যুক্ত হও',
                  iconType: VectorIconType.mosque,
                  gradientColors: const [Color(0xFF0D7377), Color(0xFF159A8C)],
                  onBack: () => Navigator.pop(context),
                ),
                LocalizedText(
                  _createAccount ? 'নতুন account তৈরি করো' : 'আবার স্বাগতম',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 23,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 7),
                const LocalizedText(
                    'অভিভাবকের email দিয়ে শিক্ষার্থীর profile সংযুক্ত করো',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black54, fontSize: 13, height: 1.5)),
                const SizedBox(height: 24),
                DuolingoCard(
                  accentColor: AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: context.uiText('অভিভাবকের email'),
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(height: 13),
                    TextField(
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: context.uiText('Password'),
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
                          const SnackBar(
                              content: LocalizedText(
                                  'Login service এখনো যুক্ত হয়নি; কোনো password সংরক্ষণ করা হয়নি।')),
                        ),
                        text: _createAccount ? 'Account তৈরি করো' : 'Login',
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _createAccount = !_createAccount),
                      child: LocalizedText(_createAccount
                          ? 'আগে থেকেই account আছে? Login'
                          : 'নতুন account তৈরি করো'),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF0D1),
                      borderRadius: BorderRadius.circular(16)),
                  child: const LocalizedText(
                    'এটি login page-এর preview। নিরাপদ account চালুর জন্য authentication backend, email verification ও password recovery যুক্ত করতে হবে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
