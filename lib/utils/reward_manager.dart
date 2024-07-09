import 'package:flutter/material.dart';

class RewardManager with ChangeNotifier {
  static const int totalRewards = 9;
  List<bool> rewardsUnlocked = List<bool>.filled(totalRewards, false);

  void unlockReward(int index) {
    if (index >= 0 && index < totalRewards) {
      rewardsUnlocked[index] = true;
      notifyListeners();
    }
  }

  bool isRewardUnlocked(int index) {
    if (index >= 0 && index < totalRewards) {
      return rewardsUnlocked[index];
    }
    return false;
  }

  String getRewardPath(int index) {
    const rewardPaths = [
      'assets/rewards/Voyelles_reward_1.pdf',
      'assets/rewards/Voyelles_reward_2.pdf',
      'assets/rewards/Voyelles_reward_3.pdf',
      'assets/rewards/Nombres_reward_1.pdf',
      'assets/rewards/Nombres_reward_2.pdf',
      'assets/rewards/Nombres_reward_3.pdf',
      'assets/rewards/Famille_reward_1.pdf',
      'assets/rewards/Famille_reward_2.pdf',
      'assets/rewards/Famille_reward_3.pdf',
    ];
    if (index >= 0 && index < rewardPaths.length) {
      return rewardPaths[index];
    }
    return '';
  }
}
