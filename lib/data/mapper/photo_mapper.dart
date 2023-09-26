import '../../domain/entity/photo.dart';
import '../model/photo_model.dart';

Photo mapToDomain(PhotoModel model) {
  return Photo(
    id: model.id,
    url: model.url,
    description: model.description,
  );
}
