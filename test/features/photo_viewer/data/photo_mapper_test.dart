import 'package:flutter_test/flutter_test.dart';
import 'package:new_app/features/photo_viewer/data/mapper/photo_mapper.dart';
import 'package:new_app/features/photo_viewer/data/model/photo_model.dart';
import 'package:new_app/features/photo_viewer/domain/entity/photo.dart';

void main() {
  test('should map PhotoModel to Photo domain entity', () {
    // Arrange
    final photoModel = PhotoModel(
      id: '123',
      url: 'http://example.com',
      description: 'A test photo',
    );

    // Act
    final result = mapToDomain(photoModel);

    // Assert
    expect(result, isA<Photo>());
    expect(result.id, equals(photoModel.id));
    expect(result.url, equals(photoModel.url));
    expect(result.description, equals(photoModel.description));
  });
}
