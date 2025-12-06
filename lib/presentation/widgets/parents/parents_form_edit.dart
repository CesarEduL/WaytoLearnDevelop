import 'package:flutter/material.dart';
import 'dart:ui';

class ParentsFormEdit extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final Function(String username, String email, String password)? onSubmit;

  const ParentsFormEdit({super.key, this.child, this.onTap, this.onSubmit});
  
  @override
  State<ParentsFormEdit> createState() => _ParentsFormEditState();
}

class _ParentsFormEditState extends State<ParentsFormEdit> {
  bool _isLoading = false;
  bool _isEditingUsername = false;
  bool _isEditingEmail = false;
  bool _isEditingPassword = false;
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get username => _usernameController.text;
  String get email => _emailController.text;
  String get password => _passwordController.text;

  // Método para validar los datos del formulario
  bool _validateForm() {
    if (_usernameController.text.trim().isEmpty) {
      _showMessage('Por favor ingrese su nombre de usuario');
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Por favor ingrese su correo');
      return false;
    }
    if (!_emailController.text.contains('@')) {
      _showMessage('Por favor ingrese un correo válido');
      return false;
    }
    if (_passwordController.text.trim().isEmpty) {
      _showMessage('Por favor ingrese su contraseña');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showMessage('La contraseña debe tener al menos 6 caracteres');
      return false;
    }
    return true;
  }

  // Método para mostrar mensajes
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8A5CF6),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Método para enviar los datos
  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final formData = {
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'timestamp': DateTime.now().toIso8601String(),
      };

      print('📝 Datos editados a enviar:');
      formData.forEach((key, value) {
        if (key == 'password') {
          print('  $key: ********');
        } else {
          print('  $key: $value');
        }
      });

      // TODO: Enviar al backend
      await Future.delayed(const Duration(seconds: 1));

      if (widget.onSubmit != null) {
        widget.onSubmit!(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      _showMessage('¡Cambios guardados exitosamente!');
      
      // Desactivar modo edición después de guardar
      setState(() {
        _isEditingUsername = false;
        _isEditingEmail = false;
        _isEditingPassword = false;
      });
    } catch (e) {
      _showMessage('Error al guardar los cambios: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        FocusScope.of(context).unfocus();
        if (widget.onTap != null) widget.onTap!();
      },
      child: SizedBox(
        width: 273,
        height: 382,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Fondo con blur
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            // Username
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 489,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C7BF6),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: const Color(0xFF5C7BF6),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 30,
                        color: const Color(0xFF5C7BF6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          enabled: _isEditingUsername,
                          decoration: InputDecoration(
                            hintText: 'Nombre de usuario',
                            hintStyle: TextStyle(
                              color: const Color(0xFF5C7BF6).withOpacity(0.5),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: _isEditingUsername 
                                ? const Color(0xFF5C7BF6) 
                                : const Color(0xFF5C7BF6).withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditingUsername ? Icons.check : Icons.edit,
                          color: const Color(0xFF5C7BF6),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditingUsername = !_isEditingUsername;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Email
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 489,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C7BF6),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: const Color(0xFF5C7BF6),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 30,
                        color: const Color(0xFF5C7BF6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          enabled: _isEditingEmail,
                          decoration: InputDecoration(
                            hintText: 'Ingrese su correo',
                            hintStyle: TextStyle(
                              color: const Color(0xFF5C7BF6).withOpacity(0.5),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: _isEditingEmail 
                                ? const Color(0xFF5C7BF6) 
                                : const Color(0xFF5C7BF6).withOpacity(0.7),
                            fontSize: 16,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditingEmail ? Icons.check : Icons.edit,
                          color: const Color(0xFF5C7BF6),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditingEmail = !_isEditingEmail;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Password
            Positioned(
              top: 190,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 489,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C7BF6),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: const Color(0xFF5C7BF6),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 30,
                        color: const Color(0xFF5C7BF6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          enabled: _isEditingPassword,
                          decoration: InputDecoration(
                            hintText: 'Ingrese su contraseña',
                            hintStyle: TextStyle(
                              color: const Color(0xFF5C7BF6).withOpacity(0.5),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: _isEditingPassword 
                                ? const Color(0xFF5C7BF6) 
                                : const Color(0xFF5C7BF6).withOpacity(0.7),
                            fontSize: 16,
                          ),
                          obscureText: true,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditingPassword ? Icons.check : Icons.edit,
                          color: const Color(0xFF5C7BF6),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditingPassword = !_isEditingPassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Botón Guardar Cambios
            Positioned(
              bottom: 60,
              right: 0,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C7BF6),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: const Color(0xFF5C7BF6).withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Guardar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}
