import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/photo_model.dart';

class UnsplashApi {
  final String baseUrl;
  final String clientId;

  UnsplashApi({
    required this.baseUrl,
    required this.clientId,
  });

  Future<PhotoModel> getDolphinPhotos() async {
    final url = Uri.parse("$baseUrl/photos/random?query=dolphin&client_id=$clientId");

    try {
      final response = await http.get(url);
      final urlData = json.decode(response.body);
      print(urlData);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final urlData = json.decode(response.body);
        return PhotoModel.fromJson(urlData);
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }

    throw Exception('Failed to load dolphin photo');
  }
}
