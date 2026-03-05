import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/lesson_repositories.dart';
import 'package:sistema_ebd/Data/repositories/matricula_repositories.dart';
import 'package:sistema_ebd/models/lesson.dart';
import 'package:sistema_ebd/models/matricula.dart';
import 'package:sistema_ebd/models/pre_lesson.dart';
import 'package:sistema_ebd/models/trimestre/turma_trimestre.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/tela_chamada.dart';

class TelaRegistroTurma extends ConsumerStatefulWidget {
  final TurmaTrimestre turmaTrimestre;
  final PreLesson preLesson;
  final Lesson? lessonExistente;
  final bool bloqueado;

  const TelaRegistroTurma({
    super.key,
    required this.turmaTrimestre,
    required this.preLesson,
    this.lessonExistente,
    this.bloqueado = false,
  });

  @override
  ConsumerState<TelaRegistroTurma> createState() => _TelaRegistroTurmaState();
}

class _TelaRegistroTurmaState extends ConsumerState<TelaRegistroTurma> {
  static const _corPrimaria = Color(0xFF034279);
  static const _corVerde = Color(0xFF43A047);

  final LessonRepository _lessonRepo = LessonRepository();
  final MatriculaRepository _matriculaRepo = MatriculaRepository();
  final TextEditingController _tituloController = TextEditingController();

  late UsuarioLogado userLog;
  bool isLoading = true;
  bool isSaving = false;

  List<Matricula> alunos = [];
  List<Map<String, dynamic>> chamadaResultado = [];
  int presentes = 0;

  int _visitantes = 0;
  int _biblias = 0;
  int _revistas = 0;
  double _ofertas = 0;

  bool get _isEdicao => widget.lessonExistente != null;
  bool get _isReadOnly => _isEdicao || widget.bloqueado;

