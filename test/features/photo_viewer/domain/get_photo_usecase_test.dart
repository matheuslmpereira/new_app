import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/features/photo_viewer/domain/entity/photo.dart';
import 'package:new_app/features/photo_viewer/domain/repository/photo_repository_interface.dart';
import 'package:new_app/features/photo_viewer/domain/usecase/get_photo_usecase.dart';

import 'get_buffered_usecase_test.mocks.dart';

@GenerateMocks([PhotoRepository])
void main() {
  late GetPhotoUseCase getPhotoUseCase;
  late MockPhotoRepository mockPhotoRepository;

  setUp(() {
    mockPhotoRepository = MockPhotoRepository();
    getPhotoUseCase = GetPhotoUseCase(
      photoRepository: mockPhotoRepository,
    );
  });

  test('should get a photo from the repository', () async {
    // arrange
    final Photo tPhoto = Photo(id: "id", url: "url", description: "description");
    when(mockPhotoRepository.getPhoto()).thenAnswer((_) async => tPhoto);

    // act
    final result = await getPhotoUseCase();

    // assert
    expect(result, tPhoto);
    verify(mockPhotoRepository.getPhoto());
    verifyNoMoreInteractions(mockPhotoRepository);
  });
}
