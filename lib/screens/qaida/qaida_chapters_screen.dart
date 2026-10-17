import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/qaida_curriculum_data.dart';
import '../../models/qaida/qaida_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import 'qaida_track_lessons_screen.dart';

int _trackCompletedCount(AppState state, QaidaTrackInfo track) {
  return track.lessons
      .where((lesson) => state.hasCompletedLesson(lesson.id))
      .length;
}

bool _isTrackUnlocked(AppState state, int trackIndex) {
  if (state.isAdmin) return true;
  if (trackIndex == 0) return true;
  final previousTrack = QaidaCurriculumData.tracks[trackIndex - 1];
  // Unlock next track if at least 70% or all of previous track completed
  final count = _trackCompletedCount(state, previousTrack);
  return count >= (previousTrack.totalLessons * 0.7).ceil();
}

void _openTrack(BuildContext context, QaidaTrackInfo track) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => QaidaTrackLessonsScreen(track: track),
    ),
  );
}

class QaidaChaptersScreen extends StatelessWidget {
  const QaidaChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final tracks = QaidaCurriculumData.tracks;
    final completedTracks = tracks
        .where((t) => _trackCompletedCount(state, t) == t.totalLessons)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: ListView(
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                _ChapterHeader(
                  onBack: () => Navigator.pop(context),
                  progress: completedTracks,
                  total: tracks.length,
                ),
                const SizedBox(height: 16),
                _PathBanner(
                  completedTracks: completedTracks,
                  totalTracks: tracks.length,
                  isAdmin: state.isAdmin,
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < tracks.length; i++) ...[
                  _QaidaTrackCard(
                    track: tracks[i],
                    index: i,
                    state: state,
                    locked: !_isTrackUnlocked(state, i),
                    onTap: () => _openTrack(context, tracks[i]),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact chapter list shown directly on Home as the Qaida learning path.
class QaidaChapterPath extends StatelessWidget {
  const QaidaChapterPath({super.key, required this.isTablet});
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final tracks = QaidaCurriculumData.tracks;
    final completed = tracks
        .where((t) => _trackCompletedCount(state, t) == t.totalLessons)
        .length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 36 : 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ক্বায়দা · ৮টি ট্র্যাকের পূর্ণ পাঠ্যক্রম',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completed/${tracks.length} ট্র্যাক',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: tracks.isNotEmpty ? completed / tracks.length : 0,
              minHeight: 9,
              backgroundColor: const Color(0xFFE2E8F0),
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => SizedBox(
                width: isTablet ? 190 : 160,
                child: _QaidaTrackCard(
                  track: tracks[i],
                  index: i,
                  state: state,
                  locked: !_isTrackUnlocked(state, i),
                  compact: true,
                  onTap: () => _openTrack(context, tracks[i]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'হরফ → রূপভেদ → হরকত/তানউইন → ১০ মাদ্দ → গুন্নাহ → যুক্তাক্ষর → শব্দ → আয়াত',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({
    required this.onBack,
    required this.progress,
    required this.total,
  });

  final VoidCallback onBack;
  final int progress;
  final int total;

  @override
  Widget build(BuildContext context) => DuolingoPageHeader(
        title: 'ক্বায়দা শিক্ষাক্রম',
        subtitle: 'সহীহ কুরআন শিক্ষার ৮টি স্তর',
        iconType: VectorIconType.qaida,
        gradientColors: const [Color(0xFF0D7377), Color(0xFF14919B)],
        onBack: onBack,
        trailing: Text(
          '$progress/$total সম্পন্ন',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}

class _PathBanner extends StatelessWidget {
  const _PathBanner({
    required this.completedTracks,
    required this.totalTracks,
    required this.isAdmin,
  });

  final int completedTracks;
  final int totalTracks;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D7377), Color(0xFF14919B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF096266),
            blurRadius: 0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'নূরানী ক্বায়দা মাস্টারি সিস্টেম',
                  style: GoogleFonts.hindSiliguri(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (isAdmin)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_open_rounded,
                          size: 14, color: Colors.black87),
                      SizedBox(width: 4),
                      Text(
                        'এডমিন মোড',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isAdmin
                ? 'এডমিন হিসেবে আপনি সকল ট্র্যাক ও পাঠ সরাসরি পরীক্ষা ও অনুশীলন করতে পারবেন।'
                : 'প্রতিটি স্তরের প্রয়োজনীয় পাঠ শেষ হলে পরবর্তী স্তর উন্মুক্ত হবে।',
            style: GoogleFonts.hindSiliguri(
              color: Colors.white.withOpacity(0.95),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalTracks > 0 ? completedTracks / totalTracks : 0,
              minHeight: 10,
              backgroundColor: Colors.white30,
              color: const Color(0xFFFFD66B),
            ),
          ),
        ],
      ),
    );
  }
}

class _QaidaTrackCard extends StatelessWidget {
  const _QaidaTrackCard({
    required this.track,
    required this.index,
    required this.state,
    required this.locked,
    required this.onTap,
    this.compact = false,
  });

  final QaidaTrackInfo track;
  final int index;
  final AppState state;
  final bool locked;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final done = _trackCompletedCount(state, track);
    final total = track.totalLessons;
    final complete = done == total && total > 0;

    return Container(
      decoration: BoxDecoration(
        color: locked ? const Color(0xFFF1F5F9) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: complete
              ? AppTheme.duoGreen
              : (locked ? const Color(0xFFE2E8F0) : const Color(0xFFE2E8F0)),
          width: complete ? 2.5 : 1.5,
        ),
        boxShadow: locked
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: track.color.withOpacity(0.15),
                            child: Icon(
                              locked
                                  ? Icons.lock_rounded
                                  : (complete
                                      ? Icons.check_rounded
                                      : track.icon),
                              color: locked
                                  ? const Color(0xFF94A3B8)
                                  : track.color,
                              size: 18,
                            ),
                          ),
                          Text(
                            track.arabicTitle,
                            style: TextStyle(
                              fontFamily: AppTheme.arabicFontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: locked
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF475569),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: locked
                              ? const Color(0xFF94A3B8)
                              : AppTheme.darkText,
                        ),
                      ),
                      Text(
                        locked ? 'লক করা' : '$done/$total পাঠ সম্পন্ন',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: locked
                              ? const Color(0xFF94A3B8)
                              : AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: track.color.withOpacity(0.15),
                        child: Icon(
                          locked
                              ? Icons.lock_rounded
                              : (complete ? Icons.check_rounded : track.icon),
                          color: locked
                              ? const Color(0xFF94A3B8)
                              : track.color,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ট্র্যাক ${track.trackNumber}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: track.color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  track.arabicTitle,
                                  style: TextStyle(
                                    fontFamily: AppTheme.arabicFontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF64748B),
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              track.title,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: locked
                                    ? const Color(0xFF94A3B8)
                                    : AppTheme.darkText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              locked
                                  ? 'আগের ট্র্যাক শেষ হলে খুলবে'
                                  : '${track.subtitle} · $done/$total পাঠ সম্পন্ন',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 12,
                                color: locked
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        locked
                            ? Icons.lock_rounded
                            : (complete
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_ios_rounded),
                        size: 20,
                        color: complete
                            ? AppTheme.duoGreen
                            : (locked
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
