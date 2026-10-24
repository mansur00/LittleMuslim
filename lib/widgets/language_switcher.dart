import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/core.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/app_state.dart';

/// Interactive, scalable language selector widget.
///
/// Supports 20+ languages with:
/// - Native names (বাংলা, English, हिंदी, Italiano)
/// - Real-time searchable dialog/modal bottom sheet
/// - Direct DropdownButton compatibility
class SearchableLanguageSelector extends StatelessWidget {
  const SearchableLanguageSelector({
    super.key,
    this.showSearchButton = true,
  });

  final bool showSearchButton;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final currentCode = AppLanguages.validate(state.selectedLanguage);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: currentCode,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primaryGreen),
          items: AppLanguages.all
              .map((lang) => DropdownMenuItem(
                    value: lang.code,
                    child: Text(
                      lang.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ))
              .toList(),
          onChanged: (language) {
            if (language != null) {
              context.read<AppState>().updateLanguage(language);
              try {
                context.read<LanguageProvider>().setLanguage(language);
              } catch (_) {}
            }
          },
        ),
        if (showSearchButton) ...[
          const SizedBox(width: 4),
          IconButton(
            tooltip: context.t('language.search_language'),
            icon: const Icon(Icons.search_rounded, size: 20, color: AppTheme.primaryGreen),
            onPressed: () => showSearchableLanguageSheet(context),
          ),
        ],
      ],
    );
  }
}

/// Opens a searchable bottom sheet allowing users to filter through 20+ languages
/// by native script, English name, or 2-letter language code.
void showSearchableLanguageSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (modalContext) => const _SearchableLanguageSheetContent(),
  );
}

class _SearchableLanguageSheetContent extends StatefulWidget {
  const _SearchableLanguageSheetContent();

  @override
  State<_SearchableLanguageSheetContent> createState() =>
      _SearchableLanguageSheetContentState();
}

class _SearchableLanguageSheetContentState
    extends State<_SearchableLanguageSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final activeCode = AppLanguages.validate(appState.selectedLanguage);

    final filteredLanguages = AppLanguages.all.where((lang) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return lang.name.toLowerCase().contains(q) ||
          lang.nativeName.toLowerCase().contains(q) ||
          lang.englishName.toLowerCase().contains(q) ||
          lang.code.toLowerCase().contains(q);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.language_rounded, color: AppTheme.primaryGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: LocalizedText(
                    'choose_language',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Search Input
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.t('language.search_hint'),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
            const SizedBox(height: 12),
            // Language list
            Expanded(
              child: filteredLanguages.isEmpty
                  ? Center(
                      child: Text(
                        context.t('language.no_language_found'),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: filteredLanguages.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final lang = filteredLanguages[index];
                        final isSelected = lang.code == activeCode;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          leading: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryGreen.withOpacity(0.12)
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              lang.code.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isSelected
                                    ? AppTheme.primaryGreen
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          title: Text(
                            lang.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : AppTheme.darkText,
                            ),
                          ),
                          subtitle: lang.englishName.isNotEmpty &&
                                  lang.englishName != lang.name
                              ? Text(
                                  lang.englishName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              : null,
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded,
                                  color: AppTheme.primaryGreen)
                              : null,
                          onTap: () {
                            context.read<AppState>().updateLanguage(lang.code);
                            try {
                              context.read<LanguageProvider>().setLanguage(lang.code);
                            } catch (_) {}
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
