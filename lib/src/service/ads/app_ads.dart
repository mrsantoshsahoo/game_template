import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_id.dart';

class AppAds extends StatefulWidget {
  final AdsType adsType;

  const AppAds({super.key, this.adsType = AdsType.none});

  @override
  State<AppAds> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AppAds> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  NativeAd? _nativeAd;

  bool _nativeAdIsLoaded = false;

  @override
  void initState() {
    _loadAds();
    super.initState();
  }

  _loadAds() async {
    if (widget.adsType == AdsType.nativeAd) {
      _loadNativeAds();
    }
    if (widget.adsType == AdsType.banner) {
      _loadBannerAds();
    }
    // if (widget.adsType == AdsType.interstitialAd) {
    //   _createInterstitialAd();
    // }
    // if (widget.adsType == AdsType.rewardedAd) {
    //    _createRewardedAdd();
    // }
  }

  _loadBannerAds() async {
    _bannerAd = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: AppAdsId.bannerId,
        listener: const BannerAdListener(),
        request: const AdRequest())
      ..load();
  }

  _loadNativeAds() {
    _nativeAd = NativeAd(
        adUnitId: AppAdsId.nativeId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,

            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.white,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                backgroundColor: Colors.white,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                backgroundColor: Colors.white,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  _createRewardedAdd()  {
     RewardedAd.load(
        adUnitId: AppAdsId.rewardedAdId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            setState(() {
              _rewardedAd = ad;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              _rewardedAd = null;
            });
          },
        ));
  }

  void _createInterstitialAd() {
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

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      // print("object");
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        // onAdShowedFullScreenContent: (InterstitialAd ad) {
        //   ad.dispose();
        //   _createInterstitialAd();
        // },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
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

  void _showRewardedAdd() {
    if (_rewardedAd != null) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _createRewardedAdd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _createRewardedAdd();
        },
      );

      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          _counter++;
        });
      });
      _rewardedAd = null;
    }
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (widget.adsType == AdsType.banner) {
      return _bannerAd == null
          ? Container()
          : SizedBox(
              width:  _bannerAd?.size.width.toDouble(),
              height: _bannerAd?.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!));
    } else if (widget.adsType == AdsType.nativeAd) {
      return _nativeAdIsLoaded == true
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 320, // minimum recommended width
                minHeight: 320, // minimum recommended height
                maxWidth: 400,
                maxHeight: 400,
              ),
              child: AdWidget(ad: _nativeAd!),
            )
          : Container();
    } else {
      return Container();
    }
  }
}

enum AdsType { banner,  nativeAd, none }
enum RewardsAdsType { interstitialAd, rewardedAd, none }
