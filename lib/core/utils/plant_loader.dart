import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/plant.dart';

class PlantLoader {
  static Future<List<Plant>> loadFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/plants.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Plant.fromJson(e)).toList();
  }
}