  @override
  void initState() {
    super.initState();
    userLog = ref.read(usuarioLogado);

    // Se já existe uma aula, preenche os campos
    if (_isEdicao) {
      final l = widget.lessonExistente!;
      _tituloController.text = l.title;
      _visitantes = l.visitors;
      _biblias = l.bibles;
      _revistas = l.magazines;
      _ofertas = l.offers.toDouble();
    }

    _carregarAlunos();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _carregarAlunos() async {
    try {
      int page = 1;
      List<Matricula> todosAlunos = [];
      // Busca todas as páginas de matriculados
      while (true) {
        final resultado = await _matriculaRepo.getMatriculas(
          numeroPage: page,
          token: userLog.token,
          trimesterRoomId: widget.turmaTrimestre.id,
        );
        todosAlunos.addAll(resultado);
        if (todosAlunos.length >= totalMatriculas || resultado.isEmpty) break;
        page++;
      }
      alunos = todosAlunos;

      // Inicializa a chamada com todos ausentes
      chamadaResultado =
          alunos
              .map(
                (a) => {'registrationId': a.registrationId, 'present': false},
              )
              .toList();
    } catch (e) {
      _mostrarErro('Erro ao carregar alunos: ${e.toString()}');
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

  void _mostrarSucesso(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _corVerde,
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

  Future<void> _abrirChamada() async {
    final resultado = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(
        builder:
            (_) => TelaChamada(
              nomeTurma: widget.turmaTrimestre.nome,
              alunos: alunos,
            ),
      ),
    );

    if (resultado != null) {
      setState(() {
        chamadaResultado = resultado;
        presentes = resultado.where((r) => r['present'] == true).length;
      });
    }
  }

  Future<void> _salvarAula() async {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      _mostrarErro('Informe o nome da lição');
      return;
    }

    setState(() => isSaving = true);

    try {
      final statusCode = await _lessonRepo.postLesson(
        token: userLog.token,
        trimesterRoomId: widget.turmaTrimestre.id,
        preLessonId: widget.preLesson.id,
        title: titulo,
        studentsAttendance: chamadaResultado,
        visitors: _visitantes,
        bibles: _biblias,
        magazines: _revistas,
        offers: _ofertas.toDouble(),
      );

      if (statusCode == 201) {
        _mostrarSucesso('Aula salva com sucesso!');
        if (mounted) Navigator.pop(context, true);
      } else if (statusCode == 409) {
        _mostrarErro('Já existe uma aula registrada para essa turma');
      } else {
        _mostrarErro('Erro ao salvar aula (código: $statusCode)');
      }
    } catch (e) {
      _mostrarErro('Erro ao salvar: ${e.toString()}');
    }

    if (mounted) setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
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
          widget.turmaTrimestre.nome,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildConteudo(),
    );
  }

  Widget _buildConteudo() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // ── Seção Dados ──
              _buildSectionHeader('Dados', Icons.edit_note),
              const SizedBox(height: 12),
              _buildCampoTitulo(),
              const SizedBox(height: 16),
              _buildContadorRow(
                'Visitantes',
                _visitantes,
                (v) {
                  setState(() => _visitantes = v);
                },
                assetPath: 'assets/images/relatorio/visitantes.png',
              ),
              _buildContadorRow(
                'Bíblias',
                _biblias,
                (v) {
                  setState(() => _biblias = v);
                },
                assetPath: 'assets/images/relatorio/biblias.png',
              ),
              _buildContadorRow(
                'Revistas',
                _revistas,
                (v) {
                  setState(() => _revistas = v);
                },
                assetPath: 'assets/images/relatorio/revista.png',
              ),
              _buildContadorRowOfertas(),

              const SizedBox(height: 24),

              // ── Seção Chamada ──
              _buildSectionHeader('Chamada', Icons.fact_check_outlined),
              const SizedBox(height: 12),
              _buildInfoChamada(),
              const SizedBox(height: 12),
              _buildBotaoChamada(),

              const SizedBox(height: 32),
            ],
          ),
        ),

        // ── Botão Salvar ──
        _buildBotaoSalvar(),
      ],
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

  // ─── Campo de título da lição ──────────────────────────────────────────────

  Widget _buildCampoTitulo() {
    return TextField(
      controller: _tituloController,
      readOnly: _isReadOnly,
      decoration: InputDecoration(
        labelText: 'Nome da Lição',
        hintText: 'Ex: A fé que move montanhas',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }

  // ─── Contador com +/- ─────────────────────────────────────────────────────

  Future<void> _editarValorInt(
    String label,
    int valorAtual,
    ValueChanged<int> onChanged,
  ) async {
    final controller = TextEditingController(text: valorAtual.toString());
    final resultado = await showDialog<int>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            content: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Digite o valor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final v = int.tryParse(controller.text.trim());
                  Navigator.pop(ctx, v);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _corPrimaria,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
    );
    controller.dispose();
    if (resultado != null && resultado >= 0) {
      onChanged(resultado);
    }
  }

  Future<void> _editarValorDouble(
    String label,
    double valorAtual,
    ValueChanged<double> onChanged,
  ) async {
    final controller = TextEditingController(
      text:
          valorAtual == valorAtual.truncateToDouble()
              ? valorAtual.toInt().toString()
              : valorAtual.toStringAsFixed(2),
    );
    final resultado = await showDialog<double>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            content: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Ex: 25,50',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = controller.text.trim().replaceAll(',', '.');
                  final v = double.tryParse(text);
                  Navigator.pop(ctx, v);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _corPrimaria,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
    );
    controller.dispose();
    if (resultado != null && resultado >= 0) {
      onChanged(resultado);
    }
  }

  Widget _buildContadorRow(
    String label,
    int valor,
    ValueChanged<int> onChanged, {
    String? assetPath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (assetPath != null) ...[
            Image.asset(assetPath, width: 24, height: 24, fit: BoxFit.contain),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),
          // Botão diminuir
          _buildBotaoContador(
            icon: Icons.remove,
            onTap:
                _isReadOnly
                    ? null
                    : () {
                      if (valor > 0) onChanged(valor - 1);
                    },
          ),
          GestureDetector(
            onTap:
                _isReadOnly
                    ? null
                    : () => _editarValorInt(label, valor, onChanged),
            child: Container(
              width: 48,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        _isReadOnly
                            ? Colors.transparent
                            : _corPrimaria.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                valor.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isReadOnly ? Colors.grey : const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          // Botão aumentar
          _buildBotaoContador(
            icon: Icons.add,
            onTap: _isReadOnly ? null : () => onChanged(valor + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildContadorRowOfertas() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Image.asset(
            'assets/images/relatorio/ofertas.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Ofertas',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),
          GestureDetector(
            onTap:
                _isReadOnly
                    ? null
                    : () => _editarValorDouble('Ofertas', _ofertas, (v) {
                      setState(() => _ofertas = v);
                    }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                    _isReadOnly
                        ? Colors.grey.shade100
                        : _corPrimaria.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      _isReadOnly
                          ? Colors.grey.shade300
                          : _corPrimaria.withOpacity(0.25),
                ),
              ),
              child: Text(
                'R\$ ${_ofertas.toStringAsFixed(2).replaceFirst('.', ',')}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isReadOnly ? Colors.grey : _corPrimaria,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoContador({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color:
              onTap != null
                  ? _corPrimaria.withOpacity(0.08)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                onTap != null
                    ? _corPrimaria.withOpacity(0.2)
                    : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null ? _corPrimaria : Colors.grey.shade400,
        ),
      ),
    );
  }

  // ─── Info de chamada ───────────────────────────────────────────────────────

  Widget _buildInfoChamada() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people,
            color: presentes > 0 ? _corVerde : const Color(0xFF757575),
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'Alunos Presentes  -  $presentes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: presentes > 0 ? _corVerde : const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Botão realizar chamada ────────────────────────────────────────────────

  Widget _buildBotaoChamada() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: _isReadOnly ? null : _abrirChamada,
        icon: const Icon(Icons.fact_check, size: 20),
        label: const Text(
          'Realizar Chamada',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _corPrimaria,
          side: BorderSide(color: _corPrimaria.withOpacity(0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ─── Botão salvar aula ─────────────────────────────────────────────────────

  Widget _buildBotaoSalvar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isReadOnly || isSaving ? null : _salvarAula,
            icon:
                isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Icon(_isReadOnly ? Icons.lock : Icons.save, size: 20),
            label: Text(
              _isReadOnly ? 'Aula já registrada' : 'Salvar Aula',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isReadOnly ? Colors.grey : _corPrimaria,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
