import '../../core/core.dart';
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
                    title: context.t('live.learn_with_teacher'),
                    subtitle: context.t('live.subtitle'),
                    iconType: VectorIconType.book,
                    gradientColors: const [
                      Color(0xFF58CC02),
                      Color(0xFF46A302),
                    ],
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(tablet ? 24 : 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF58CC02), Color(0xFF46A302)],
                      ),
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
                      const Icon(Icons.video_call_rounded,
                          color: Colors.white, size: 38),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          context.t('live.banner_info'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.5),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  DuolingoSectionLabel(label: context.t('live.section_title')),
                  const SizedBox(height: 10),
                  FutureBuilder<List<LiveClass>>(
                    future: _classesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return _ScheduleMessage(
                          icon: Icons.hourglass_top_rounded,
                          title: context.t('live.loading_title'),
                          detail: context.t('live.loading_detail'),
                        );
                      }
                      if (snapshot.hasError) {
                        return _ScheduleMessage(
                          icon: Icons.wifi_off_rounded,
                          title: context.t('live.error_title'),
                          detail: context.t('live.error_detail'),
                          action: TextButton.icon(
                            onPressed: () => setState(() {
                              _classesFuture = _loadClasses();
                            }),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(context.t('live.retry_btn')),
                          ),
                        );
                      }
                      final classes = [...?snapshot.data]..sort((a, b) =>
                          (a.startAt ?? DateTime(9999))
                              .compareTo(b.startAt ?? DateTime(9999)));
                      if (classes.isEmpty) {
                        return _ScheduleMessage(
                          icon: Icons.event_busy_rounded,
                          title: context.t('live.empty_title'),
                          detail: context.t('live.empty_detail'),
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
                  Text(
                    context.t('live.schedule_source_note'),
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

  String _joinMessage(BuildContext context) {
    switch (widget.liveClass.statusAt(_now)) {
      case LiveClassStatus.upcoming:
        return context.t('live.cannot_join_upcoming');
      case LiveClassStatus.completed:
        return context.t('live.cannot_join_completed');
      case LiveClassStatus.cancelled:
        return context.t('live.cannot_join_cancelled');
      case LiveClassStatus.unavailable:
        return context.t('live.cannot_join_unavailable');
      case LiveClassStatus.live:
        if (widget.liveClass.meetingUrl == null ||
            widget.liveClass.meetingUrl!.trim().isEmpty) {
          return context.t('live.cannot_join_missing_url');
        }
        if (widget.liveClass.safeMeetingUri == null) {
          return context.t('live.cannot_join_unsafe_url');
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
          content: Text(context.t('live.join_error_snackbar')),
          action: SnackBarAction(
            label: context.t('live.copy_link'),
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
    final joinMsg = _joinMessage(context);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DuolingoPageHeader(
              title: context.t('live.detail_header_title'),
              subtitle: liveClass.title,
              iconType: VectorIconType.book,
              gradientColors: const [Color(0xFF58CC02), Color(0xFF46A302)],
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
                        child: Text(liveClass.title,
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
                        label: context.t('live.teacher_label'),
                        value: liveClass.teacher!.trim()),
                  ],
                  if (liveClass.startAt != null) ...[
                    const SizedBox(height: 11),
                    _DetailLine(
                      icon: Icons.calendar_month_rounded,
                      label: context.t('live.date_label'),
                      value: _formatDate(context, liveClass.startAt!),
                    ),
                    if (liveClass.endAt != null) ...[
                      const SizedBox(height: 9),
                      _DetailLine(
                        icon: Icons.schedule_rounded,
                        label: context.t('live.time_label'),
                        value:
                            '${_formatTime(context, liveClass.startAt!)} – ${_formatTime(context, liveClass.endAt!)}',
                      ),
                    ],
                  ],
                  if (liveClass.description?.trim().isNotEmpty ?? false) ...[
                    const SizedBox(height: 16),
                    Text(liveClass.description!.trim(),
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
              label: Text(
                  _opening ? context.t('live.opening_link') : context.t('live.join_btn')),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppTheme.primaryGreen,
              ),
            ),
            if (!_canJoin && joinMsg.isNotEmpty) ...[
              const SizedBox(height: 9),
              Text(joinMsg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, height: 1.5)),
            ],
            const SizedBox(height: 14),
            Text(
              context.t('live.parent_help_disclaimer'),
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
    context.formatDate(date.toLocal(), format: AppDateFormat.medium);

String _formatTime(BuildContext context, DateTime date) =>
    context.formatTime(date.toLocal());

String _statusTitle(BuildContext context, LiveClassStatus status) => switch (status) {
      LiveClassStatus.upcoming => context.t('live.status.upcoming'),
      LiveClassStatus.live => context.t('live.status.live'),
      LiveClassStatus.completed => context.t('live.status.completed'),
      LiveClassStatus.cancelled => context.t('live.status.cancelled'),
      LiveClassStatus.unavailable => context.t('live.status.unavailable'),
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
              child: Text(liveClass.title,
                  style: const TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w900)),
            ),
            _StatusBadge(status: status),
          ]),
          if (liveClass.teacher?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 7),
            Text(
              context.t('live.teacher', params: {'name': liveClass.teacher!.trim()}),
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
          if (liveClass.startAt != null) ...[
            const SizedBox(height: 7),
            Text(
              '${_formatDate(context, liveClass.startAt!)} · ${_formatTime(context, liveClass.startAt!)}',
              style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ],
          const SizedBox(height: 9),
          Text(context.t('live.card_view_details'),
              style: const TextStyle(
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
        child: Text(_statusTitle(context, status),
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
        Text('$label: ',
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w700)),
        Expanded(
          child: Text(value,
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
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.darkText, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(detail,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.5)),
          if (action != null) action!,
        ]),
      );
}
