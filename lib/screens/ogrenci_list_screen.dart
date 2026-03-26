import 'package:flutter/material.dart';
import '../models/ogrenci.dart';
import '../models/sinif.dart';
import '../data/ogrenci_service.dart';
import '../data/sinif_service.dart';

class OgrenciListScreen extends StatefulWidget {
  const OgrenciListScreen({super.key});

  @override
  State<OgrenciListScreen> createState() => _OgrenciListScreenState();
}

class _OgrenciListScreenState extends State<OgrenciListScreen> {
  final OgrenciService _service = OgrenciService();
  final SinifService _sinifService = SinifService();

  // Renk Paleti (Dashboard ile uyumlu)
  final Color blushPink = const Color(0xFFF7C6D5);
  final Color sageGreen = const Color(0xFFA9C8A5);

  // --- ÖĞRENCİ EKLEME VE GÜNCELLEME FORMU ---
  void _showOgrenciForm({Ogrenci? ogrenci}) async {
    final TextEditingController _adController = TextEditingController(text: ogrenci?.ad ?? "");
    final TextEditingController _soyadController = TextEditingController(text: ogrenci?.soyad ?? "");
    final TextEditingController _noController = TextEditingController(text: ogrenci?.numara ?? "");
    
    // Dropdown için sınıfları çekiyoruz
    List<Sinif> siniflar = await _sinifService.getAll();
    int? secilenSinifId = ogrenci?.sinifId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 15),
              Text(ogrenci == null ? "Yeni Öğrenci Kaydı" : "Bilgileri Güncelle", 
                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: _adController, decoration: const InputDecoration(labelText: "Öğrenci Adı", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: _soyadController, decoration: const InputDecoration(labelText: "Öğrenci Soyadı", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: _noController, decoration: const InputDecoration(labelText: "Okul Numarası", border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge))),
              const SizedBox(height: 10),
              
              // SINIF SEÇİM DROPDOWN
              DropdownButtonFormField<int>(
                value: secilenSinifId,
                decoration: const InputDecoration(labelText: "Sınıf Seçin", border: OutlineInputBorder(), prefixIcon: Icon(Icons.school)),
                items: siniflar.map((s) => DropdownMenuItem(value: s.id, child: Text(s.ad))).toList(),
                onChanged: (val) => setModalState(() => secilenSinifId = val),
              ),
              const SizedBox(height: 25),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: sageGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () async {
                    if (_adController.text.isNotEmpty && secilenSinifId != null) {
                      final yeniOgrenci = Ogrenci(
                        id: ogrenci?.id ?? 0,
                        ad: _adController.text,
                        soyad: _soyadController.text,
                        numara: _noController.text,
                        sinifId: secilenSinifId!,
                      );

                      if (ogrenci == null) {
                        await _service.add(yeniOgrenci);
                      } else {
                        await _service.update(yeniOgrenci.id, yeniOgrenci);
                      }
                      Navigator.pop(context);
                      setState(() {}); // Ekranı tazele
                    }
                  },
                  child: const Text("KAYDET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EF),
      appBar: AppBar(
        title: const Text("Öğrenci Yönetimi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: blushPink,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Ogrenci>>(
        future: _service.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final ogrenciler = snapshot.data ?? [];
          if (ogrenciler.isEmpty) return const Center(child: Text("Henüz kayıtlı öğrenci yok."));

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: ogrenciler.length,
            itemBuilder: (context, index) {
              final ogr = ogrenciler[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  onTap: () => _showOgrenciForm(ogrenci: ogr),
                  leading: CircleAvatar(
                    backgroundColor: sageGreen,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text("${ogr.ad} ${ogr.soyad}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("No: ${ogr.numara} • ${ogr.sinif?.ad ?? 'Sınıf Yok'}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                    onPressed: () async {
                      await _service.delete(ogr.id);
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
        onPressed: () => _showOgrenciForm(),
        backgroundColor: blushPink,
        icon: const Icon(Icons.add, color: Colors.black87),
        label: const Text("Öğrenci Ekle", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
    );
  }
}