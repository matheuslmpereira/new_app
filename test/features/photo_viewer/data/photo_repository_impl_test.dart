import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/features/photo_viewer/data/datasource/buffer_photos_data_source.dart';
import 'package:new_app/features/photo_viewer/data/datasource/dolphin_photo_data_source.dart';
import 'package:new_app/features/photo_viewer/data/mapper/photo_mapper.dart';
import 'package:new_app/features/photo_viewer/data/model/photo_model.dart';
import 'package:new_app/features/photo_viewer/data/repository/photo_repository_impl.dart';

import 'photo_repository_impl_test.mocks.dart';

// Indicate the classes to generate mocks for
@GenerateMocks([PhotoDataSource, BufferPhotosDataSource])
void main() {
  late PhotoRepositoryImpl repository;
  late MockPhotoDataSource mockPhotoDataSource;
  late MockBufferPhotosDataSource mockBufferPhotosDataSource;

  setUp(() {
    mockPhotoDataSource = MockPhotoDataSource();
    mockBufferPhotosDataSource = MockBufferPhotosDataSource();
    repository = PhotoRepositoryImpl(
      photoDataSource: mockPhotoDataSource,
      bufferPhotosDataSource: mockBufferPhotosDataSource,
    );
  });

  group('getPhoto', () {
    test('should get photo from PhotoDataSource, update buffer, and return it', () async {
      // Arrange
      final photoModel = PhotoModel(id: '123', url: 'http://example.com', description: 'Test Photo');
      final photo = mapToDomain(photoModel);
      when(mockPhotoDataSource.getPhoto()).thenAnswer((_) async => photoModel);

      // Act
      final result = await repository.getPhoto();

      // Assert
      expect(result.id, equals(photo.id));
      verify(mockPhotoDataSource.getPhoto()).called(1);
      verify(mockBufferPhotosDataSource.updateBuffer(photoModel)).called(1);
    });
  });

  group('getBufferedPhotos', () {
    test('should return buffered photos', () async {
      // Arrange
      final photoModels = [
        PhotoModel(id: 'id1', url: 'http://example.com', description: 'Test Photo'),
        PhotoModel(id: 'id2', url: 'http://example.com', description: 'Test Photo')
      ];
      final photos = photoModels.map(mapToDomain).toList();
      when(mockBufferPhotosDataSource.getBufferedPhotos()).thenAnswer((_) async => photoModels);

      // Act
      final result = await repository.getBufferedPhotos();

      // Assert
      expect(result.length, equals(photos.length));
      for (int i = 0; i < result.length; i++) {
        expect(result[i].id, equals(photos[i].id));
        expect(result[i].url, equals(photos[i].url));
        expect(result[i].description, equals(photos[i].description));
      }
      verify(mockBufferPhotosDataSource.getBufferedPhotos()).called(1);
    });
  });
}
