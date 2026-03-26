import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sinif.dart';
import 'api_constants.dart';

class SinifService {
  final String url = "${ApiConstants.baseUrl}/SinifApi";

  Future<List<Sinif>> getAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Sinif.fromJson(data)).toList();
    }
    throw Exception("Sınıflar yüklenemedi");
  }
  Future<bool> add(Sinif sinif) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(sinif.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> update(int id, Sinif sinif) async {
    final response = await http.put(
      Uri.parse("$url/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(sinif.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    return response.statusCode == 200;
  }
}