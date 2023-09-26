import '../../domain/entities/photo.dart';
import '../models/photo_model.dart';

class PhotoMapper {
  Photo toDomain(PhotoModel model) {
    return Photo(
      id: model.id,
      url: model.url,
      description: model.description,
    );
  }
}
