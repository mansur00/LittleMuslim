import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

enum PrayerLocationKind { device, city }

@immutable
class PrayerLocationSelection {
  const PrayerLocationSelection.device({
    required this.latitude,
    required this.longitude,
    this.timeZoneId,
  })  : kind = PrayerLocationKind.device,
        city = null,
        country = null;

  const PrayerLocationSelection.city({
    required this.city,
    required this.country,
    this.timeZoneId,
  })  : kind = PrayerLocationKind.city,
        latitude = null,
        longitude = null;

  final PrayerLocationKind kind;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;
  final String? timeZoneId;

  String get displayName =>
      kind == PrayerLocationKind.city ? '$city, $country' : 'Device location';

  PrayerLocationSelection withTimeZone(String timeZone) =>
      kind == PrayerLocationKind.city
          ? PrayerLocationSelection.city(
              city: city!, country: country!, timeZoneId: timeZone)
          : PrayerLocationSelection.device(
              latitude: latitude!,
              longitude: longitude!,
              timeZoneId: timeZone,
            );

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'country': country,
        'timeZoneId': timeZoneId,
      };

  static PrayerLocationSelection? fromJson(Object? value) {
    if (value is! Map<String, dynamic>) return null;
    final kind = value['kind'];
    final timeZoneId = value['timeZoneId'] as String?;
    if (kind == PrayerLocationKind.device.name) {
      final latitude = value['latitude'];
      final longitude = value['longitude'];
      if (latitude is! num || longitude is! num) return null;
      if (!_validCoordinates(latitude.toDouble(), longitude.toDouble())) {
        return null;
      }
      return PrayerLocationSelection.device(
        latitude: latitude.toDouble(),
        longitude: longitude.toDouble(),
        timeZoneId: timeZoneId,
      );
    }
    if (kind == PrayerLocationKind.city.name) {
      final city = value['city'];
      final country = value['country'];
      if (city is! String || city.trim().isEmpty) return null;
      if (country is! String || country.trim().isEmpty) return null;
      return PrayerLocationSelection.city(
        city: city.trim(),
        country: country.trim(),
        timeZoneId: timeZoneId,
      );
    }
    return null;
  }
}

@immutable
class PrayerCalculationSettings {
  const PrayerCalculationSettings({
    this.location,
    this.methodId = 1,
    this.asrSchool = 1,
  });

  final PrayerLocationSelection? location;
  final int methodId;
  final int asrSchool;

  PrayerCalculationSettings copyWith({
    PrayerLocationSelection? location,
    bool clearLocation = false,
    int? methodId,
    int? asrSchool,
  }) =>
      PrayerCalculationSettings(
        location: clearLocation ? null : (location ?? this.location),
        methodId: methodId ?? this.methodId,
        asrSchool: asrSchool ?? this.asrSchool,
      );

  Map<String, Object?> toJson() => {
        'location': location?.toJson(),
        'methodId': methodId,
        'asrSchool': asrSchool,
      };

  static PrayerCalculationSettings fromJson(Object? value) {
    if (value is! Map<String, dynamic>) {
      return const PrayerCalculationSettings();
    }
    final method = value['methodId'];
    final school = value['asrSchool'];
    return PrayerCalculationSettings(
      location: PrayerLocationSelection.fromJson(value['location']),
      methodId: method is int && supportedPrayerMethodIds.contains(method)
          ? method
          : 1,
      asrSchool: school == 1 ? 1 : 0,
    );
  }
}

const supportedPrayerMethodIds = <int>{
  0,
  1,
  2,
  3,
  4,
  5,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
};

@immutable
class PrayerTimesResult {
  const PrayerTimesResult({
    required this.date,
    required this.timeZoneId,
    required this.times,
    this.isCached = false,
  });

  final DateTime date;
  final String timeZoneId;
  final Map<String, DateTime> times;
  final bool isCached;
}

abstract interface class PrayerTimesRepository {
  Future<PrayerTimesResult> calculate({
    required PrayerLocationSelection location,
    required DateTime date,
    required int methodId,
    required int asrSchool,
  });
}

