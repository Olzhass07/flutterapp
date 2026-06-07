import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'utils/validation.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool isSubmitting = false;

  bool _validate() {
    bool ok = true;
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    nameError = validateName(name);
    if (nameError != null) ok = false;

    emailError = validateEmail(email);
    if (emailError != null) ok = false;

    passwordError = validatePassword(password);
    if (passwordError != null) ok = false;

    confirmPasswordError = validateConfirmPassword(password, confirm);
    if (confirmPasswordError != null) ok = false;

    setState(() {});
    return ok;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> registerUser() async {
    if (!_validate()) return;

    setState(() => isSubmitting = true);

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3001/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          _showSnackBar(data['message'] ?? 'Регистрация успешна!');

          try {
            final loginRes = await http.post(
              Uri.parse('http://localhost:3001/login'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'email': email, 'password': password}),
            );
            final loginData = jsonDecode(loginRes.body);
            if (loginRes.statusCode == 200 && loginData['token'] != null) {
              final String token = loginData['token'];
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(token: token),
                    ),
                  );
                }
              });
            } else {
              _showSnackBar(loginData['message'] ?? 'Ошибка входа. Войди вручную.', isError: true);
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) Navigator.pushReplacementNamed(context, '/login');
              });
            }
          } catch (_) {
            _showSnackBar('Ошибка входа. Войди вручную.', isError: true);
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            });
          }
        }
      } else {
        if (mounted) {
          _showSnackBar(data['message'] ?? 'Ошибка регистрации', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Ошибка: $e", isError: true);
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Присоединись",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Начни изучать языки сегодня",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  controller: nameController,
                  label: "Имя",
                  icon: Icons.person_outline_rounded,
                  errorText: nameError,
                  onChanged: (_) {
                    if (nameError != null) setState(() => nameError = null);
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  errorText: emailError,
                  onChanged: (_) {
                    if (emailError != null) setState(() => emailError = null);
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  label: "Пароль",
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscurePassword,
                  errorText: passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  onChanged: (_) {
                    if (passwordError != null) setState(() => passwordError = null);
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: confirmPasswordController,
                  label: "Подтвердить пароль",
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscureConfirmPassword,
                  errorText: confirmPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  onChanged: (_) {
                    if (confirmPasswordError != null) setState(() => confirmPasswordError = null);
                  },
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Зарегистрироваться",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Уже есть аккаунт? ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        "Войти",
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red.shade300 : Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : const Color(0xFF6C63FF),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
