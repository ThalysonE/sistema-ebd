import 'package:flutter/material.dart';

/// Argumentos para a tela de chamada (lista de alunos da turma).
class TelaChamadaArgs {
  final String nomeTurma;
  final List<String> nomesAlunos;

  TelaChamadaArgs({
    required this.nomeTurma,
    List<String>? nomesAlunos,
  }) : nomesAlunos = nomesAlunos ?? _listaAlunosPadrao;

  static const _listaAlunosPadrao = [
    'Adriele de Assis do Nascimento',
    'Alany Silva dos Santos',
    'Ana Letícia dos Santos',
    'Calebe Conceição',
    'Eduardo da Silva',
    'Ester Cavalcante',
    'Gabriel Oliveira',
    'Isabela Ferreira',
    'João Pedro Santos',
    'Maria Eduarda Lima',
  ];
}

class TelaChamada extends StatefulWidget {
  const TelaChamada({super.key});

  @override
  State<TelaChamada> createState() => _TelaChamadaState();
}

class _TelaChamadaState extends State<TelaChamada> {
  static const _corFundo = Color(0xFFFFFFFF);
  static const _corTitulo = Color(0xFF1A1A1A);
  static const _corTexto = Color(0xFF4A4A4A);
  static const _corTextoSuave = Color(0xFF757575);
  static const _corCheckboxAtivo = Color(0xFF6ACC6E);
  static const _corCheckboxBorda = Color(0xFF9E9E9E);
  static const _corFundoResumo = Color(0xFFF5F5F5);
  static const _corFundoPresente = Color(0xFFE8F5E9);
  static const _corDivisor = Color(0xFFEEEEEE);
  static const _paddingHorizontal = 20.0;
  static const _paddingVertical = 12.0;
  static const _paddingVerticalItem = 14.0;
  static const _espacamentoTextoCheckbox = 12.0;
  static const _raioBotao = 12.0;

  late List<String> _nomesAlunos;
  late List<bool> _presentes;
  bool _selecionarTudo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as TelaChamadaArgs?;
    if (args != null && _nomesAlunos.isEmpty) {
      setState(() {
        _nomesAlunos = List.from(args.nomesAlunos);
        _presentes = List.filled(_nomesAlunos.length, false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nomesAlunos = [];
    _presentes = [];
  }

  void _aplicarSelecionarTudo(bool valor) {
    setState(() {
      _selecionarTudo = valor;
      for (int i = 0; i < _presentes.length; i++) {
        _presentes[i] = valor;
      }
    });
  }

  void _alternarPresenca(int index) {
    setState(() {
      _presentes[index] = !_presentes[index];
      _selecionarTudo = _presentes.every((e) => e);
    });
  }

  int get _totalPresentes =>
      _presentes.where((e) => e).length;

  void _concluirChamada() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chamada registrada: $_totalPresentes de ${_nomesAlunos.length} presentes.',
        ),
        backgroundColor: _corCheckboxAtivo,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      appBar: AppBar(
        backgroundColor: _corFundo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 28, color: _corTitulo),
        ),
        title: Text(
          'Chamada',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _corTitulo,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: _paddingHorizontal),
            child: InkWell(
              onTap: () => _aplicarSelecionarTudo(!_selecionarTudo),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selecionar Tudo',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: _corTitulo,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _selecionarTudo,
                        onChanged: (v) => _aplicarSelecionarTudo(v ?? false),
                        activeColor: _corCheckboxAtivo,
                        checkColor: Colors.white,
                        side: const BorderSide(
                          color: _corCheckboxBorda,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _nomesAlunos.isEmpty
          ? _buildEstadoVazio()
          : Column(
              children: [
                _buildResumoPresentes(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _paddingHorizontal,
                      vertical: _paddingVertical,
                    ),
                    itemCount: _nomesAlunos.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: _corDivisor,
                    ),
                    itemBuilder: (context, index) {
                      final nome = _nomesAlunos[index];
                      final presente =
                          index < _presentes.length && _presentes[index];
                      return Material(
                        color: presente ? _corFundoPresente : _corFundo,
                        child: InkWell(
                          onTap: () => _alternarPresenca(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: _paddingVerticalItem,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${index + 1}. $nome',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: presente
                                          ? _corTexto
                                          : _corTextoSuave,
                                      fontWeight: presente
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: _espacamentoTextoCheckbox),
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: Checkbox(
                                    value: presente,
                                    onChanged: (_) => _alternarPresenca(index),
                                    activeColor: _corCheckboxAtivo,
                                    checkColor: Colors.white,
                                    side: const BorderSide(
                                      color: _corCheckboxBorda,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildBotaoConcluir(),
              ],
            ),
    );
  }

  Widget _buildEstadoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: _corTextoSuave.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum aluno nesta turma',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _corTextoSuave,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione alunos à turma para fazer a chamada.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _corTextoSuave.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoPresentes() {
    final total = _nomesAlunos.length;
    final presentes = _totalPresentes;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: _paddingHorizontal),
      color: _corFundoResumo,
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: _corCheckboxAtivo),
          const SizedBox(width: 8),
          Text(
            '$presentes de $total presentes',
            style: const TextStyle(
              fontSize: 14,
              color: _corTexto,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoConcluir() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _paddingHorizontal,
          16,
          _paddingHorizontal,
          16,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _concluirChamada,
            style: ElevatedButton.styleFrom(
              backgroundColor: _corCheckboxAtivo,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_raioBotao),
              ),
            ),
            child: const Text('Concluir chamada'),
          ),
        ),
      ),
    );
  }
}
