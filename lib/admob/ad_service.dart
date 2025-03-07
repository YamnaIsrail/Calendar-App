import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false; // Track if ad is loading

  void loadInterstitialAd(Function onAdLoaded, Function onAdFailedToLoad) {
    if (_isAdLoading || _interstitialAd != null) return; // Prevent multiple loads

    _isAdLoading = true;
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3384646858316717/1577141288", // Test Ad Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoading = false;
          onAdLoaded();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoading = false;
          onAdFailedToLoad();
        },
      ),
    );
  }

  bool isAdLoaded() => _interstitialAd != null; // Check if ad is ready

  void showInterstitialAd(BuildContext context, Function onNavigate) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _interstitialAd = null; // Clear the ad after displaying
          loadInterstitialAd(() {}, () {}); // Preload next ad
          onNavigate(); // Navigate after ad is dismissed
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print("fully");
          ad.dispose();
          _interstitialAd = null; // Clear the ad
          onNavigate(); // Navigate even if ad fails
        },
      );
      _interstitialAd!.show();
    } else {
      onNavigate(); // If ad is not ready, navigate immediately
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
