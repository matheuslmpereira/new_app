import 'package:flutter_test/flutter_test.dart';
import 'package:new_app/features/photo_viewer/data/model/photo_model.dart';

void main() {
  group('PhotoModel', () {
    test('fromJson should return a valid PhotoModel', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'id': '123',
        'urls': {'small': 'http://example.com'},
        'description': 'A test photo',
      };

      // Act
      final result = PhotoModel.fromJson(jsonMap);

      // Assert
      expect(result, isA<PhotoModel>());
      expect(result.id, '123');
      expect(result.url, 'http://example.com');
      expect(result.description, 'A test photo');
    });

    test('fromJson should handle missing description', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'id': '123',
        'urls': {'small': 'http://example.com'},
      };

      // Act
      final result = PhotoModel.fromJson(jsonMap);

      // Assert
      expect(result, isA<PhotoModel>());
      expect(result.id, '123');
      expect(result.url, 'http://example.com');
      expect(result.description, 'No Description');
    });
  });
}
