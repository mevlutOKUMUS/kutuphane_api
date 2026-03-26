import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kitap.dart';
import 'api_constants.dart';

class KitapService {
  final String url = "${ApiConstants.baseUrl}/KitapApi";

  Future<List<Kitap>> getAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Kitap.fromJson(data)).toList();
    }
    throw Exception("Kitaplar yüklenemedi");
  }
  Future<bool> add(Kitap kitap) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(kitap.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> update(int id, Kitap kitap) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(kitap.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return response.statusCode == 200;
  }
}