import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/usecase/get_buffered_usecase.dart';
import '../../domain/usecase/get_photo_usecase.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetPhotoUseCase _getDolphinPhotoUseCase;
  final GetBufferedPhotosUseCase _getBufferedPhotosUseCase;
  final duration = const Duration(seconds: 2);
  Timer? _photoTimer;

  PhotoBloc(
      {required GetPhotoUseCase getDolphinPhotoUseCase,
      required GetBufferedPhotosUseCase getBufferedPhotosUseCase})
      : _getBufferedPhotosUseCase = getBufferedPhotosUseCase,
        _getDolphinPhotoUseCase = getDolphinPhotoUseCase,
        super(PhotoInitial()) {
    on<StartFetchingPhotos>(_startFetchingPhotos);
    on<TimerTriggerEvent>(_timeTriggerLoad);
    on<StopFetchingPhotos>(_stopFetchingPhotos);
    on<RewindPhotos>(_rewindPhotos);
    on<RewindFinish>(_rewindFinish);
  }

  FutureOr<void> _startFetchingPhotos(
      StartFetchingPhotos event, Emitter<PhotoState> emit) {
    _executeTemporizedFunction(() async {
      final photo = await _getDolphinPhotoUseCase.call();
      add(TimerTriggerEvent(photo));
    });
    emit(LoadingPhotoState());
  }

  FutureOr<void> _timeTriggerLoad(
      TimerTriggerEvent event, Emitter<PhotoState> emit) async {
    emit(LoadedPhotoState(event.photo));
  }

  FutureOr<void> _stopFetchingPhotos(
      StopFetchingPhotos event, Emitter<PhotoState> emit) {
    _photoTimer?.cancel();
  }

  FutureOr<void> _rewindPhotos(
      RewindPhotos event, Emitter<PhotoState> emit) async {
    final photos = await _getBufferedPhotosUseCase.call();
    final iterator = photos.iterator;

    _executeTemporizedFunction(() async {
      if (iterator.moveNext()) {
        add(TimerTriggerEvent(iterator.current));
      } else {
        _photoTimer?.cancel();
        add(RewindFinish());
      }
    });
  }

  FutureOr<void> _rewindFinish(RewindFinish event, Emitter<PhotoState> emit) {
    emit(PhotoInitial(message: "Cannot remember any more dolphins"));
  }

  void _executeTemporizedFunction(void Function() action) {
    _photoTimer?.cancel();

    // Call the action immediately
    action();

    // Then set up the Timer for subsequent calls
    _photoTimer = Timer.periodic(duration, (timer) {
      action();
    });
  }
}
