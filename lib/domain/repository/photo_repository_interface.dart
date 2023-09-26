import '../entity/photo.dart';

abstract class PhotoRepository {
  Future<Photo> getDolphinPhoto();
  Future<List<Photo>> getBufferedPhotos();
}
