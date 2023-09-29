import 'package:test/test.dart';

import 'package:new_app/features/photo_viewer/data/datasource/local/buffer_photos.dart';
import 'package:new_app/features/photo_viewer/data/model/photo_model.dart';

void main() {
  late BufferPhotosDataSourceImpl dataSource;
  final testPhotoModel = PhotoModel(id: '1', url: 'http://example.com', description: 'Test Photo');

  setUp(() {
    dataSource = BufferPhotosDataSourceImpl();
  });

  group('getBufferedPhotos', () {
    test('should return an unmodifiable list containing the correct elements', () async {
      // Arrange
      dataSource.updateBuffer(testPhotoModel);

      // Act
      final result = await dataSource.getBufferedPhotos();

      // Assert
      expect(result, contains(testPhotoModel));
      expect(() => result.add(testPhotoModel), throwsUnsupportedError);
    });
  });

  group('updateBuffer', () {
    test('should add elements to the buffer', () {
      // Act
      dataSource.updateBuffer(testPhotoModel);

      // Assert
      expect(dataSource.getBufferedPhotos(), completion(contains(testPhotoModel)));
    });

    test('should remove the oldest element when the buffer size exceeds the maximum', () async {
      // Arrange
      final oldestPhotoModel = PhotoModel(id: '0', url: 'http://oldest.com', description: 'Oldest Photo');
      dataSource.updateBuffer(oldestPhotoModel);

      // Act
      for (int i = 1; i <= 5; i++) {
        dataSource.updateBuffer(PhotoModel(id: i.toString(), url: 'http://example.com/$i', description: 'Test Photo $i'));
      }

      // Assert
      final result = await dataSource.getBufferedPhotos();
      expect(result, isNot(contains(oldestPhotoModel)));
      expect(result.length, 5);
    });
  });
}