class PrayerTimesException implements Exception {
  const PrayerTimesException(this.message);
  final String message;
  @override
  String toString() => message;
}

class AlAdhanPrayerTimesRepository implements PrayerTimesRepository {
  AlAdhanPrayerTimesRepository({http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  void dispose() {
    if (_ownsClient) _client.close();
  }

  String _cacheKey({
    required PrayerLocationSelection location,
    required DateTime date,
    required int methodId,
    required int asrSchool,
  }) {
    final loc = location.kind == PrayerLocationKind.device
        ? 'dev_${location.latitude}_${location.longitude}'
        : 'city_${location.city}_${location.country}';
    return 'prayer_cache_${loc}_${_apiDate(date)}_m${methodId}_s$asrSchool';
  }

  Future<PrayerTimesResult?> _loadCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final date = DateTime.parse(map['date'] as String);
      final timeZoneId = map['timeZoneId'] as String;
      final timesRaw = map['times'] as Map<String, dynamic>;
      final times = <String, DateTime>{};
      for (final e in timesRaw.entries) {
        times[e.key] = DateTime.parse(e.value as String);
      }
      return PrayerTimesResult(
        date: date,
        timeZoneId: timeZoneId,
        times: Map.unmodifiable(times),
        isCached: true,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(String key, PrayerTimesResult result) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = {
        'date': result.date.toIso8601String(),
        'timeZoneId': result.timeZoneId,
        'times': result.times.map((k, v) => MapEntry(k, v.toIso8601String())),
      };
      await prefs.setString(key, jsonEncode(map));
    } catch (_) {}
  }

  @override
  Future<PrayerTimesResult> calculate({
    required PrayerLocationSelection location,
    required DateTime date,
    required int methodId,
    required int asrSchool,
  }) async {
    if (!supportedPrayerMethodIds.contains(methodId)) {
      throw const PrayerTimesException('Unsupported calculation method.');
    }
    if (asrSchool != 0 && asrSchool != 1) {
      throw const PrayerTimesException('Unsupported Asr school.');
    }
    final key = _cacheKey(
      location: location,
      date: date,
      methodId: methodId,
      asrSchool: asrSchool,
    );
    final path = location.kind == PrayerLocationKind.device
        ? '/v1/timings/${_apiDate(date)}'
        : '/v1/timingsByCity/${_apiDate(date)}';
    final query = <String, String>{
      'method': '$methodId',
      'school': '$asrSchool',
      'iso8601': 'true',
    };
    if (location.kind == PrayerLocationKind.device) {
      final latitude = location.latitude;
      final longitude = location.longitude;
      if (latitude == null ||
          longitude == null ||
          !_validCoordinates(latitude, longitude)) {
        throw const PrayerTimesException('Invalid coordinates.');
      }
      query['latitude'] = '$latitude';
      query['longitude'] = '$longitude';
    } else {
      final city = location.city?.trim() ?? '';
      final country = location.country?.trim() ?? '';
      if (city.isEmpty || country.isEmpty) {
        throw const PrayerTimesException('City and country are required.');
      }
      query['city'] = city;
      query['country'] = country;
    }

    final uri = Uri.https('api.aladhan.com', path, query);
    late final http.Response response;
    try {
      response = await _client.get(uri, headers: const {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 15));
    } catch (error) {
      final cached = await _loadCache(key);
      if (cached != null) return cached;
      throw PrayerTimesException('Prayer times could not be reached: $error');
    }
    if (response.statusCode != 200) {
      final cached = await _loadCache(key);
      if (cached != null) return cached;
      throw PrayerTimesException(
          'Prayer times service returned ${response.statusCode}.');
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['code'] != 200) {
        throw const PrayerTimesException('Prayer times are unavailable.');
      }
      final data = body['data'] as Map<String, dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;
      final timeZoneId = meta['timezone'];
      final timings = data['timings'] as Map<String, dynamic>;
      if (timeZoneId is! String || timeZoneId.isEmpty) {
        throw const PrayerTimesException('Location time zone is unavailable.');
      }
      final times = <String, DateTime>{};
      for (final prayer in const [
        'Fajr',
        'Sunrise',
        'Dhuhr',
        'Asr',
        'Maghrib',
        'Isha',
      ]) {
        final raw = timings[prayer];
        if (raw is! String) {
          throw PrayerTimesException('$prayer time is missing.');
        }
        final match = RegExp(r'T(\d{2}):(\d{2})').firstMatch(raw) ??
            RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(raw.trim());
        if (match == null) {
          throw PrayerTimesException('$prayer time has an invalid format.');
        }
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        if (hour > 23 || minute > 59) {
          throw PrayerTimesException('$prayer time is out of range.');
        }
        times[prayer] = DateTime(date.year, date.month, date.day, hour, minute);
      }
      final result = PrayerTimesResult(
        date: DateTime(date.year, date.month, date.day),
        timeZoneId: timeZoneId,
        times: Map.unmodifiable(times),
      );
      await _saveCache(key, result);
      return result;
    } on PrayerTimesException {
      rethrow;
    } catch (error) {
      throw PrayerTimesException('Prayer times response is invalid: $error');
    }
  }

