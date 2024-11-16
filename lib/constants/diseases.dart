import 'package:flutter/material.dart';

TextStyle kStyleDefault = const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

List<String> countryNames = [
  "Severe Anemia",
  "Severe Malaria",
  "Dehydration",
  "Severe Acute Malnutrition",
  "Ascites",
];

List<Country> countries = List<Country>.generate(
  countryNames.length,
  (index) => Country(
    name: countryNames[index],
  
  ),
);

class Country {
  final String name;
 
  const Country({
    required this.name,
  });

  @override
  String toString() {
    return 'Country(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}