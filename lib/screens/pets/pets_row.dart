import 'package:flutter/material.dart';
import 'choose_pet.dart';
import 'get_pet_images.dart';

class PetRow extends StatefulWidget {
  const PetRow({Key? key}) : super(key: key);

  @override
  State<PetRow> createState() => _PetRowState();
}
class _PetRowState extends State<PetRow> {
  static List<String> petImages = [];

  @override
  void initState() {
    super.initState();
    _loadPetImages();
  }

  Future<void> _loadPetImages() async {
    if (petImages.isEmpty) {
      final images = await loadPetsItems();
      setState(() {
        petImages = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pets",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetSelectionScreen()),
                  );
                },
                child: Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Pet Images List
          SizedBox(
            height: 70,
            child:
            petImages.isEmpty
                ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/pets/butterfly-01.png', height: 60, width: 60),
                Image.asset('assets/pets/cat-01.png', height: 60, width: 60),
                Image.asset('assets/pets/chick.png', height: 60, width: 60),
                Image.asset('assets/pets/crab-01.png', height: 60, width: 60),
              ],
            )
                :
            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space evenly
                  children: List.generate(
                    petImages.length > 4 ? 4 : petImages.length,
                        (index) {
                      double screenWidth = MediaQuery.of(context).size.width;
                      double itemWidth = (screenWidth / 4) - 20; // Distribute evenly
                      double maxItemSize = 60;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PetSelectionScreen()),
                          );
                        },
                        child: SizedBox(
                          width: itemWidth.clamp(40, maxItemSize),
                          child: Image.asset(
                            petImages[index],
                            height: itemWidth.clamp(40, maxItemSize),
                            width: itemWidth.clamp(40, maxItemSize),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                )
          ),
        ],
      ),
    );
  }
}
