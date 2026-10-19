import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';

class _SeerahStory {
  const _SeerahStory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconType,
    required this.accent,
    required this.readTime,
    required this.reference,
    required this.body,
    required this.lesson,
    required this.color,
  });

  final String title, subtitle, readTime, reference, body, lesson;
  final String id;
  final VectorIconType iconType;
  final Color accent;
  final Color color;
}

const _stories = [
  // ── Level 1: Short & sweet (2 min) ──
  _SeerahStory(
    id: 'abu_umair',
    title: '\u0986\u09ac\u09c1 \u0989\u09ae\u09be\u0987\u09b0\u09c7\u09b0 \u099b\u09cb\u099f\u09cd\u099f \u09ac\u09a8\u09cd\u09a7\u09c1',
    subtitle: '\u09b6\u09bf\u09b6\u09c1\u09a6\u09c7\u09b0 \u09b8\u0999\u09cd\u0997\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u0995\u09cb\u09ae\u09b2 \u09ac\u09cd\u09af\u09ac\u09b9\u09be\u09b0',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    readTime: '\u09e8 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ec\u09e8\u09e6\u09e9',
    body: '\u0986\u09a8\u09be\u09b8 (\u09b0\u09be.)-\u098f\u09b0 \u099b\u09cb\u099f \u09ad\u09be\u0987 \u0986\u09ac\u09c1 \u0989\u09ae\u09be\u0987\u09b0\u09c7\u09b0 \u098f\u0995\u099f\u09bf \u099b\u09cb\u099f \u09aa\u09be\u0996\u09bf \u099b\u09bf\u09b2\u0964 \u09a8\u09ac\u09c0\u099c\u09bf \u202f\u09a4\u09be\u09a6\u09c7\u09b0 \u09ac\u09be\u09dc\u09bf\u09a4\u09c7 \u098f\u09b2\u09c7 \u09b8\u09cd\u09a8\u09c7\u09b9 \u0995\u09b0\u09c7 \u099b\u09c7\u09b2\u09c7\u099f\u09bf\u09b0 \u0996\u09cb\u0981\u099c \u09a8\u09bf\u09a4\u09c7\u09a8 \u098f\u09ac\u0982 \u09a4\u09be\u09b0 \u09aa\u09be\u0996\u09bf\u099f\u09bf\u09b0 \u0995\u09a5\u09be \u099c\u09bf\u099c\u09cd\u099e\u09c7\u09b8 \u0995\u09b0\u09a4\u09c7\u09a8\u0964 \u099b\u09cb\u099f\u09a6\u09c7\u09b0 \u0986\u09a8\u09a8\u09cd\u09a6\u09c7\u09b0 \u09ac\u09bf\u09b7\u09af\u09bc\u0993 \u09a4\u09bf\u09a8\u09bf \u09ae\u09a8 \u09a6\u09bf\u09af\u09bc\u09c7 \u09a6\u09c7\u0996\u09a4\u09c7\u09a8\u0964',
    lesson: '\u0995\u09be\u09b0\u09cb\u09b0 \u09b8\u0999\u09cd\u0997\u09c7 \u09ad\u09be\u09b2\u09cb \u09b8\u09ae\u09cd\u09aa\u09b0\u09cd\u0995 \u0997\u09dc\u09a4\u09c7 \u09a4\u09be\u09b0 \u09aa\u099b\u09a8\u09cd\u09a6\u09c7\u09b0 \u09ac\u09bf\u09b7\u09af\u09bc \u09ae\u09a8 \u09a6\u09bf\u09af\u09bc\u09c7 \u09b6\u09cb\u09a8\u09cb\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'hasan_kindness',
    title: '\u09b9\u09be\u09b8\u09be\u09a8 (\u09b0\u09be.)-\u098f\u09b0 \u09aa\u09cd\u09b0\u09a4\u09bf \u09ae\u09ae\u09a4\u09be',
    subtitle: '\u09a6\u09af\u09bc\u09be \u09a6\u09c7\u0996\u09be\u09a8\u09cb \u0986\u09ae\u09be\u09a6\u09c7\u09b0 \u09b8\u09c1\u09a8\u09cd\u09a6\u09b0 \u0985\u09ad\u09cd\u09af\u09be\u09b8',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    readTime: '\u09e8 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09eb\u09ef\u09ef\u09ed',
    body: '\u098f\u0995\u09a6\u09bf\u09a8 \u09a8\u09ac\u09c0\u099c\u09bf \u202f\u09a4\u09be\u0981\u09b0 \u09a8\u09be\u09a4\u09bf \u09b9\u09be\u09b8\u09be\u09a8 (\u09b0\u09be.)-\u0995\u09c7 \u09b8\u09cd\u09a8\u09c7\u09b9 \u0995\u09b0\u09b2\u09c7\u09a8\u0964 \u09aa\u09be\u09b6\u09c7 \u09a5\u09be\u0995\u09be \u098f\u0995\u099c\u09a8 \u09ac\u09b2\u09b2\u09c7\u09a8, \u09a4\u09bf\u09a8\u09bf \u09a8\u09bf\u099c\u09c7\u09b0 \u09b8\u09a8\u09cd\u09a4\u09be\u09a8\u09a6\u09c7\u09b0 \u0995\u09be\u0989\u0995\u09c7 \u099a\u09c1\u09ae\u09c1 \u09a6\u09c7\u09a8\u09a8\u09bf\u0964 \u09a8\u09ac\u09c0\u099c\u09bf \u202f\u09ac\u09c1\u099d\u09bf\u09af\u09bc\u09c7 \u09a6\u09bf\u09b2\u09c7\u09a8\u2014\u09af\u09c7 \u0985\u09a8\u09cd\u09af\u09c7\u09b0 \u09aa\u09cd\u09b0\u09a4\u09bf \u09a6\u09af\u09bc\u09be \u0995\u09b0\u09c7 \u09a8\u09be, \u09a4\u09be\u09b0 \u09aa\u09cd\u09b0\u09a4\u09bf\u0993 \u09a6\u09af\u09bc\u09be \u0995\u09b0\u09be \u09b9\u09af\u09bc \u09a8\u09be\u0964',
    lesson: '\u099b\u09cb\u099f-\u09ac\u09dc \u09b8\u09ac\u09be\u09b0 \u09b8\u0999\u09cd\u0997\u09c7 \u09a6\u09af\u09bc\u09be \u0993 \u09b8\u09cd\u09a8\u09c7\u09b9\u09c7\u09b0 \u0986\u099a\u09b0\u09a3 \u0995\u09b0\u09bf\u0964',
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'first_revelation',
    title: '\u09b9\u09c7\u09b0\u09be \u0997\u09c1\u09b9\u09be\u09af\u09bc \u09aa\u09cd\u09b0\u09a5\u09ae \u0993\u09b9\u09bf',
    subtitle: '\u099c\u09cd\u099e\u09be\u09a8 \u0993 \u09b8\u09a4\u09cd\u09af\u09c7\u09b0 \u098f\u0995 \u09a8\u09a4\u09c1\u09a8 \u09b6\u09c1\u09b0\u09c1',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    readTime: '\u09e9 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09e9',
    body: '\u09a8\u09ac\u09c1\u0993\u09af\u09bc\u09be\u09a4\u09c7\u09b0 \u0986\u0997\u09c7 \u09ae\u09c1\u09b9\u09be\u09ae\u09cd\u09ae\u09a6 \u202f \u09b9\u09c7\u09b0\u09be \u0997\u09c1\u09b9\u09be\u09af\u09bc \u09a8\u09bf\u09b0\u09bf\u09ac\u09bf\u09b2\u09bf \u09b8\u09ae\u09af\u09bc \u0995\u09be\u099f\u09be\u09a4\u09c7\u09a8\u0964 \u09b8\u09c7\u0996\u09be\u09a8\u09c7 \u09a4\u09be\u0981\u09b0 \u0995\u09be\u099b\u09c7 \u09aa\u09cd\u09b0\u09a5\u09ae \u0993\u09b9\u09bf \u0986\u09b8\u09c7\u0964 \u0996\u09be\u09a6\u09bf\u099c\u09be (\u09b0\u09be.) \u09a4\u09be\u0981\u0995\u09c7 \u09b8\u09be\u09b9\u09b8 \u0993 \u09b8\u09be\u09a8\u09cd\u09a4\u09cd\u09ac\u09a8\u09be \u09a6\u09c7\u09a8 \u098f\u09ac\u0982 \u09aa\u09be\u09b6\u09c7 \u09a6\u09be\u0981\u09dc\u09be\u09a8\u0964 \u098f\u09ad\u09be\u09ac\u09c7\u0987 \u0995\u09c1\u09b0\u0986\u09a8\u09c7\u09b0 \u09ac\u09be\u09b0\u09cd\u09a4\u09be \u09ae\u09be\u09a8\u09c1\u09b7\u09c7\u09b0 \u0995\u09be\u099b\u09c7 \u09aa\u09cc\u0981\u099b\u09be\u09a8\u09cb\u09b0 \u09b6\u09c1\u09b0\u09c1 \u09b9\u09af\u09bc\u0964',
    lesson: '\u0995\u09a0\u09bf\u09a8 \u09b8\u09ae\u09af\u09bc\u09c7 \u09aa\u09b0\u09bf\u09ac\u09be\u09b0\u09c7\u09b0 \u09ae\u09be\u09a8\u09c1\u09b7\u0995\u09c7 \u09b8\u09be\u09b9\u09b8 \u09a6\u09bf\u0987 \u098f\u09ac\u0982 \u09b8\u09a4\u09cd\u09af\u09c7\u09b0 \u09aa\u09be\u09b6\u09c7 \u09a5\u09be\u0995\u09bf\u0964',
    color: Color(0xFFE8F8D8),
  ),

  // ── Level 2: Medium stories (3-4 min) ──
  _SeerahStory(
    id: 'zamzam_baby',
    title: '\u099c\u09be\u09ae\u099c\u09be\u09ae\u09c7\u09b0 \u09aa\u09be\u09a8\u09bf\u09b0 \u0997\u09b2\u09cd\u09aa',
    subtitle: '\u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u0993\u09aa\u09b0 \u09ad\u09b0\u09b8\u09be\u09b0 \u09aa\u09c1\u09b0\u09b8\u09cd\u0995\u09be\u09b0',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF3B82C4),
    readTime: '\u09e9 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09e9\u09e7\u09eb\u09ea',
    body: '\u09b9\u09be\u099c\u09be\u09b0 (\u09b0\u09be.) \u09a4\u09be\u0981\u09b0 \u099b\u09cb\u099f \u09b6\u09bf\u09b6\u09c1 \u0987\u09b8\u09ae\u09be\u0987\u09b2\u0995\u09c7 \u09a8\u09bf\u09af\u09bc\u09c7 \u09ae\u0995\u09cd\u0995\u09be\u09b0 \u09ae\u09b0\u09c1\u09ad\u09c2\u09ae\u09bf\u09a4\u09c7 \u09a8\u09bf\u0983\u09b8\u0999\u09cd\u0997 \u09b9\u09af\u09bc\u09c7 \u09aa\u09dc\u09b2\u09c7\u09a8\u0964 \u09aa\u09be\u09a8\u09bf \u09b6\u09c7\u09b7 \u09b9\u09af\u09bc\u09c7 \u09af\u09be\u099a\u09cd\u099b\u09bf\u09b2\u0964 \u09a4\u09bf\u09a8\u09bf \u09b6\u09bf\u09b6\u09c1\u09b0 \u099c\u09a8\u09cd\u09af \u09aa\u09be\u09a8\u09bf \u0996\u09c1\u0981\u099c\u09a4\u09c7 \u09b8\u09be\u09ab\u09be \u09a8\u09be\u09ae\u09a6\u09c1\u09a8 \u09aa\u09be\u09b9\u09be\u09dc\u09c7\u09b0 \u09ae\u09be\u099d\u09c7 \u09a6\u09cc\u09dc\u09be\u09a8\u0964 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u09b9\u09c1\u0995\u09c1\u09ae\u09c7 \u09b6\u09bf\u09b6\u09c1\u09b0 \u09aa\u09be\u09df\u09c7\u09b0 \u09a8\u09bf\u099a\u09c7 \u09a5\u09c7\u0995\u09c7 \u099c\u09be\u09ae\u099c\u09be\u09ae\u09c7\u09b0 \u09aa\u09be\u09a8\u09bf \u09ac\u09c7\u09b0\u09bf\u09af\u09bc\u09c7 \u09b8\u09ac\u09be\u0995\u09c7 \u09b9\u09a4\u09ac\u09be\u0995 \u0995\u09b0\u09c7 \u09a6\u09bf\u09b2\u0964',
    lesson: '\u09b6\u09cd\u09b0\u09c7\u09b7\u09cd\u09a0\u09a4\u09ae \u09ac\u09bf\u09aa\u09a6\u09c7\u0993 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09c7\u09b0 \u0993\u09aa\u09b0 \u09ad\u09b0\u09b8\u09be \u09b0\u09be\u0996\u09bf\u0964 \u09a4\u09bf\u09a8\u09bf \u0995\u0996\u09a8\u09cb \u0986\u09ae\u09be\u09a6\u09c7\u09b0 \u09a6\u09bf\u0995\u09a8\u09bf\u09b0\u09cd\u09a6\u09c7\u09b6\u09a8\u09be \u09a6\u09c7\u09a8 \u09a8\u09be\u0964',
    color: Color(0xFFDCEBFF),
  ),
  _SeerahStory(
    id: 'kaaba_corner',
    title: '\u0995\u09be\u09ac\u09be \u09aa\u09c1\u09a8\u09b0\u09cd\u09a8\u09bf\u09b0\u09cd\u09ae\u09be\u09a3\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u09ac\u09bf\u099a\u09be\u09b0',
    subtitle: '\u09b8\u09ae\u09cd\u09aa\u09cd\u09b0\u09a6\u09be\u09af\u09bc\u09c7\u09b0 \u09ac\u09bf\u09ac\u09be\u09a6 \u09a5\u09be\u09ae\u09be\u09a8\u09cb',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF9B6BC9),
    readTime: '\u09e9 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ea\u09ef\u09eb',
    body: '\u0995\u09be\u09ac\u09be \u09aa\u09c1\u09a8\u09b0\u09cd\u09a8\u09bf\u09b0\u09cd\u09ae\u09be\u09a3\u09c7 \u09b9\u09be\u099c\u09be\u09b0\u09c7 \u0986\u09b8\u0993\u09af\u09be\u09a6 \u09aa\u09be\u09a5\u09b0 \u09b0\u09be\u0996\u09be \u09a8\u09bf\u09df\u09c7 \u0997\u09cb\u09a4\u09cd\u09b0\u09c7 \u0997\u09cb\u09a4\u09cd\u09b0\u09c7 \u09b0\u09c7\u09b7\u09be\u09b0\u09c7\u09b7\u09bf \u09b6\u09c1\u09b0\u09c1 \u09b9\u09af\u09bc\u0964 \u09ae\u09c1\u09b9\u09be\u09ae\u09cd\u09ae\u09be\u09a6 \u202f \u09ac\u09bf\u099c\u09cd\u099e\u09a4\u09be\u09b0 \u09b8\u09be\u09a5\u09c7 \u09b8\u09ac\u09be\u09b0 \u09ae\u09a7\u09cd\u09af\u09c7 \u09b6\u09cd\u09b0\u09c7\u09b7\u09cd\u09a0 \u09ac\u09cd\u09af\u0995\u09cd\u09a4\u09bf\u0995\u09c7 \u09ac\u09c7\u099b\u09c7 \u09a8\u09bf\u09a4\u09c7 \u09ac\u09b2\u09b2\u09c7\u09a8\u0964 \u09b8\u09ac\u09be\u0987 \u09b8\u09ae\u09cd\u09ae\u09a4 \u09b9\u09b2 \u09ae\u09c1\u09b9\u09be\u09ae\u09cd\u09ae\u09be\u09a6 \u202f-\u09b0 \u09aa\u09cd\u09b0\u09b8\u09cd\u09a4\u09be\u09ac\u09c7\u0964 \u09a4\u09bf\u09a8\u09bf \u09aa\u09be\u09a5\u09b0\u099f\u09bf \u09ac\u09dc \u09aa\u09b0\u09cd\u09a6\u09be\u09b0 \u0993\u09aa\u09b0 \u09b0\u09c7\u0996\u09c7 \u09aa\u09cd\u09b0\u09a4\u09bf\u099f\u09bf \u0997\u09cb\u09a4\u09cd\u09b0\u09aa\u09cd\u09b0\u09a7\u09be\u09a8\u0995\u09c7 \u09a7\u09b0\u09a4\u09c7 \u09ac\u09b2\u09b2\u09c7\u09a8 \u0964 \u09b8\u09ac\u09be\u09b0 \u09b8\u09b9\u09af\u09cb\u0997\u09bf\u09a4\u09be\u09af\u09bc \u09aa\u09be\u09a5\u09b0 \u09af\u09a5\u09be\u09b8\u09cd\u09a5\u09be\u09a8\u09c7 \u09b0\u09be\u0996\u09be \u09b9\u09b2\u0964',
    lesson: '\u09ac\u09bf\u09ac\u09be\u09a6 \u09a8\u09bf\u09b0\u09b8\u09a8\u09c7 \u09ac\u09c1\u09a6\u09cd\u09a7\u09bf\u09ae\u09a4\u09cd\u09a4\u09be \u09a6\u09bf\u09af\u09bc\u09c7 \u09b8\u09ac\u09be\u09b0 \u09ae\u09a4\u09be\u09ae\u09a4 \u09ac\u09bf\u09ac\u09c7\u099a\u09a8\u09be \u0995\u09b0\u09bf\u0964',
    color: Color(0xFFF3E8FF),
  ),
  _SeerahStory(
    id: 'khadija_trust',
    title: '\u0996\u09be\u09a6\u09bf\u099c\u09be (\u09b0\u09be.)\u09b0 \u09ac\u09bf\u09b6\u09cd\u09ac\u09be\u09b8',
    subtitle: '\u09b8\u09be\u09b9\u09b8\u09c0 \u09b8\u0999\u09cd\u0997\u09c0 \u09a5\u09be\u0995\u09be',
    iconType: VectorIconType.star,
    accent: Color(0xFFE05A7A),
    readTime: '\u09e9 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ea',
    body: '\u09a8\u09ac\u09c1\u0993\u09af\u09bc\u09be\u09a4\u09c7\u09b0 \u09aa\u09b0 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09ad\u09df\u09c7 \u0995\u09be\u0981\u09aa\u09a4\u09c7 \u0995\u09be\u0981\u09aa\u09a4\u09c7 \u0998\u09b0\u09c7 \u09ab\u09bf\u09b0\u09c7\u09b2\u09c7\u09a8\u0964 \u0996\u09be\u09a6\u09bf\u099c\u09be (\u09b0\u09be.) \u09a4\u09be\u0981\u0995\u09c7 \u09b6\u09be\u09a8\u09cd\u09a4 \u0995\u09b0\u09c7 \u09a6\u09bf\u09b2\u09c7\u09a8, \u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u0986\u09aa\u09a8\u09be\u0995\u09c7 \u0995\u0996\u09a8\u09cb \u09a8\u09bf\u09b0\u09be\u09b6 \u0995\u09b0\u09ac\u09c7\u09a8 \u09a8\u09be\u09b0\u09cd\u0964 \u09a4\u09bf\u09a8\u09bf \u09ac\u09b2\u09b2\u09c7\u09a8: \u09a4\u09c1\u09ae\u09bf \u0986\u09a4\u09cd\u09ae\u09c0\u09af\u09bc\u09a6\u09c7\u09b0 \u09b8\u09be\u09a5\u09c7 \u09ae\u09bf\u09b6\u09be\u0993, \u09b8\u09a4\u09cd\u09af \u09ac\u09b2\u09cb, \u0985\u09a8\u09cd\u09af\u09c7\u09b0 \u09a6\u09c1\u09b0\u09cd\u09a6\u09b6\u09be \u09b2\u09be\u0998\u09ac \u0995\u09b0\u09cb\u2014\u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u09a4\u09cb\u09ae\u09be\u09b0 \u09b8\u09be\u09a5\u09c7 \u0986\u099b\u09c7\u09a8\u0964',
    lesson: '\u09aa\u09be\u09b0\u09bf\u09ac\u09be\u09b0\u09bf\u0995 \u09ae\u09be\u09a8\u09c1\u09b7\u09c7\u09b0 \u09b8\u09be\u09b9\u09b8 \u0993 \u09ad\u09be\u09b2\u09cb\u09ac\u09be\u09b8\u09be \u0985\u09ae\u09c2\u09b2\u09cd\u09af\u0964',
    color: Color(0xFFFFEBCF),
  ),
  _SeerahStory(
    id: 'bilal_patience',
    title: '\u09ac\u09bf\u09b2\u09be\u09b2 (\u09b0\u09be.)\u09b0 \u09a7\u09c8\u09b0\u09cd\u09af',
    subtitle: '\u0995\u09b7\u09cd\u099f\u09c7\u09b0 \u09ae\u09be\u099d\u09c7\u0993 \u09b8\u09a4\u09cd\u09af \u0986\u0981\u0995\u09dc\u09c7 \u09a5\u09be\u0995\u09be',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    readTime: '\u09e3 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09bf\u09b0\u09be\u09a4\u09c1\u09a8 \u09a8\u09be\u09ac\u09be\u09ac\u09bf\u09af\u09bc\u09cd\u09af\u09be\u09b9',
    body: '\u09ae\u0995\u09cd\u0995\u09be\u09b0 \u09a6\u09be\u09b8 \u09ac\u09bf\u09b2\u09be\u09b2 (\u09b0\u09be.) \u09b8\u09a4\u09cd\u09af\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09b8\u09a8\u09cd\u09a4\u09cd\u09b0\u09be\u09b8 \u09ad\u09cb\u0997 \u0995\u09b0\u09a4\u09c7\u09a8\u0964 \u0997\u09b0\u09ae \u09ac\u09be\u09b2\u09c1\u09b0 \u0993\u09aa\u09b0 \u09b6\u09c1\u09df\u09bc\u09c7 \u09a4\u09be\u0981\u0995\u09c7 \u0995\u09b7\u09cd\u099f \u09a6\u09c7\u0993\u09af\u09bc\u09be \u09b9\u09a4\u09cb\u0964 \u09a4\u09bf\u09a8\u09bf \u09a4\u09be\u09b0\u09aa\u09b0\u0993 \u09ac\u09b2\u09a4\u09c7\u09a8 \u201c\u0986\u09b9\u09be\u09a6! \u0986\u09b9\u09be\u09a6!\u201d\u2014 \u0985\u09b0\u09cd\u09a5\u09be\u09ce \u09a4\u09bf\u09a8\u09bf \u098f\u0995 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09c7 \u09ac\u09bf\u09b6\u09cd\u09ac\u09be\u09b8 \u0995\u09b0\u09c7\u09a8\u0964 \u09aa\u09b0\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u202f \u09aa\u0995\u09cd\u09b7\u09c7 \u0986\u09ac\u09c1 \u09ac\u0995\u09b0 (\u09b0\u09be.) \u09a4\u09be\u0981\u0995\u09c7 \u09ae\u09c1\u0995\u09cd\u09a4 \u0995\u09b0\u09c7\u09a8\u0964',
    lesson: '\u09b8\u09a4\u09cd\u09af \u0993 \u09ac\u09bf\u09b6\u09cd\u09ac\u09be\u09b8\u09c7\u09b0 \u09aa\u09a5\u09c7 \u0995\u09b7\u09cd\u099f \u0986\u09b8\u09b2\u09c7\u0993 \u09a7\u09c8\u09b0\u09cd\u09af \u09b0\u09be\u0996\u09bf\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'anas_servant',
    title: '\u0986\u09a8\u09be\u09b8 (\u09b0\u09be.)\u09b0 \u09b8\u09c7\u09ac\u09be',
    subtitle: '\u09b8\u09cd\u09a8\u09c7\u09b9 \u0993 \u0995\u09c3\u09a4\u099c\u09cd\u099e\u09a4\u09be',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    readTime: '\u09e3 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ec\u09e8\u09e6\u09e8',
    body: '\u0986\u09a8\u09be\u09b8 (\u09b0\u09be.) \u09ac\u09b2\u09c7\u09a8, \u0986\u09ae\u09bf \u09a6\u09b6 \u09ac\u099b\u09b0 \u09a7\u09b0\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u202f \u09b8\u09c7\u09ac\u09be \u0995\u09b0\u09c7\u099b\u09bf\u0964 \u09a4\u09bf\u09a8\u09bf \u09b6\u09bf\u09b6\u09c1\u09ac\u09df\u09b8 \u09a5\u09c7\u0995\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u09b8\u0999\u09cd\u0997\u09c7 \u099c\u09c0\u09ac\u09a8 \u0995\u09be\u099f\u09bf\u09af\u09bc\u09c7\u099b\u09bf\u09b2\u09c7\u09a8\u0964 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u0995\u0996\u09a8\u09cb \u09a4\u09be\u0981\u0995\u09c7 \u09a4\u09bf\u09b0\u09b8\u09cd\u0995\u09be\u09b0 \u0995\u09b0\u09c7\u09a8\u09a8\u09bf, \u0995\u09cb\u09a8\u09cb \u0995\u09be\u099c \u0995\u09c7\u09a8 \u0995\u09b0\u09b2\u09c7 \u09ac\u09be \u0995\u09c7\u09a8 \u0995\u09b0\u09b2\u09c7 \u09a8\u09be \u09a4\u09be\u09b0 \u09aa\u09cd\u09b0\u09b6\u09cd\u09a8\u0993 \u09a4\u09c1\u09b2\u09a4\u09c7\u09a8 \u09a8\u09be\u0964',
    lesson: '\u09af\u09be\u09b0\u09be \u0986\u09ae\u09be\u09a6\u09c7\u09b0 \u09b8\u09be\u09a5\u09c7 \u0995\u09be\u099c \u0995\u09b0\u09c7 \u09a4\u09be\u09a6\u09c7\u09b0 \u09aa\u09cd\u09b0\u09a4\u09bf \u09b8\u09a6\u09af\u09bc \u09b9\u0987\u0964',
    color: Color(0xFFFFF6D0),
  ),

  // ── Level 3: Detailed stories (4-5 min) ──
  _SeerahStory(
    id: 'migration_madina',
    title: '\u09ae\u09a6\u09bf\u09a8\u09be\u09af\u09bc \u09b9\u09bf\u099c\u09b0\u09a4',
    subtitle: '\u09ad\u09af\u09bc\u09be\u09b2 \u09aa\u09a5\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u09ad\u09b0\u09b8\u09be',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    readTime: '\u09ea \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09e9\u09e6\u09ea\u09e7',
    body: '\u09ae\u0995\u09cd\u0995\u09be\u09b0 \u09ae\u09c1\u09b6\u09b0\u09bf\u0995\u09b0\u09be \u09a8\u09ac\u09c0\u099c\u09bf\u0995\u09c7 \u202f \u09b9\u09a4\u09cd\u09af\u09be\u09b0 \u09aa\u09b0\u09bf\u0995\u09b2\u09cd\u09aa\u09a8\u09be \u0995\u09b0\u09c7\u099b\u09bf\u09b2\u0964 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u09b9\u09c1\u0995\u09c1\u09ae\u09c7 \u09a4\u09bf\u09a8\u09bf \u0986\u09ac\u09c1 \u09ac\u0995\u09b0 (\u09b0\u09be.)-\u0995\u09c7 \u09b8\u0999\u09cd\u0997\u09c7 \u09a8\u09bf\u09af\u09bc\u09c7 \u09ae\u09a6\u09bf\u09a8\u09be\u09b0 \u09a6\u09bf\u0995\u09c7 \u09b9\u09bf\u099c\u09b0\u09a4 \u0995\u09b0\u09c7\u09a8\u0964 \u09aa\u09a5\u09c7 \u09a5\u09be\u0993\u09b0 \u0997\u09c1\u09b9\u09be\u09af\u09bc \u09b2\u09c1\u0995\u09bf\u09af\u09bc\u09c7 \u09a5\u09be\u0995\u09a4\u09c7 \u09b9\u09b2\u0964 \u0986\u09a8\u09be\u09b8 (\u09b0\u09be.) \u0996\u09be\u09ac\u09be\u09b0 \u09b8\u09b0\u09ac\u09b0\u09be\u09b9 \u0995\u09b0\u09a4\u09c7\u09a8, \u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u09aa\u09cd\u09b0\u09a4\u09bf \u09ad\u09b0\u09b8\u09be \u09b0\u09be\u0996\u09a4\u09c7 \u09b0\u09be\u0996\u09a4\u09c7 \u09a4\u09be\u0981\u09b0\u09be \u09b8\u09ab\u09b2\u09ad\u09be\u09ac\u09c7 \u09ae\u09a6\u09bf\u09a8\u09be\u09af\u09bc \u09aa\u09cc\u0981\u099b\u09be\u09a8\u09cd\u09a4\u09bf\u09a8\u0964',
    lesson: '\u0995\u09a0\u09bf\u09a8 \u09b8\u09bf\u09a6\u09cd\u09a7\u09be\u09a8\u09cd\u09a4 \u09a8\u09bf\u09a4\u09c7 \u09b9\u09b2\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u0993\u09aa\u09b0 \u09ad\u09b0\u09b8\u09be \u09b0\u09c7\u0996\u09c7 \u099a\u09b2\u09bf\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'badr_dua',
    title: '\u09ac\u09a6\u09b0\u09c7\u09b0 \u09af\u09c1\u09a6\u09cd\u09a7\u09c7 \u09a6\u09cb\u09af\u09bc\u09be',
    subtitle: '\u09ac\u09bf\u09aa\u09a6\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09c7\u09b0 \u09a6\u09b0\u09ac\u09be\u09b0\u09c7',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF3B82C4),
    readTime: '\u09ea \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae \u09ec\u09ea\u09eb',
    body: '\u09ac\u09a6\u09b0\u09c7\u09b0 \u09af\u09c1\u09a6\u09cd\u09a7\u09c7\u09b0 \u0986\u0997\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u0995\u09be\u099b\u09c7 \u09b8\u09be\u09b9\u09be\u09af\u09cd\u09af \u09aa\u09cd\u09b0\u09be\u09b0\u09cd\u09a5\u09a8\u09be \u0995\u09b0\u09b2\u09c7\u09a8\u0964 \u09a4\u09bf\u09a8\u09bf \u0985\u09b6\u09cd\u09b0\u09c1\u09b8\u09c0\u09a8 \u0995\u09a3\u09cd\u09a0\u09c7 \u09ac\u09b2\u09b2\u09c7\u09a8: \u201c\u09b9\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9, \u09a4\u09c1\u09ae\u09bf \u09af\u09a6\u09bf \u098f\u0987 \u09a6\u09b2\u0995\u09c7 \u09a8\u09b7\u09cd\u099f \u0995\u09b0\u09cb, \u09a4\u09be\u09b9\u09b2\u09c7 \u09aa\u09c3\u09a5\u09bf\u09ac\u09c0\u09a4\u09c7 \u09a4\u09cb\u09ae\u09be\u09b0 \u0987\u09ac\u09be\u09a6\u09a4 \u0995\u09be\u09b0\u09be \u0995\u09b0\u09ac\u09c7!\u201d \u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae\u09a6\u09c7\u09b0 \u09ac\u09bf\u099c\u09af\u09bc \u09a6\u09bf\u09a8\u09c7\u09a8\u0964',
    lesson: '\u09ac\u09bf\u09aa\u09a6\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u0995\u09be\u099b\u09c7 \u09b9\u09be\u09a4 \u09a4\u09c1\u09b2\u09bf; \u09a4\u09bf\u09a8\u09bf\u0987 \u09b8\u09c7\u09b0\u09be \u09b8\u09be\u09b9\u09be\u09af\u09cd\u09af\u0995\u09be\u09b0\u09c0\u0964',
    color: Color(0xFFDCEBFF),
  ),
  _SeerahStory(
    id: 'conquest_mercy',
    title: '\u09ae\u0995\u09cd\u0995\u09be \u09ac\u09bf\u099c\u09af\u09bc\u09c7\u09b0 \u09a6\u09bf\u09a8',
    subtitle: '\u0995\u09cd\u09b7\u09ae\u09be \u0993 \u09ae\u09b9\u09be\u09a8\u09c1\u09ad\u09ac\u09a4\u09be',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF9B6BC9),
    readTime: '\u09eb \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae \u09e7\u09e6\u09eb\u09ec',
    body: '\u09ae\u0995\u09cd\u0995\u09be \u09ac\u09bf\u099c\u09af\u09bc\u09c7\u09b0 \u09aa\u09b0 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09ae\u0995\u09cd\u0995\u09be\u09b0 \u09ae\u09be\u09a8\u09c1\u09b7\u09a6\u09c7\u09b0 \u09b8\u09be\u09ae\u09a8\u09c7 \u09a6\u09be\u0981\u09dc\u09bf\u09af\u09bc\u09c7 \u09ac\u09b2\u09b2\u09c7\u09a8: \u201c\u09a4\u09cb\u09ae\u09be\u09a6\u09c7\u09b0 \u09ac\u09bf\u09b0\u09c1\u09a6\u09cd\u09a7\u09c7 \u0986\u099c \u0995\u09cb\u09a8\u09cb \u0985\u09ad\u09bf\u09af\u09cb\u0997 \u09a8\u09c7\u0987\u2014\u09af\u09be\u0993, \u09a4\u09cb\u09ae\u09b0\u09be \u09b8\u09ac\u09be\u0987 \u09ae\u09c1\u0995\u09cd\u09a4\u0964\u201d \u09af\u09be\u09b0\u09be \u09a4\u09be\u0981\u0995\u09c7 \u09b8\u09ac\u099a\u09c7\u09af\u09bc\u09c7 \u09ac\u09c7\u09b6\u09bf \u0995\u09b7\u09cd\u099f \u09a6\u09bf\u09af\u09bc\u09c7\u099b\u09bf\u09b2 \u09a4\u09be\u09a6\u09c7\u09b0\u0995\u09c7\u0993 \u09a4\u09bf\u09a8\u09bf \u0995\u09cd\u09b7\u09ae\u09be \u0995\u09b0\u09b2\u09c7\u09a8\u0964',
    lesson: '\u09b6\u0995\u09cd\u09a4\u09bf\u09b6\u09be\u09b2\u09c0 \u09b9\u09af\u09bc\u09c7\u0993 \u0995\u09cd\u09b7\u09ae\u09be \u0995\u09b0\u09be\u0987 \u09b8\u09a4\u09cd\u09af\u09bf\u0995\u09be\u09b0\u09c7\u09b0 \u09ac\u09dc\u09a4\u09cd\u09ac\u0964',
    color: Color(0xFFF3E8FF),
  ),

  // ── Level 4: Richer stories (5-6 min) ──
  _SeerahStory(
    id: 'taif_patience',
    title: '\u09a4\u09be\u09af\u09bc\u09c7\u09ab\u09c7\u09b0 \u09a6\u09c1\u09ac\u09bf\u09b8\u09b9 \u09af\u09be\u09a4\u09cd\u09b0\u09be',
    subtitle: '\u0995\u09b7\u09cd\u099f\u09c7\u09b0 \u09aa\u09b0\u09c7\u0993 \u09ac\u09a6 \u09a6\u09cb\u09af\u09bc\u09be \u09a8\u09be \u0995\u09b0\u09be',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFFE8913A),
    readTime: '\u09eb \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09e9\u09e2\u09e7\u09e6',
    body: '\u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09a4\u09be\u09af\u09bc\u09c7\u09ab\u09c7\u09b0 \u09ae\u09be\u09a8\u09c1\u09b7\u09a6\u09c7\u09b0 \u0995\u09be\u099b\u09c7 \u0987\u09b8\u09b2\u09be\u09ae\u09c7\u09b0 \u09a6\u09be\u0993\u09af\u09bc\u09be\u09a4 \u09a6\u09bf\u09a4\u09c7 \u0997\u09bf\u09af\u09bc\u09c7\u099b\u09bf\u09b2\u09c7\u09a8\u0964 \u09a4\u09be\u09b0\u09be \u09a4\u09be\u0981\u0995\u09c7 \u09aa\u09be\u09a5\u09b0 \u099b\u09c1\u0981\u09dc\u09c7 \u09b6\u09b9\u09b0 \u09a5\u09c7\u0995\u09c7 \u09a4\u09be\u09dc\u09bf\u09af\u09bc\u09c7 \u09a6\u09bf\u09b2\u0964 \u09a4\u09bf\u09a8\u09bf \u09b0\u0995\u09cd\u09a4\u09be\u0995\u09cd\u09a4 \u09b9\u09df\u09c7\u0993 \u09a4\u09be\u09a6\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09ac\u09a6 \u09a6\u09cb\u09af\u09bc\u09be \u0995\u09b0\u09c7\u09a8\u09a8\u09bf\u0964 \u09ac\u09b0\u0982 \u09ac\u09b2\u09c7\u09a8: \u201c\u09b9\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9, \u098f\u09a6\u09c7\u09b0 \u09b9\u09bf\u09a6\u09be\u09af\u09bc\u09a4 \u09a6\u09be\u0993\u09b0\u0964 \u09a4\u09be\u09b0\u09be \u09af\u09be \u0995\u09b0\u09c7\u099b\u09c7 \u09a4\u09be \u09a8\u09be \u099c\u09c7\u09a8\u09c7\u0987 \u0995\u09b0\u09c7\u099b\u09c7\u0964\u201d',
    lesson: '\u0985\u09a8\u09cd\u09af\u09be\u09af\u09bc\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09ac\u09a6 \u09a6\u09cb\u09af\u09bc\u09be \u09a8\u09be \u0995\u09b0\u09c7 \u09b9\u09bf\u09a6\u09be\u09af\u09bc\u09a4\u09c7\u09b0 \u09a6\u09cb\u09af\u09bc\u09be \u0995\u09b0\u09bf\u0964',
    color: Color(0xFFFFEBCF),
  ),
  _SeerahStory(
    id: 'suleiman_wisdom',
    title: '\u09b9\u09be\u09b2\u09bf\u09ae\u09be (\u09b0\u09be.)\u09b0 \u0995\u09cb\u09b2\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf',
    subtitle: '\u09ae\u09be\u09a4\u09c3\u09a4\u09cd\u09ac \u0993 \u09b6\u09c8\u09b6\u09ac\u09c7\u09b0 \u09b8\u09cd\u09ae\u09c3\u09a4\u09bf',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    readTime: '\u09eb \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09bf\u09b0\u09be\u09a4\u09c1\u09a8 \u09a8\u09be\u09ac\u09be\u09ac\u09bf\u09af\u09bc\u09cd\u09af\u09be\u09b9',
    body: '\u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u202f \u09a6\u09c1\u09a7 \u09ae\u09be \u09b9\u09be\u09b2\u09bf\u09ae\u09be (\u09b0\u09be.) \u09a4\u09be\u0981\u0995\u09c7 \u09b2\u09be\u09b2\u09a8-\u09aa\u09be\u09b2\u09a8 \u0995\u09b0\u09c7\u099b\u09bf\u09b2\u09c7\u09a8\u0964 \u09b6\u09bf\u09b6\u09c1 \u09ae\u09c1\u09b9\u09be\u09ae\u09cd\u09ae\u09be\u09a6 \u202f \u09a4\u09be\u0981\u09b0 \u0995\u09cb\u09b2\u09c7 \u09ac\u09dc \u09b9\u09af\u09bc\u09c7\u099b\u09bf\u09b2\u09c7\u09a8\u0964 \u09ac\u09b9\u09c1 \u09aa\u09b0\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf \u09b9\u09be\u09b2\u09bf\u09ae\u09be\u09b0 \u0997\u09cb\u09a4\u09cd\u09b0\u09c7\u09b0 \u09ae\u09be\u09a8\u09c1\u09b7\u09a6\u09c7\u09b0 \u09b8\u09be\u09a5\u09c7 \u09a6\u09c7\u0996\u09be \u09b9\u09b2\u09c7 \u09a4\u09bf\u09a8\u09bf \u09b8\u09cd\u09a8\u09c7\u09b9\u09c7\u09b0 \u09b8\u09be\u09a5\u09c7 \u09a4\u09be\u09a6\u09c7\u09b0 \u0996\u09cb\u0981\u099c \u09a8\u09bf\u09a4\u09c7\u09a8\u0964',
    lesson: '\u09af\u09be\u09b0\u09be \u0986\u09ae\u09be\u09a6\u09c7\u09b0 \u09b6\u09bf\u09b6\u09c1\u0995\u09be\u09b2\u09c7 \u09af\u09a4\u09cd\u09a8 \u09a8\u09bf\u09af\u09bc\u09c7\u099b\u09c7\u09a8 \u09a4\u09be\u09a6\u09c7\u09b0 \u0995\u09c3\u09a4\u099c\u09cd\u099e \u09a5\u09be\u0995\u09bf\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'madinah_brotherhood',
    title: '\u09ae\u09a6\u09bf\u09a8\u09be\u09b0 \u09ad\u09be\u09af\u09bc\u09c7\u09b0 \u09ac\u09a8\u09cd\u09a7\u09a8',
    subtitle: '\u09aa\u09b0\u09b8\u09cd\u09aa\u09b0\u09c7\u09b0 \u09b8\u09be\u09b9\u09be\u09af\u09cd\u09af\u0995\u09be\u09b0\u09c0 \u09b9\u0993\u09af\u09bc\u09be',
    iconType: VectorIconType.star,
    accent: Color(0xFFD4A017),
    readTime: '\u09eb \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ec\u09e6\u09ec',
    body: '\u09ae\u09a6\u09bf\u09a8\u09be\u09af\u09bc \u09b9\u09bf\u099c\u09b0\u09a4\u09c7\u09b0 \u09aa\u09b0 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09ae\u09be\u0995\u09cd\u0995\u09bf (\u09ae\u09c1\u09b9\u09be\u099c\u09bf\u09b0) \u0993 \u09ae\u09a6\u09bf\u09a8\u09bf (\u0986\u09a8\u09b8\u09be\u09b0) \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae\u09a6\u09c7\u09b0 \u09ae\u09a7\u09cd\u09af\u09c7 \u09ad\u09be\u09af\u09bc\u09c7\u09b0 \u09ac\u09a8\u09cd\u09a7\u09a8 \u09a4\u09c8\u09b0\u09bf \u0995\u09b0\u09b2\u09c7\u09a8\u0964 \u0986\u09a8\u09b8\u09be\u09b0\u09b0\u09be \u09a4\u09be\u09a6\u09c7\u09b0 \u09b8\u09ae\u09cd\u09aa\u09a6 \u09ad\u09be\u0997 \u0995\u09b0\u09c7 \u09a6\u09bf\u09b2\u09c7\u09a8\u0964 \u09b8\u09be\u09a6 \u0987\u09ac\u09a8 \u09b0\u09be\u09ac\u09bf\u0986 (\u09b0\u09be.) \u09a4\u09be\u0981\u09b0 \u09ae\u09c1\u09b9\u09be\u099c\u09bf\u09b0 \u09ad\u09be\u0987\u0995\u09c7 \u09a4\u09be\u0981\u09b0 \u0986\u09a7\u09be \u09b8\u09ae\u09cd\u09aa\u09a6 \u098f\u09ac\u0982 \u0986\u09a7\u09be \u0998\u09b0 \u09a6\u09bf\u09b2\u09c7\u09a8\u0964',
    lesson: '\u0986\u09ae\u09b0\u09be \u09af\u09be \u09b0\u09be\u0996\u09bf \u09a4\u09be\u09b0 \u0995\u09bf\u099b\u09c1 \u09ae\u09a8\u09c7\u09b0 \u099a\u09be\u09b9\u09bf\u09a6\u09be\u09a4\u09c7\u0993 \u09ac\u09be\u0981\u099f\u09a4\u09c7 \u09b9\u09be\u09a4 \u09ac\u09be\u09dc\u09be\u0987\u0964',
    color: Color(0xFFFFF6D0),
  ),

  // ── Level 5: Advanced stories (6+ min) ──
  _SeerahStory(
    id: 'uhud_wound',
    title: '\u0989\u09b9\u09c1\u09a6\u09c7\u09b0 \u09aa\u09b0 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u0989\u09a6\u09be\u09b0\u09a4\u09be',
    subtitle: '\u0986\u09b9\u09a4 \u09b9\u09df\u09c7\u0993 \u09ae\u09be\u09a8\u09c1\u09b7\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09a6\u09cb\u09af\u09bc\u09be',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    readTime: '\u09ec \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae \u09e7\u09e2\u09eb\u09e6',
    body: '\u0989\u09b9\u09c1\u09a6\u09c7\u09b0 \u09af\u09c1\u09a6\u09cd\u09a7\u09c7 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae\u09b0\u09be \u09aa\u09bf\u099b\u09bf\u09af\u09bc\u09c7 \u09aa\u09dc\u09b2\u0964 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09a8\u09bf\u099c\u09c7 \u0986\u09b9\u09a4 \u09b9\u09b2\u09c7\u09a8\u0964 \u09b8\u09be\u09b9\u09be\u09ac\u09be\u09b0\u09be \u09a4\u09be\u0981\u0995\u09c7 \u09b0\u0995\u09cd\u09b7\u09be \u0995\u09b0\u09a4\u09c7 \u099c\u09c0\u09ac\u09a8 \u09ac\u09be\u099c\u09bf \u09b0\u09be\u0996\u09b2\u09c7\u09a8\u0964 \u09a4\u09bf\u09a8\u09bf \u0986\u09b9\u09a4 \u0985\u09ac\u09b8\u09cd\u09a5\u09be\u09af\u09bc\u0993 \u09a8\u09bf\u099c\u09c7\u09b0 \u099c\u09be\u09a4\u09bf\u09b0 \u09b9\u09bf\u09a6\u09be\u09af\u09bc\u09be\u09a4\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09a6\u09cb\u09af\u09bc\u09be \u0995\u09b0\u09b2\u09c7\u09a8: \u201c\u09b9\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9, \u0986\u09ae\u09be\u09b0 \u099c\u09be\u09a4\u09bf\u0995\u09c7 \u09b9\u09bf\u09a6\u09be\u09af\u09bc\u09be\u09a4 \u09a6\u09be\u0993; \u09a4\u09be\u09b0\u09be \u099c\u09be\u09a8\u09c7 \u09a8\u09be \u09a4\u09be\u0987 \u0995\u09b0\u09c7\u099b\u09c7\u0964\u201d',
    lesson: '\u0995\u09b7\u09cd\u099f\u09c7\u09b0 \u09ae\u09a7\u09cd\u09af\u09c7\u0993 \u0985\u09a8\u09cd\u09af\u09c7\u09b0 \u09ad\u09be\u09b2\u09cb \u099a\u09be\u0993\u09af\u09bc\u09be\u0987 \u09b8\u09b0\u09cd\u09ac\u09cb\u099a\u09cd\u099a \u09ae\u09b9\u09a8\u09c1\u09ad\u09ac\u09a4\u09be\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'marriage_khadija',
    title: '\u0996\u09be\u09a6\u09bf\u099c\u09be (\u09b0\u09be.)-\u09b0 \u09b8\u09be\u09a5\u09c7 \u09ac\u09bf\u09ac\u09be\u09b9',
    subtitle: '\u09b8\u09b0\u09cd\u09ac\u09b6\u09cd\u09b0\u09c7\u09b7\u09cd\u09a0 \u09b8\u0999\u09cd\u0997\u09c0\u09a8\u09c0',
    iconType: VectorIconType.star,
    accent: Color(0xFFE05A7A),
    readTime: '\u09ec \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ea',
    body: '\u0996\u09be\u09a6\u09bf\u099c\u09be (\u09b0\u09be.) \u099b\u09bf\u09b2\u09c7\u09a8 \u09ae\u0995\u09cd\u0995\u09be\u09b0 \u09b8\u09ae\u09cd\u09ae\u09be\u09a8\u09bf\u09a4\u09be \u09ac\u09cd\u09af\u09ac\u09b8\u09be\u09af\u09bc\u09c0\u0964 \u09a4\u09bf\u09a8\u09bf \u09ae\u09c1\u09b9\u09be\u09ae\u09cd\u09ae\u09be\u09a6 \u202f-\u09b0 \u09b8\u09a4\u09cd\u09af\u09a4\u09be \u0993 \u09a8\u09bf\u09b7\u09cd\u09a0\u09be \u09a6\u09c7\u0996\u09c7 \u09b8\u09cd\u09ac\u09df\u0982 \u09ac\u09bf\u09ac\u09be\u09b9\u09c7\u09b0 \u09aa\u09cd\u09b0\u09b8\u09cd\u09a4\u09be\u09ac \u09a6\u09bf\u09b2\u09c7\u09a8\u0964 \u09a8\u09ac\u09c1\u0993\u09af\u09bc\u09be\u09a4\u09c7\u09b0 \u09aa\u09b0 \u09a4\u09bf\u09a8\u09bf\u0987 \u09b8\u09b0\u09cd\u09ac\u09aa\u09cd\u09b0\u09a5\u09ae \u0987\u09b8\u09b2\u09be\u09ae \u0997\u09cd\u09b0\u09b9\u09a3 \u0995\u09b0\u09b2\u09c7\u09a8 \u098f\u09ac\u0982 \u09a4\u09be\u0981\u09b0 \u09b8\u09ae\u09b8\u09cd\u09a4 \u09b8\u09ae\u09cd\u09aa\u09a6 \u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u09aa\u09a5\u09c7 \u09ac\u09cd\u09af\u09af\u09bc \u0995\u09b0\u09c7\u09a8\u0964',
    lesson: '\u099c\u09c0\u09ac\u09a8\u09b8\u0999\u09cd\u0997\u09c0 \u09ac\u09c7\u099b\u09c7 \u09a8\u09c7\u0993\u09af\u09bc\u09be\u09b0 \u09b8\u09ae\u09af\u09bc \u09ae\u09a8 \u09a8\u09df, \u099a\u09b0\u09bf\u09a4\u09cd\u09b0 \u09a6\u09c7\u0996\u09bf\u0964',
    color: Color(0xFFFFEBCF),
  ),
  _SeerahStory(
    id: 'isra_miraj',
    title: '\u0987\u09b8\u09b0\u09be \u0993 \u09ae\u09bf\u09b0\u09be\u099c',
    subtitle: '\u09b0\u09be\u09a4\u09c7\u09b0 \u098f\u0995 \u09af\u09be\u09a4\u09cd\u09b0\u09be, \u09b8\u09a4\u09cd\u09a4\u09be\u09b0 \u0986\u09b2\u09cb',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF9B6BC9),
    readTime: '\u09ed \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09c1\u09b0\u09be \u0987\u09b8\u09b0\u09be \u09e7\u09ed:\u09e7',
    body: '\u098f\u0995 \u09b0\u09be\u09a4\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf\u0995\u09c7 \u202f \u09ae\u0995\u09cd\u0995\u09be \u09a5\u09c7\u0995\u09c7 \u09ac\u09be\u09df\u09a4\u09c1\u09b2 \u09ae\u09be\u0995\u09a6\u09bf\u09b8\u09c7 (\u099c\u09c7\u09b0\u09c1\u09b8\u09be\u09b2\u09c7\u09ae) \u09a8\u09bf\u09af\u09bc\u09c7 \u09af\u09be\u0993\u09af\u09bc\u09be \u09b9\u09b2\u09cb\u0964 \u09b8\u09c7\u0996\u09be\u09a8 \u09a5\u09c7\u0995\u09c7 \u09a4\u09bf\u09a8\u09bf \u09b8\u09aa\u09cd\u09a4 \u0986\u09b8\u09ae\u09be\u09a8 \u09ad\u09cd\u09b0\u09ae\u09a3 \u0995\u09b0\u09b2\u09c7\u09a8\u0964 \u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u09a4\u09be\u0981\u0995\u09c7 \u09aa\u09be\u0981\u099a \u0993\u09af\u09bc\u09be\u0995\u09cd\u09a4 \u09a8\u09be\u09ae\u09be\u099c \u09a6\u09bf\u09b2\u09c7\u09a8\u0964 \u098f \u09af\u09be\u09a4\u09cd\u09b0\u09be \u09b8\u09a4\u09cd\u09af \u09ac\u09b2\u09c7 \u09ac\u09bf\u09b6\u09cd\u09ac\u09be\u09b8 \u0995\u09b0\u09be \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae\u09a6\u09c7\u09b0 \u0987\u09ae\u09be\u09a8\u09c7\u09b0 \u09aa\u09b0\u09c0\u0995\u09cd\u09b7\u09be \u09b9\u09b2\u09cb\u0964',
    lesson: '\u0986\u09b2\u09cd\u09b2\u09be\u09b9\u09b0 \u09b6\u0995\u09cd\u09a4\u09bf\u09b0 \u0993\u09aa\u09b0 \u09ac\u09bf\u09b6\u09cd\u09ac\u09be\u09b8 \u09b0\u09be\u0996\u09bf\u09b0\u09be\u09b0\u09cd\u09a6\u09cd\u09a7\u09c7 \u09a8\u09be\u09ae\u09be\u099c \u09b9\u09b2\u09cb \u0986\u09ae\u09be\u09a6\u09c7\u09b0 \u09b8\u09b0\u09cd\u09ac\u09ac\u09dc \u09b8\u09a8\u09cd\u09a7\u09be\u09a8\u0964',
    color: Color(0xFFF3E8FF),
  ),
  _SeerahStory(
    id: 'arqam_house',
    title: '\u0986\u09b0\u0995\u09be\u09ae\u09c7\u09b0 \u0998\u09b0\u09c7 \u09b6\u09bf\u0995\u09cd\u09b7\u09be',
    subtitle: '\u0995\u09bf\u09ad\u09be\u09ac\u09c7 \u09b8\u09a4\u09cd\u09af \u09b6\u09bf\u0996\u09a4\u09c7 \u09b9\u09af\u09bc',
    iconType: VectorIconType.scroll,
    accent: Color(0xFF3B82C4),
    readTime: '\u09ed \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09bf\u09b0\u09be\u09a4\u09c1\u09a8 \u09a8\u09be\u09ac\u09be\u09ac\u09bf\u09af\u09bc\u09cd\u09af\u09be\u09b9',
    body: '\u09b8\u09be\u09b9\u09be\u09ac\u09be\u09b0\u09be \u09ae\u0995\u09cd\u0995\u09be\u09b0 \u09aa\u09b0\u09bf\u09b8\u09cd\u09a5\u09bf\u09a4\u09bf \u0995\u09a0\u09bf\u09a8 \u09b9\u09b2\u09c7 \u0986\u09b0\u0995\u09be\u09ae \u0987\u09ac\u09a8 \u0986\u09ac\u09bf (\u09b0\u09be.) \u09a4\u09be\u0981\u09b0 \u0998\u09b0 \u09a6\u09bf\u09b2\u09c7\u09a8\u0964 \u09b8\u09c7\u0996\u09be\u09a8\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u0997\u09cb\u09aa\u09a8\u09c7 \u0995\u09c1\u09b0\u0986\u09a8 \u09b6\u09bf\u0996\u09be\u09a4\u09c7\u09a8\u0964 \u0993\u09ae\u09b0 (\u09b0\u09be.) \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u0989\u09aa\u09b0 \u09b0\u09be\u0997 \u0995\u09b0\u09c7 \u09af\u09be\u09b0\u09be\u09a6 \u09b9\u09b2\u09c7\u09a8, \u0995\u09bf\u09a8\u09cd\u09a4\u09c1 \u09b8\u09c1\u09b0\u09be \u09a4\u09be\u09b9\u09be (\u0986\u09b0\u09ac\u09bf\u09a4\u09c7) \u09b6\u09c1\u09a8\u09c7 \u09a4\u09bf\u09a8\u09bf \u0995\u09be\u0981\u09a6\u09c7 \u09ab\u09c7\u09b2\u09c7\u09a8 \u098f\u09ac\u0982 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae \u09b9\u09b2\u09c7\u09a8\u0964',
    lesson: '\u09b8\u09a4\u09cd\u09af\u09c7\u09b0 \u09ac\u09be\u09a3\u09c0 \u09b8\u09ac\u0995\u09c7 \u09a6\u09cb\u09b2\u09be\u09af\u09bc; \u09b6\u09c7\u0996\u09be\u09b0 \u09b8\u09c1\u09af\u09cb\u0997 \u09a5\u09c7\u0995\u09c7 \u09a8\u09bf\u099c\u09c7\u0995\u09c7 \u09ac\u09be\u0981\u099a\u09be\u0987\u09a8\u09be\u0964',
    color: Color(0xFFDCEBFF),
  ),
  _SeerahStory(
    id: 'farewell_sermon',
    title: '\u09ac\u09bf\u09a6\u09be\u09af\u09bc\u09c0 \u09b9\u099c\u09c7\u09b0 \u09ad\u09be\u09b7\u09a3',
    subtitle: '\u09ae\u09be\u09a8\u09ac\u09a4\u09be\u09b0 \u099c\u09a8\u09cd\u09af \u0986\u099c\u09a8\u09cd\u09ae\u09c7\u09b0 \u09a8\u09bf\u09b0\u09cd\u09a6\u09c7\u09b6\u09a8\u09be',
    iconType: VectorIconType.scroll,
    accent: Color(0xFF46A302),
    readTime: '\u09ed \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae \u09e7\u09e8\u09eb\u09e6',
    body: '\u09b9\u09bf\u099c\u09b0\u09a4\u09c7\u09b0 \u09e7\u09e6\u09ae \u09ac\u099b\u09b0\u09c7 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09b9\u099c \u0995\u09b0\u09b2\u09c7\u09a8\u0964 \u098f\u0995 \u09b2\u0995\u09cd\u09b7\u09c7\u09b0\u0993 \u09ac\u09c7\u09b6\u09bf \u09ae\u09be\u09a8\u09c1\u09b7\u09c7\u09b0 \u09b8\u09be\u09ae\u09a8\u09c7 \u09a4\u09bf\u09a8\u09bf \u0985\u09b0\u09ab\u09be\u09a4\u09c7\u09b0 \u09ae\u09be\u09a0\u09c7 \u09ad\u09be\u09b7\u09a3 \u09a6\u09bf\u09b2\u09c7\u09a8\u0964 \u09ac\u09b2\u09b2\u09c7\u09a8: \u201c\u09b8\u09a6\u0998\u09a8 \u09a4\u09cb\u09ae\u09be\u09a6\u09c7\u09b0 \u09b0\u0995\u09cd\u09a4, \u09b8\u09ae\u09cd\u09aa\u09a6 \u0993 \u09ae\u09be\u09a8-\u09b8\u09ae\u09cd\u09ae\u09be\u09a8 \u09aa\u09ac\u09bf\u09a4\u09cd\u09b0\u0964 \u09a8\u09be\u09b0\u09c0\u09b0 \u09b8\u09be\u09a5\u09c7 \u09a8\u09cd\u09af\u09be\u09af\u09bc \u0995\u09b0\u09cb\u0964 \u09a1\u09be\u09a8\u09c7 \u0993 \u09ac\u09be\u0981\u09df\u09c7 \u0995\u09c1\u09b0\u0986\u09a8 \u0993 \u09b8\u09c1\u09a8\u09cd\u09a8\u09be\u09b9 \u09a7\u09b0\u09cb\u2014 \u0995\u09cb\u09a8\u09cb \u0986\u09b0\u09ac \u0985\u09a8\u09be\u09b0\u09ac\u09c7\u09b0 \u09aa\u09cd\u09b0\u09a4\u09bf \u09b6\u09cd\u09b0\u09c7\u09b7\u09cd\u09a0 \u09a8\u09af\u09bc\u09c7\u0964\u201d',
    lesson: '\u09a7\u09b0\u09cd\u09ae \u0993 \u09ac\u09bf\u09ac\u09c7\u0995\u0987 \u09b9\u09b2\u09cb \u09b8\u09a4\u09cd\u09af\u09bf\u0995\u09be\u09b0\u09c7\u09b0 \u09b6\u09cd\u09b0\u09c7\u09b7\u09cd\u09a0\u09a4\u09be\u09b0 \u09ae\u09be\u09a8\u09a6\u09a8\u09cd\u09a1\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'hadith_smile',
    title: '\u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u09b9\u09be\u09b8\u09bf',
    subtitle: '\u09b8\u09cd\u09ae\u09bf\u09a4 \u09b8\u09a6\u0995\u09be',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFF58A700),
    readTime: '\u09e8 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ae\u09c1\u09b8\u09b2\u09bf\u09ae \u09eb\u09eb',
    body: '\u099c\u09be\u09b0\u09bf\u09b0 \u0987\u09ac\u09a8\u09c7 \u0986\u09ac\u09a6\u09c1\u09b2\u09cd\u09b2\u09be\u09b9 (\u09b0\u09be.) \u09ac\u09b2\u09c7\u09a8, \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u0987\u09b8\u09b2\u09be\u09ae\u09c7\u09b0 \u09aa\u09b0 \u09a5\u09c7\u0995\u09c7 \u0986\u09ae\u09be\u09b0 \u09b8\u09be\u09a5\u09c7 \u09a6\u09c7\u0996\u09be \u09a8\u09be \u09b9\u09b2\u09c7\u0993 \u09b9\u09be\u09b8\u09bf\u09ae\u09c1\u0996\u09c7 \u09b8\u09be\u09b2\u09be\u09ae \u09a6\u09bf\u09a4\u09c7\u09a8\u0964 \u09a4\u09be\u0981\u09b0 \u09b9\u09be\u09b8\u09bf \u099b\u09bf\u09b2 \u09b8\u09a6\u0995\u09be \u09b8\u09ae\u09a4\u09c1\u09b2\u09cd\u09af\u0964 \u09b9\u09be\u09b8\u09bf\u09ae\u09c1\u0996\u09c7 \u09a6\u09c7\u0996\u09be \u0995\u09b0\u09be\u0987 \u09ae\u09a8\u09c7\u09b0 \u0986\u09a8\u09a8\u09cd\u09a6 \u09ae\u09a8\u09c7\u09b0 \u099c\u09bf\u09a8\u09bf\u09b8\u0964',
    lesson: '\u09b9\u09be\u09b8\u09bf\u09ae\u09c1\u0996\u09c7 \u09a5\u09be\u0995\u09be\u0993 \u0987\u09ac\u09be\u09a6\u09a4\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'food_sharing',
    title: '\u099b\u09af\u09bc \u099c\u09a8\u09c7\u09b0 \u0996\u09be\u09ac\u09be\u09b0',
    subtitle: '\u09ac\u09b0\u0995\u09a4\u09c7\u09b0 \u0997\u09b2\u09cd\u09aa',
    iconType: VectorIconType.sparkle,
    accent: Color(0xFFD4A017),
    readTime: '\u09e9 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ec\u09eb\u09ef',
    body: '\u0986\u09ac\u09c1 \u09b9\u09c1\u09b0\u09be\u09af\u09bc\u09b0\u09be (\u09b0\u09be.) \u09ac\u09b2\u09c7\u09a8, \u098f\u0995 \u09b0\u09be\u09a4\u09c7 \u0985\u09a8\u09c7\u0995 \u09ae\u09c7\u09b9\u09ae\u09be\u09a8 \u098f\u09b2\u09c7\u09a8\u0964 \u09a8\u09ac\u09c0\u099c\u09bf\u09b0 \u202f \u09b8\u09cd\u09a4\u09cd\u09b0\u09c0\u09b0 \u09aa\u09be\u09a0\u09be\u09a8\u09cb \u09a5\u09c7\u0995\u09c7 \u0986\u09a8\u09be \u09b8\u09be\u09ae\u09be\u09a8\u09cd\u09af \u09aa\u09be\u09a4\u09cd\u09b0\u09c7\u09b0 \u0996\u09be\u09ac\u09be\u09b0 \u09a6\u09bf\u09af\u09bc\u09c7 \u09b8\u09ac\u09be\u0987\u0995\u09c7 \u09a4\u09c3\u09aa\u09cd\u09a4 \u0995\u09b0\u09be\u09a8\u09cb \u09b9\u09b2\u09cb\u0964 \u09b8\u09ac\u09be\u0987 \u0996\u09c7\u09af\u09bc\u09c7 \u09b0\u0987\u09b2 \u098f\u09ac\u0982 \u0996\u09be\u09ac\u09be\u09b0 \u09ac\u09be\u09dc\u09a4\u09c7\u0987 \u09b0\u0987\u09b2\u0964 \u09b8\u09a4\u09cd\u09af\u09bf\u0995\u09be\u09b0\u09b0\u09c7\u09b0 \u0996\u09be\u09a8\u09be\u09af\u09bc \u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u09ac\u09b0\u0995\u09a4 \u09a6\u09bf\u09b2\u09c7\u09a8\u0964',
    lesson: '\u09b9\u09be\u09b2\u09be\u09b2 \u0993 \u09ac\u09b0\u0995\u09a4\u09ae\u09af\u09bc \u0996\u09be\u09ac\u09be\u09b0 \u09ac\u09be\u09dc\u09a4\u09c7 \u09a5\u09be\u0995\u09c7\u0964',
    color: Color(0xFFFFF6D0),
  ),
  _SeerahStory(
    id: 'muadh_kindness',
    title: '\u09ae\u09c1\u0986\u09b0 (\u09b0\u09be.)\u09b0 \u09b2\u09ae\u09cd\u09ac\u09be \u09a8\u09be\u09ae\u09be\u099c',
    subtitle: '\u099c\u09be\u09ae\u09be\u0993\u09af\u09bc\u09be\u09a4\u09c7 \u09b8\u09b9\u099c \u09a8\u09be\u09ae\u09be\u099c',
    iconType: VectorIconType.crescent,
    accent: Color(0xFF46A302),
    readTime: '\u09e3 \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ed\u09e6\u09e6',
    body: '\u09ae\u09c1\u0986\u09b0 (\u09b0\u09be.) \u09b6\u0982\u0995\u09be\u09b0 \u09a8\u09be\u09ae\u09be\u099c \u09aa\u09dc\u09be\u09a4\u09c7\u09a8 \u0993 \u09b2\u09ae\u09cd\u09ac\u09be \u09b8\u09c1\u09b0\u09be \u09a6\u09bf\u09af\u09bc\u09c7 \u09a8\u09be\u09ae\u09be\u099c \u09a6\u09bf\u09a4\u09c7\u09a8\u0964 \u098f\u0995 \u09b8\u09be\u09b9\u09be\u09ac\u09bf \u09a4\u09be\u0981\u09b0 \u0995\u09be\u099b \u09a5\u09c7\u0995\u09c7 \u0985\u09a8\u09c1\u09ae\u09a4\u09bf \u09a8\u09bf\u09af\u09bc\u09c7 \u0986\u09b2\u09be\u09a6\u09be \u09b8\u0982\u0995\u09cd\u09b7\u09bf\u09aa\u09cd\u09a4 \u09a8\u09be\u09ae\u09be\u099c \u09aa\u09dc\u09b2\u09c7\u09a8\u0964 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09b6\u09c1\u09a8\u09c7 \u09ac\u09b2\u09b2\u09c7\u09a8: \u201c\u09ae\u09c1\u0986\u09b0, \u09a4\u09c1\u09ae\u09bf \u0995\u09bf \u09ab\u09bf\u09a4\u09a8\u09be\u09df \u09ab\u09c7\u09b2\u09a4\u09c7 \u099a\u09be\u0993?\u201d \u09ae\u09be\u09a8\u09c1\u09b7\u09c7\u09b0 \u09b8\u09be\u09a7\u09cd\u09af-\u09b8\u09c0\u09ae\u09be \u09ac\u09bf\u09ac\u09c7\u099a\u09a8\u09be \u0995\u09b0\u09c7 \u09a8\u09be\u09ae\u09be\u099c \u09aa\u09dc\u09be\u09a8\u09cb\u0964',
    lesson: '\u0987\u09ac\u09be\u09a6\u09a4\u09c7 \u09b8\u09b9\u099c \u0995\u09b0\u09cb; \u09ae\u09be\u09a8\u09c1\u09b7\u09c7\u09b0 \u0995\u09b7\u09cd\u099f\u09c7\u09b0 \u09a6\u09bf\u0995\u09c7 \u09a8\u09b2 \u09a4\u09be\u0995\u09be\u0993\u0964',
    color: Color(0xFFE8F8D8),
  ),
  _SeerahStory(
    id: 'ashab_suffa',
    title: '\u0986\u09b8\u09b9\u09be\u09ac\u09c1\u09b8 \u09b8\u09c1\u09ab\u09cd\u09ab\u09be',
    subtitle: '\u099c\u09cd\u099e\u09be\u09a8\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09b8\u09ac\u0995\u09bf\u099b\u09c1 \u09a4\u09cd\u09af\u09be\u0997',
    iconType: VectorIconType.scroll,
    accent: Color(0xFF9B6BC9),
    readTime: '\u09ea \u09ae\u09bf\u09a8\u09bf\u099f',
    reference: '\u09b8\u09b9\u09bf\u09b9 \u09ac\u09c1\u0996\u09be\u09b0\u09bf \u09ed\u09e6\u09e7',
    body: '\u09ae\u09a6\u09bf\u09a8\u09be\u09b0 \u09ae\u09b8\u099c\u09bf\u09a6\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09a8\u09bf\u09b0\u09cd\u09a6\u09bf\u09b7\u09cd\u099f \u098f\u0995 \u09a1\u09be\u09b2\u09be\u09a8 (=\u09ac\u09be\u0981\u09b0\u09be\u09a8\u09cd\u09a6\u09be) \u099b\u09bf\u09b2 \u09af\u09c7\u0996\u09be\u09a8\u09c7 \u09a6\u09b0\u09bf\u09a6\u09cd\u09b0 \u09b8\u09be\u09b9\u09be\u09ac\u09be\u09b0\u09be \u09a5\u09be\u0995\u09a4\u09c7\u09a8\u0964 \u09a4\u09be\u09a6\u09c7\u09b0 \u09b6\u09c1\u09a7\u09c1 \u09ae\u09b8\u099c\u09bf\u09a6\u09c7 \u09aa\u09dc\u09be\u09b6\u09c1\u09a8\u09be\u09b0 \u099c\u09a8\u09cd\u09af \u09a5\u09be\u0995\u09a4\u09c7\u09a8\u0964 \u09a8\u09ac\u09c0\u099c\u09bf \u202f \u09a4\u09be\u09a6\u09c7\u09b0 \u0996\u09be\u09ac\u09be\u09b0 \u09a8\u09bf\u09b0\u09cd\u09ac\u09bf\u0998\u09cd\u09a8 \u0995\u09b0\u09a4\u09c7\u09a8 \u098f\u09ac\u0982 \u09ae\u09be\u099d\u09c7 \u09ae\u09a7\u09cd\u09af\u09c7 \u09a8\u09bf\u099c\u09c7 \u0993 \u09a4\u09be\u09a6\u09c7\u09b0 \u09b8\u09be\u09a5\u09c7 \u09ac\u09b8\u09a4\u09c7\u09a8\u0964',
    lesson: '\u099c\u09cd\u099e\u09be\u09a8 \u0985\u09b0\u09cd\u099c\u09a8\u09c7 \u09af\u09a4\u09cd\u09a8 \u09a8\u09bf\u09b2\u09c7 \u0986\u09b2\u09cd\u09b2\u09be\u09b9 \u09aa\u09cd\u09b0\u09a4\u09bf\u09ab\u09b2 \u09a6\u09c7\u09a8\u0964',
    color: Color(0xFFF3E8FF),
  ),
];

