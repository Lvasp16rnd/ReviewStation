import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa o ViewModel
import 'register_viewmodel.dart'; 

class RegisterView extends StatefulWidget {
  final RegisterViewModel viewModel;

  const RegisterView({super.key, required this.viewModel});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Chave global para identificar o Form e validar campos
  final _formKey = GlobalKey<FormState>(); 

  // Controladores para capturar o texto dos campos
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    // Liberar recursos dos controladores
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Valida todos os campos do formulário
    if (_formKey.currentState!.validate()) {
      // Se a validação for bem-sucedida, chama a lógica do ViewModel
      widget.viewModel.handleRegister(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        // Converte o texto da idade para inteiro
        age: int.tryParse(_ageController.text) ?? 0, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>.value(
      value: widget.viewModel,
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) {
          // Exibe SnackBar com erro, se houver
          if (viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(viewModel.errorMessage!)),
              );
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Criar Nova Conta'),
              // O botão de voltar (pop) é gerenciado automaticamente pelo Scaffold
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // --- CAMPO NOME ---
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) => value == null || value.isEmpty ? 'Informe seu nome.' : null,
                    ),
                    const SizedBox(height: 16),

                    // --- CAMPO E-MAIL ---
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      validator: (value) => value == null || value.isEmpty || !value.contains('@') ? 'E-mail inválido.' : null,
                    ),
                    const SizedBox(height: 16),

                    // --- CAMPO SENHA ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (value) => value == null || value.length < 6 ? 'A senha deve ter pelo menos 6 caracteres.' : null,
                    ),
                    const SizedBox(height: 16),

                    // --- CAMPO IDADE ---
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Idade (mínimo 18)'),
                      validator: (value) {
                        final age = int.tryParse(value ?? '');
                        if (age == null || age < 18) {
                          return 'Você deve ter 18 anos ou mais para se cadastrar.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // --- BOTÃO DE CADASTRO ---
                    ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _submitForm, // Desabilita se estiver carregando
                      child: viewModel.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : const Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}