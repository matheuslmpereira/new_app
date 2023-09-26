import 'dart:convert';

import 'package:flutter/services.dart';

import '../../model/photo_model.dart';
import '../dolphin_photo_data_source.dart';

class UnsplashMockup implements PhotoDataSource {
  List<PhotoModel>? _listPhotos;
  var _index = 0;

  @override
  Future<PhotoModel> getDolphinPhoto() async {
    _listPhotos ??= await _loadMockupData();
    var photo = _listPhotos![_index];
    _index = ((_index + 1) % _listPhotos!.length);
    return photo;
  }

  Future<List<PhotoModel>> _loadMockupData() async {
    final jsonString = await rootBundle.loadString('assets/mockup_data.json');
    final List<dynamic> body = json.decode(jsonString);
    return body.map((dynamic json) => PhotoModel.fromJson(json)).toList();
  }
}
