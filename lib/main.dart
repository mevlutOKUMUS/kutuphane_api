import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart'; // Dashboard dosyanı import ediyoruz

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki kırmızı "Debug" yazısını kaldırır
      title: 'Kütüphane Yönetimi',
      
      // Uygulamanın genel renk şemasını o "Spring Garden" havasına sokalım
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFFAF5EF), // Arka plan krem
      ),
      
      // Uygulama açıldığında karşına gelecek ilk ekran
      home: const DashboardScreen(), 
    );
  }
}