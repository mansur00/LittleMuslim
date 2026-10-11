import 'package:url_launcher/url_launcher.dart';

enum LiveClassStatus { upcoming, live, completed, cancelled, unavailable }

enum ClassRecordState { scheduled, cancelled, unavailable }

class LiveClass {
  const LiveClass({
    required this.id,
    required this.title,
    this.teacher,
    this.startAt,
    this.endAt,
    this.description,
    this.meetingUrl,
    this.recordState = ClassRecordState.scheduled,
  });

  final String id;
  final String title;
  final String? teacher;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? description;
  final String? meetingUrl;
  final ClassRecordState recordState;

  LiveClassStatus statusAt(DateTime now) {
    if (recordState == ClassRecordState.cancelled) {
      return LiveClassStatus.cancelled;
    }
    if (recordState == ClassRecordState.unavailable ||
        startAt == null ||
        endAt == null ||
        !endAt!.isAfter(startAt!)) {
      return LiveClassStatus.unavailable;
    }
    if (!now.isBefore(endAt!)) return LiveClassStatus.completed;
    if (now.isBefore(startAt!)) return LiveClassStatus.upcoming;
    return LiveClassStatus.live;
  }

  Uri? get safeMeetingUri {
    final value = meetingUrl?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme.toLowerCase() != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      return null;
    }
    return uri;
  }
}

abstract interface class ClassScheduleRepository {
  Future<List<LiveClass>> loadClasses();
}

/// The app has no connected class schedule source yet, so the default is empty.
class EmptyClassScheduleRepository implements ClassScheduleRepository {
  const EmptyClassScheduleRepository();

  @override
  Future<List<LiveClass>> loadClasses() async => const [];
}

abstract interface class MeetingLinkLauncher {
  Future<bool> open(Uri uri);
}

class ExternalMeetingLinkLauncher implements MeetingLinkLauncher {
  const ExternalMeetingLinkLauncher();

  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}
