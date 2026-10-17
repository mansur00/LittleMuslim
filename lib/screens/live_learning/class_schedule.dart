import 'dart:convert';

import 'package:http/http.dart' as http;
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

  factory LiveClass.fromJson(Map<String, dynamic> json) {
    return LiveClass(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      teacher: json['teacher'] as String?,
      startAt: json['startAt'] != null
          ? DateTime.tryParse(json['startAt'] as String)
          : null,
      endAt: json['endAt'] != null
          ? DateTime.tryParse(json['endAt'] as String)
          : null,
      description: json['description'] as String?,
      meetingUrl: json['meetingUrl'] as String?,
      recordState: ClassRecordState.values.firstWhere(
        (e) => e.name == json['recordState'],
        orElse: () => ClassRecordState.scheduled,
      ),
    );
  }

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
        !endAt!.toUtc().isAfter(startAt!.toUtc())) {
      return LiveClassStatus.unavailable;
    }
    final nowUtc = now.toUtc();
    final startUtc = startAt!.toUtc();
    final endUtc = endAt!.toUtc();
    if (!nowUtc.isBefore(endUtc)) return LiveClassStatus.completed;
    if (nowUtc.isBefore(startUtc)) return LiveClassStatus.upcoming;
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

/// Production HTTP adapter for connecting a teacher/school class scheduling API.
class HttpClassScheduleRepository implements ClassScheduleRepository {
  HttpClassScheduleRepository({
    required this.endpointUri,
    this.apiKey,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final Uri endpointUri;
  final String? apiKey;
  final http.Client _client;
  final bool _ownsClient;

  void dispose() {
    if (_ownsClient) _client.close();
  }

  @override
  Future<List<LiveClass>> loadClasses() async {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (apiKey != null && apiKey!.isNotEmpty) 'Authorization': 'Bearer $apiKey',
    };
    final response = await _client
        .get(endpointUri, headers: headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to load class schedule: HTTP ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data is! List) {
      throw const FormatException('Expected JSON array of live classes');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(LiveClass.fromJson)
        .toList();
  }
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
