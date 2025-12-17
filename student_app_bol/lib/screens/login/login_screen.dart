import 'package:flutter/material.dart';
// Kendi proje yolumuzu (student_app_bol) kullanalım
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
    final String studentNumberInput = _studentIdController.text.trim();
    final String passwordInput = _passwordController.text.trim();

    if (studentNumberInput.isEmpty || passwordInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen öğrenci numarası ve şifrenizi girin.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isLoading = true; });

    // API adresin (StudentAuthApi)
    const String apiUrl = "https://10.0.2.2:7072/api/StudentAuthApi/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'studentNumber': studentNumberInput,
          'password': passwordInput,
        }),
      ).timeout(const Duration(seconds: 10));

      // DEBUG İÇİN: API yanıtını konsola yazdır
      print("API Yanıt Kodu: ${response.statusCode}");
      print("API Yanıt Body: ${response.body}");

      if (response.statusCode == 200) {
        // --- BAŞARILI GİRİŞ ---
        final data = json.decode(response.body);

        // --- HATA DÜZELTMESİ (Gelişmiş) ---
        // API'den gelen veriyi daha güvenli bir şekilde çekmeye çalışıyoruz.
        // Hata mesajına göre API 'studentId' gönderiyor.
        int studentDbId = 0;
        if (data['id'] != null) {
          studentDbId = int.tryParse(data['id'].toString()) ?? 0;
        } else if (data['Id'] != null) {
          studentDbId = int.tryParse(data['Id'].toString()) ?? 0;
        } else if (data['studentId'] != null) { // <-- API yanıtına göre eklendi
          studentDbId = int.tryParse(data['studentId'].toString()) ?? 0;
        }

        // İsim alanını kontrol et ('fullname' küçük harfle geliyor olabilir)
        String studentName = "Öğrenci";
        if (data['fullName'] != null) {
          studentName = data['fullName'];
        } else if (data['FullName'] != null) {
          studentName = data['FullName'];
        } else if (data['fullname'] != null) { // <-- API yanıtına göre eklendi
          studentName = data['fullname'];
        }

        // Öğrenci numarası
        String studentNumber = studentNumberInput;
        if (data['studentNumber'] != null) {
          studentNumber = data['studentNumber'];
        }

        if (studentDbId == 0) {
          // ID hala 0 ise API farklı bir yapı dönüyor demektir.
          // Hata mesajında API yanıtını göster ki sorunu anlayabilelim.
          throw Exception("Öğrenci ID'si alınamadı. API yanıtı: ${response.body}");
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScaffold(
                studentDbId: studentDbId,
                studentName: studentName,
                studentNumber: studentNumber,
              ),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Öğrenci numarası veya şifre hatalı.'), backgroundColor: Colors.red),
        );
      } else {
        throw Exception('Giriş yapılamadı. Hata Kodu: ${response.statusCode}. Mesaj: ${response.body}');
      }
    } catch (e) {
      print("Giriş Hatası Detayı: $e"); // Hatayı konsola da yazdır
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
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