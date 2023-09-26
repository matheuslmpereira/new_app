import '../entity/photo.dart';
import '../repository/photo_repository_interface.dart';

class GetBufferedPhotosUseCase {
  final PhotoRepository _photoRepository;

  GetBufferedPhotosUseCase({
    required PhotoRepository photoRepository
  }) : _photoRepository = photoRepository;

  Future<List<Photo>> call() {
    return _photoRepository.getBufferedPhotos();
  }
}
