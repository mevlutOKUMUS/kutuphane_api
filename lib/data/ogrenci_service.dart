import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ogrenci.dart';
import 'api_constants.dart';

class OgrenciService {
  final String url = "${ApiConstants.baseUrl}/OgrenciApi";

  Future<List<Ogrenci>> getAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Ogrenci.fromJson(data)).toList();
    }
    throw Exception("Öğrenciler yüklenemedi");
  }
  Future<bool> add(Ogrenci ogrenci) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(ogrenci.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> update(int id, Ogrenci ogrenci) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(ogrenci.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return response.statusCode == 200;
  }
}