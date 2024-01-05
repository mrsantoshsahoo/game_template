import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_id.dart';

InterstitialAd? _interstitialAd;
RewardedAd? _rewardedAd;
createRewardedAdd() {
  RewardedAd.load(
      adUnitId: AppAdsId.rewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
        },
      ));
}

showRewardedAdd() {
  if (_rewardedAd != null) {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        createRewardedAdd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        createRewardedAdd();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      // _counter++;
    });
    _rewardedAd = null;
  }
}

 createInterstitialAd() {
  InterstitialAd.load(
      adUnitId: AppAdsId.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _interstitialAd = null;
          // if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
          //   _createInterstitialAd();
          // }
        },
      ));
}

void showInterstitialAd() {
  if (_interstitialAd != null) {
    // print("object");
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      // onAdShowedFullScreenContent: (InterstitialAd ad) {
      //   ad.dispose();
      //   _createInterstitialAd();
      // },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        // _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
