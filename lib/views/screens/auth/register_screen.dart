import 'package:flutter/material.dart';
import 'package:javabus/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              const SizedBox(height: 48),
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
              const SizedBox(height: 16),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Buat Akun',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 206, 145, 1),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Daftarkan akunmu sekarang!',
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

              // Username
              _buildTextField(
                controller: usernameController,
                hintText: 'Username',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Full Name
              _buildTextField(
                controller: fullNameController,
                hintText: 'Nama Lengkap',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),

              // Password
              _buildPasswordField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                toggleObscure: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password
              _buildPasswordField(
                controller: confirmPasswordController,
                hintText: 'Konfirmasi Password',
                obscureText: _obscureConfirmPassword,
                toggleObscure: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final password = passwordController.text;
                          final confirmPassword = confirmPasswordController.text;

                          if (password != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password tidak cocok')),
                            );
                            return;
                          }

                          final success = await authVM.register(
                            username: usernameController.text,
                            fullName: fullNameController.text,
                            email: emailController.text,
                            password: password,
                            staySigned: true,
                          );

                          if (success && mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pendaftaran gagal')),
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
                  child: authVM.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Daftar'),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(color: Color.fromARGB(255, 206, 145, 1)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleObscure,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
