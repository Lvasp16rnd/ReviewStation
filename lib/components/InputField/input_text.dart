import 'package:flutter/material.dart';

// 🚨 IMPORTS DO DESIGN SYSTEM (Ajuste o prefixo do seu pacote)
import 'package:reviewstation_app/resources/shared/styles/colors.dart'; 
import 'package:reviewstation_app/resources/shared/styles/typography.dart'; 

import 'input_text_view_model.dart';

class StyledInputField extends StatefulWidget {
  final InputTextViewModel viewModel;

  // A função static make() do seu código original foi removida para simplificação.
  const StyledInputField._({Key? key, required this.viewModel}) : super(key: key);

  @override
  StyledInputFieldState createState() => StyledInputFieldState();
  
  // Método de Factory para uso no código principal (facilita a injeção do VM)
  static Widget instantiate({required InputTextViewModel viewModel}) {
    return StyledInputField._(viewModel: viewModel);
  }
}

class StyledInputFieldState extends State<StyledInputField> {
  late bool obscureText;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    // Inicializa o estado de visibilidade
    obscureText = widget.viewModel.password;
    
    // Adiciona o listener para validação em tempo real (se houver validator)
    if (widget.viewModel.validator != null) {
      widget.viewModel.controller.addListener(validateInput);
    }
  }

  void validateInput() {
    // A validação do widget principal (FormKey) é usada, mas a validação local
    // é usada para exibir o erro em tempo real.
    final errorText = widget.viewModel.validator?.call(widget.viewModel.controller.text);
    setState(() {
      errorMsg = errorText;
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    // Remove o listener para evitar vazamento de memória
    widget.viewModel.controller.removeListener(validateInput);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      filled: true,
      
      // Ícone de Visibilidade
      suffixIcon: widget.viewModel.password
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textDark, //  Design System
              ),
              onPressed: togglePasswordVisibility,
            )
          : widget.viewModel.suffixIcon,
          
      // Cor de Fundo
      fillColor: widget.viewModel.isEnabled ? AppColors.surface : AppColors.background, 
      
      labelText: widget.viewModel.placeholder.isNotEmpty ? widget.viewModel.placeholder : null,
      
      // Estilo do Rótulo
      labelStyle: AppTypography.caption.copyWith(color: AppColors.textLight), 
      
      // Borda Padrão
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.textDark),
      ),
      
      // 🚨 Borda de Erro
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.error), //  Design System
      ),
      
      // 🚨 Borda Focada
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.primary, width: 2), //  Design System
      ),
      
      // Borda Habilitada (não focada)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.textLight), //  Design System
      ),
      
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.textLight), 
      ),
      
      errorText: errorMsg,
    );

    return TextFormField(
      controller: widget.viewModel.controller,
      obscureText: obscureText,
      decoration: decoration,
      // Estilo do Texto digitado
      style: AppTypography.bodyText.copyWith(color: AppColors.textDark), 
      enabled: widget.viewModel.isEnabled,
      // O VALIDADOR OFICIAL É O DO FORMKEY. Aqui passamos o validator do VM.
      validator: widget.viewModel.validator, 
    );
  }
}