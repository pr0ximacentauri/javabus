import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool staySignedIn = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/javabus-logo.png', height: 40),
                  const SizedBox(width: 8),
                  const Text(
                    'JavaBus',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 206, 145, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 206, 145, 1),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ayo mulai perjalanan serumu!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 96, 67, 0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _usernameController,
                focusNode: _usernameFocus,
                decoration: InputDecoration(
                  hintText: 'Username',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Checkbox(
                    value: staySignedIn,
                    onChanged: (value) {
                      setState(() {
                        staySignedIn = value ?? false;
                      });
                    },
                  ),
                  const Text("Tetap masuk"),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum Punya Akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(
                      'Daftar',
                      style: TextStyle(color: Color.fromARGB(255, 206, 145, 1)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final username = _usernameController.text.trim();
                          final password = _passwordController.text;

                          if (username.isEmpty || password.isEmpty) {
                            _showMessageDialog(
                              context,
                              title: 'Peringatan',
                              message: 'Username dan password tidak boleh kosong.',
                            );
                            return;
                          }

                          final success = await authVM.login(username, password, staySignedIn);

                          if (success && mounted) {
                            final user = context.read<AuthViewModel>().user!;
                            switch (user.roleId) {
                              case 1:
                                Navigator.pushReplacementNamed(context, '/admin');
                                break;
                              case 2:
                                Navigator.pushReplacementNamed(context, '/subadmin');
                                break;
                              default:
                                Navigator.pushReplacementNamed(context, '/home');
                                break;
                            }
                          } else {
                            _showMessageDialog(
                              context,
                              title: 'Login Gagal',
                              message: 'Username atau password salah.',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 206, 145, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),

          if (authVM.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _showMessageDialog(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
