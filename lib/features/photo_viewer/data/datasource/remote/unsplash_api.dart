import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/photo_model.dart';
import '../dolphin_photo_data_source.dart';

class UnsplashApi implements PhotoDataSource {
  final String _baseUrl;
  final String _clientId;

  UnsplashApi({
    required String baseUrl,
    required String clientId,
  }) : _clientId = clientId, _baseUrl = baseUrl;

  @override
  Future<PhotoModel> getPhoto() async {
    final url = Uri.parse("$_baseUrl/photos/random?query=dolphin&client_id=$_clientId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final urlData = json.decode(response.body);
        return PhotoModel.fromJson(urlData);
      }
    } catch (e) {
      throw Exception('Error during HTTP request: $e');
    }

    throw Exception('Failed to load dolphin photo');
  }
}
