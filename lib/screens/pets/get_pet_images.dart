import 'dart:convert';
import 'package:flutter/services.dart';


Future<List<String>> loadPetsItems() async {
  final List<String> petImagePaths = [];
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestJson);

  final iconPaths = manifestMap.keys
      .where((path) => path.contains('assets/pets/') && path.endsWith('.png'))
      .toList();

  petImagePaths.addAll(iconPaths);
  return petImagePaths;
}

