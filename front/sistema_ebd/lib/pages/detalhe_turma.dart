import 'package:flutter/material.dart';
import 'package:sistema_ebd/pages/tela_chamada.dart';

/// Argumentos para a tela de detalhe da turma (chamada e relatório da aula).
class DetalheTurmaArgs {
  final String nomeTurma;
  final int matriculados;
  final int presentes;
  final int ausentes;
  final int visitantes;
  final int biblias;
  final int revistas;
  final double ofertas;

  DetalheTurmaArgs({
    required this.nomeTurma,
    this.matriculados = 0,
    this.presentes = 0,
    this.ausentes = 0,
    this.visitantes = 0,
    this.biblias = 0,
    this.revistas = 0,
    this.ofertas = 0.0,
  });
}

class DetalheTurma extends StatelessWidget {
  const DetalheTurma({super.key});

  static const _corFundoConteudo = Color(0xFFFFFFFF);
  static const _corFundoCard = Color(0xFFF5F5F5);
  static const _corTexto = Color(0xFF333333);
  static const _margemHorizontal = 16.0;
  static const _paddingCard = 14.0;
  static const _espacamentoEntreItens = 10.0;
  static const _raioBordaCard = 12.0;
  static const _corBoxPresentes = Color(0xFF6ACC6E);
  static const _corBoxAusentes = Color(0xFFFFA726);
  static const _corTextoCardPercentual = Color(0xFF1A1A1A);
  static const _alturaMinimaCardPercentual = 88.0;
  static const _espacamentoEntreSecoes = 22.0;
  static const _espacamentoEntreTituloELista = 12.0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as DetalheTurmaArgs?;
    final nomeTurma = args?.nomeTurma ?? 'Turma';
    final matriculados = args?.matriculados ?? 0;
    final presentes = args?.presentes ?? 0;
    final ausentes = args?.ausentes ?? 0;
    final total = presentes + ausentes;
    final percentualPresentes =
        total > 0 ? (presentes / total * 100).round() : 0;
    final percentualAusentes = total > 0 ? (ausentes / total * 100).round() : 0;
    return Scaffold(
      backgroundColor: _corFundoConteudo,
      appBar: AppBar(
        backgroundColor: _corFundoConteudo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 28, color: _corTexto),
        ),
        title: Text(
          nomeTurma,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _corTexto,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            _margemHorizontal, 20, _margemHorizontal, 24),
        children: [
          _buildTituloSecao('Chamada'),
          const SizedBox(height: _espacamentoEntreTituloELista),
          _CardChamada(
            label: 'Chamada dos Alunos',
            nomeTurma: nomeTurma,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const TelaChamada(),
                  settings: RouteSettings(
                    arguments: TelaChamadaArgs(nomeTurma: nomeTurma),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: _espacamentoEntreSecoes),
          _buildTituloSecao('Relatório Da Aula'),
          const SizedBox(height: _espacamentoEntreTituloELista),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/matriculados.png',
            label: 'Matriculados',
            valor: matriculados.toString(),
          ),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/presentes.png',
            label: 'Presentes',
            valor: presentes.toString(),
          ),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/ausentes.png',
            label: 'Ausentes',
            valor: ausentes.toString(),
          ),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/visitantes.png',
            label: 'Visitantes',
            valor: (args?.visitantes ?? 0).toString(),
          ),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/biblias.png',
            label: 'Bíblias',
            valor: (args?.biblias ?? 0).toString(),
          ),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/revista.png',
            label: 'Revistas',
            valor: (args?.revistas ?? 0).toString(),
          ),
          _ItemRelatorioTurma(
            assetPath: 'assets/images/relatorio/ofertas.png',
            label: 'Ofertas',
            valor: _formatarMoeda(args?.ofertas ?? 0.0),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _BoxPercentual(
                  label: 'Presentes',
                  percentual: percentualPresentes,
                  corFundo: _corBoxPresentes,
                  delayInicio: Duration.zero,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BoxPercentual(
                  label: 'Ausentes',
                  percentual: percentualAusentes,
                  corFundo: _corBoxAusentes,
                  delayInicio: const Duration(milliseconds: 150),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTituloSecao(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _corTexto,
      ),
    );
  }

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceFirst('.', ',')}';
  }
}

