import 'package:flutter/material.dart';
import 'package:sistema_ebd/pages/detalhe_turma.dart';

/// Argumentos para a tela de detalhe do registro de aula.
class DetalheRegistroAulaArgs {
  final String tituloLicao;
  final String data;
  final int presentes;
  final int ausentes;
  final int matriculados;
  final int visitantes;
  final int biblias;
  final int revistas;
  final double ofertas;

  DetalheRegistroAulaArgs({
    required this.tituloLicao,
    required this.data,
    required this.presentes,
    required this.ausentes,
    this.matriculados = 0,
    this.visitantes = 0,
    this.biblias = 0,
    this.revistas = 0,
    this.ofertas = 0.0,
  });
}

class DetalheRegistroAula extends StatelessWidget {
  const DetalheRegistroAula({super.key});

  static const _corFundoDispositivo = Color(0xFF212F3D);
  static const _corFundoConteudo = Color(0xFFFFFFFF);
  static const _corFundoCard = Color(0xFFF5F5F5);
  static const _corTexto = Color(0xFF333333);
  static const _corBordaTurma = Color(0xFF6ACC6E);
  static const _corCheckTurma = Color(0xFF6ACC6E);
  static const _margemHorizontal = 16.0;
  static const _paddingCard = 14.0;
  static const _espacamentoEntreItens = 10.0;
  static const _raioBordaCard = 12.0;
  static const _raioBordaConteudo = 20.0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as DetalheRegistroAulaArgs?;
    final titulo =
        args != null ? '${args.tituloLicao} - ${args.data}' : 'Detalhe';
    final matriculados =
        args?.matriculados ?? ((args?.presentes ?? 0) + (args?.ausentes ?? 0));
    final turmas = ['Abraão', 'Crescendo na fé', 'Discipulado'];
    return Scaffold(
      backgroundColor: _corFundoDispositivo,
      appBar: AppBar(
        backgroundColor: _corFundoConteudo,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 28, color: _corTexto),
        ),
        title: Text(
          titulo,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _corTexto,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        decoration: const BoxDecoration(color: _corFundoConteudo),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            _margemHorizontal,
            20,
            _margemHorizontal,
            24,
          ),
          children: [
            _buildTituloSecao('Turmas'),
            const SizedBox(height: 12),
            ...turmas.map(
              (nome) => Padding(
                padding: const EdgeInsets.only(bottom: _espacamentoEntreItens),
                child: _CardTurma(nome: nome, args: args),
              ),
            ),
            const SizedBox(height: 22),
            _buildTituloSecao('Relatório Geral Da Aula'),
            const SizedBox(height: 12),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/matriculados.png',
              label: 'Matriculados',
              valor: matriculados.toString(),
            ),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/presentes.png',
              label: 'Presentes',
              valor: (args?.presentes ?? 0).toString(),
            ),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/ausentes.png',
              label: 'Ausentes',
              valor: (args?.ausentes ?? 0).toString(),
            ),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/visitantes.png',
              label: 'Visitantes',
              valor: (args?.visitantes ?? 0).toString(),
            ),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/biblias.png',
              label: 'Bíblias',
              valor: (args?.biblias ?? 0).toString(),
            ),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/revista.png',
              label: 'Revistas',
              valor: (args?.revistas ?? 0).toString(),
            ),
            _ItemRelatorio(
              assetPath: 'assets/images/relatorio/ofertas.png',
              label: 'Ofertas',
              valor: _formatarMoeda(args?.ofertas ?? 0.0),
            ),
          ],
        ),
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

class _CardTurma extends StatelessWidget {
  final String nome;
  final DetalheRegistroAulaArgs? args;

  const _CardTurma({required this.nome, this.args});

  @override
  Widget build(BuildContext context) {
    final matriculados =
        args?.matriculados ?? ((args?.presentes ?? 0) + (args?.ausentes ?? 0));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const DetalheTurma(),
              settings: RouteSettings(
                arguments: DetalheTurmaArgs(
                  nomeTurma: nome,
                  matriculados: matriculados,
                  presentes: args?.presentes ?? 0,
                  ausentes: args?.ausentes ?? 0,
                  visitantes: args?.visitantes ?? 0,
                  biblias: args?.biblias ?? 0,
                  revistas: args?.revistas ?? 0,
                  ofertas: args?.ofertas ?? 0.0,
                ),
              ),
            ),
          );
        },
        borderRadius:
            BorderRadius.circular(DetalheRegistroAula._raioBordaCard),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DetalheRegistroAula._paddingCard,
            vertical: DetalheRegistroAula._paddingCard,
          ),
          decoration: BoxDecoration(
            color: DetalheRegistroAula._corFundoCard,
            borderRadius:
                BorderRadius.circular(DetalheRegistroAula._raioBordaCard),
            border: Border.all(
                color: DetalheRegistroAula._corBordaTurma, width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: DetalheRegistroAula._corCheckTurma,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 15,
                    color: DetalheRegistroAula._corTexto,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: DetalheRegistroAula._corTexto,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRelatorio extends StatelessWidget {
  final String? assetPath;
  final Widget? leading;
  final String label;
  final String valor;

  const _ItemRelatorio({
    this.assetPath,
    this.leading,
    required this.label,
    required this.valor,
  }) : assert(assetPath != null || leading != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: DetalheRegistroAula._espacamentoEntreItens,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DetalheRegistroAula._paddingCard,
        vertical: DetalheRegistroAula._paddingCard,
      ),
      decoration: BoxDecoration(
        color: DetalheRegistroAula._corFundoCard,
        borderRadius: BorderRadius.circular(DetalheRegistroAula._raioBordaCard),
      ),
      child: Row(
        children: [
          if (assetPath != null)
            Image.asset(assetPath!, width: 28, height: 28, fit: BoxFit.contain)
          else
            leading!,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: DetalheRegistroAula._corTexto,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 15,
              color: DetalheRegistroAula._corTexto,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