class SeerahScreen extends StatelessWidget {
  const SeerahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final state = context.watch<AppState>();
    final completed = _stories
        .where((story) => state.hasCompletedLesson('seerah_${story.id}'))
        .length;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      tablet ? 36 : 18, 12, tablet ? 36 : 18, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Duolingo Header ──
                      DuolingoPageHeader(
                        title: 'নবীজির জীবন থেকে শিখি',
                        subtitle: 'ছোট গল্প, বড় শিক্ষা',
                        customIcon: Image.asset(
                          'assets/images/badge_seerah_3d.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                        gradientColors: const [
                          Color(0xFFE05A7A),
                          Color(0xFFC44569)
                        ],
                        onBack: () => Navigator.pop(context),
                      ),

                      DuolingoSectionLabel(
                        label: 'আজ কোন গল্পটি পড়বে?',
                        badgeText: '$completed/${_stories.length}টি শেষ',
                        badgeColor: const Color(0xFFFFE4EC),
                        badgeTextColor: const Color(0xFFE05A7A),
                      ),
                      const SizedBox(height: 14),

                      for (final story in _stories)
                        _StoryCard(
                          story: story,
                          completed:
                              state.hasCompletedLesson('seerah_${story.id}'),
                          inProgress:
                              !state.hasCompletedLesson('seerah_${story.id}') &&
                                  state.seerahProgress(story.id) > 0,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    _StoryDetailScreen(story: story)),
                          ),
                        ),

                      const SizedBox(height: 8),
                      LocalizedText(
                        'গল্পগুলো সংক্ষেপে লেখা। সূত্রের বিস্তারিত জানতে কার্ডে দেওয়া হাদিস নম্বর দেখো।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.darkText.withValues(alpha: 0.45),
                            fontSize: 11,
                            height: 1.5),
                      ),
                    ]),
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

