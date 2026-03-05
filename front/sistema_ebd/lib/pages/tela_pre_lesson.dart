import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/pre_lesson_repositories.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/models/pre_lesson.dart';
import 'package:sistema_ebd/models/trimestre/trismestre.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/tela_relatorio_aula.dart';

class TelaPreLesson extends ConsumerStatefulWidget {
  const TelaPreLesson({super.key});

  @override
  ConsumerState<TelaPreLesson> createState() => _TelaPreLessonState();
}

class _TelaPreLessonState extends ConsumerState<TelaPreLesson> {
  final PreLessonRepository _preLessonRepo = PreLessonRepository();
  final TrimestreRepository _trimestreRepo = TrimestreRepository();
  final ScrollController _scrollController = ScrollController();

  late UsuarioLogado userLog;
  List<PreLesson> preLessons = [];
  Trimestre? ultimoTrimestre;
  bool isLoading = true;
  bool carregandoMais = false;
  int numeroPage = 1;

  @override
  void initState() {
    super.initState();
    userLog = ref.read(usuarioLogado);
    _carregarDados();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (preLessons.length < totalPreLessons && !carregandoMais) {
          _carregarMaisPreLessons();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      // Buscar o último trimestre cadastrado (página 1, pegar o primeiro)
      final trimestres = await _trimestreRepo.getTrimestre(
        numeroPage: 1,
        token: userLog.token,
      );
      if (trimestres.isNotEmpty) {
        ultimoTrimestre = trimestres.first;
        await _fetchPreLessons(1);
      }
    } catch (e) {
      _mostrarErro('Erro ao carregar dados: ${e.toString()}');
    }
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _fetchPreLessons(int page) async {
    if (ultimoTrimestre == null) return;
    try {
      final resultado = await _preLessonRepo.getPreLessons(
        page: page,
        token: userLog.token,
        trimesterId: ultimoTrimestre!.id,
      );
      if (resultado != null) {
        if (page == 1) {
          preLessons = resultado;
        } else {
          preLessons.addAll(resultado);
        }
      }
    } catch (e) {
      _mostrarErro('Erro ao buscar aulas: ${e.toString()}');
    }
  }

  Future<void> _carregarMaisPreLessons() async {
    setState(() => carregandoMais = true);
    numeroPage++;
    await _fetchPreLessons(numeroPage);
    if (mounted) setState(() => carregandoMais = false);
  }

  Future<void> _recarregar() async {
    setState(() {
      isLoading = true;
      preLessons.clear();
      numeroPage = 1;
    });
    await _carregarDados();
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

  void _mostrarSucesso(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        content: Center(
          child: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _abrirModalCadastro() {
    showDialog(
      context: context,
      builder: (ctx) {
        return _DialogCadastroPreLesson(
          token: userLog.token,
          trimesterId: ultimoTrimestre?.id ?? '',
          onSucesso: () {
            _recarregar();
            _mostrarSucesso('Aula cadastrada com sucesso!');
          },
          onErro: (msg) => _mostrarErro(msg),
        );
      },
    );
  }

  String _formatarData(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left, size: 30),
            color: Colors.white,
          ),
          title: Text(
            'Aulas em andamento',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: ultimoTrimestre != null ? _abrirModalCadastro : null,
              icon: const Icon(Icons.add, size: 28),
              color: Colors.white,
            ),
          ],
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ultimoTrimestre == null
                ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Nenhum trimestre cadastrado.\nCadastre um trimestre primeiro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                )
                : preLessons.isEmpty
                ? const Center(
                  child: Text(
                    'Nenhuma aula pendente',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _recarregar,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    itemCount: preLessons.length + (carregandoMais ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == preLessons.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final item = preLessons[index];
                      return _buildPreLessonCard(item);
                    },
                  ),
                ),
      ),
    );
  }

  Widget _buildPreLessonCard(PreLesson item) {
    final bool temPendentes = item.pendingClasses > 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              temPendentes
                  ? const Color(0xFFE8A020)
                  : const Color.fromARGB(218, 231, 230, 237),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading:
            temPendentes
                ? const Icon(Icons.error, color: Color(0xFFE8A020), size: 28)
                : const Icon(Icons.check_circle, color: Colors.green, size: 28),
        title: Text(
          'Lição ${item.lesson} - ${_formatarData(item.date)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle:
            temPendentes
                ? Text(
                  'Turmas pendentes: ${item.pendingClasses}',
                  style: const TextStyle(
                    color: Color(0xFFE8A020),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
                : const Text(
                  'Todas as turmas registradas',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFFE8A020),
          size: 26,
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TelaRelatorioAula(preLesson: item),
            ),
          );
          // Recarrega a lista ao voltar (pode ter mudado pendingClasses)
          _recarregar();
        },
      ),
    );
  }
}

// ─── MODAL DE CADASTRO ──────────────────────────────────────────────────────

class _DialogCadastroPreLesson extends StatefulWidget {
  final String token;
  final String trimesterId;
  final VoidCallback onSucesso;
  final Function(String) onErro;

  const _DialogCadastroPreLesson({
    required this.token,
    required this.trimesterId,
    required this.onSucesso,
    required this.onErro,
  });

  @override
  State<_DialogCadastroPreLesson> createState() =>
      _DialogCadastroPreLessonState();
}

class _DialogCadastroPreLessonState extends State<_DialogCadastroPreLesson> {
  final PreLessonRepository _repo = PreLessonRepository();
  DateTime? _dataSelecionada;
  int? _numeroAulaSelecionado;
  bool _enviando = false;

  final List<int> _numerosAulas = List.generate(13, (i) => i + 1);

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );
    if (data != null) {
      setState(() => _dataSelecionada = data);
    }
  }

  Future<void> _cadastrar() async {
    if (_dataSelecionada == null) {
      widget.onErro('Selecione a data da aula');
      return;
    }
    if (_numeroAulaSelecionado == null) {
      widget.onErro('Selecione o número da aula');
      return;
    }

    setState(() => _enviando = true);

    final dataFormatada = _dataSelecionada!.toIso8601String();
    final statusCode = await _repo.postPreLesson(
      token: widget.token,
      trimesterId: widget.trimesterId,
      date: dataFormatada,
      numberLesson: _numeroAulaSelecionado!,
    );

    setState(() => _enviando = false);

    if (statusCode == 201) {
      if (mounted) Navigator.pop(context);
      widget.onSucesso();
    } else if (statusCode == 409) {
      widget.onErro('Já existe uma aula com esse número neste trimestre');
    } else {
      widget.onErro('Erro ao cadastrar aula. Tente novamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cadastro de Aula',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.red, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Campo Data
            const Text(
              'Data da aula',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _selecionarData,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _dataSelecionada != null
                          ? dateFormat.format(_dataSelecionada!)
                          : 'Selecione a data',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            _dataSelecionada != null
                                ? Colors.black87
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo Número da Aula
            const Text(
              'Número da Aula',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  hint: const Text(
                    'Número da Aula',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  value: _numeroAulaSelecionado,
                  items:
                      _numerosAulas.map((num) {
                        return DropdownMenuItem<int>(
                          value: num,
                          child: Text('Lição $num'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _numeroAulaSelecionado = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão Cadastrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enviando ? null : _cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF034279),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _enviando
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
