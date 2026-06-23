import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/data_service.dart';

/// Estado global do app. Tudo em memória — não persiste entre reinícios
/// (comportamento intencional para o protótipo).
class AppState extends ChangeNotifier {
  final DataService _service = DataService();

  bool carregando = true;
  String? erro;

  List<Local> locais = [];
  List<Categoria> categorias = [];
  List<Rota> rotas = [];
  List<Aventureiro> aventureiros = [];
  Perfil? perfil;

  /// Filtro de categoria ativo (compartilhado entre Mapa e Catálogo).
  String categoriaSelecionada = 'todos';

  /// Ids de locais favoritados/salvos (estado em memória).
  final Set<String> favoritos = {};

  Future<void> inicializar() async {
    try {
      final results = await Future.wait([
        _service.carregarLocais(),
        _service.carregarCategorias(),
        _service.carregarRotas(),
        _service.carregarAventureiros(),
        _service.carregarPerfil(),
      ]);
      locais = results[0] as List<Local>;
      categorias = results[1] as List<Categoria>;
      rotas = results[2] as List<Rota>;
      aventureiros = results[3] as List<Aventureiro>;
      perfil = results[4] as Perfil;
      carregando = false;
      notifyListeners();
    } catch (e) {
      erro = e.toString();
      carregando = false;
      notifyListeners();
    }
  }

  void selecionarCategoria(String id) {
    categoriaSelecionada = id;
    notifyListeners();
  }

  /// Locais filtrados pela categoria ativa.
  List<Local> get locaisFiltrados {
    if (categoriaSelecionada == 'todos') return locais;
    return locais.where((l) => l.categoria == categoriaSelecionada).toList();
  }

  Local? localPorId(String id) {
    for (final l in locais) {
      if (l.id == id) return l;
    }
    return null;
  }

  List<Local> paradasDaRota(Rota rota) {
    return rota.paradas
        .map(localPorId)
        .whereType<Local>()
        .toList();
  }

  bool isFavorito(String id) => favoritos.contains(id);

  void toggleFavorito(String id) {
    if (!favoritos.remove(id)) favoritos.add(id);
    notifyListeners();
  }

  /// Adiciona uma avaliação do usuário (no topo da lista) em memória.
  void adicionarAvaliacao(Local local, int estrelas, String comentario) {
    local.avaliacoes.insert(
      0,
      Avaliacao(
        autor: 'Você',
        estrelas: estrelas,
        comentario: comentario.trim().isEmpty
            ? 'Avaliação sem comentário.'
            : comentario.trim(),
        resposta: null,
      ),
    );
    notifyListeners();
  }

  /// Registra uma visita a um local (incrementa contadores + histórico).
  void registrarVisita(Local local) {
    final p = perfil;
    if (p == null) return;
    p.locaisVisitados += 1;
    p.xp += 50;
    p.historico.insert(
      0,
      HistoricoItem(local: local.nome, data: 'Agora mesmo'),
    );
    notifyListeners();
  }

  /// Conclui uma rota: desbloqueia o selo correspondente e soma XP.
  void concluirRota(Rota rota) {
    final p = perfil;
    if (p == null) return;
    p.rotasCompletas += 1;
    p.xp += rota.xpRecompensa;
    for (final selo in p.selos) {
      if (selo.nome == rota.seloRecompensa) {
        selo.conquistado = true;
      }
    }
    notifyListeners();
  }
}