class _StoryCard extends StatefulWidget {
  const _StoryCard({
    required this.story,
    required this.onTap,
    required this.completed,
    this.inProgress = false,
  });
  final _SeerahStory story;
  final bool completed;
  final bool inProgress;
  final VoidCallback onTap;

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        margin: const EdgeInsets.only(bottom: 14),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: story.accent.withValues(alpha: 0.25), width: 2),
          boxShadow: [
            BoxShadow(
                color: story.accent.withValues(alpha: _pressed ? 0.05 : 0.15),
                blurRadius: 0,
                offset: Offset(0, _pressed ? 0 : 4))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: story.color, borderRadius: BorderRadius.circular(18)),
              child: Center(
                  child: VectorIcon(
                      type: story.iconType, size: 32, color: story.accent)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocalizedText(story.title,
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    const SizedBox(height: 3),
                    LocalizedText(
                        widget.completed
                            ? 'গল্পটি শেষ · চাইলে আবার পড়ো'
                            : widget.inProgress
                                ? 'চলমান · শিক্ষা অংশে আছো'
                                : story.subtitle,
                        style: TextStyle(
                            color: widget.completed
                                ? const Color(0xFF58A700)
                                : widget.inProgress
                                    ? const Color(0xFFD4A017)
                                    : AppTheme.darkText.withValues(alpha: 0.55),
                            fontWeight: (widget.completed || widget.inProgress)
                                ? FontWeight.w700
                                : FontWeight.normal,
                            fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: story.color,
                            borderRadius: BorderRadius.circular(8)),
                        child: LocalizedText(story.readTime,
                            style: TextStyle(
                                color: story.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(8)),
                        child: LocalizedText(story.reference,
                            style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ]),
            ),
            Container(
              width: 32,
              height: 32,
              decoration:
                  BoxDecoration(color: story.color, shape: BoxShape.circle),
              child: Icon(
                  widget.completed
                      ? Icons.check_rounded
                      : Icons.chevron_right_rounded,
                  color: story.accent,
                  size: 20),
            ),
          ]),
        ),
      ),
    );
  }
}

