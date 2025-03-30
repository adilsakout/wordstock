import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

class AudioPlayerRepository {
  AudioPlayerRepository() {
    _audioPlayer = AudioPlayer();
    _setupListeners();
  }

  late final AudioPlayer _audioPlayer;
  final _logger = Logger();
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  void _setupListeners() {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen(
      (state) {
        _logger.d('Player state changed: $state');
      },
      onError: (Object error) {
        _logger.e('Player state error: $error');
      },
    );

    _positionSubscription = _audioPlayer.onPositionChanged.listen(
      (position) {
        _logger.d('Position changed: $position');
      },
      onError: (Object error) {
        _logger.e('Position error: $error');
      },
    );
  }

  /// Play audio from a URL
  Future<void> playFromUrl(String url) async {
    try {
      await _audioPlayer.play(
        UrlSource(url),
        volume: 1,
        mode: PlayerMode.mediaPlayer,
      );
    } catch (e) {
      _logger.e('Error playing audio from URL: $e');
      rethrow;
    }
  }

  /// Play audio from a local asset
  Future<void> playFromAsset(
    String assetPath, {
    double volume = 1.0,
    PlayerMode mode = PlayerMode.lowLatency,
  }) async {
    try {
      await _audioPlayer.play(
        AssetSource(assetPath),
        volume: volume,
        mode: mode,
      );
    } catch (e) {
      _logger.e('Error playing audio from asset: $e');
      rethrow;
    }
  }

  /// Play audio from a local file path
  Future<void> playFromFile(String filePath, {double volume = 1}) async {
    try {
      await _audioPlayer.play(
        DeviceFileSource(filePath),
        volume: volume,
        mode: PlayerMode.mediaPlayer,
      );
    } catch (e) {
      _logger.e('Error playing audio from file: $e');
      rethrow;
    }
  }

  /// Pause the current audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      _logger.e('Error pausing audio: $e');
      rethrow;
    }
  }

  /// Resume the current audio
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      _logger.e('Error resuming audio: $e');
      rethrow;
    }
  }

  /// Stop the current audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      _logger.e('Error stopping audio: $e');
      rethrow;
    }
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      _logger.e('Error seeking audio: $e');
      rethrow;
    }
  }

  /// Set the volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      _logger.e('Error setting volume: $e');
      rethrow;
    }
  }

  /// Get the current position
  Future<Duration?> getPosition() async {
    try {
      return await _audioPlayer.getCurrentPosition();
    } catch (e) {
      _logger.e('Error getting position: $e');
      return null;
    }
  }

  /// Get the total duration
  Future<Duration?> getDuration() async {
    try {
      return await _audioPlayer.getDuration();
    } catch (e) {
      _logger.e('Error getting duration: $e');
      return null;
    }
  }

  /// Get the current player state
  PlayerState get state => _audioPlayer.state;

  /// Stream of player state changes
  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

  /// Stream of position changes
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;

  /// Stream of duration changes
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;

  /// Dispose of the audio player and its resources
  Future<void> dispose() async {
    try {
      await _playerStateSubscription?.cancel();
      await _positionSubscription?.cancel();
      await _audioPlayer.dispose();
    } catch (e) {
      _logger.e('Error disposing audio player: $e');
      rethrow;
    }
  }
}