  String _apiDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}

abstract interface class PrayerSettingsStore {
  Future<PrayerCalculationSettings> load();
  Future<void> save(PrayerCalculationSettings settings);
}

class SharedPreferencesPrayerSettingsStore implements PrayerSettingsStore {
  static const _key = 'prayer_calculation_settings';

  @override
  Future<PrayerCalculationSettings> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null) return const PrayerCalculationSettings();
    try {
      return PrayerCalculationSettings.fromJson(jsonDecode(raw));
    } on FormatException {
      return const PrayerCalculationSettings();
    }
  }

  @override
  Future<void> save(PrayerCalculationSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(settings.toJson()));
  }
}

class PrayerCoordinates {
  const PrayerCoordinates(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

enum DeviceLocationFailure {
  serviceDisabled,
  denied,
  deniedForever,
  unavailable,
}

class DeviceLocationException implements Exception {
  const DeviceLocationException(this.failure);
  final DeviceLocationFailure failure;
}

abstract interface class PrayerDeviceLocationProvider {
  Future<PrayerCoordinates> currentCoordinates();
  Future<bool> openAppSettings();
}

class GeolocatorPrayerDeviceLocationProvider
    implements PrayerDeviceLocationProvider {
  @override
  Future<PrayerCoordinates> currentCoordinates() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const DeviceLocationException(
            DeviceLocationFailure.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw const DeviceLocationException(DeviceLocationFailure.denied);
      }
      if (permission == LocationPermission.deniedForever) {
        throw const DeviceLocationException(
            DeviceLocationFailure.deniedForever);
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!_validCoordinates(position.latitude, position.longitude)) {
        throw const DeviceLocationException(DeviceLocationFailure.unavailable);
      }
      return PrayerCoordinates(position.latitude, position.longitude);
    } catch (error) {
      if (error is DeviceLocationException) rethrow;
      throw const DeviceLocationException(DeviceLocationFailure.unavailable);
    }
  }

  @override
  Future<bool> openAppSettings() async {
    if (kIsWeb) return false;
    return Geolocator.openAppSettings();
  }
}

class PrayerDateTools {
  PrayerDateTools._();
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    _initialized = true;
  }

  static DateTime today({String? timeZoneId, DateTime? now}) {
    final instant = now ?? DateTime.now();
    if (timeZoneId == null || timeZoneId.isEmpty) {
      return DateTime(instant.year, instant.month, instant.day);
    }
    try {
      initialize();
      final local = tz.TZDateTime.from(instant, tz.getLocation(timeZoneId));
      return DateTime(local.year, local.month, local.day);
    } on Exception {
      return DateTime(instant.year, instant.month, instant.day);
    }
  }

  static DateTime normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _validCoordinates(double latitude, double longitude) =>
    latitude.isFinite &&
    longitude.isFinite &&
    latitude >= -90 &&
    latitude <= 90 &&
    longitude >= -180 &&
    longitude <= 180;
