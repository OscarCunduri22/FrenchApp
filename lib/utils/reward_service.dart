import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

class RewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, bool> _unlockedRewards = {};

  Future<void> initialize() async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot snapshot = await _firestore.collection('user_rewards').doc(userId).get();
      if (snapshot.exists) {
        _unlockedRewards = Map<String, bool>.from(snapshot.data() as Map<String, dynamic>);
      }
    }
  }

  Future<void> unlockReward(String rewardId) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      _unlockedRewards[rewardId] = true;
      DocumentReference userRewardsRef = _firestore.collection('user_rewards').doc(userId);
      await userRewardsRef.set({rewardId: true}, SetOptions(merge: true));
    }
  }

  bool isRewardUnlocked(String rewardId) {
    return _unlockedRewards[rewardId] ?? false;
  }

  List<String> getUnlockedRewards() {
    return _unlockedRewards.keys.where((key) => _unlockedRewards[key] == true).toList();
  }

  Future<void> saveFile(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final fileName = assetPath.split('/').last;
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName';

      final file = File(tempPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      final params = SaveFileDialogParams(sourceFilePath: tempPath);
      await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      throw Exception('Error saving file: $e');
    }
  }

  String getRewardPath(int index) {
    List<String> rewards = [
      'assets/rewards/Voyelles_reward_1.pdf',
      'assets/rewards/Voyelles_reward_2.pdf',
      'assets/rewards/Voyelles_reward_3.pdf',
    ];
    return rewards[index];
  }

  static const int totalRewards = 3; // Número total de recompensas
}
