import '../../model/photo_model.dart';
import '../buffer_photos_data_source.dart';

class BufferPhotosDataSourceImpl implements BufferPhotosDataSource {
  final int _maxBufferSize = 5;
  final List<PhotoModel> _buffer = [];

  @override
  Future<List<PhotoModel>> getBufferedPhotos() async {
    return List.unmodifiable(_buffer); // Return a copy of the buffer to preserve encapsulation
  }

  @override
  void updateBuffer(PhotoModel photoModel) {
    if (_buffer.length >= _maxBufferSize) {
      _buffer.removeAt(0); // Remove the oldest element if the buffer size is at the maximum
    }
    _buffer.add(photoModel); // Add the new photo model to the buffer
  }
}
