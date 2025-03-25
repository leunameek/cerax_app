import 'range_info.dart';

class Plant {
  final String plant;
  final String scientificName;
  final String image;
  final RangeInfo moisture;
  final RangeInfo light;
  final RangeInfo temperature;

  Plant({
    required this.plant,
    required this.scientificName,
    required this.image,
    required this.moisture,
    required this.light,
    required this.temperature,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plant: json['plant'],
      scientificName: json['scientific_name'],
      image: json['image'],
      moisture: RangeInfo.fromJson(json['moisture']),
      light: RangeInfo.fromJson(json['light']),
      temperature: RangeInfo.fromJson(json['temperature']),
    );
  }
}
