import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori.dart';
import 'api_constants.dart';

class KategoriService {
  final String url = "${ApiConstants.baseUrl}/KategoriApi";

  Future<List<Kategori>> getAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Kategori.fromJson(data)).toList();
    }
    throw Exception("Kategoriler yüklenemedi");
  }

  Future<bool> add(Kategori kategori) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(kategori.toJson()),
    );
    return response.statusCode == 201;
  }
  // GÜNCELLE (PUT)
  Future<bool> update(int id, Kategori kategori) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(kategori.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // SİL (DELETE)
  Future<bool> delete(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return response.statusCode == 200 || response.statusCode == 204;
  }
}