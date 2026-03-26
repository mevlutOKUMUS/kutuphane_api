import 'package:flutter/material.dart';
import '../models/kategori.dart';
import '../data/kategori_service.dart';


class KategoriListScreen extends StatefulWidget {
  const KategoriListScreen({super.key});

  @override
  State<KategoriListScreen> createState() => _KategoriListScreenState();
}

class _KategoriListScreenState extends State<KategoriListScreen> {
  final KategoriService _service = KategoriService();
  
  final Color sageGreen = const Color(0xFFA9C8A5);
  final Color blushPink = const Color(0xFFF7C6D5);
  final Color gold = const Color(0xFFC4A158);

  // --- EKLEME VE GÜNCELLEME DİYALOĞU ---
  void _showFormDialog({Kategori? kategori}) {
    // Eğer kategori null değilse güncelleme modundayız demektir
    final TextEditingController _nameController = TextEditingController(
      text: kategori != null ? kategori.kategoriAdi : ""
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(kategori == null ? "Yeni Kategori Ekle" : "Kategoriyi Düzenle"),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Kategori Adı",
            hintText: "Örn: Roman, Bilim Kurgu",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Vazgeç")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gold),
            onPressed: () async {
              if (_nameController.text.isNotEmpty) {
                if (kategori == null) {
                  // EKLEME
                  await _service.add(Kategori(id: 0, kategoriAdi: _nameController.text));
                } else {
                  // GÜNCELLEME
                  kategori.kategoriAdi = _nameController.text;
                  await _service.update(kategori.id, kategori);
                }
                Navigator.pop(context);
                setState(() {}); // Ekranı yenile
              }
            },
            child: const Text("Kaydet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- SİLME ONAY DİYALOĞU ---
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Emin misiniz?"),
        content: const Text("Bu kategoriyi sildiğinizde geri alamazsınız."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          TextButton(
            onPressed: () async {
              await _service.delete(id);
              Navigator.pop(context);
              setState(() {}); // Ekranı yenile
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
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
        title: const Text("Kategoriler", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: sageGreen,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Kategori>>(
        future: _service.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz kategori eklenmemiş."));
          }

          final kategoriler = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: kategoriler.length,
            itemBuilder: (context, index) {
              final item = kategoriler[index];
              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () => _showFormDialog(kategori: item), // Tıklayınca Düzenle
                  leading: CircleAvatar(
                    backgroundColor: blushPink,
                    child: Text(item.id.toString(), style: const TextStyle(color: Colors.black87)),
                  ),
                  title: Text(item.kategoriAdi, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(item.id), // Silme Butonu
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(), // Boş çağırırsak "Yeni Ekle" olur
        backgroundColor: gold,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}