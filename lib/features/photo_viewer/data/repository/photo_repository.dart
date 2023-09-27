import '../../domain/entity/photo.dart';
import '../../domain/repository/photo_repository_interface.dart';
import '../datasource/buffer_photos_data_source.dart';
import '../datasource/dolphin_photo_data_source.dart';
import '../mapper/photo_mapper.dart';
import '../model/photo_model.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoDataSource _photoDataSource;
  final BufferPhotosDataSource _bufferPhotosDataSource;

  PhotoRepositoryImpl({
    required PhotoDataSource photoDataSource,
    required BufferPhotosDataSource bufferPhotosDataSource
  }) : _bufferPhotosDataSource = bufferPhotosDataSource, _photoDataSource = photoDataSource;

  @override
  Future<Photo> getPhoto() async {
    final PhotoModel photoModel = await _photoDataSource.getPhoto();
    _bufferPhotosDataSource.updateBuffer(photoModel);
    return mapToDomain(photoModel);
  }

  @override
  Future<List<Photo>> getBufferedPhotos() async {
    final List<PhotoModel> photoModelList = await _bufferPhotosDataSource.getBufferedPhotos();
    return photoModelList.map(mapToDomain).toList();
  }
}
