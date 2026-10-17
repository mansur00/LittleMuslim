import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/vector_icons.dart';
import 'class_schedule.dart';

class LiveLearningScreen extends StatefulWidget {
  const LiveLearningScreen({
    super.key,
    this.repository = const EmptyClassScheduleRepository(),
    this.launcher = const ExternalMeetingLinkLauncher(),
    this.now,
  });

  final ClassScheduleRepository repository;
  final MeetingLinkLauncher launcher;
  final DateTime Function()? now;

  @override
  State<LiveLearningScreen> createState() => _LiveLearningScreenState();
}

class _LiveLearningScreenState extends State<LiveLearningScreen> {
  late Future<List<LiveClass>> _classesFuture;

  DateTime get _now => widget.now?.call() ?? DateTime.now();

  Future<List<LiveClass>> _loadClasses() =>
      Future<List<LiveClass>>.sync(widget.repository.loadClasses);

  @override
  void initState() {
    super.initState();
    _classesFuture = _loadClasses();
  }

  Future<void> _reload() async {
    setState(() => _classesFuture = _loadClasses());
    try {
      await _classesFuture;
    } catch (_) {
      // The FutureBuilder displays the error state and offers another retry.
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(tablet ? 32 : 18),
                children: [
                  DuolingoPageHeader(
                    title: 'শিক্ষকের সাথে শিখি',
                    subtitle: 'ক্লাসের সময় ও তথ্য দেখো',
                    iconType: VectorIconType.book,
                    gradientColors: const [
                      Color(0xFF0D7377),
                      Color(0xFF159A8C)
                    ],
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(tablet ? 24 : 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D7377), Color(0xFF159A8C)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(children: [
                      Icon(Icons.video_call_rounded,
                          color: Colors.white, size: 38),
                      SizedBox(width: 14),
                      Expanded(
                        child: LocalizedText(
                          'শিক্ষকের দেওয়া ক্লাসের তথ্য এখানে দেখবে।',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.5),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  const DuolingoSectionLabel(label: 'তোমার ক্লাস'),
                  const SizedBox(height: 10),
                  FutureBuilder<List<LiveClass>>(
                    future: _classesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const _ScheduleMessage(
                          icon: Icons.hourglass_top_rounded,
                          title: 'ক্লাসের তথ্য আনা হচ্ছে…',
                          detail: 'একটু অপেক্ষা করো।',
                        );
                      }
                      if (snapshot.hasError) {
                        return _ScheduleMessage(
                          icon: Icons.wifi_off_rounded,
                          title: 'ক্লাসের তথ্য আনা যায়নি।',
                          detail: 'আবার চেষ্টা করো।',
                          action: TextButton.icon(
                            onPressed: () => setState(() {
                              _classesFuture = _loadClasses();
                            }),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const LocalizedText('আবার চেষ্টা'),
                          ),
                        );
                      }
                      final classes = [...?snapshot.data]..sort((a, b) =>
                          (a.startAt ?? DateTime(9999))
                              .compareTo(b.startAt ?? DateTime(9999)));
                      if (classes.isEmpty) {
                        return const _ScheduleMessage(
                          icon: Icons.event_busy_rounded,
                          title: 'এখনো কোনো ক্লাসের সময়সূচি নেই।',
                          detail:
                              'শিক্ষক বা প্রতিষ্ঠান সময়সূচি দিলে এখানে দেখাবে।',
                        );
                      }
                      return Column(
                        children: [
                          for (final liveClass in classes)
                            _ClassCard(
                              liveClass: liveClass,
                              now: _now,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => LiveClassDetailScreen(
                                    liveClass: liveClass,
                                    launcher: widget.launcher,
                                    now: widget.now,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  LocalizedText(
                    'ক্লাসের সময়সূচি ও লিংক শিক্ষক/প্রতিষ্ঠানের কাছ থেকে আসতে হবে।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.darkText.withValues(alpha: .55),
                        fontSize: 11,
                        height: 1.5),
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

class LiveClassDetailScreen extends StatefulWidget {
  const LiveClassDetailScreen({
    super.key,
    required this.liveClass,
    required this.launcher,
    this.now,
  });

  final LiveClass liveClass;
  final MeetingLinkLauncher launcher;
  final DateTime Function()? now;

  @override
  State<LiveClassDetailScreen> createState() => _LiveClassDetailScreenState();
}

class _LiveClassDetailScreenState extends State<LiveClassDetailScreen> {
  bool _opening = false;

  DateTime get _now => widget.now?.call() ?? DateTime.now();

  bool get _canJoin =>
      widget.liveClass.statusAt(_now) == LiveClassStatus.live &&
      widget.liveClass.safeMeetingUri != null;

  String get _joinMessage {
    switch (widget.liveClass.statusAt(_now)) {
      case LiveClassStatus.upcoming:
        return 'ক্লাস শুরু হলে যোগ দিতে পারবে।';
      case LiveClassStatus.completed:
        return 'এই ক্লাসটি শেষ হয়েছে।';
      case LiveClassStatus.cancelled:
        return 'এই ক্লাসটি বাতিল করা হয়েছে।';
      case LiveClassStatus.unavailable:
        return 'এই ক্লাসের সময়সূচি এখন পাওয়া যাচ্ছে না।';
      case LiveClassStatus.live:
        if (widget.liveClass.meetingUrl == null ||
            widget.liveClass.meetingUrl!.trim().isEmpty) {
          return 'শিক্ষক এখনো মিটিং লিংক দেননি।';
        }
        if (widget.liveClass.safeMeetingUri == null) {
          return 'নিরাপদ HTTPS মিটিং লিংক না থাকায় যোগ দেওয়া যাবে না।';
        }
        return '';
    }
  }

  Future<void> _join() async {
    final uri = widget.liveClass.safeMeetingUri;
    if (!_canJoin || uri == null || _opening) return;
    setState(() => _opening = true);
    var opened = false;
    try {
      opened = await widget.launcher.open(uri);
    } catch (_) {
      opened = false;
    }
    if (!mounted) return;
    setState(() => _opening = false);
    if (!opened) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: const LocalizedText(
              'মিটিং লিংক খুলতে পারিনি। অভিভাবকের সাহায্য নাও।'),
          action: SnackBarAction(
            label: context.uiText('লিংক কপি'),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: uri.toString())),
          ),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveClass = widget.liveClass;
    final status = liveClass.statusAt(_now);
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DuolingoPageHeader(
              title: 'ক্লাসের বিস্তারিত',
              subtitle: liveClass.title,
              iconType: VectorIconType.book,
              gradientColors: const [Color(0xFF0D7377), Color(0xFF159A8C)],
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 18),
            DuolingoCard(
              accentColor: AppTheme.primaryGreen,
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LocalizedText(liveClass.title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.darkText)),
                      ),
                      _StatusBadge(status: status),
                    ],
                  ),
                  if (liveClass.teacher?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 14),
                    _DetailLine(
                        icon: Icons.person_rounded,
                        label: 'শিক্ষক',
                        value: liveClass.teacher!.trim()),
                  ],
                  if (liveClass.startAt != null) ...[
                    const SizedBox(height: 11),
                    _DetailLine(
                      icon: Icons.calendar_month_rounded,
                      label: 'তারিখ',
                      value: _formatDate(context, liveClass.startAt!),
                    ),
                    if (liveClass.endAt != null) ...[
                      const SizedBox(height: 9),
                      _DetailLine(
                        icon: Icons.schedule_rounded,
                        label: 'সময়',
                        value:
                            '${_formatTime(context, liveClass.startAt!)} – ${_formatTime(context, liveClass.endAt!)}',
                      ),
                    ],
                  ],
                  if (liveClass.description?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 16),
                    LocalizedText(liveClass.description!.trim(),
                        style: const TextStyle(
                            color: Colors.black87, height: 1.6)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _canJoin && !_opening ? _join : null,
              icon: _opening
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.open_in_new_rounded),
              label: LocalizedText(
                  _opening ? 'লিংক খোলা হচ্ছে…' : 'ক্লাসে যোগ দাও'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppTheme.primaryGreen,
              ),
            ),
            if (!_canJoin && _joinMessage.isNotEmpty) ...[
              const SizedBox(height: 9),
              LocalizedText(_joinMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, height: 1.5)),
            ],
            const SizedBox(height: 14),
            LocalizedText(
              'ক্লাসে যোগ দিতে সমস্যা হলে অভিভাবককে বলো. ক্লাসের উপস্থিতি ও উপকরণ এখন অ্যাপে সংযুক্ত নেই.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.darkText.withValues(alpha: .55),
                  fontSize: 11,
                  height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context).formatMediumDate(date.toLocal());

String _formatTime(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(date.toLocal()));

String _statusTitle(LiveClassStatus status) => switch (status) {
      LiveClassStatus.upcoming => 'আসছে',
      LiveClassStatus.live => 'এখন চলছে',
      LiveClassStatus.completed => 'শেষ',
      LiveClassStatus.cancelled => 'বাতিল',
      LiveClassStatus.unavailable => 'তথ্য নেই',
    };

Color _statusColor(LiveClassStatus status) => switch (status) {
      LiveClassStatus.live => const Color(0xFF16834A),
      LiveClassStatus.upcoming => const Color(0xFF8A6500),
      LiveClassStatus.completed => Colors.blueGrey,
      LiveClassStatus.cancelled => Colors.redAccent,
      LiveClassStatus.unavailable => Colors.black45,
    };

class _ClassCard extends StatelessWidget {
  const _ClassCard(
      {required this.liveClass, required this.now, required this.onTap});

  final LiveClass liveClass;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = liveClass.statusAt(now);
    return DuolingoCard(
      onTap: onTap,
      accentColor: _statusColor(status),
      margin: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: LocalizedText(liveClass.title,
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
            ),
            _StatusBadge(status: status),
          ]),
          if (liveClass.teacher?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 7),
            LocalizedText('শিক্ষক: ${liveClass.teacher!.trim()}',
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
          if (liveClass.startAt != null) ...[
            const SizedBox(height: 7),
            LocalizedText(
              '${_formatDate(context, liveClass.startAt!)} · ${_formatTime(context, liveClass.startAt!)}',
              style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ],
          const SizedBox(height: 9),
          const LocalizedText('বিস্তারিত দেখো  ›',
              style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final LiveClassStatus status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _statusColor(status).withValues(alpha: .12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: LocalizedText(_statusTitle(status),
            style: TextStyle(
                color: _statusColor(status),
                fontSize: 11,
                fontWeight: FontWeight.w800)),
      );
}

class _DetailLine extends StatelessWidget {
  const _DetailLine(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 19, color: AppTheme.primaryGreen),
        const SizedBox(width: 9),
        LocalizedText('$label: ',
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w700)),
        Expanded(
          child: LocalizedText(value,
              style: const TextStyle(
                  color: AppTheme.darkText, fontWeight: FontWeight.w700)),
        ),
      ]);
}

class _ScheduleMessage extends StatelessWidget {
  const _ScheduleMessage(
      {required this.icon,
      required this.title,
      required this.detail,
      this.action});
  final IconData icon;
  final String title, detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) => DuolingoCard(
        accentColor: AppTheme.primaryGreen,
        margin: EdgeInsets.zero,
        child: Column(children: [
          Icon(icon, size: 32, color: AppTheme.primaryGreen),
          const SizedBox(height: 9),
          LocalizedText(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.darkText, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          LocalizedText(detail,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.5)),
          if (action != null) action!,
        ]),
      );
}
