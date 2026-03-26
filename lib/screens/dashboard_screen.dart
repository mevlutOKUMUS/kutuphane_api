import 'package:flutter/material.dart';
import 'package:kutuphane_api/screens/ogrenci_list_screen.dart';
import 'package:kutuphane_api/screens/sinif_list_screen.dart';
import '../data/kitap_service.dart';
import '../data/ogrenci_service.dart';
import '../data/sinif_service.dart';
import '../data/kategori_service.dart';
import 'kitap_list_screen.dart';
import 'kategori_list_screen.dart';
// import 'ogrenci_list_screen.dart'; // Bu dosyaları oluşturunca açarsın
// import 'sinif_list_screen.dart';

class SpringGardenColors {
  static const Color blushPink = Color(0xFFF7C6D5);
  static const Color sageGreen = Color(0xFFA9C8A5);
  static const Color buttercream = Color(0xFFF8EAC4);
  static const Color gold = Color(0xFFC4A158);
  static const Color scaffoldBg = Color(0xFFFAF5EF);
  static const Color textDark = Color(0xFF3E4E3A);
}

class DashboardScreen extends StatefulWidget { // ARTIK STATEFUL
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Canlı verileri tutacak değişkenler
  int ogrenciSayisi = 0;
  int kitapSayisi = 0;
  int kategoriSayisi = 0;
  int sinifSayisi = 0;
  String sonKitap = "Yükleniyor...";
  String sonYazar = "...";

  @override
  void initState() {
    super.initState();
    _verileriGetir(); // Ekran açılırken verileri çek
  }

  Future<void> _verileriGetir() async {
    // Tüm servislerden verileri çekiyoruz
    final kitaplar = await KitapService().getAll();
    final ogrenciler = await OgrenciService().getAll();
    final siniflar = await SinifService().getAll();
    final kategoriler = await KategoriService().getAll();

    setState(() {
      kitapSayisi = kitaplar.length;
      ogrenciSayisi = ogrenciler.length;
      sinifSayisi = siniflar.length;
      kategoriSayisi = kategoriler.length;
      
      if (kitaplar.isNotEmpty) {
        sonKitap = kitaplar.last.kitapAdi;
        sonYazar = kitaplar.last.yazar;
      } else {
        sonKitap = "Kitap bulunamadı";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SpringGardenColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("Kütüphane Yönetimi", style: TextStyle(color: SpringGardenColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: SpringGardenColors.sageGreen,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _verileriGetir) // El ile yenileme
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hoş geldiniz!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: SpringGardenColors.textDark)),
            const SizedBox(height: 30),

            // Kartlar (Değişkenleri buraya bağladık)
            Row(
              children: [
                Expanded(child: _buildInfoCard("Öğrenciler", ogrenciSayisi.toString(), SpringGardenColors.blushPink, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OgrenciListScreen()));
                })),
                const SizedBox(width: 15),
                Expanded(child: _buildInfoCard("Sınıflar", sinifSayisi.toString(), SpringGardenColors.sageGreen, () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const SinifListScreen()));
                })),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildInfoCard("Kitaplar", kitapSayisi.toString(), SpringGardenColors.gold, () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const KitapListScreen()));
                })),
                const SizedBox(width: 15),
                Expanded(child: _buildInfoCard("Kategoriler", kategoriSayisi.toString(), SpringGardenColors.buttercream, () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const KategoriListScreen()));
                })),
              ],
            ),
            
            const SizedBox(height: 25),
            _buildLastBookCard("Sisteme Son Eklenen Kitap", sonKitap, sonYazar),
            const SizedBox(height: 30),

            
          ],
        ),
      ),
    );
  }

  // Kartlara tıklama (onTap) özelliği ekledik
  Widget _buildInfoCard(String title, String value, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastBookCard(String title, String bookName, String authorName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SpringGardenColors.blushPink.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: SpringGardenColors.blushPink),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.book, size: 30),
              const SizedBox(width: 15),
              Expanded(child: Text("$bookName ($authorName)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }
}