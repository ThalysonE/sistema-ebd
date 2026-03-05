import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/lesson_repositories.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/models/lesson.dart';
import 'package:sistema_ebd/models/pre_lesson.dart';
import 'package:sistema_ebd/models/trimestre/turma_trimestre.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/tela_registro_turma.dart';

class TelaRelatorioAula extends ConsumerStatefulWidget {
  final PreLesson preLesson;

  const TelaRelatorioAula({super.key, required this.preLesson});

  @override
  ConsumerState<TelaRelatorioAula> createState() => _TelaRelatorioAulaState();
}

class _TelaRelatorioAulaState extends ConsumerState<TelaRelatorioAula> {
  static const _corPrimaria = Color(0xFF034279);
  static const _corLaranja = Color(0xFFE8A020);
  static const _corVerde = Color(0xFF43A047);
  static const _corFundo = Color(0xFFF5F5F5);

  final TrimestreRepository _trimestreRepo = TrimestreRepository();
  final LessonRepository _lessonRepo = LessonRepository();

  late UsuarioLogado userLog;
  List<TurmaTrimestre> turmas = [];
  Map<String, Lesson?> turmaLessonMap = {};
  bool isLoading = true;
  bool _aulaFinalizada = false;

  @override
  void initState() {
    super.initState();
    userLog = ref.read(usuarioLogado);
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => isLoading = true);
    try {
      // 1. Buscar todas as turmas do trimestre
      turmas = await _trimestreRepo.getTurmasTrimestre(
        numeroPage: 1,
        token: userLog.token,
        idTrimestre: widget.preLesson.trimesterId,
      );

      // 2. Para cada turma, buscar as aulas e encontrar a que pertence a esta pré-aula
      turmaLessonMap.clear();
      final futures = turmas.map((turma) async {
        try {
          final lessons = await _lessonRepo.getLessons(
            page: 1,
            token: userLog.token,
            trimesterRoomId: turma.id,
            perPage: 50,
          );
          final match = lessons.cast<Lesson?>().firstWhere(
            (l) => l!.preLessonId == widget.preLesson.id,
            orElse: () => null,
          );
          return MapEntry(turma.id, match);
        } catch (_) {
          return MapEntry(turma.id, null);
        }
      });

      final results = await Future.wait(futures);
      for (final entry in results) {
        turmaLessonMap[entry.key] = entry.value;
      }
    } catch (e) {
      _mostrarErro('Erro ao carregar dados: ${e.toString()}');
    }
    if (mounted) setState(() => isLoading = false);
  }

  void _mostrarErro(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  // ─── Cálculos do relatório geral ───────────────────────────────────────────

  int get _totalMatriculados =>
      turmas.fold<int>(0, (sum, t) => sum + t.registros);

  int get _totalVisitantes => turmaLessonMap.values
      .where((l) => l != null)
      .fold<int>(0, (sum, l) => sum + l!.visitors);

  int get _totalBiblias => turmaLessonMap.values
      .where((l) => l != null)
      .fold<int>(0, (sum, l) => sum + l!.bibles);

  int get _totalRevistas => turmaLessonMap.values
      .where((l) => l != null)
      .fold<int>(0, (sum, l) => sum + l!.magazines);

  double get _totalOfertas => turmaLessonMap.values
      .where((l) => l != null)
      .fold<double>(0, (sum, l) => sum + l!.offers);

  int get _turmasCompletas =>
      turmaLessonMap.values.where((l) => l != null).length;

  int get _turmasPendentes => turmas.length - _turmasCompletas;

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(widget.preLesson.date);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _corPrimaria,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
          color: Colors.white,
        ),
        title: Text(
          'Relatório Geral da Aula',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed:
                _aulaFinalizada
                    ? null
                    : () async {
                      final confirmou = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (ctx) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 28,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Ícone decorativo
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: Colors.red.shade400,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Título
                                    const Text(
                                      'Finalizar Aula',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Descrição
                                    Text(
                                      'Tem certeza que deseja finalizar esta aula?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.orange.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange.shade700,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Essa ação é irreversível. Não será '
                                              'possível editar os dados das turmas.',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.orange.shade900,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Botões
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, false),
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              side: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade500,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              'Finalizar',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );

                      if (confirmou == true && mounted) {
                        setState(() => _aulaFinalizada = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[400],
                            duration: const Duration(seconds: 2),
                            content: const Center(
                              child: Text(
                                'Aula finalizada - edição bloqueada',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
            icon: Icon(
              _aulaFinalizada ? Icons.lock : Icons.lock_open,
              color: _aulaFinalizada ? Colors.red[300] : Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _carregarDados,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    // ── Cabeçalho da lição ──
                    _buildCabecalhoLicao(dateStr),
                    const SizedBox(height: 20),

                    // ── Lista de turmas ──
                    _buildSectionHeader('Turmas', Icons.groups),
                    const SizedBox(height: 8),
                    ...turmas.map((turma) => _buildTurmaCard(turma)),

                    const SizedBox(height: 24),

                    // ── Relatório Geral Da Aula ──
                    _buildSectionHeader(
                      'Relatório Geral Da Aula',
                      Icons.bar_chart,
                    ),
                    const SizedBox(height: 8),
                    _buildEstatisticasLista(),

                    const SizedBox(height: 28),

                    // ── Botão atualizar ──
                    if (!_aulaFinalizada) _buildBotaoAtualizar(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  // ─── Cabeçalho da lição ────────────────────────────────────────────────────

  Widget _buildCabecalhoLicao(String dateStr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _corPrimaria.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _corPrimaria.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: _corPrimaria, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lição ${widget.preLesson.lesson} - $dateStr',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _turmasPendentes > 0
                      ? '$_turmasPendentes turma(s) pendente(s)'
                      : 'Todas as turmas registradas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _turmasPendentes > 0 ? _corLaranja : _corVerde,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String titulo, IconData icone) {
    return Row(
      children: [
        Icon(icone, size: 20, color: _corPrimaria),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  // ─── Card de turma ─────────────────────────────────────────────────────────

  Widget _buildTurmaCard(TurmaTrimestre turma) {
    final lesson = turmaLessonMap[turma.id];
    final bool completa = lesson != null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              completa
                  ? _corVerde.withOpacity(0.4)
                  : _corLaranja.withOpacity(0.4),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          completa ? Icons.check_circle : Icons.error,
          color: completa ? _corVerde : _corLaranja,
          size: 28,
        ),
        title: Text(
          turma.nome,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          completa ? 'Aula registrada' : 'Pendente',
          style: TextStyle(
            color: completa ? _corVerde : _corLaranja,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: completa ? _corVerde : _corLaranja,
          size: 26,
        ),
        onTap: () async {
          final resultado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder:
                  (_) => TelaRegistroTurma(
                    turmaTrimestre: turma,
                    preLesson: widget.preLesson,
                    lessonExistente: lesson,
                    bloqueado: _aulaFinalizada,
                  ),
            ),
          );
          // Se salvou uma nova aula, recarrega os dados
          if (resultado == true) {
            _carregarDados();
          }
        },
      ),
    );
  }

  // ─── Lista de estatísticas ─────────────────────────────────────────────────

  Widget _buildEstatisticasLista() {
    final items = [
      _StatItem(
        'Matriculados',
        _totalMatriculados.toString(),
        'assets/images/relatorio/matriculados.png',
      ),
      _StatItem('Presentes', '0', 'assets/images/relatorio/presentes.png'),
      _StatItem('Ausentes', '0', 'assets/images/relatorio/ausentes.png'),
      _StatItem(
        'Visitantes',
        _totalVisitantes.toString(),
        'assets/images/relatorio/visitantes.png',
      ),
      _StatItem(
        'Bíblias',
        _totalBiblias.toString(),
        'assets/images/relatorio/biblias.png',
      ),
      _StatItem(
        'Revistas',
        _totalRevistas.toString(),
        'assets/images/relatorio/revista.png',
      ),
      _StatItem(
        'Ofertas',
        'R\$ ${_totalOfertas.toStringAsFixed(2).replaceFirst('.', ',')}',
        'assets/images/relatorio/ofertas.png',
      ),
    ];

    return Column(
      children:
          items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: _corFundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    item.assetPath,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    item.valor,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  // ─── Botão atualizar ───────────────────────────────────────────────────────

  Widget _buildBotaoAtualizar() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _carregarDados,
        icon: const Icon(Icons.refresh, size: 20),
        label: const Text(
          'Atualizar Aula',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _corPrimaria,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// ─── Modelo auxiliar para estatísticas ────────────────────────────────────────

class _StatItem {
  final String label;
  final String valor;
  final String assetPath;

  _StatItem(this.label, this.valor, this.assetPath);
}
