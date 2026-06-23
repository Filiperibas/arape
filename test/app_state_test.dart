// Testes automatizados do Plano de Teste (Campo 3 do roteiro do AVA).
//
// Cobrem as 3 funcionalidades críticas do MVP — cada uma com caminho feliz
// e caso de erro/borda — e ainda checam propriedades/invariantes do AppState.
// Roda com: flutter test

import 'package:arape/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppState state;

  setUp(() async {
    // Estado novo a cada teste — garante isolamento.
    state = AppState();
    await state.inicializar();
  });

  // ---------------------------------------------------------------------------
  // FUNCIONALIDADE 1 — Filtro por categoria (Mapa e Catálogo)
  // Oráculo: locaisFiltrados é sempre {l ∈ locais : l.categoria == id}.
  // ---------------------------------------------------------------------------
  group('Filtro por categoria', () {
    test('caminho feliz: "Águas" devolve os 3 locais cadastrados', () {
      state.selecionarCategoria('aguas');
      final filtrados = state.locaisFiltrados;
      final nomes = filtrados.map((l) => l.nome).toList();

      expect(filtrados.length, 3);
      expect(nomes, containsAll([
        'Cachoeira do Monte Negro',
        'Balneário Rio Jamari',
        'Pesqueiro Águas Claras',
      ]));
    });

    test('borda: "Todos" depois de filtrar volta a exibir os 12 locais', () {
      state.selecionarCategoria('aguas');
      expect(state.locaisFiltrados.length, lessThan(state.locais.length));

      state.selecionarCategoria('todos');
      expect(state.locaisFiltrados.length, state.locais.length);
      expect(state.locais.length, 12);
    });

    test('invariante: lista filtrada é sempre subconjunto coerente do total', () {
      final categorias = ['trilhas', 'aguas', 'agroindustria', 'cultura', 'gastronomia'];

      for (final cat in categorias) {
        state.selecionarCategoria(cat);
        final filt = state.locaisFiltrados;

        // Subconjunto: nunca maior que o total.
        expect(filt.length, lessThanOrEqualTo(state.locais.length));
        // Coerência: todos pertencem à categoria solicitada.
        for (final l in filt) {
          expect(l.categoria, cat);
        }
      }
    });
  });

  // ---------------------------------------------------------------------------
  // FUNCIONALIDADE 2 — Conclusão de rota com desbloqueio do selo
  // Oráculo: concluir uma rota desbloqueia EXATAMENTE rota.seloRecompensa
  //          e soma rota.xpRecompensa ao perfil. Abandono não desbloqueia.
  // ---------------------------------------------------------------------------
  group('Conclusão de rota e desbloqueio de selo', () {
    test('caminho feliz: concluir Rota Cultural desbloqueia "Guardião da Cultura" e soma 140 XP', () {
      // rota_003 começa com o selo "Guardião da Cultura" NÃO conquistado.
      final rota = state.rotas.firstWhere((r) => r.id == 'rota_003');
      final perfil = state.perfil!;
      final seloAlvo = perfil.selos.firstWhere((s) => s.nome == rota.seloRecompensa);

      // Sanity check do estado inicial mockado.
      expect(seloAlvo.conquistado, isFalse,
          reason: 'O selo deveria começar bloqueado para o teste fazer sentido');

      final xpAntes = perfil.xp;
      final rotasAntes = perfil.rotasCompletas;

      state.concluirRota(rota);

      expect(perfil.rotasCompletas, rotasAntes + 1);
      expect(perfil.xp, xpAntes + rota.xpRecompensa);
      expect(seloAlvo.conquistado, isTrue,
          reason: 'O selo cujo nome bate com rota.seloRecompensa deve estar conquistado');
    });

    test('borda: visitar uma parada (sem concluir) NÃO desbloqueia o selo', () {
      final rota = state.rotas.firstWhere((r) => r.id == 'rota_003');
      final paradas = state.paradasDaRota(rota);
      final perfil = state.perfil!;
      final seloAlvo = perfil.selos.firstWhere((s) => s.nome == rota.seloRecompensa);

      final rotasAntes = perfil.rotasCompletas;

      // "Cheguei" em apenas uma parada — simula abandono da rota.
      state.registrarVisita(paradas.first);

      expect(seloAlvo.conquistado, isFalse,
          reason: 'Selo só deve abrir após concluirRota completa');
      expect(perfil.rotasCompletas, rotasAntes,
          reason: 'rotasCompletas só muda quando a rota é concluída');
    });

    test('invariante: número de selos conquistados nunca diminui após concluir uma rota', () {
      final perfil = state.perfil!;
      final conqAntes = perfil.selos.where((s) => s.conquistado).length;

      state.concluirRota(state.rotas.first);

      final conqDepois = perfil.selos.where((s) => s.conquistado).length;
      expect(conqDepois, greaterThanOrEqualTo(conqAntes));
    });
  });

  // ---------------------------------------------------------------------------
  // FUNCIONALIDADE 3 — Adicionar avaliação de local (em memória)
  // Oráculo: nova avaliação vira o 1º item da lista, autor "Você",
  //          comentário em branco usa texto padrão.
  // ---------------------------------------------------------------------------
  group('Avaliação de local', () {
    test('caminho feliz: 5 estrelas + comentário vira a 1ª avaliação da lista', () {
      final local = state.locaisFiltrados
          .firstWhere((l) => l.nome == 'Cachoeira do Monte Negro');
      final qtdAntes = local.avaliacoes.length;
      const comentario = 'Lindo demais!';

      state.adicionarAvaliacao(local, 5, comentario);

      expect(local.avaliacoes.length, qtdAntes + 1);
      expect(local.avaliacoes.first.autor, 'Você');
      expect(local.avaliacoes.first.estrelas, 5);
      expect(local.avaliacoes.first.comentario, comentario);
    });

    test('borda: comentário em branco usa texto padrão e não trava', () {
      final local = state.locais.first;

      state.adicionarAvaliacao(local, 4, '   '); // só espaços em branco

      expect(local.avaliacoes.first.comentario, 'Avaliação sem comentário.');
      expect(local.avaliacoes.first.estrelas, 4);
    });
  });
}
