import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/features/photo_viewer/domain/entity/photo.dart';
import 'package:new_app/features/photo_viewer/domain/repository/photo_repository_interface.dart';
import 'package:new_app/features/photo_viewer/domain/usecase/get_buffered_usecase.dart';

import 'get_buffered_usecase_test.mocks.dart';

@GenerateMocks([PhotoRepository])
void main() {
  late GetBufferedPhotosUseCase getBufferedPhotosUseCase;
  late MockPhotoRepository mockPhotoRepository;

  setUp(() {
    mockPhotoRepository = MockPhotoRepository();
    getBufferedPhotosUseCase = GetBufferedPhotosUseCase(
      photoRepository: mockPhotoRepository,
    );
  });

  test('should get list of buffered photos from the repository', () async {
    // arrange
    final List<Photo> tPhotosList = [
      Photo(id: "id1", url: "url1", description: "description1"),
      Photo(id: "id2", url: "url2", description: "description2")];
    when(mockPhotoRepository.getBufferedPhotos())
        .thenAnswer((_) async => tPhotosList);

    // act
    final result = await getBufferedPhotosUseCase();

    // assert
    expect(result, tPhotosList);
    verify(mockPhotoRepository.getBufferedPhotos());
    verifyNoMoreInteractions(mockPhotoRepository);
  });
}
