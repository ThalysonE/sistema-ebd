import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_ebd/Data/providers/usuario_provider.dart';
import 'package:sistema_ebd/Data/repositories/usuarios_repositories.dart';
import 'package:sistema_ebd/Widgets/appbar.dart';
import 'package:sistema_ebd/models/membro.dart';
import 'package:sistema_ebd/models/usuarioLogado.dart';
import 'package:sistema_ebd/pages/tela_membros.dart';

class CadastroUsuarioForm extends ConsumerStatefulWidget {
  const CadastroUsuarioForm({super.key});

  @override
  ConsumerState<CadastroUsuarioForm> createState() =>
      _CadastroUsuarioFormState();
}

class _CadastroUsuarioFormState extends ConsumerState<CadastroUsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _usernameController = TextEditingController();

  String? _membroId;
  String? _membroNome;

  bool _esconderSenha = true;
  bool _isLoading = false;
  String? _roleSelecionado;

  static const _roles = <String, String>{
    'COMMON': 'Estudante',
    'TEACHER': 'Professor',
    'SHEPHERD': 'Pastor',
    'PEDAGOGICAL_DEPARTMENT': 'Departamento Pedagógico',
    'SUPERINTENDENT': 'Superintendente',
    'SECRETARY': 'Secretário',
  };

  late UsuarioLogado _userLog;

  @override
  void initState() {
    super.initState();
    _userLog = ref.read(usuarioLogado);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _mostrarMsg(String msg, int tipo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: tipo == 0 ? Colors.green : Colors.red,
        content: Center(
          child: Text(
            msg,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    if (_roleSelecionado == null) {
      _mostrarMsg('Selecione um cargo', 1);
      return;
    }

    setState(() => _isLoading = true);

    final repo = UsuariosRepository();
    final codigo = await repo.cadastrarUsuario(
      email: _emailController.text.trim(),
      password: _senhaController.text,
      username: _usernameController.text.trim().toLowerCase(),
      memberId: _membroId,
      role: _roleSelecionado!,
      token: _userLog.token,
    );

    setState(() => _isLoading = false);

    if (codigo == 201) {
      Navigator.pop(context, true);
      _mostrarMsg('Usuário cadastrado com sucesso!', 0);
    } else if (codigo == 409) {
      _mostrarMsg('E-mail ou nome de usuário já existe', 1);
    } else {
      _mostrarMsg('Erro ao cadastrar usuário', 1);
    }
  }

  InputDecoration _inputDecoration({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Color(0xFFD0D5DD)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: Theme.of(context).buttonTheme.colorScheme!.primary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: Theme.of(context).buttonTheme.colorScheme!.primary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      label:
          hint != null
              ? Text(
                hint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFAFADBE),
                  fontWeight: FontWeight.w700,
                ),
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CriarAppBar(context, 'Cadastrar Usuário'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email
                _buildLabel('E-mail'),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    hint: 'joao.silva@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Username
                _buildLabel('Nome de Usuário'),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration(
                    hint: 'joaosilva',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome de usuário';
                    }
                    if (value.length < 3) {
                      return 'Deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Senha
                _buildLabel('Senha'),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _senhaController,
                  obscureText: _esconderSenha,
                  decoration: _inputDecoration(
                    hint: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _esconderSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _esconderSenha = !_esconderSenha);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha';
                    }
                    if (value.length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Cargo (Role)
                _buildLabel('Cargo'),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _roleSelecionado,
                  decoration: _inputDecoration(),
                  isExpanded: true,
                  hint: Text(
                    'Selecione o cargo',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFAFADBE),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  items:
                      _roles.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _roleSelecionado = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione um cargo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Membro (opcional)
                _buildLabel('Membro (opcional)'),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    final Membro? resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TelaMembros(
                              temSelecao: true,
                              selecaoUnica: true,
                            ),
                      ),
                    );
                    if (resultado != null) {
                      setState(() {
                        _membroId = resultado.id;
                        _membroNome = resultado.nome;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).inputDecorationTheme.fillColor ??
                          Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1.5,
                        color: const Color(0xFFD0D5DD),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _membroNome != null
                              ? Icons.person
                              : Icons.person_add_alt_1,
                          color:
                              _membroNome != null
                                  ? const Color(0xFF1565C0)
                                  : const Color(0xFFAFADBE),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _membroNome ?? 'Toque para selecionar um membro',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color:
                                  _membroNome != null
                                      ? Colors.black
                                      : const Color(0xFFAFADBE),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (_membroNome != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _membroId = null;
                                _membroNome = null;
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          )
                        else
                          const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF1565C0),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: ElevatedButton.icon(
          icon:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Icon(Icons.add_circle_outline, color: Colors.white),
          onPressed: _isLoading ? null : _cadastrarUsuario,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 100),
            backgroundColor: const Color(0xFF1565C0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          label: Text(
            _isLoading ? 'Cadastrando...' : 'Cadastrar',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
