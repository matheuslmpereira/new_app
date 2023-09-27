import 'package:get_it/get_it.dart';

import '../features/photo_viewer/data/datasource/buffer_photos_data_source.dart';
import '../features/photo_viewer/data/datasource/dolphin_photo_data_source.dart';
import '../features/photo_viewer/data/datasource/local/buffer_photos.dart';
import '../features/photo_viewer/data/datasource/mockup/unsplash_mockup.dart';
import '../features/photo_viewer/data/datasource/remote/unsplash_api.dart';
import '../features/photo_viewer/data/repository/photo_repository.dart';
import '../features/photo_viewer/domain/repository/photo_repository_interface.dart';
import '../features/photo_viewer/domain/usecase/get_buffered_usecase.dart';
import '../features/photo_viewer/domain/usecase/get_photo_usecase.dart';
import '../features/photo_viewer/presentation/bloc/photo_bloc.dart';
import 'config_loader.dart';

final locator = GetIt.instance;

void setupLocator(Config config) {
  if (config.isMockupMode) {
    locator.registerLazySingleton<PhotoDataSource>(() => UnsplashMockup());
  } else {
    locator.registerLazySingleton<PhotoDataSource>(() => UnsplashApi(
          baseUrl: config.baseUrl,
          clientId: config.clientId,
        ));
  }
  locator.registerLazySingleton<BufferPhotosDataSource>(
      () => BufferPhotosDataSourceImpl());
  locator.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(
      photoDataSource: locator<PhotoDataSource>(),
      bufferPhotosDataSource: locator<BufferPhotosDataSource>()));
  locator.registerLazySingleton(
      () => GetPhotoUseCase(photoRepository: locator<PhotoRepository>()));
  locator.registerLazySingleton(() =>
      GetBufferedPhotosUseCase(photoRepository: locator<PhotoRepository>()));
  locator.registerLazySingleton(() => PhotoBloc(
      getDolphinPhotoUseCase: locator<GetPhotoUseCase>(),
      getBufferedPhotosUseCase: locator<GetBufferedPhotosUseCase>()));
}
