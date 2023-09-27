import '../entity/photo.dart';
import '../repository/photo_repository_interface.dart';

class GetPhotoUseCase {
  final PhotoRepository _photoRepository;

  GetPhotoUseCase({
    required PhotoRepository photoRepository
  }) : _photoRepository = photoRepository;

  Future<Photo> call() {
    return _photoRepository.getPhoto();
  }
}
