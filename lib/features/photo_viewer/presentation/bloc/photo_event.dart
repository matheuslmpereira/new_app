import '../../domain/entity/photo.dart';

abstract class PhotoEvent {}

class StartFetchingPhotos extends PhotoEvent {}

class StopFetchingPhotos extends PhotoEvent {}

class RewindPhotos extends PhotoEvent {}

class TimerTriggerEvent extends PhotoEvent {
  final Photo photo;
  TimerTriggerEvent(this.photo);
}

class RewindFinish extends PhotoEvent {}