import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:new_app/utils/temporized_function_executor.dart';

import '../../domain/usecase/get_buffered_usecase.dart';
import '../../domain/usecase/get_photo_usecase.dart';
import 'photo_event.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState>
    with TemporizedFunctionExecutor {
  final GetPhotoUseCase _getDolphinPhotoUseCase;
  final GetBufferedPhotosUseCase _getBufferedPhotosUseCase;
  final Duration duration;

  PhotoBloc(
      {required GetPhotoUseCase getDolphinPhotoUseCase,
      required GetBufferedPhotosUseCase getBufferedPhotosUseCase,
      Duration? duration})
      : _getBufferedPhotosUseCase = getBufferedPhotosUseCase,
        _getDolphinPhotoUseCase = getDolphinPhotoUseCase,
        duration = duration ?? const Duration(seconds: 2),
        super(PhotoInitial()) {
    on<StartFetchingPhotos>(_startFetchingPhotos);
    on<StopFetchingPhotos>(_stopFetchingPhotos);
    on<RewindPhotos>(_rewindPhotos);
    on<RewindFinish>(_rewindFinish);
    on<TimerTriggerEvent>(_timeTriggerLoad);
    on<OnErrorEvent>(_onError);
  }

  FutureOr<void> _startFetchingPhotos(
      StartFetchingPhotos event, Emitter<PhotoState> emit) {
    emit(LoadingPhotoState());
    executeTemporizedFunction(duration, () async {
      _getDolphinPhotoUseCase.call().then((photo) {
        add(TimerTriggerEvent(photo));
      }).catchError((error) {
        add(OnErrorEvent(error));
      });
    });
  }

  FutureOr<void> _timeTriggerLoad(
      TimerTriggerEvent event, Emitter<PhotoState> emit) async {
    emit(LoadedPhotoState(event.photo));
  }

  FutureOr<void> _stopFetchingPhotos(
      StopFetchingPhotos event, Emitter<PhotoState> emit) {
    photoTimer?.cancel();
  }

  FutureOr<void> _rewindPhotos(
      RewindPhotos event, Emitter<PhotoState> emit) async {
    emit(LoadingPhotoState());
    final photos = await _getBufferedPhotosUseCase.call();
    final iterator = photos.iterator;

    executeTemporizedFunction(duration, () async {
      if (iterator.moveNext()) {
        add(TimerTriggerEvent(iterator.current));
      } else {
        photoTimer?.cancel();
        add(RewindFinish());
      }
    });
  }

  FutureOr<void> _rewindFinish(RewindFinish event, Emitter<PhotoState> emit) {
    emit(PhotoInitial(message: "Cannot remember any more dolphins"));
  }

  FutureOr<void> _onError(OnErrorEvent event, Emitter<PhotoState> emit) {
    debugPrint(event.error);
    photoTimer?.cancel();
    emit(PhotoError("An error has occurred, please try again"));
  }
}
