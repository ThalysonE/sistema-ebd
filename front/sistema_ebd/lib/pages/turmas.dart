import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/trimestre_repositories.dart';
import 'package:sistema_ebd/Data/repositories/turmas_repositories.dart';
import 'package:sistema_ebd/Data/variaveisGlobais/variaveis_globais.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/Widgets/dialog_cadastro_turma.dart';
import 'package:sistema_ebd/models/trimestre/trismestre.dart';
import 'package:sistema_ebd/models/trimestre/turma_trimestre.dart';
import 'package:sistema_ebd/models/turma.dart';
import 'package:sistema_ebd/pages/forms/trimestre/turmas_professor.dart';
import 'package:sistema_ebd/pages/tela_alunos_matriculados.dart';

class Turmas extends ConsumerStatefulWidget {
  final bool temCadastro;
  final String idTrimestre;
  const Turmas({super.key, required this.temCadastro, this.idTrimestre = ""});

  @override
  ConsumerState<Turmas> createState() => _TurmasState();
}

class _TurmasState extends ConsumerState<Turmas> {
  // Cores e estilos do filtro (igual à tela de histórico)
  static const _corHeader = Color(0xFF2C3E50);
  static const _corTextoHeader = Color(0xFFFFFFFF);
  static const _corBotaoSelecionado = Color(0xFF007AFF);
  static const _corBotaoNaoSelecionado = Color(0xFF1E3A5F);
  static const _raioBordaFiltro = 16.0;

  static const _trimestresLabel = [
    '1º trimestre',
    '2º trimestre',
    '3º trimestre',
    '4º trimestre',
  ];

  final ScrollController _controllerScroll = ScrollController();
  List<Turma>? turmas = [];
  List<Turma> listaTurmasSelecionadas = [];
  int numeroPaginaTurmas = 1;
  var usuarioLogadoUser;
  var conteudo;
  bool isLoading = true;
  bool novasTurmas = false;

  final requisicaoTurmas = TurmasRepositories();

  //variaveis trimestre
  final requisicaoTrimestre = TrimestreRepository();
  bool loadingCadastrandoTurmas = false;

  // Variáveis do filtro de trimestre (para temCadastro == true)
  List<Trimestre> _trimestres = [];
  List<TurmaTrimestre> _turmasTrimestre = [];
  bool _isLoadingTrimestres = true;
  bool _isLoadingTurmasTrimestre = false;
  bool _maisturmasTrimestre = false;
  int _paginaTurmasTrimestre = 1;
  String _anoSelecionado = DateTime.now().year.toString();
  int _trimestreSelecionado = 1;
  String? _idTrimestreSelecionado;
  List<String> _anosDisponiveis = [];

  showError(String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  Future<void> cadastroTurmasTrimestre(List<String> idsTurmas) async {
    setState(() {
      loadingCadastrandoTurmas = true;
    });
    try {
      await requisicaoTrimestre.alocarTurmasTrimestre(
        token: usuarioLogadoUser.token,
        idTrimestre: widget.idTrimestre,
        turmasId: idsTurmas,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => AlocacaoProfessores(idTrimestre: widget.idTrimestre),
        ),
      );
    } catch (e) {
      showError(e.toString());
    }
    setState(() {
      loadingCadastrandoTurmas = false;
    });
  }

  // ── Busca de trimestres e turmas do trimestre ──

  Future<void> _fetchTrimestres() async {
    try {
      final lista = await requisicaoTrimestre.getTrimestre(
        numeroPage: 1,
        token: usuarioLogadoUser.token,
      );
      setState(() {
        _trimestres = lista;
        _anosDisponiveis =
            lista.map((t) => t.ano.toString()).toSet().toList()..sort();
        if (_anosDisponiveis.isNotEmpty &&
            !_anosDisponiveis.contains(_anoSelecionado)) {
          _anoSelecionado = _anosDisponiveis.last;
        }
        _isLoadingTrimestres = false;
      });
      _atualizarTrimestreSelecionado();
    } catch (e) {
      setState(() {
        _isLoadingTrimestres = false;
      });
      showError(e.toString());
    }
  }

