import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool submitting = false;
  bool obscure = true;

  Future<void> _submit() async {
    final code = codeController.text.trim();
    final newPass = passController.text.trim();
    if (code.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите код и новый пароль')),
      );
      return;
    }
    setState(() => submitting = true);
    try {
      final res = await http.post(
        Uri.parse('http://localhost:3001/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'code': code,
          'newPassword': newPass,
        }),
      );
      if (!mounted) return;
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароль обновлён, войдите заново')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        final body = res.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $body')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Сбой сети: $e')),
      );
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сброс пароля')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Email: ${widget.email}'),
            const SizedBox(height: 12),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Код из письма',
                prefixIcon:
                    const Icon(Icons.verified_user, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: Colors.deepPurpleAccent.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passController,
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                prefixIcon: const Icon(Icons.lock, color: Colors.deepPurpleAccent),
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscure = !obscure),
                ),
                filled: true,
                fillColor: Colors.deepPurpleAccent.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  submitting ? 'Отправляем…' : 'Сбросить пароль',
                  style:
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

