import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../firebase/analytics/analytics_service.dart';
import '../../hive/pets_services.dart';
import '../flow2/home_flow2.dart';
import 'get_pet_images.dart';


class PetSelectionScreen extends StatefulWidget {
  @override
  _PetSelectionScreenState createState() => _PetSelectionScreenState();
}

class _PetSelectionScreenState extends
  State<PetSelectionScreen> {

  List<String> petImages = [];
  String? selectedPet;
  InterstitialAd? interstitialAd;
  bool isAdLoaded = false; // Track if the ad has been loaded
  bool isLoadingAd = false;
  DateTime? _startTime;


  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Record the entry time
    AnalyticsService.logScreenView("PetsSelection");

    _loadPets();
    _loadInterstitialAd();

  }



  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false; // No internet connection
    }
  }

  Future<void> _loadPets() async {
    final images = await loadPetsItems();
    setState(() {
      petImages = images;
      selectedPet = HiveService.getSelectedPet();
    });
  }

  Future<void> _loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3384646858316717/1577141288", // Test AdMob Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            interstitialAd = ad;
            isAdLoaded = true;
            isLoadingAd = false; // ✅ Stop loading if ad is loaded
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            isAdLoaded = false;
            isLoadingAd = false; // ✅ Stop loading if ad fails
          });
        },
      ),
    );
  }

  void _showPetUnlockedDialog(String pet) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Congratulations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("New pet unlocked! Check it out in your collection.",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 15),
                    CircleAvatar(radius: 40,
                      // backgroundImage: AssetImage(pet) ,
                      child:Image.asset(pet)
                      ,),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                        onPressed: () async {
                          // Check for internet connectivity
                          bool hasInternet = await checkInternetConnection();

                          if (!hasInternet) {
                            // Proceed without showing the ad
                            HiveService.saveSelectedPet(pet);
                            setState(() {
                              selectedPet = pet;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Flow2Page()),
                            );
                            return;
                          }

                          // If internet is available, only then start loading the ad
                          setDialogState(() => isLoadingAd = true);

                          int attempts = 0;
                          const maxAttempts = 30; // Wait for 6 seconds max (200ms * 30)
                          while (!isAdLoaded && attempts < maxAttempts) {
                            await Future.delayed(Duration(milliseconds: 200));
                            attempts++;
                          }

                          setDialogState(() => isLoadingAd = false); // Stop loading

                          // If ad is still not loaded, proceed without showing the ad
                          if (!isAdLoaded) {
                            HiveService.saveSelectedPet(pet);
                            setState(() {
                              selectedPet = pet;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Flow2Page()),
                            );
                            return;
                          }

                          // Show ad if loaded
                          if (interstitialAd != null) {
                            interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                                ad.dispose();
                                HiveService.saveSelectedPet(pet);
                                setState(() {
                                  selectedPet = pet; // Update stored pet after ad
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Flow2Page()),
                                );
                              },
                              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                                ad.dispose();
                                HiveService.saveSelectedPet(pet);
                                setState(() {
                                  selectedPet = pet; // Update stored pet after failed ad
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Flow2Page()),
                                );
                              },
                            );
                            interstitialAd!.show();
                          } else {
                            HiveService.saveSelectedPet(pet);
                            setState(() {
                              selectedPet = pet;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Flow2Page()),
                            );
                          }

                        },
                        child: isLoadingAd
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Apply", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 10),
                    Image.asset("assets/pets_unlock_banner.png", fit: BoxFit.cover),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((_) {
      // ✅ Reset selection if dialog is dismissed (user didn't press "Apply")
      setState(() {
        selectedPet = HiveService.getSelectedPet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String? tempSelectedPet;

    return Scaffold(
      appBar: AppBar(title: Text('Choose your Pet')),
      body: Stack(
        children: [
          petImages.isEmpty
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: petImages.length,
            itemBuilder: (context, index) {
              final pet = petImages[index];
              return GestureDetector(
                onTap: () {
                  setState(() => tempSelectedPet = pet); // Temporarily select pet
                  _showPetUnlockedDialog(pet);
                },

                child: Container(
                  height: 120,
                  width: 104,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedPet == pet ? Colors.blue : Color(0xffe7e5e5),
                      width: 3,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(pet, fit: BoxFit.contain, height: 78, width: 78),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    if (_startTime != null) {
      int duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("PetsSelection", duration);
    }

    super.dispose();
  }
}
