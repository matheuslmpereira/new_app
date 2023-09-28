import '../entity/photo.dart';

abstract class PhotoRepository {
  Future<Photo> getPhoto();
  Future<List<Photo>> getBufferedPhotos();
}
