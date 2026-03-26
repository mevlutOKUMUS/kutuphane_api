import 'sinif.dart';

class Ogrenci {
  final int id;
  final String ad;
  final String soyad;
  final String numara;
  final int sinifId;
  final Sinif? sinif; // İlişkili Sınıf nesnesi

  Ogrenci({
    required this.id,
    required this.ad,
    required this.soyad,
    required this.numara,
    required this.sinifId,
    this.sinif,
  });

  // JSON -> Dart nesnesi (API'den veri çekerken)
  factory Ogrenci.fromJson(Map<String, dynamic> json) {
    return Ogrenci(
      id: json['id'] ?? 0,
      ad: json['ad'] ?? '',
      soyad: json['soyad'] ?? '',
      numara: json['numara'] ?? '',
      sinifId: json['sinifId'] ?? 0,
      // Eğer API'den .Include(o => o.Sinif) ile veri gelirse burası dolar
      sinif: json['sinif'] != null 
          ? Sinif.fromJson(json['sinif']) 
          : null,
    );
  }

  // Dart nesnesi -> JSON (API'ye veri gönderirken)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'numara': numara,
      'sinifId': sinifId,
      // Ekleme yaparken genelde sadece sinifId gönderilir
    };
  }
}