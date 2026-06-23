import 'package:latlong2/latlong.dart';

class Produto {
  final String nome;
  final String preco;
  final String imagem;

  Produto({required this.nome, required this.preco, required this.imagem});

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        nome: json['nome'] as String,
        preco: json['preco'] as String,
        imagem: json['imagem'] as String,
      );
}

class Avaliacao {
  final String autor;
  final int estrelas;
  final String comentario;
  final String? resposta;

  Avaliacao({
    required this.autor,
    required this.estrelas,
    required this.comentario,
    this.resposta,
  });

  factory Avaliacao.fromJson(Map<String, dynamic> json) => Avaliacao(
        autor: json['autor'] as String,
        estrelas: json['estrelas'] as int,
        comentario: json['comentario'] as String,
        resposta: json['resposta'] as String?,
      );
}

class Local {
  final String id;
  final String nome;
  final String categoria;
  final String categoriaLabel;
  final String icone;
  final String descricaoCurta;
  final String descricaoCompleta;
  final double lat;
  final double lng;
  final String distancia;
  final List<String> imagens;
  final double avaliacaoMedia;
  final int totalAvaliacoes;
  final String horario;
  final String valor;
  final String oQueEsperar;
  final String whatsapp;
  final bool verificado;
  final List<Produto> produtos;

  /// Avaliações são mutáveis em memória — novas avaliações do usuário entram aqui.
  final List<Avaliacao> avaliacoes;

  Local({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.categoriaLabel,
    required this.icone,
    required this.descricaoCurta,
    required this.descricaoCompleta,
    required this.lat,
    required this.lng,
    required this.distancia,
    required this.imagens,
    required this.avaliacaoMedia,
    required this.totalAvaliacoes,
    required this.horario,
    required this.valor,
    required this.oQueEsperar,
    required this.whatsapp,
    required this.verificado,
    required this.produtos,
    required this.avaliacoes,
  });

  LatLng get latLng => LatLng(lat, lng);

  factory Local.fromJson(Map<String, dynamic> json) => Local(
        id: json['id'] as String,
        nome: json['nome'] as String,
        categoria: json['categoria'] as String,
        categoriaLabel: json['categoriaLabel'] as String,
        icone: json['icone'] as String,
        descricaoCurta: json['descricaoCurta'] as String,
        descricaoCompleta: json['descricaoCompleta'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        distancia: json['distancia'] as String? ?? '',
        imagens: (json['imagens'] as List).cast<String>(),
        avaliacaoMedia: (json['avaliacaoMedia'] as num).toDouble(),
        totalAvaliacoes: json['totalAvaliacoes'] as int,
        horario: json['horario'] as String,
        valor: json['valor'] as String,
        oQueEsperar: json['oQueEsperar'] as String,
        whatsapp: json['whatsapp'] as String,
        verificado: json['verificado'] as bool? ?? false,
        produtos: (json['produtos'] as List)
            .map((e) => Produto.fromJson(e as Map<String, dynamic>))
            .toList(),
        avaliacoes: (json['avaliacoes'] as List)
            .map((e) => Avaliacao.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Categoria {
  final String id;
  final String label;
  final String icone;

  Categoria({required this.id, required this.label, required this.icone});

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json['id'] as String,
        label: json['label'] as String,
        icone: json['icone'] as String,
      );
}

class Rota {
  final String id;
  final String nome;
  final String descricao;
  final String imagem;
  final String duracaoEstimada;
  final String dificuldade;
  final String seloRecompensa;
  final int xpRecompensa;
  final List<String> paradas;

  Rota({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.duracaoEstimada,
    required this.dificuldade,
    required this.seloRecompensa,
    required this.xpRecompensa,
    required this.paradas,
  });

  factory Rota.fromJson(Map<String, dynamic> json) => Rota(
        id: json['id'] as String,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String,
        imagem: json['imagem'] as String,
        duracaoEstimada: json['duracaoEstimada'] as String,
        dificuldade: json['dificuldade'] as String,
        seloRecompensa: json['seloRecompensa'] as String,
        xpRecompensa: json['xpRecompensa'] as int,
        paradas: (json['paradas'] as List).cast<String>(),
      );
}

class Selo {
  final String id;
  final String nome;
  final String icone;
  bool conquistado;

  Selo({
    required this.id,
    required this.nome,
    required this.icone,
    required this.conquistado,
  });

  factory Selo.fromJson(Map<String, dynamic> json) => Selo(
        id: json['id'] as String,
        nome: json['nome'] as String,
        icone: json['icone'] as String,
        conquistado: json['conquistado'] as bool? ?? false,
      );
}

class HistoricoItem {
  final String local;
  final String data;

  HistoricoItem({required this.local, required this.data});

  factory HistoricoItem.fromJson(Map<String, dynamic> json) => HistoricoItem(
        local: json['local'] as String,
        data: json['data'] as String,
      );
}

class Perfil {
  final String nome;
  final String avatar;
  int locaisVisitados;
  int rotasCompletas;
  int xp;
  final String nivel;
  final List<Selo> selos;
  final List<HistoricoItem> historico;

  Perfil({
    required this.nome,
    required this.avatar,
    required this.locaisVisitados,
    required this.rotasCompletas,
    required this.xp,
    required this.nivel,
    required this.selos,
    required this.historico,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) => Perfil(
        nome: json['nome'] as String,
        avatar: json['avatar'] as String,
        locaisVisitados: json['locaisVisitados'] as int,
        rotasCompletas: json['rotasCompletas'] as int,
        xp: json['xp'] as int,
        nivel: json['nivel'] as String,
        selos: (json['selos'] as List)
            .map((e) => Selo.fromJson(e as Map<String, dynamic>))
            .toList(),
        historico: (json['historico'] as List)
            .map((e) => HistoricoItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Aventureiro {
  final String nome;
  final double lat;
  final double lng;
  final String avatar;

  Aventureiro({
    required this.nome,
    required this.lat,
    required this.lng,
    required this.avatar,
  });

  LatLng get latLng => LatLng(lat, lng);

  factory Aventureiro.fromJson(Map<String, dynamic> json) => Aventureiro(
        nome: json['nome'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        avatar: json['avatar'] as String,
      );
}
