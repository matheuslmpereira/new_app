import 'package:get_it/get_it.dart';
import 'package:new_app/domain/usecase/get_dolphin_buffered_usecase.dart';

import '../data/datasource/buffer_photos_data_source.dart';
import '../data/datasource/dolphin_photo_data_source.dart';
import '../data/datasource/local/buffer_photos.dart';
import '../data/datasource/mockup/unsplash_mockup.dart';
import '../data/datasource/remote/unsplash_api.dart';
import '../data/mapper/photo_mapper.dart';
import '../data/repository/photo_repository.dart';
import '../domain/repository/photo_repository_interface.dart';
import '../domain/usecase/get_dolphin_usecase.dart';
import '../presentation/bloc/photo_bloc.dart';
import 'config_loader.dart';

final locator = GetIt.instance;

void setupLocator(Config config) {
  if(config.isMockupMode) {
    locator.registerLazySingleton<PhotoDataSource>(() => UnsplashMockup());
  } else {
    locator.registerLazySingleton<PhotoDataSource>(() => UnsplashApi(
      baseUrl: config.baseUrl,
      clientId: config.clientId,
    ));
  }
  locator.registerLazySingleton<BufferPhotosDataSource>(() => BufferPhotosDataSourceImpl());
  locator.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(
      photoDataSource: locator<PhotoDataSource>(),
      bufferPhotosDataSource: locator<BufferPhotosDataSource>()
  ));
  locator.registerLazySingleton(
          () => GetDolphinPhotoUseCase(photoRepository: locator<PhotoRepository>()));
  locator.registerLazySingleton(
          () => GetBufferedPhotosUseCase(photoRepository: locator<PhotoRepository>()));
  locator.registerLazySingleton(
      () => PhotoBloc(getDolphinPhotoUseCase: locator<GetDolphinPhotoUseCase>(), getBufferedPhotosUseCase: locator<GetBufferedPhotosUseCase>()));
}
