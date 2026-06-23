import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/models.dart';

/// Carrega e parseia os JSONs mockados de `assets/data/`.
class DataService {
  Future<List<Local>> carregarLocais() async {
    final raw = await rootBundle.loadString('assets/data/locais.json');
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Local.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Categoria>> carregarCategorias() async {
    final raw = await rootBundle.loadString('assets/data/categorias.json');
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Categoria.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Rota>> carregarRotas() async {
    final raw = await rootBundle.loadString('assets/data/rotas.json');
    final list = jsonDecode(raw) as List;
    return list.map((e) => Rota.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Perfil> carregarPerfil() async {
    final raw = await rootBundle.loadString('assets/data/perfil.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return Perfil.fromJson(map);
  }

  Future<List<Aventureiro>> carregarAventureiros() async {
    final raw = await rootBundle.loadString('assets/data/aventureiros.json');
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Aventureiro.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
