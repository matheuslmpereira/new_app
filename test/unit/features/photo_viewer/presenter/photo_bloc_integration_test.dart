import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/features/photo_viewer/domain/entity/photo.dart';
import 'package:new_app/features/photo_viewer/domain/usecase/get_buffered_usecase.dart';
import 'package:new_app/features/photo_viewer/domain/usecase/get_photo_usecase.dart';
import 'package:new_app/features/photo_viewer/presentation/bloc/photo_bloc.dart';
import 'package:new_app/features/photo_viewer/presentation/bloc/photo_event.dart';
import 'package:new_app/features/photo_viewer/presentation/bloc/photo_state.dart';

import 'photo_bloc_integration_test.mocks.dart';

@GenerateMocks([GetPhotoUseCase, GetBufferedPhotosUseCase])
void main() {
  late PhotoBloc photoBloc;
  late MockGetPhotoUseCase getPhotoUseCase;
  late MockGetBufferedPhotosUseCase getBufferedPhotosUseCase;
  const durationInMillis = 50;

  setUp(() {
    getPhotoUseCase = MockGetPhotoUseCase();
    getBufferedPhotosUseCase = MockGetBufferedPhotosUseCase();
    photoBloc = PhotoBloc(
      getDolphinPhotoUseCase: getPhotoUseCase,
      getBufferedPhotosUseCase: getBufferedPhotosUseCase,
      duration: const Duration(milliseconds: durationInMillis)
    );
  });

  tearDown(() {
    photoBloc.close();
  });

  test('initial state is PhotoInitial', () {
    expect(photoBloc.state.runtimeType, PhotoInitial().runtimeType);
  });

  group('FetchingPhotos', () {
    final mockPhoto = Photo(id: '1', url: 'url', description: 'description');

    test('emits LoadingPhotoState and LoadedPhotoState on success', () async {
      when(getPhotoUseCase.call()).thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 10), () => mockPhoto));
      photoBloc.add(StartFetchingPhotos());

      await expectLater(
        photoBloc.stream,
        emitsInOrder([
          isA<LoadingPhotoState>(),
          isA<LoadedPhotoState>(),
        ]),
      );

      photoBloc.add(StopFetchingPhotos());
      await Future.delayed(const Duration(milliseconds: durationInMillis));
      assert(photoBloc.photoTimer?.isActive != true);
    });
  });

  group('RewindPhotos', () {
    final mockPhotos = [
      Photo(id: '1', url: 'url1', description: 'description1'),
      Photo(id: '2', url: 'url2', description: 'description2'),
    ];

    test('emits LoadedPhotoState for each photo and PhotoInitial on finish', () async {
      when(getBufferedPhotosUseCase.call()).thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 10), () => mockPhotos));
      photoBloc.add(RewindPhotos());

      await expectLater(
        photoBloc.stream,
        emitsInOrder([
          isA<LoadingPhotoState>(),
          isA<LoadedPhotoState>(),
          isA<LoadedPhotoState>(),
          isA<PhotoInitial>(),
        ]),
      );
    });
  });

  group('OnErrorEvent', () {
    test('emits ErrorPhotoState when an error occurs', () async {
      when(getPhotoUseCase.call()).thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 10), () => Future.error("Error Message")));
      photoBloc.add(StartFetchingPhotos());

      await expectLater(
        photoBloc.stream,
        emitsInOrder([
          isA<LoadingPhotoState>(),
          isA<PhotoError>(),
        ]),
      );
    });
  });
}
