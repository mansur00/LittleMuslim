import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/ds/parental_gate_dialog.dart';
import '../../widgets/faceless_silhouette.dart';

class NameAgePage extends StatefulWidget {
  final bool isTablet;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const NameAgePage({
    super.key,
    required this.isTablet,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<NameAgePage> createState() => _NameAgePageState();
}

class _NameAgePageState extends State<NameAgePage> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAge = 8;
  String _selectedRole = 'child';
  String _selectedAvatarType = 'topi';
  int _selectedAvatarColor = 0xFF10B981;
  final List<int> _ages = List.generate(9, (i) => i + 6); // 6 to 14
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = context.read<AppState>();
      if (appState.draftName.isNotEmpty) {
        _nameController.text = appState.draftName;
      }
      _selectedAge = appState.draftAge;
      _selectedRole = appState.draftRole;
      _selectedAvatarType = appState.draftAvatarType;
      _selectedAvatarColor = appState.draftAvatarColor;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 64 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Mascot speech row
          Row(
            children: [
              Container(
                width: widget.isTablet ? 64 : 50,
                height: widget.isTablet ? 64 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: DS.green500, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Center(
                    child: FacelessSilhouette(
                      size: widget.isTablet ? 48 : 38,
                      pose: SilhouettePose.reading,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DS.rLg),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        offset: Offset(0, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    context.t('onboarding.who_will_use'),
                    style: TextStyle(
                      fontSize: widget.isTablet ? 17 : 14,
                      fontWeight: DS.black,
                      color: DS.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.2, end: 0),

          const SizedBox(height: 16),

          // User Role Selector (Original Child vs Admin Tester)
          Text(
            context.t('onboarding.user_type'),
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 15,
              fontWeight: DS.black,
              color: DS.textPrimary,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

          const SizedBox(height: 10),

          Row(
            children: [
              // 1. Regular Student
              Expanded(
                child: _RoleCard(
                  title: context.t('onboarding.role_student_title'),
                  subtitle: context.t('onboarding.role_student_sub'),
                  badge: context.t('onboarding.role_student_badge'),
                  icon: Icons.child_care_rounded,
                  color: DS.green500,
                  shadowColor: DS.green600,
                  isSelected: _selectedRole == 'child',
                  onTap: () {
                    setState(() {
                      _selectedRole = 'child';
                      if (_nameController.text == 'Admin') {
                        _nameController.clear();
                        context.read<AppState>().updateDraftName('');
                      }
                    });
                    context.read<AppState>().updateDraftRole('child');
                  },
                ),
              ),
              const SizedBox(width: 12),
              // 2. Admin Tester
              Expanded(
                child: _RoleCard(
                  title: context.t('onboarding.role_admin_title'),
                  subtitle: context.t('onboarding.role_admin_sub'),
                  badge: context.t('onboarding.role_admin_badge'),
                  icon: Icons.admin_panel_settings_rounded,
                  color: DS.orange500,
                  shadowColor: DS.orange600,
                  isSelected: _selectedRole == 'admin',
                  onTap: () async {
                    final token = await ParentalGate.verify(context);
                    if (token == null || !mounted) return;
                    context.read<AppState>().setPendingAdminToken(token);
                    setState(() {
                      _selectedRole = 'admin';
                      if (_nameController.text.trim().isEmpty) {
                        _nameController.text = 'Admin';
                        context.read<AppState>().updateDraftName('Admin');
                      }
                    });
                    context.read<AppState>().updateDraftRole('admin');
                  },
                ),
              ),
            ],
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

          const SizedBox(height: 20),

          Text(
            context.t('onboarding.enter_name'),
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 15,
              fontWeight: DS.black,
              color: DS.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 350.ms),

          const SizedBox(height: 8),

          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              fontSize: widget.isTablet ? 17 : 15,
              fontWeight: DS.bold,
              color: DS.textPrimary,
            ),
            onChanged: (value) {
              context.read<AppState>().updateDraftName(value);
            },
            decoration: InputDecoration(
              hintText: context.t('onboarding.name_hint_examples'),
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: widget.isTablet ? 18 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.rLg),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.rLg),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.rLg),
                borderSide: const BorderSide(color: DS.green500, width: 2.5),
              ),
              prefixIcon: const Icon(Icons.person_rounded, color: DS.green500),
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 350.ms),

          const SizedBox(height: 20),

          Text(
            context.t('onboarding.select_age'),
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 15,
              fontWeight: DS.black,
              color: DS.textPrimary,
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 350.ms),

          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ages.map((age) {
              final isSelected = _selectedAge == age;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAge = age);
                  context.read<AppState>().updateDraftAge(age);
                },
                child: SizedBox(
                  width: widget.isTablet ? 56 : 46,
                  height: widget.isTablet ? 56 : 46,
                  child: Stack(
                    children: [
                      // Bevel
                      Positioned.fill(
                        top: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? DS.green600 : const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(DS.rMd),
                          ),
                        ),
                      ),
                      // Face
                      Positioned(
                        top: 0,
                        bottom: 3,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? DS.green500 : Colors.white,
                            borderRadius: BorderRadius.circular(DS.rMd),
                            border: Border.all(
                              color: isSelected ? DS.green600 : const Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '$age',
                            style: TextStyle(
                              fontSize: widget.isTablet ? 18 : 16,
                              fontWeight: DS.black,
                              color: isSelected ? Colors.white : DS.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

          const SizedBox(height: 20),

          // Avatar & Color Picker Section (Prani-chhara Faceless Silhouette)
          Text(
            context.t('onboarding.avatar_color_picker_title'),
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 15,
              fontWeight: DS.black,
              color: DS.textPrimary,
            ),
          ).animate().fadeIn(delay: 380.ms, duration: 350.ms),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(DS.rLg),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                // Live preview & type toggle
                Row(
                  children: [
                    // Avatar Silhouette Circle Preview
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: widget.isTablet ? 68 : 58,
                      height: widget.isTablet ? 68 : 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(_selectedAvatarColor).withValues(alpha: 0.12),
                        border: Border.all(
                          color: Color(_selectedAvatarColor),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(_selectedAvatarColor).withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FacelessSilhouette(
                          size: widget.isTablet ? 50 : 42,
                          type: SilhouetteType.fromString(_selectedAvatarType),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Type selector buttons
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _AvatarTypeChip(
                              title: context.t('avatar.cap_topi'),
                              icon: Icons.person_rounded,
                              isSelected: _selectedAvatarType == 'topi',
                              activeColor: Color(_selectedAvatarColor),
                              onTap: () {
                                setState(() => _selectedAvatarType = 'topi');
                                context.read<AppState>().updateDraftAvatar(type: 'topi');
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _AvatarTypeChip(
                              title: context.t('avatar.hijab'),
                              icon: Icons.face_3_rounded,
                              isSelected: _selectedAvatarType == 'hijab',
                              activeColor: Color(_selectedAvatarColor),
                              onTap: () {
                                setState(() => _selectedAvatarType = 'hijab');
                                context.read<AppState>().updateDraftAvatar(type: 'hijab');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFF3F4F6), height: 1),
                const SizedBox(height: 10),
                // Color palette row
                Row(
                  children: [
                    Text(
                      context.t('avatar.color_label'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: kAvatarColors.map((col) {
                          final isSelected = col.value == _selectedAvatarColor;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedAvatarColor = col.value);
                              context.read<AppState>().updateDraftAvatar(color: col.value);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: widget.isTablet ? 30 : 26,
                              height: widget.isTablet ? 30 : 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: col,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: col.withValues(alpha: isSelected ? 0.45 : 0.15),
                                    blurRadius: isSelected ? 6 : 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _selectedRole == 'admin'
                  ? const Color(0xFFFEF3C7)
                  : AppTheme.lightGold.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _selectedRole == 'admin'
                    ? const Color(0xFFF59E0B)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedRole == 'admin'
                      ? Icons.admin_panel_settings_rounded
                      : Icons.lightbulb_rounded,
                  size: 22,
                  color: _selectedRole == 'admin'
                      ? const Color(0xFFD97706)
                      : const Color(0xFFD4A017),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedRole == 'admin'
                        ? context.t('onboarding.admin_mode_notice')
                        : context.t('onboarding.student_mode_notice'),
                    style: TextStyle(
                      fontSize: widget.isTablet ? 13.5 : 12,
                      color: _selectedRole == 'admin'
                          ? const Color(0xFF92400E)
                          : AppTheme.darkText.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms, duration: 400.ms),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;
  final Color shadowColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
    required this.shadowColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: isSelected ? 2.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? shadowColor.withValues(alpha: 0.25)
                  : const Color(0x0C000000),
              offset: const Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? color : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected ? color : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: isSelected ? color : DS.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarTypeChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _AvatarTypeChip({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.12) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? activeColor : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
