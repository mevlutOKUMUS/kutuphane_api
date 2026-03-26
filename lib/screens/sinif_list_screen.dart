import 'package:flutter/material.dart';
import '../models/sinif.dart';
import '../data/sinif_service.dart';

class SinifListScreen extends StatefulWidget {
  const SinifListScreen({super.key});

  @override
  State<SinifListScreen> createState() => _SinifListScreenState();
}

class _SinifListScreenState extends State<SinifListScreen> {
  final SinifService _service = SinifService();
  final Color sageGreen = const Color(0xFFA9C8A5);

  // --- SINIF EKLEME / DÜZENLEME FORMU ---
  void _showSinifForm({Sinif? sinif}) {
    final TextEditingController _adController = TextEditingController(text: sinif?.ad ?? "");
    final TextEditingController _seviyeController = TextEditingController(text: sinif?.seviye?.toString() ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(sinif == null ? "Yeni Sınıf Oluştur" : "Sınıfı Güncelle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _adController,
              decoration: const InputDecoration(labelText: "Sınıf Adı (Örn: 11-A)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _seviyeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Seviye (9, 10, 11...)", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Vazgeç")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: sageGreen),
            onPressed: () async {
              if (_adController.text.isNotEmpty) {
                final yeniSinif = Sinif(
                  id: sinif?.id ?? 0,
                  ad: _adController.text,
                  seviye: int.tryParse(_seviyeController.text) ?? 0,
                );

                if (sinif == null) {
                  await _service.add(yeniSinif);
                } else {
                  await _service.update(yeniSinif.id, yeniSinif);
                }
                Navigator.pop(context);
                setState(() {}); // Ekranı tazele
              }
            },
            child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EF),
      appBar: AppBar(
        title: const Text("Sınıf Yönetimi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: sageGreen,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Sinif>>(
        future: _service.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final siniflar = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: siniflar.length,
            itemBuilder: (context, index) {
              final sinif = siniflar[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  onTap: () => _showSinifForm(sinif: sinif),
                  leading: CircleAvatar(
                    backgroundColor: sageGreen.withOpacity(0.3),
                    child: Icon(Icons.school, color: Colors.green[700]),
                  ),
                  title: Text(sinif.ad, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text("${sinif.seviye}. Sınıf Seviyesi"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () async {
                      await _service.delete(sinif.id);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSinifForm(),
        backgroundColor: sageGreen,
        label: const Text("Sınıf Ekle", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}