import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/cycle_page_components/category_grid.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class ShowHideMood extends StatefulWidget {
  const ShowHideMood({Key? key}) : super(key: key);

  @override
  _ShowHideMoodState createState() => _ShowHideMoodState();
}

class _ShowHideMoodState extends State<ShowHideMood> {
  late Future<List<CategoryItem>> _emojiList;

  @override
  void initState() {
    super.initState();
    _emojiList = loadCategoryItems('emoji'); // Load emojis from assets/emoji folder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Moods",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        ),
        actions: [
          Icon(Icons.check_box, color: primaryColor),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder<List<CategoryItem>>(
        future: _emojiList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final emojis = snapshot.data ?? [];
          final moodsProvider = Provider.of<MoodsProvider>(context);

          // Initialize all moods to be visible by default if not already done
          if (moodsProvider.visibleMoods.isEmpty) {
            moodsProvider.initializeVisibleMoods(emojis.map((emoji) => emoji.label).toList());
          }

          return ListView.builder(
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              final emoji = emojis[index];
              final isSwitched = moodsProvider.isMoodVisible(emoji.label);

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.white,
                child: ListTile(
                  leading: emoji.iconPath.endsWith('.svg')
                      ? SvgPicture.asset(emoji.iconPath, height: 30, width: 30)
                      : Image.asset(emoji.iconPath, height: 30, width: 30),
                  title: Text(emoji.label),
                  trailing: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          moodsProvider.addVisibleMood(emoji.label);
                        } else {
                          moodsProvider.removeVisibleMood(emoji.label);
                        }
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}