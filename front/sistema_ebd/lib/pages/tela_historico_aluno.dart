import 'package:flutter/material.dart';

/// Argumentos para a tela de histórico do aluno.
class HistoricoAlunoArgs {
  final String nomeAluno;
  final String nomeTurma;

  HistoricoAlunoArgs({required this.nomeAluno, required this.nomeTurma});
}

/// Um registro de presença no histórico.
class RegistroPresenca {
  final String data;
  final String licao;
  final bool presente;

  RegistroPresenca({
    required this.data,
    required this.licao,
    required this.presente,
  });
}

class TelaHistoricoAluno extends StatefulWidget {
  const TelaHistoricoAluno({super.key});

  @override
  State<TelaHistoricoAluno> createState() => _TelaHistoricoAlunoState();
}

class _TelaHistoricoAlunoState extends State<TelaHistoricoAluno> {
  static const _corHeader = Color(0xFF2C3E50);
  static const _corTextoHeader = Color(0xFFFFFFFF);
  static const _corBotaoSelecionado = Color(0xFF007AFF);
  static const _corBotaoNaoSelecionado = Color(0xFF1E3A5F);
  static const _corFundoConteudo = Color(0xFFFFFFFF);
  static const _corCard = Color(0xFFFFFFFF);
  static const _corCardPresente = Color(0xFFE8F5E9);
  static const _corCardAusente = Color(0xFFFFEBEE);
  static const _corTextoCard = Color(0xFF000000);
  static const _corTextoSuave = Color(0xFF757575);
  static const _corPresente = Color(0xFF6ACC6E);
  static const _corAusente = Color(0xFFE74C3C);
  static const _corFab = Color(0xFFB39DDB);
  static const _paddingHorizontal = 8.0;
  static const _raioBorda = 12.0;
  static const _raioBordaFiltro = 16.0;

  String _anoSelecionado = '2025';
  int _trimestreSelecionado = 1;
  late String _nomeAluno;
  late String _nomeTurma;
  late List<RegistroPresenca> _registros;
  late int _totalPresencas;
  late int _totalAusencias;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as HistoricoAlunoArgs?;
    if (args != null && _nomeAluno != args.nomeAluno) {
      setState(() {
        _nomeAluno = args.nomeAluno;
        _nomeTurma = args.nomeTurma;
        _carregarDadosExemplo();
      });
    }
  }

  void _carregarDadosExemplo() {
    _registros = [
      RegistroPresenca(data: '12/03/2025', licao: 'Lição 4', presente: true),
      RegistroPresenca(data: '05/03/2025', licao: 'Lição 3', presente: false),
      RegistroPresenca(data: '26/02/2025', licao: 'Lição 2', presente: true),
      RegistroPresenca(data: '19/02/2025', licao: 'Lição 1', presente: true),
    ];
    _totalPresencas = _registros.where((r) => r.presente).length;
    _totalAusencias = _registros.where((r) => !r.presente).length;
  }

  int get _frequenciaPercentual {
    final total = _registros.length;
    if (total == 0) return 0;
    return (_totalPresencas / total * 100).round();
  }

  @override
  void initState() {
    super.initState();
    _nomeAluno = 'Eduardo Silva';
    _nomeTurma = 'Heróis da Fé';
    _carregarDadosExemplo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundoConteudo,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoAluno(),
                _buildCardResumo(),
                _buildTituloHistorico(),
                _buildListaRegistros(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: true,
      backgroundColor: _corHeader,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.chevron_left, size: 28, color: _corTextoHeader),
      ),
      centerTitle: true,
      title: const Text(
        'Histórico',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: _corTextoHeader,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.print, color: _corTextoHeader, size: 24),
        ),
      ],
    );
  }

  Widget _buildInfoAluno() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        _paddingHorizontal,
        56,
        _paddingHorizontal,
        24,
      ),
      decoration: const BoxDecoration(color: _corHeader),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _nomeAluno,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _corTextoHeader,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _nomeTurma,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: _corTextoHeader.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 25),
          _buildFiltros(),
        ],
      ),
    );
  }

  static const _trimestres = [
    '1º trimestre',
    '2º trimestre',
    '3º trimestre',
    '4º trimestre',
  ];

  Widget _buildChipCustom({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool showCheckmark = false,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: padding,
        decoration: BoxDecoration(
          color: selected ? _corBotaoSelecionado : _corBotaoNaoSelecionado,
          borderRadius: BorderRadius.circular(_raioBordaFiltro),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _corBotaoSelecionado.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: showCheckmark && selected
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 18, color: _corTextoHeader),
                        SizedBox(width: 6),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _corTextoHeader,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        _paddingHorizontal,
        16,
        _paddingHorizontal,
        20,
      ),
      decoration: const BoxDecoration(color: _corHeader),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChipCustom(
                label: _anoSelecionado,
                selected: true,
                onTap: () {},
                showCheckmark: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: _trimestres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final trimestre = index + 1;
                final label = _trimestres[index];
                final selecionado = _trimestreSelecionado == trimestre;
                return _buildChipCustom(
                  label: label,
                  selected: selecionado,
                  onTap: () {
                    setState(() => _trimestreSelecionado = trimestre);
                  },
                  showCheckmark: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardResumo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        _paddingHorizontal,
        20,
        _paddingHorizontal,
        0,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: _corCard,
        borderRadius: BorderRadius.circular(_raioBorda),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '$_totalPresencas',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _corTextoCard,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Presenças',
                  style: TextStyle(fontSize: 13, color: _corTextoSuave),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$_totalAusencias',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _corTextoCard,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ausências',
                  style: TextStyle(fontSize: 13, color: _corTextoSuave),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$_frequenciaPercentual%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _corTextoCard,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Frequência',
                  style: TextStyle(fontSize: 13, color: _corTextoSuave),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTituloHistorico() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _paddingHorizontal,
        24,
        _paddingHorizontal,
        12,
      ),
      child: const Text(
        'Histórico de Presença',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _corTextoCard,
        ),
      ),
    );
  }

  Widget _buildListaRegistros() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _paddingHorizontal),
      child: Column(
        children:
            _registros
                .map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildCardRegistro(r),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildCardRegistro(RegistroPresenca registro) {
    final corFundoCard = registro.presente ? _corCardPresente : _corCardAusente;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: corFundoCard,
        borderRadius: BorderRadius.circular(_raioBorda),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              registro.data,
              style: const TextStyle(fontSize: 14, color: _corTextoCard),
            ),
          ),
          Expanded(
            child: Text(
              registro.licao,
              style: const TextStyle(fontSize: 14, color: _corTextoSuave),
            ),
          ),
          Text(
            registro.presente ? 'Presente' : 'Ausente',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: registro.presente ? _corPresente : _corAusente,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: _corFab,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
