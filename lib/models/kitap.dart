import 'kategori.dart';

class Kitap {
  final int id;
  final String kitapAdi;
  final int kategoriId;
  final String yazar;
  final Kategori? kategori; // Navigation Property (İlişkili veri)

  Kitap({
    required this.id,
    required this.kitapAdi,
    required this.kategoriId,
    required this.yazar,
    this.kategori,
  });

  // JSON -> Dart nesnesi
  factory Kitap.fromJson(Map<String, dynamic> json) {
    return Kitap(
      id: json['id'] ?? 0,
      kitapAdi: json['kitapAdi'] ?? '',
      kategoriId: json['kategoriId'] ?? 0,
      yazar: json['yazar'] ?? '',
      // Eğer JSON içinde 'kategori' nesnesi dolu gelirse onu da dönüştür
      kategori: json['kategori'] != null 
          ? Kategori.fromJson(json['kategori']) 
          : null,
    );
  }

  // Dart nesnesi -> JSON (Ekleme ve Güncelleme için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kitapAdi': kitapAdi,
      'kategoriId': kategoriId,
      'yazar': yazar,
      // API'ye gönderirken genelde nesneyi değil sadece ID'yi göndeririz
    };
  }
}