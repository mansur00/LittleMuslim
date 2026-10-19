import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/faceless_silhouette.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late int _age;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _nameController = TextEditingController(text: state.userName);
    _age = state.age;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                DuolingoPageHeader(
                  title: 'প্রোফাইল ও অ্যাকাউন্ট',
                  subtitle: 'তোমার শেখার পরিচয় ও অগ্রগতি',
                  iconType: VectorIconType.smile,
                  gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
                  onBack: () => Navigator.pop(context),
                ),
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF58CC02), Color(0xFF46A302)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF46A302).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () => showAvatarCustomizerModal(context),
                      child: Tooltip(
                        message: 'অবতার ও রঙ পরিবর্তন করুন',
                        child: Stack(
                          children: [
                            const FacelessSilhouette(
                              size: 62,
                              circleBackground: true,
                              backgroundColor: Colors.white,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFD54F),
                                ),
                                child: const Icon(Icons.edit, size: 12, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          LocalizedText(
                              state.userName.isEmpty
                                  ? 'শিক্ষার্থী'
                                  : state.userName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                          LocalizedText(
                              'শেখার স্ট্রিক ${state.streakDays} দিন · ${state.xp} XP',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ])),
                  ]),
                ),
                const SizedBox(height: 14),
                // User Mode Switcher (Admin / Regular Child)
                DuolingoCard(
                  accentColor: state.isAdmin ? const Color(0xFFF59E0B) : AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.isAdmin
                                ? Icons.admin_panel_settings_rounded
                                : Icons.child_care_rounded,
                            color: state.isAdmin ? const Color(0xFFD97706) : AppTheme.primaryGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LocalizedText(
                                  state.isAdmin
                                      ? '🛠️ অ্যাডমিন মোড (সব আনলক)'
                                      : '👶 মূল শিক্ষার্থী মোড',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    color: state.isAdmin ? const Color(0xFFB45309) : AppTheme.darkText,
                                  ),
                                ),
                                LocalizedText(
                                  state.isAdmin
                                      ? 'সব লেসন, ক্বায়দা, কুইজ ও ধাপ ১০০% আনলক আছে'
                                      : 'স্বাভাবিক নিয়মে ক্রমান্বয়ে লেসন আনলক হবে',
                                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await state.toggleAdminMode();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: LocalizedText(
                                        state.isAdmin
                                            ? '🛠️ অ্যাডমিন মোড চালু: সব ধাপ আনলক!'
                                            : '👶 শিক্ষার্থী মোড চালু: স্বাভাবিক লক নিয়ম সক্রিয়!',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: state.isAdmin
                                          ? const Color(0xFFD97706)
                                          : AppTheme.primaryGreen,
                                    ),
                                  );
                              },
                              icon: Icon(
                                state.isAdmin ? Icons.swap_horiz_rounded : Icons.lock_open_rounded,
                                size: 18,
                              ),
                              label: LocalizedText(
                                state.isAdmin
                                    ? 'মূল শিক্ষার্থী মোডে যান'
                                    : 'অ্যাডমিন মোডে যান (সব আনলক)',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: state.isAdmin ? const Color(0xFFD97706) : AppTheme.primaryGreen,
                                side: BorderSide(
                                  color: state.isAdmin ? const Color(0xFFF59E0B) : AppTheme.primaryGreen,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                DuolingoCard(
                  accentColor: AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LocalizedText('শিক্ষার্থীর তথ্য',
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 13),
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              labelText: context.uiText('নাম'),
                              prefixIcon: const Icon(Icons.person_outline_rounded)),
                        ),
                        const SizedBox(height: 13),
                        DropdownButtonFormField<int>(
                          initialValue: _age,
                          decoration: InputDecoration(
                              labelText: context.uiText('বয়স'),
                              prefixIcon: const Icon(Icons.cake_outlined)),
                          items: [
                            for (var age = 6; age <= 14; age++)
                              DropdownMenuItem(
                                  value: age, child: LocalizedText('$age বছর'))
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _age = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () async {
                              await context.read<AppState>().updateProfile(
                                  name: _nameController.text, age: _age);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: LocalizedText(
                                          'প্রোফাইল সংরক্ষণ হয়েছে')));
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: const LocalizedText('প্রোফাইল সংরক্ষণ করুন'),
                            style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 14),
                const DuolingoCard(
                  accentColor: Color(0xFF58CC02),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(17),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.verified_user_rounded,
                              color: AppTheme.primaryGreen),
                          SizedBox(width: 9),
                          LocalizedText('Account login ও sync',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15))
                        ]),
                        SizedBox(height: 8),
                        LocalizedText(
                            'এই profile ও শেখার অগ্রগতি এখন এই ডিভাইসে সেভ হয়। Email/phone login, একাধিক device-এ sync ও password recovery চালু করতে authentication backend সংযোগ প্রয়োজন।',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                height: 1.55)),
                      ]),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    )),
                    icon: const Icon(Icons.login_rounded),
                    label: const LocalizedText('Login / account তৈরি'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      side: const BorderSide(color: AppTheme.primaryGreen),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      await context.read<AppState>().resetOnboarding();
                      if (!context.mounted) return;
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.black45),
                    label: const LocalizedText(
                      'অনবোর্ডিং আবার দেখুন / রিসেট করুন',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
