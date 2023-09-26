import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:new_app/presentation/bloc/photo_event.dart';
import 'package:new_app/presentation/bloc/photo_state.dart';

import '../../domain/usecase/get_dolphin_buffered_usecase.dart';
import '../../domain/usecase/get_dolphin_usecase.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetDolphinPhotoUseCase _getDolphinPhotoUseCase;
  final GetBufferedPhotosUseCase _getBufferedPhotosUseCase;
  final duration = const Duration(seconds: 2);
  Timer? _photoTimer;

  PhotoBloc(
      {required GetDolphinPhotoUseCase getDolphinPhotoUseCase,
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
    try {
      _photoTimer = Timer.periodic(duration, (timer) async {
        final photo = await _getDolphinPhotoUseCase.call();
        add(TimerTriggerEvent(photo));
      });
      emit(LoadingPhotoState());
    } catch (error) {
      emit(PhotoError(error.toString()));
    }
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
    _photoTimer?.cancel();
    final photos = await _getBufferedPhotosUseCase.call();
    final iterator = photos.iterator;
    _photoTimer = Timer.periodic(duration, (timer) async {
      if(iterator.moveNext()) {
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
}