class _StoryDetailScreen extends StatefulWidget {
  const _StoryDetailScreen({required this.story});
  final _SeerahStory story;

  @override
  State<_StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<_StoryDetailScreen> {
  late _SeerahStory _currentStory;
  late int _step;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _currentStory = widget.story;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = context.read<AppState>();
      final isComp = appState.hasCompletedLesson('seerah_${_currentStory.id}');
      final saved = appState.seerahProgress(_currentStory.id);
      _step = isComp ? 2 : (saved > 0 ? saved : 0);
      _initialized = true;
    }
  }

  void _goToStory(_SeerahStory nextStory) {
    final appState = context.read<AppState>();
    final isComp = appState.hasCompletedLesson('seerah_${nextStory.id}');
    final saved = appState.seerahProgress(nextStory.id);
    setState(() {
      _currentStory = nextStory;
      _step = isComp ? 2 : (saved > 0 ? saved : 0);
    });
  }

  Future<void> _advanceStep(int newStep) async {
    setState(() => _step = newStep);
    await context.read<AppState>().saveSeerahProgress(_currentStory.id, newStep);
  }

  Future<void> _finishStory() async {
    final appState = context.read<AppState>();
    final earned =
        await appState.completeLesson('seerah_${_currentStory.id}', xp: 10);
    await appState.saveSeerahProgress(_currentStory.id, 2);
    if (!mounted) return;
    setState(() => _step = 2);

    final currentIndex = _stories.indexWhere((s) => s.id == _currentStory.id);
    final hasNext = currentIndex < _stories.length - 1;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.celebration_rounded,
                color: Color(0xFF58A700), size: 28),
            SizedBox(width: 10),
            Expanded(child: LocalizedText('মাশাআল্লাহ!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocalizedText(
              earned
                  ? 'গল্পটি সম্পন্ন হয়েছে! তুমি পেয়েছ +১০ XP।'
                  : 'গল্পটি আবার পড়ে শেষ করেছ! (+১০ XP আগেই পেয়েছ)',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (hasNext)
              LocalizedText(
                'পরবর্তী গল্প: ${_stories[currentIndex + 1].title}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGreen,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const LocalizedText('এখানেই থাকি'),
          ),
          if (hasNext)
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _goToStory(_stories[currentIndex + 1]);
              },
              style: FilledButton.styleFrom(
                backgroundColor: _stories[currentIndex + 1].accent,
              ),
              child: const LocalizedText('পরের গল্প পড়ুন'),
            )
          else
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen),
              child: const LocalizedText('তালিকায় ফেরো'),
            ),
        ],
      ),
    );
  }

  Future<void> _handleExit() async {
    final isComp = context
        .read<AppState>()
        .hasCompletedLesson('seerah_${_currentStory.id}');
    if (!isComp && _step == 1) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const LocalizedText('পড়া থেকে বিরতি নেবে?'),
          content: const LocalizedText(
              'তোমার পড়ার অগ্রগতি সেভ থাকবে। পরে শিক্ষা অংশ থেকে শুরু করতে পারবে।'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const LocalizedText('চালিয়ে যাই'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE05A7A)),
              child: const LocalizedText('বিরতি নিই'),
            ),
          ],
        ),
      );
      if (shouldExit == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final completed =
        state.hasCompletedLesson('seerah_${_currentStory.id}') || _step == 2;
    final currentIndex = _stories.indexWhere((s) => s.id == _currentStory.id);
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < _stories.length - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleExit();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8F0),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  DuolingoPageHeader(
                    title: _currentStory.title,
                    subtitle:
                        '${_currentStory.readTime}  ·  ${_currentStory.reference}',
                    iconType: _currentStory.iconType,
                    gradientColors: [
                      _currentStory.accent,
                      _currentStory.accent.withValues(alpha: 0.75)
                    ],
                    onBack: _handleExit,
                  ),

                  // Reading progress indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: _currentStory.accent.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StepIndicatorPill(
                          label: '১. মূল ঘটনা',
                          active: _step >= 0,
                          current: _step == 0,
                          accent: _currentStory.accent,
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16,
                            color: _currentStory.accent.withValues(alpha: 0.4)),
                        _StepIndicatorPill(
                          label: '২. শিক্ষা ও আমল',
                          active: _step >= 1,
                          current: _step == 1,
                          accent: _currentStory.accent,
                        ),
                        Icon(Icons.chevron_right_rounded,
                            size: 16,
                            color: _currentStory.accent.withValues(alpha: 0.4)),
                        _StepIndicatorPill(
                          label: '৩. সমাপ্তি',
                          active: completed,
                          current: _step == 2,
                          accent: _currentStory.accent,
                        ),
                      ],
                    ),
                  ),

                  // Completed Banner if finished
                  if (completed && _step == 2) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8D8),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: const Color(0xFF58A700).withValues(alpha: 0.4),
                            width: 1.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Color(0xFF58A700), size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: LocalizedText(
                              'গল্পটি পড়া শেষ হয়েছে! মাশাআল্লাহ।',
                              style: TextStyle(
                                  color: Color(0xFF3B7A00),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Story body card
                  if (_step == 0 || _step == 2) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: _currentStory.accent.withValues(alpha: 0.2),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: _currentStory.accent
                                  .withValues(alpha: 0.1),
                              blurRadius: 0,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: LocalizedText(
                        _currentStory.body,
                        style: const TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 16,
                            height: 1.85,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Step 0 forward action
                  if (_step == 0) ...[
                    FilledButton.icon(
                      onPressed: () => _advanceStep(1),
                      style: FilledButton.styleFrom(
                        backgroundColor: _currentStory.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const LocalizedText('গল্পের শিক্ষা পড়ি →',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Lesson card (visible during Step 1 and Step 2)
                  if (_step >= 1) ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _currentStory.color,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: _currentStory.accent.withValues(alpha: 0.3),
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: _currentStory.accent
                                  .withValues(alpha: 0.12),
                              blurRadius: 0,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              VectorIcon(
                                  type: VectorIconType.sparkle,
                                  size: 20,
                                  color: _currentStory.accent),
                              const SizedBox(width: 8),
                              LocalizedText('গল্পের শিক্ষা',
                                  style: TextStyle(
                                      color: _currentStory.accent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                            ]),
                            const SizedBox(height: 10),
                            LocalizedText(_currentStory.lesson,
                                style: const TextStyle(
                                    color: AppTheme.darkText,
                                    fontSize: 15,
                                    height: 1.55,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Step 1 controls
                  if (_step == 1) ...[
                    Row(
                      children: [
                        DSButton(
                          label: 'ঘটনা আবার দেখি',
                          variant: DSButtonVariant.outline,
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => _advanceStep(0),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DSButton(
                            label: 'গল্প শেষ করেছি · +১০ XP',
                            variant: DSButtonVariant.primary,
                            icon: Icons.celebration_rounded,
                            onPressed: _finishStory,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Reference footnote
                  LocalizedText(
                    'সূত্র: ${_currentStory.reference}',
                    style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),

                  // Review restart action in step 2
                  if (_step == 2) ...[
                    const SizedBox(height: 12),
                    DSButton(
                      label: 'প্রথম থেকে আবার পড়ো',
                      variant: DSButtonVariant.outline,
                      icon: Icons.refresh_rounded,
                      onPressed: () => _advanceStep(0),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE8E8E8)),
                  const SizedBox(height: 12),

                  // Previous / Next Story Navigation
                  Row(
                    children: [
                      if (hasPrev)
                        Expanded(
                          child: DSButton(
                            label: 'আগের গল্প',
                            icon: Icons.chevron_left_rounded,
                            variant: DSButtonVariant.outline,
                            onPressed: () =>
                                _goToStory(_stories[currentIndex - 1]),
                          ),
                        )
                      else
                        const Spacer(),
                      const SizedBox(width: 10),
                      if (hasNext)
                        Expanded(
                          child: DSButton(
                            label: 'পরের গল্প',
                            icon: Icons.chevron_right_rounded,
                            variant: DSButtonVariant.secondary,
                            onPressed: () =>
                                _goToStory(_stories[currentIndex + 1]),
                          ),
                        )
                      else
                        const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIndicatorPill extends StatelessWidget {
  const _StepIndicatorPill({
    required this.label,
    required this.active,
    required this.current,
    required this.accent,
  });

  final String label;
  final bool active;
  final bool current;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: current
            ? accent
            : active
                ? accent.withValues(alpha: 0.15)
                : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LocalizedText(
        label,
        style: TextStyle(
          color: current
              ? Colors.white
              : active
                  ? accent
                  : const Color(0xFF999999),
          fontWeight: current ? FontWeight.w800 : FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
