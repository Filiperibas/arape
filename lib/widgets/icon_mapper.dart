import 'package:flutter/material.dart';

/// Converte os nomes de ícone vindos do JSON em [IconData] do Material.
IconData iconeFromString(String nome) {
  switch (nome) {
    case 'water':
      return Icons.water;
    case 'pool':
      return Icons.pool;
    case 'terrain':
      return Icons.terrain;
    case 'landscape':
      return Icons.landscape;
    case 'agriculture':
      return Icons.agriculture;
    case 'restaurant':
      return Icons.restaurant;
    case 'coffee':
      return Icons.coffee;
    case 'festival':
      return Icons.festival;
    case 'phishing':
      return Icons.phishing;
    case 'apps':
      return Icons.apps;
    default:
      return Icons.place;
  }
}
