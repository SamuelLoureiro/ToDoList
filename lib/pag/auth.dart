import 'package:todolist/componentes/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:todolist/core/modelos/auth_form_data.dart';
import 'package:todolist/core/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      setState(() => _isLoading = true);

      if (formData.isLogin) {
        await AuthService().login(
          formData.email,
          formData.password,
        );
      } else {
        await AuthService().signup(
            formData.name, formData.email, formData.password, formData.image);
      }
    } catch (error) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 192, 40, 91),
      body: Stack(
        children: [
          AppBar(
            title: Container(
              child: Text(
                'To-Do List',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 192, 40, 91),
            elevation: 0,
          ),
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            ),
          ),
          if (_isLoading)
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
