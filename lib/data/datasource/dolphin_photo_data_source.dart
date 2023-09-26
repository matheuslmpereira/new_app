import '../model/photo_model.dart';

abstract class PhotoDataSource {
  Future<PhotoModel> getDolphinPhoto();
}
