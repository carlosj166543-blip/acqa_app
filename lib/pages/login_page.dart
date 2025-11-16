// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _isRegisterMode = false;

  Future<void> _submit() async {
    final email = _emailC.text.trim();
    final pass = _passC.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (_isRegisterMode) {
      await prefs.setString('acqa_user_email', email);
      await prefs.setString('acqa_user_pass', pass);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada com sucesso')));
      setState(() => _isRegisterMode = false);
      return;
    } else {
      final saved = prefs.getString('acqa_user_email') ?? '';
      final savedPass = prefs.getString('acqa_user_pass') ?? '';
      if (saved == email && savedPass == pass) {
        Navigator.pushReplacementNamed(context, '/calendar');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciais inválidas')));
      }
    }
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Cadastro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_isRegisterMode ? 'Criar Conta' : 'Entrar', style: TextStyle(fontSize: 22, color: primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(controller: _emailC, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 10),
                  TextField(controller: _passC, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isRegisterMode ? 'Criar conta' : 'Entrar'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isRegisterMode = !_isRegisterMode),
                    child: Text(_isRegisterMode ? 'Já tenho conta' : 'Criar nova conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
