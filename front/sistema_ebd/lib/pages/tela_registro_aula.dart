import 'package:flutter/material.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/pages/detalhe_registro_aula.dart';
import 'package:sistema_ebd/utils/rotas.dart';

/// Modelo simples para um item da lista de registros.
class RegistroAulaItem {
  final String tituloLicao;
  final String data;
  final int presentes;
  final int ausentes;

  RegistroAulaItem({
    required this.tituloLicao,
    required this.data,
    required this.presentes,
    required this.ausentes,
  });
}

class TelaRegistroAula extends StatelessWidget {
  const TelaRegistroAula({super.key});

  static const _corFundoCard = Color(0xFFF7F8FA);
  static const _corBordaCard = Color.fromARGB(218, 231, 230, 237);
  static const _corBadgeFundo = Color(0xFFE0F2F7);
  static const _corDetalhes = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    // Dados de exemplo; depois pode vir de um provider/API
    final registros = [
      RegistroAulaItem(tituloLicao: 'Lição 4', data: '25/01/2025', presentes: 15, ausentes: 5),
      RegistroAulaItem(tituloLicao: 'Lição 3', data: '25/01/2025', presentes: 15, ausentes: 5),
      RegistroAulaItem(tituloLicao: 'Lição 2', data: '25/01/2025', presentes: 15, ausentes: 5),
      RegistroAulaItem(tituloLicao: 'Lição 1', data: '25/01/2025', presentes: 15, ausentes: 5),
    ];

    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CriarAppBar(context, 'Registro de Aulas'),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          itemCount: registros.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final item = registros[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRotas.detalheRegistroAula,
                  arguments: DetalheRegistroAulaArgs(
                    tituloLicao: item.tituloLicao,
                    data: item.data,
                    presentes: item.presentes,
                    ausentes: item.ausentes,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: _CardRegistroAula(
                tituloLicao: item.tituloLicao,
                data: item.data,
                presentes: item.presentes,
                ausentes: item.ausentes,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CardRegistroAula extends StatelessWidget {
  final String tituloLicao;
  final String data;
  final int presentes;
  final int ausentes;

  const _CardRegistroAula({
    required this.tituloLicao,
    required this.data,
    required this.presentes,
    required this.ausentes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: TelaRegistroAula._corFundoCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pin.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tituloLicao,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Presentes: $presentes | Ausentes: $ausentes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TelaRegistroAula._corDetalhes,
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: TelaRegistroAula._corBadgeFundo,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
