import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

enum AlertSoundType {
  adhan,
  learningAlarm,
}

/// Service to handle authentic audio alerts for LittleMuslim:
/// 1. Adhan (call to prayer) audio playback (`assets/audio/adhan.mp3`)
/// 2. Daily Learning Alarm audio recitation of Auzubillah & Bismillah (`assets/audio/learning_alarm.mp3`)
class AlertSoundService {
  AlertSoundService._();
  static final AlertSoundService instance = AlertSoundService._();

  AudioPlayer? _player;
  AlertSoundType? _currentType;

  final ValueNotifier<AlertSoundType?> currentPlayingNotifier =
      ValueNotifier<AlertSoundType?>(null);

  bool get isPlaying => _currentType != null;
  AlertSoundType? get currentType => _currentType;

  AudioPlayer _getPlayer() {
    if (_player == null) {
      final p = AudioPlayer();
      p.onPlayerComplete.listen((_) {
        _currentType = null;
        currentPlayingNotifier.value = null;
      });
      _player = p;
    }
    return _player!;
  }

  /// Play the authentic Adhan audio.
  /// If already playing, this acts as a toggle to stop it.
  Future<void> playAdhan() async {
    if (_currentType == AlertSoundType.adhan) {
      await stop();
      return;
    }
    await stop();
    try {
      final player = _getPlayer();
      _currentType = AlertSoundType.adhan;
      currentPlayingNotifier.value = AlertSoundType.adhan;
      await player.play(AssetSource('audio/adhan.mp3'));
    } catch (e) {
      debugPrint('AlertSoundService: failed to play adhan: $e');
      _currentType = null;
      currentPlayingNotifier.value = null;
    }
  }

  /// Play the authentic Auzubillah + Bismillah learning alarm audio.
  /// If already playing, this acts as a toggle to stop it.
  Future<void> playLearningAlarm() async {
    if (_currentType == AlertSoundType.learningAlarm) {
      await stop();
      return;
    }
    await stop();
    try {
      final player = _getPlayer();
      _currentType = AlertSoundType.learningAlarm;
      currentPlayingNotifier.value = AlertSoundType.learningAlarm;
      await player.play(AssetSource('audio/learning_alarm.mp3'));
    } catch (e) {
      debugPrint('AlertSoundService: failed to play learning alarm: $e');
      _currentType = null;
      currentPlayingNotifier.value = null;
    }
  }

  /// Stop any currently playing alert audio.
  Future<void> stop() async {
    try {
      if (_player != null) {
        await _player!.stop();
      }
    } catch (e) {
      debugPrint('AlertSoundService: stop error: $e');
    } finally {
      _currentType = null;
      currentPlayingNotifier.value = null;
    }
  }

  /// Release resources.
  Future<void> dispose() async {
    await stop();
    try {
      await _player?.dispose();
      _player = null;
    } catch (_) {}
  }
}
