import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  late AudioPlayer _audioPlayer;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> play(String audioPath) async {
    await _audioPlayer.play(AssetSource(audioPath));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<bool> isPlaying() async {
    return _audioPlayer.state == PlayerState.playing;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
