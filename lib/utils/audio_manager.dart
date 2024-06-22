import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _backgroundInstance = AudioManager._internal();
  static final AudioManager _effectsInstance = AudioManager._internal();

  late AudioPlayer _audioPlayer;

  factory AudioManager.background() {
    return _backgroundInstance;
  }

  factory AudioManager.effects() {
    return _effectsInstance;
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

  static Future<void> playBackground(String audioPath) async {
    await AudioManager.background().play(audioPath);
  }

  static Future<void> pauseBackground() async {
    await AudioManager.background().pause();
  }

  static Future<void> stopBackground() async {
    await AudioManager.background().stop();
  }

  static Future<bool> isBackgroundPlaying() async {
    return await AudioManager.background().isPlaying();
  }

  static Future<void> disposeBackground() async {
    await AudioManager.background().dispose();
  }

  static Future<void> playEffect(String audioPath) async {
    await AudioManager.effects().play(audioPath);
  }

  static Future<void> pauseEffect() async {
    await AudioManager.effects().pause();
  }

  static Future<void> stopEffect() async {
    await AudioManager.effects().stop();
  }

  static Future<bool> isEffectPlaying() async {
    return await AudioManager.effects().isPlaying();
  }

  static Future<void> disposeEffect() async {
    await AudioManager.effects().dispose();
  }
}
