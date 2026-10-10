import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
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
                  gradientColors: const [Color(0xFF0D7377), Color(0xFF159A8C)],
                  onBack: () => Navigator.pop(context),
                ),
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF0D7377), Color(0xFF159A8C)]),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 31,
                      backgroundColor: Colors.white.withValues(alpha: .2),
                      child: const Icon(Icons.child_care_rounded,
                          color: Colors.white, size: 34),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                              state.userName.isEmpty
                                  ? 'শিক্ষার্থী'
                                  : state.userName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                          Text(
                              'শেখার স্ট্রিক ${state.streakDays} দিন · ${state.xp} XP',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ])),
                  ]),
                ),
                const SizedBox(height: 14),
                DuolingoCard(
                  accentColor: AppTheme.primaryGreen,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('শিক্ষার্থীর তথ্য',
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 13),
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              labelText: 'নাম',
                              prefixIcon: Icon(Icons.person_outline_rounded)),
                        ),
                        const SizedBox(height: 13),
                        DropdownButtonFormField<int>(
                          value: _age,
                          decoration: const InputDecoration(
                              labelText: 'বয়স',
                              prefixIcon: Icon(Icons.cake_outlined)),
                          items: [
                            for (var age = 6; age <= 14; age++)
                              DropdownMenuItem(
                                  value: age, child: Text('$age বছর'))
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
                                      content: Text('প্রোফাইল সংরক্ষণ হয়েছে')));
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('প্রোফাইল সংরক্ষণ'),
                            style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 14),
                DuolingoCard(
                  accentColor: const Color(0xFF58CC02),
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(17),
                  child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.verified_user_rounded,
                              color: AppTheme.primaryGreen),
                          SizedBox(width: 9),
                          Text('Account login ও sync',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15))
                        ]),
                        SizedBox(height: 8),
                        Text(
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
                    label: const Text('Login / account তৈরি'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      side: const BorderSide(color: AppTheme.primaryGreen),
                    ),
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
