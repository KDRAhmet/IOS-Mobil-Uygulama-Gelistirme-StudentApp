import 'package:flutter/material.dart';
import 'package:student_app_bol/screens/main_scaffold/main_scaffold.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'dart:async'; // Asenkron işlemler için
import 'package:http/http.dart' as http; // HTTP paketi
import 'dart:convert'; // JSON işlemleri için


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    final String studentNumberInput = _studentIdController.text;

    if (studentNumberInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen öğrenci numaranızı girin.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isLoading = true; });

    const String apiUrl = "https://10.0.2.2:7072/api/StudentsApi";

    try {
      final response = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> students = json.decode(response.body);

        var foundStudent = students.firstWhere(
              (student) => student['studentNumber'] == studentNumberInput,
          orElse: () => null,
        );

        if (foundStudent != null) {
          final int studentDbId = foundStudent['id'];
          final String studentName = foundStudent['fullName'];

          // Ana ekrana yönlendir ve ID'yi (ve ismi) ilet
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScaffold(
                studentDbId: studentDbId,
                studentName: studentName,
                // Öğrenci numarasını da iletiyoruz ---
                studentNumber: studentNumberInput,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Öğrenci numarası bulunamadı.'), backgroundColor: Colors.red),
          );
        }

      } else {
        throw Exception('API\'den öğrenci listesi alınamadı. Hata Kodu: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() { _isLoading = false; });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.school,
                  size: 80,
                  color: ankaraUniversityBlue,
                ),
                const SizedBox(height: 16),
                Text(
                  "Öğrenci Portalı",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Öğrenci Numarası',
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _performLogin,
                  child: _isLoading
                      ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                  )
                      : const Text('Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}