import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../hive/pets_services.dart'; // Ensure this imports the correct HiveService


void showInterstitialAd(BuildContext context, String pet) {
  bool adLoading = true;
  InterstitialAd? interstitialAd;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text("Loading Ad"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            adLoading
                ? CircularProgressIndicator()
                : Icon(Icons.error, color: Colors.red, size: 30), // Error state
            SizedBox(height: 10),
            Text(adLoading ? "Please wait..." : "Ad failed to load."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog if user wants to exit
              interstitialAd?.dispose(); // Dispose of the ad if it was loaded
            },
            child: Text("Close"),
          ),
        ],
      ),
    ),
  );

  // Load the interstitial ad
  InterstitialAd.load(
    adUnitId: "ca-app-pub-3384646858316717/1577141288", // Test AdMob Unit ID for Interstitial
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        interstitialAd = ad;
        Navigator.pop(context); // Close loading dialog

        // Show the ad
        ad.show().then((_) {
          // This callback is called when the ad is closed
          // Unlock the pet after watching the ad
          HiveService.saveSelectedPet(pet);
        });

        // Dispose of the ad when it is closed
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            ad.dispose();
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
            ad.dispose();
          },
        );
      },
      onAdFailedToLoad: (LoadAdError error) {
        // Update loading dialog state to show an error
        adLoading = false; // Update the loading state

      },
    ),
  );
}