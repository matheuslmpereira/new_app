import '../entity/photo.dart';
import '../repository/photo_repository_interface.dart';

class GetDolphinPhotoUseCase {
  final PhotoRepository _photoRepository;

  GetDolphinPhotoUseCase({
    required PhotoRepository photoRepository
  }) : _photoRepository = photoRepository;

  Future<Photo> call() {
    return _photoRepository.getDolphinPhoto();
  }
}