class Sinif {
  final int id;
  final String ad;
  final int seviye;

  Sinif({
    required this.id,
    required this.ad,
    required this.seviye,
  });

  // API'den gelen veriyi Dart nesnesine çevirir
  factory Sinif.fromJson(Map<String, dynamic> json) {
    return Sinif(
      id: json['id'] ?? 0,
      ad: json['ad'] ?? '',
      seviye: json['seviye'] ?? 0,
    );
  }

  // Dart nesnesini API'ye göndermek için JSON'a çevirir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'seviye': seviye,
    };
  }
}