  void _atualizarTrimestreSelecionado() {
    final encontrado = _trimestres.where(
      (t) =>
          t.ano.toString() == _anoSelecionado &&
          t.numTrimestre == _trimestreSelecionado,
    );
    if (encontrado.isNotEmpty) {
      _idTrimestreSelecionado = encontrado.first.id;
    } else {
      _idTrimestreSelecionado = null;
    }
    _paginaTurmasTrimestre = 1;
    _turmasTrimestre = [];
    if (_idTrimestreSelecionado != null) {
      _fetchTurmasTrimestre(_paginaTurmasTrimestre++);
    } else {
      setState(() {
        _isLoadingTurmasTrimestre = false;
      });
    }
  }

  Future<void> _fetchTurmasTrimestre(int page) async {
    setState(() {
      if (page == 1) _isLoadingTurmasTrimestre = true;
    });
    try {
      final lista = await requisicaoTrimestre.getTurmasTrimestre(
        numeroPage: page,
        token: usuarioLogadoUser.token,
        idTrimestre: _idTrimestreSelecionado!,
      );
      setState(() {
        if (page == 1) {
          _turmasTrimestre = lista;
        } else {
          _turmasTrimestre.addAll(lista);
        }
        _isLoadingTurmasTrimestre = false;
        _maisturmasTrimestre = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTurmasTrimestre = false;
        _maisturmasTrimestre = false;
      });
      showError(e.toString());
    }
  }

  // ── Busca de turmas normais (temCadastro == false) ──

