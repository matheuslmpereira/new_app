import '../../domain/entity/photo.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {
  final String? message;
  PhotoInitial({this.message});
}

class LoadingPhotoState extends PhotoState {}

class LoadedPhotoState extends PhotoState {
  final Photo photo;
  LoadedPhotoState(this.photo);
}

class PhotoError extends PhotoState {
  final String error;
  PhotoError(this.error);
}
