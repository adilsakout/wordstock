import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';

class TTSRepository {
  TTSRepository() {
    _audioPlayer = AudioPlayer();
  }

  TexttospeechApi? _ttsClient;
  bool _isInitialized = false;
  late final AudioPlayer _audioPlayer;
  File? _tempFile;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final client = await _getAuthClient();
      _ttsClient = TexttospeechApi(client);
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('TTS Initialization error: $e');
      }
      rethrow;
    }
  }

  Future<AuthClient> _getAuthClient() async {
    final json = await rootBundle.loadString('assets/service_account.json');
    final credentials = ServiceAccountCredentials.fromJson(json);
    return clientViaServiceAccount(
      credentials,
      [TexttospeechApi.cloudPlatformScope],
    );
  }

  Future<void> synthesizeAndPlay(String text) async {
    if (!_isInitialized || _ttsClient == null) {
      throw Exception('TTS not initialized');
    }

    final request = SynthesizeSpeechRequest()
      ..input = SynthesisInput(text: text)
      ..voice = VoiceSelectionParams(
        languageCode: 'en-US',
        name: 'en-US-Wavenet-D',
      )
      ..audioConfig = AudioConfig(
        audioEncoding: 'MP3',
        speakingRate: 1,
        pitch: 0,
      );

    try {
      final response = await _ttsClient!.text.synthesize(request);
      final audioBytes = base64.decode(response.audioContent!);

      // Clean up previous temp file if it exists
      await _tempFile?.delete();

      // Create new temp file
      final dir = await getTemporaryDirectory();
      _tempFile = File(
        '${dir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.mp3',
      );
      await _tempFile!.writeAsBytes(audioBytes);

      // Play from temp file
      await _audioPlayer.play(DeviceFileSource(_tempFile!.path));
    } catch (e) {
      if (kDebugMode) {
        print('TTS Error: $e');
      }
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    // Clean up temp file
    await _tempFile?.delete();
  }
}