  Future<void> fetchTurmas(int numeroPag) async {
    final fetchTurmas = await requisicaoTurmas.getTurmas(
      numeroPag,
      usuarioLogadoUser.token,
    );
    if (fetchTurmas == null) {
      turmas = null;
    } else if (turmas == null) {
      turmas = fetchTurmas;
    } else {
      turmas!.addAll(fetchTurmas);
    }
    print('teste turmas: ${turmas}');
    setState(() {
      if (isLoading) {
        isLoading = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    usuarioLogadoUser = ref.read(usuarioLogado);

    if (widget.temCadastro) {
      // Modo principal: busca trimestres e depois turmas do trimestre
      _fetchTrimestres();
      _controllerScroll.addListener(() {
        if (_controllerScroll.position.maxScrollExtent ==
            _controllerScroll.offset) {
          if (_turmasTrimestre.length < totalTurmasTrimestre) {
            if (!_maisturmasTrimestre) {
              setState(() {
                _maisturmasTrimestre = true;
              });
            }
            _fetchTurmasTrimestre(_paginaTurmasTrimestre++);
          } else {
            setState(() {
              _maisturmasTrimestre = false;
            });
          }
        }
      });
    } else {
      // Modo seleção (criação de trimestre)
      fetchTurmas(numeroPaginaTurmas++);
      _controllerScroll.addListener(() {
        if (_controllerScroll.position.maxScrollExtent ==
            _controllerScroll.offset) {
          if (turmas!.length < totalTurmas) {
            if (!novasTurmas) {
              setState(() {
                novasTurmas = true;
              });
            }
            fetchTurmas(numeroPaginaTurmas++);
          } else {
            setState(() {
              novasTurmas = false;
            });
          }
        }
      });
    }
  }

  recarregarTurmas() {
    numeroPaginaTurmas = 1;
    turmas = [];
    fetchTurmas(numeroPaginaTurmas++);
    //pq nao é necessario esse setState?
    setState(() {});
  }

  mostrarMsg(int tipoMsg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            tipoMsg == 0
                ? 'Erro ao cadastrar a turma, tente novamente'
                : 'Turma cadastrada com sucesso!',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: tipoMsg == 0 ? Colors.red : Colors.green,
      ),
    );
  }

  //colocar em outra pagina
  cadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return CadastroDialog(
          usuarioToken: usuarioLogadoUser.token,
          recarregarTurmas: recarregarTurmas,
          mostrarMsg: mostrarMsg,
        );
      },
    );
  }

  bool get temTurmaSelecionada {
    if (turmas == null || turmas!.isEmpty) {
      return false;
    }
    for (Turma turma in turmas!) {
      if (turma.selectBox!) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.temCadastro) {
      return _buildTelaTurmasTrimestre(context);
    } else {
      return _buildTelaSelecionarTurmas(context);
    }
  }

  // ── Chip customizado (igual ao da tela de histórico) ──

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
          boxShadow:
              selected
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
              child:
                  showCheckmark && selected
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

  // ── Filtro de trimestre ──

  Widget _buildFiltroTrimestre() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(color: _corHeader),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _anosDisponiveis.map((ano) {
                  return _buildChipCustom(
                    label: ano,
                    selected: _anoSelecionado == ano,
                    onTap: () {
                      setState(() {
                        _anoSelecionado = ano;
                      });
                      _atualizarTrimestreSelecionado();
                    },
                    showCheckmark: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: _trimestresLabel.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final trimestre = index + 1;
                final label = _trimestresLabel[index];
                final selecionado = _trimestreSelecionado == trimestre;
                return _buildChipCustom(
                  label: label,
                  selected: selecionado,
                  onTap: () {
                    setState(() => _trimestreSelecionado = trimestre);
                    _atualizarTrimestreSelecionado();
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

  // ── Card da turma (modo trimestre) ──

  Widget _buildCardTurmaTrimestre(TurmaTrimestre turma) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(width: 1, color: Color.fromARGB(218, 231, 230, 237)),
          bottom: BorderSide(
            width: 1,
            color: Color.fromARGB(218, 231, 230, 237),
          ),
          right: BorderSide(
            width: 1,
            color: Color.fromARGB(218, 231, 230, 237),
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TelaAlunosMatriculados(
                    idTurmaTrimestre: turma.id,
                    nomeTurma: turma.nome,
                  ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(width: 10, color: Colors.teal)),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    turma.nome,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Alunos: ${turma.registros}',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(185, 0, 0, 0),
                  ),
                ),
              ],
            ),
            tileColor: Colors.white,
            trailing: Icon(Icons.chevron_right, size: 32),
          ),
        ),
      ),
    );
  }

  // ── Tela principal: turmas por trimestre ──

  Widget _buildTelaTurmasTrimestre(BuildContext context) {
    Widget conteudoTrimestre;

    if (_isLoadingTrimestres) {
      conteudoTrimestre = Expanded(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    } else if (_idTrimestreSelecionado == null) {
      conteudoTrimestre = Expanded(
        child: Center(
          child: Text(
            'Nenhum trimestre encontrado para o período selecionado.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
      );
    } else if (_isLoadingTurmasTrimestre) {
      conteudoTrimestre = Expanded(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    } else if (_turmasTrimestre.isEmpty) {
      conteudoTrimestre = Expanded(
        child: Center(
          child: Text(
            'Nenhuma turma cadastrada neste trimestre.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
      );
    } else {
      conteudoTrimestre = Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: 15, left: 15),
          child: ListView.builder(
            controller: _controllerScroll,
            itemCount: _turmasTrimestre.length + 1,
            itemBuilder: (context, index) {
              if (index < _turmasTrimestre.length) {
                final turma = _turmasTrimestre[index];
                if (index == 0) {
                  return Column(
                    children: [
                      SizedBox(height: 16),
                      _buildCardTurmaTrimestre(turma),
                    ],
                  );
                }
                return _buildCardTurmaTrimestre(turma);
              } else {
                return Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child:
                        _maisturmasTrimestre
                            ? CircularProgressIndicator()
                            : SizedBox(height: 25),
                  ),
                );
              }
            },
          ),
        ),
      );
    }

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _corHeader,
          centerTitle: true,
          title: Text(
            'Turmas',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(242, 255, 255, 255),
            ),
          ),
        ),
        body: Column(children: [_buildFiltroTrimestre(), conteudoTrimestre]),
      ),
    );
  }

  // ── Tela de seleção de turmas (criação de trimestre) ──

  Widget _buildTelaSelecionarTurmas(BuildContext context) {
    if (isLoading) {
      conteudo = Center(child: CircularProgressIndicator.adaptive());
    } else if (turmas == null) {
      conteudo = Center(
        child: Text('Um erro ocorreu, tente novamente mais tarde'),
      );
    } else if (turmas!.isEmpty) {
      conteudo = Center(child: Text('Nenhuma turma cadastrada.'));
    } else {
      conteudo = Padding(
        padding: EdgeInsets.only(right: 15, left: 15),
        child: ListView.builder(
          controller: _controllerScroll,
          itemCount: turmas!.length + 1,
          itemBuilder: (context, index) {
            if (index < turmas!.length) {
              Turma item = turmas![index];
              if (index == 0) {
                return Column(
                  children: [
                    SizedBox(height: 30),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Selecione as turmas que irão compor o trimestre',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium!.copyWith(fontSize: 13),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    _buildCardTurmaSelecao(item),
                  ],
                );
              } else {
                return _buildCardTurmaSelecao(item);
              }
            } else {
              return Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child:
                      novasTurmas
                          ? CircularProgressIndicator()
                          : SizedBox(height: 25),
                ),
              );
            }
          },
        ),
      );
    }
    return Material(
      child: Scaffold(
        appBar: CriarAppBar(context, 'Turmas'),
        body: conteudo,
        bottomNavigationBar: Container(
          color: Color(0xFFfaf9fe),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: ElevatedButton(
              onPressed:
                  loadingCadastrandoTurmas
                      ? null
                      : temTurmaSelecionada
                      ? () {
                        for (Turma turma in turmas!) {
                          if (turma.selectBox! &&
                              !listaTurmasSelecionadas.contains(turma)) {
                            listaTurmasSelecionadas.add(turma);
                          } else if (!turma.selectBox! &&
                              listaTurmasSelecionadas.contains(turma)) {
                            listaTurmasSelecionadas.remove(turma);
                          }
                        }
                        if (listaTurmasSelecionadas.isNotEmpty) {
                          List<String> idsTurmas = [];
                          for (final turma in listaTurmasSelecionadas) {
                            idsTurmas.add(turma.id);
                          }
                          cadastroTurmasTrimestre(idsTurmas);
                        }
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 100),
                backgroundColor: Color(0xFF1565C0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child:
                  loadingCadastrandoTurmas
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1565C0),
                        ),
                      )
                      : Text(
                        'Continuar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTurmaSelecao(Turma item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(
            width: !item.selectBox! ? 1 : 1.5,
            color:
                !item.selectBox!
                    ? Color.fromARGB(218, 231, 230, 237)
                    : Colors.green,
          ),
          bottom: BorderSide(
            width: !item.selectBox! ? 1 : 1.5,
            color:
                !item.selectBox!
                    ? Color.fromARGB(218, 231, 230, 237)
                    : Colors.green,
          ),
          right: BorderSide(
            width: !item.selectBox! ? 1 : 1.5,
            color:
                !item.selectBox!
                    ? Color.fromARGB(218, 231, 230, 237)
                    : Colors.green,
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            item.selectBox = !item.selectBox!;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(width: 10, color: Colors.teal)),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              item.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            tileColor: Colors.white,
            trailing: Checkbox(
              value: item.selectBox,
              activeColor: Color(0xFF008000),
              onChanged: (value) {
                setState(() {
                  item.selectBox = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
