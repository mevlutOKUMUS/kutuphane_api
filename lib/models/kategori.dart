class Kategori {
  final int id;
   String kategoriAdi;

  Kategori({
    required this.id,
    required this.kategoriAdi,
  });

  // API'den gelen JSON verisini Dart nesnesine dönüştürür (From JSON)
  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] ?? 0,
      kategoriAdi: json['kategoriAdi'] ?? '',
    );
  }

  // Dart nesnesini API'ye göndermek için JSON formatına dönüştürür (To JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategoriAdi': kategoriAdi,
    };
  }
}