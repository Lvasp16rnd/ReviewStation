import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

// Importa o Design System e o ViewModel
import '../../../resources/shared/styles/colors.dart';
import '../../../resources/shared/styles/typography.dart';
import 'login_viewmodel.dart';

// Muda de StatelessWidget para StatefulWidget para gerenciar o Form
class LoginView extends StatefulWidget {
  final LoginViewModel viewModel;

  const LoginView({super.key, required this.viewModel});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Chave global para identificar o Form e validar campos
  final _formKey = GlobalKey<FormState>(); 

  // Controladores para capturar o texto dos campos
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  // Função que será chamada pelo botão 'Entrar'
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.handleLogin(
        _emailController.text.trim(),
        _passwordController.text, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usa widget.viewModel para acessar o VM da classe State
    return ChangeNotifierProvider.value(
      value: widget.viewModel, 
      child: Scaffold(
        appBar: AppBar(title: const Text("Acessar ReviewStation")),
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            
            // 💡 Lógica de SnackBar/Erro (Opcional, mas útil)
            if (viewModel.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.errorMessage!)),
                  );
                });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bem-vindo(a)!', style: AppTypography.headline1),
                    const SizedBox(height: 32),

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
                      validator: (value) => value == null || value.length < 6 ? 'Senha incorreta ou incompleta.' : null,
                    ),
                    const SizedBox(height: 40),

                    // 1. BOTÃO PRINCIPAL (LOGIN)
                    ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _submitForm,
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: AppColors.surface)
                          : Text('Entrar', style: AppTypography.buttonText),
                    ),
                    const SizedBox(height: 16),

                    // 2. BOTÃO SECUNDÁRIO (CADASTRO)
                    TextButton(
                      onPressed: viewModel.isLoading 
                          ? null 
                          : viewModel.goToRegister, // Chama a intenção de navegação
                      child: const Text('Não tenho conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}