import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool isSubmitting = false;

  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  bool _validate() {
  bool ok = true;
  setState(() {
    nameError = null;
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;
  });

  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;
  final confirm = confirmPasswordController.text;

  if (name.isEmpty) {
    nameError = 'Please enter your name';
    ok = false;
  } else if (name.length < 2) {
    nameError = 'Name is too short';
    ok = false;
  }

  if (email.isEmpty) {
    emailError = 'Please enter your email';
    ok = false;
  } else if (!_emailRegExp.hasMatch(email)) {
    emailError = 'Enter a valid email';
    ok = false;
  }

  
  final passwordRegex =
      RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~^%]).{8,}$'); 

  if (password.isEmpty) {
    passwordError = 'Please enter a password';
    ok = false;
  } else if (!passwordRegex.hasMatch(password)) {
    passwordError =
        'Password must be at least 8 chars, include 1 uppercase & 1 special symbol';
    ok = false;
  }

  if (confirm.isEmpty) {
    confirmPasswordError = 'Please confirm password';
    ok = false;
  } else if (password != confirm) {
    confirmPasswordError = 'Passwords do not match';
    ok = false;
  }

  setState(() {});
  return ok;
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Registration successful!'),
            ),
          );

          // Auto-login to obtain token, then navigate to home
          try {
            final loginRes = await http.post(
              Uri.parse('http://localhost:3001/login'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': email,
                'password': password,
              }),
            );
            final loginData = jsonDecode(loginRes.body);
            if (loginRes.statusCode == 200 && loginData['token'] != null) {
              final String token = loginData['token'];
              Future.delayed(const Duration(milliseconds: 800), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(token: token),
                  ),
                );
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loginData['message'] ?? 'Auto-login failed. Please sign in.')),
              );
              Future.delayed(const Duration(milliseconds: 800), () {
                Navigator.pushReplacementNamed(context, '/login');
              });
            }
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Auto-login failed. Please sign in.')),
            );
            Future.delayed(const Duration(milliseconds: 800), () {
              Navigator.pushReplacementNamed(context, '/login');
            });
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Error during registration'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.language,
                size: 90,
                color: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 10),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Start your language journey today!",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // 🧑 Имя
              _buildTextField(
                controller: nameController,
                label: "Name",
                icon: Icons.person,
                errorText: nameError,
                onChanged: (_) {
                  if (nameError != null) setState(() => nameError = null);
                },
              ),
              const SizedBox(height: 16),

              // ✉️ Email
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                errorText: emailError,
                onChanged: (_) {
                  if (emailError != null) setState(() => emailError = null);
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Пароль
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                obscure: _obscurePassword,
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                onChanged: (_) {
                  if (passwordError != null)
                    setState(() => passwordError = null);
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Подтверждение
              _buildTextField(
                controller: confirmPasswordController,
                label: "Confirm Password",
                icon: Icons.lock_outline,
                obscure: _obscureConfirmPassword,
                errorText: confirmPasswordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                ),
                onChanged: (_) {
                  if (confirmPasswordError != null)
                    setState(() => confirmPasswordError = null);
                },
              ),
              const SizedBox(height: 30),

              // 🌟 Кнопка регистрации
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 5,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // 🧭 Переход к логину
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.deepPurpleAccent.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
