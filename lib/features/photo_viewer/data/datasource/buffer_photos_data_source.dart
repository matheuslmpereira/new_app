import '../model/photo_model.dart';

abstract class BufferPhotosDataSource {
  Future<List<PhotoModel>> getBufferedPhotos();
  void updateBuffer(PhotoModel photoModel);
}
