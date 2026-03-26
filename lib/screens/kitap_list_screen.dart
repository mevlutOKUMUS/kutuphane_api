import 'package:flutter/material.dart';
import '../models/kitap.dart';
import '../models/kategori.dart';
import '../data/kitap_service.dart';
import '../data/kategori_service.dart';

class KitapListScreen extends StatefulWidget {
  const KitapListScreen({super.key});

  @override
  State<KitapListScreen> createState() => _KitapListScreenState();
}

class _KitapListScreenState extends State<KitapListScreen> {
  final KitapService _service = KitapService();
  final KategoriService _kategoriService = KategoriService();

  // --- EKLEME VE GÜNCELLEME FORMU ---
  void _showKitapForm({Kitap? kitap}) async {
    final TextEditingController _adController = TextEditingController(text: kitap?.kitapAdi ?? "");
    final TextEditingController _yazarController = TextEditingController(text: kitap?.yazar ?? "");
    
    // Kategorileri çekelim ki dropdown doldurabilelim
    List<Kategori> kategoriler = await _kategoriService.getAll();
    int? secilenKategoriId = kitap?.kategoriId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavye açılınca ekran kayması için
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder( // BottomSheet içinde state yönetimi için
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(kitap == null ? "Yeni Kitap Ekle" : "Kitabı Düzenle", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(controller: _adController, decoration: const InputDecoration(labelText: "Kitap Adı", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: _yazarController, decoration: const InputDecoration(labelText: "Yazar", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              
              // Kategori Seçimi (Dropdown)
              DropdownButtonFormField<int>(
                value: secilenKategoriId,
                decoration: const InputDecoration(labelText: "Kategori Seçin", border: OutlineInputBorder()),
                items: kategoriler.map((k) => DropdownMenuItem(value: k.id, child: Text(k.kategoriAdi))).toList(),
                onChanged: (val) => setModalState(() => secilenKategoriId = val),
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC4A158), foregroundColor: Colors.white),
                  onPressed: () async {
                    if (_adController.text.isNotEmpty && secilenKategoriId != null) {
                      final yeniKitap = Kitap(
                        id: kitap?.id ?? 0,
                        kitapAdi: _adController.text,
                        yazar: _yazarController.text,
                        kategoriId: secilenKategoriId!,
                      );

                      if (kitap == null) {
                        await _service.add(yeniKitap);
                      } else {
                        await _service.update(yeniKitap.id, yeniKitap);
                      }
                      Navigator.pop(context);
                      setState(() {}); // Ana ekranı yenile
                    }
                  },
                  child: const Text("KAYDET"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- SİLME ONAYI ---
  void _deleteKitap(int id) async {
    await _service.delete(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kitap silindi")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EF),
      appBar: AppBar(
        title: const Text("Kitap Listesi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFC4A158),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Kitap>>(
        future: _service.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final kitaplar = snapshot.data ?? [];
          return ListView.builder(
            itemCount: kitaplar.length,
            itemBuilder: (context, index) {
              final kitap = kitaplar[index];
              return Dismissible( // Sağa kaydırarak silme özelliği
                key: Key(kitap.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) => _deleteKitap(kitap.id),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    border: const Border(left: BorderSide(color: Color(0xFFA9C8A5), width: 5))
                  ),
                  child: ListTile(
                    onTap: () => _showKitapForm(kitap: kitap), // Düzenlemek için tıkla
                    title: Text(kitap.kitapAdi, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${kitap.yazar} • ${kitap.kategori?.kategoriAdi ?? 'Genel'}"),
                    trailing: const Icon(Icons.edit_note, color: Color(0xFFC4A158)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showKitapForm(),
        backgroundColor: const Color(0xFFC4A158),
        child: const Icon(Icons.add_business, color: Colors.white),
      ),
    );
  }
}