class _CardChamada extends StatelessWidget {
  final String label;
  final String nomeTurma;
  final VoidCallback onTap;

  const _CardChamada({
    required this.label,
    required this.nomeTurma,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DetalheTurma._raioBordaCard),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DetalheTurma._paddingCard,
            vertical: DetalheTurma._paddingCard,
          ),
          decoration: BoxDecoration(
            color: DetalheTurma._corFundoCard,
            borderRadius:
                BorderRadius.circular(DetalheTurma._raioBordaCard),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/icone_opcoes/chamada_icon.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    color: DetalheTurma._corTexto,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: DetalheTurma._corTexto, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRelatorioTurma extends StatelessWidget {
  final String assetPath;
  final String label;
  final String valor;

  const _ItemRelatorioTurma({
    required this.assetPath,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: DetalheTurma._espacamentoEntreItens),
      padding: const EdgeInsets.symmetric(
        horizontal: DetalheTurma._paddingCard,
        vertical: DetalheTurma._paddingCard,
      ),
      decoration: BoxDecoration(
        color: DetalheTurma._corFundoCard,
        borderRadius:
            BorderRadius.circular(DetalheTurma._raioBordaCard),
      ),
      child: Row(
        children: [
          Image.asset(
            assetPath,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: DetalheTurma._corTexto,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              color: DetalheTurma._corTexto,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoxPercentual extends StatefulWidget {
  final String label;
  final int percentual;
  final Color corFundo;
  final Duration delayInicio;

  const _BoxPercentual({
    required this.label,
    required this.percentual,
    required this.corFundo,
    this.delayInicio = Duration.zero,
  });

  @override
  State<_BoxPercentual> createState() => _BoxPercentualState();
}

class _BoxPercentualState extends State<_BoxPercentual>
    with SingleTickerProviderStateMixin {
  static const _duracaoAnimacao = Duration(milliseconds: 1000);

  AnimationController? _controller;
  Animation<double>? _animacaoPreenchimento;
  Animation<double>? _animacaoNumero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.delayInicio, () {
        if (!mounted) return;
        _controller = AnimationController(
          vsync: this,
          duration: _duracaoAnimacao,
        );
        final fracao = (widget.percentual / 100).clamp(0.0, 1.0);
        _animacaoPreenchimento =
            Tween<double>(begin: 0.0, end: fracao).animate(
          CurvedAnimation(
            parent: _controller!,
            curve: Curves.easeOutCubic,
          ),
        );
        _animacaoNumero = Tween<double>(
          begin: 0.0,
          end: widget.percentual.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: _controller!,
            curve: Curves.easeOutCubic,
          ),
        );
        _controller!.forward();
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null ||
        _animacaoPreenchimento == null ||
        _animacaoNumero == null) {
      return _buildContainerBase(
        heightFactor: 0.0,
        valorPercentual: 0,
      );
    }
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return _buildContainerBase(
          heightFactor: _animacaoPreenchimento!.value,
          valorPercentual: _animacaoNumero!.value.round().clamp(0, 100),
        );
      },
    );
  }

  Widget _buildContainerBase({
    required double heightFactor,
    required int valorPercentual,
  }) {
    return Container(
      height: DetalheTurma._alturaMinimaCardPercentual,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(DetalheTurma._raioBordaCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(DetalheTurma._raioBordaCard),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.corFundo,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                          DetalheTurma._raioBordaCard),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: DetalheTurma._corTextoCardPercentual,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$valorPercentual%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DetalheTurma._corTextoCardPercentual,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
