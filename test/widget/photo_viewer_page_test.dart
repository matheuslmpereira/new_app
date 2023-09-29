import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/features/photo_viewer/presentation/bloc/photo_bloc.dart';
import 'package:new_app/features/photo_viewer/presentation/bloc/photo_event.dart';
import 'package:new_app/features/photo_viewer/presentation/bloc/photo_state.dart';
import 'package:new_app/features/photo_viewer/presentation/pages/photo_viewer_page.dart';

import 'photo_viewer_page_test.mocks.dart';

class MockBlocPhotoBloc extends MockBloc<PhotoEvent, PhotoState>
    implements PhotoBloc {}

@GenerateMocks([PhotoBloc])
void main() {
  group('PhotoViewerPage render', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      final initialState = PhotoInitial();
      final mockPhotoBloc = MockBlocPhotoBloc();
      whenListen(
        mockPhotoBloc,
        Stream.fromIterable([initialState]),
        initialState: initialState,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PhotoBloc>.value(
            value: mockPhotoBloc,
            child: const PhotoViewerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Play'), findsOneWidget);
      expect(find.text('Pause'), findsOneWidget);
      expect(find.text('Rewind'), findsOneWidget);
    });
  });

  group('PhotoViewerPage Listener', () {
    testWidgets('emitting initial state with message',
        (WidgetTester tester) async {
      final initialState = PhotoInitial();
      const snackBarMessage = "snackbarMessage";
      final updatedState = PhotoInitial(message: snackBarMessage);

      final mockPhotoBloc = MockBlocPhotoBloc();
      whenListen(
        mockPhotoBloc,
        Stream.fromIterable([initialState, updatedState]),
        initialState: initialState,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PhotoBloc>.value(
            value: mockPhotoBloc,
            child: const PhotoViewerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(mockPhotoBloc.state, updatedState);
      expect(find.text(snackBarMessage), findsOneWidget);
    });

    testWidgets('emitting exception message', (WidgetTester tester) async {
      final initialState = PhotoInitial();
      const exceptionMessage = "exceptionMessage";
      final updatedState = PhotoError(exceptionMessage);

      final mockPhotoBloc = MockBlocPhotoBloc();
      whenListen(
        mockPhotoBloc,
        Stream.fromIterable([initialState, updatedState]),
        initialState: initialState,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PhotoBloc>.value(
            value: mockPhotoBloc,
            child: const PhotoViewerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(mockPhotoBloc.state, updatedState);
      expect(find.text(exceptionMessage), findsOneWidget);
    });
  });

  group('PhotoViewerPage Actions', () {
    late MockPhotoBloc mockPhotoBloc;
    late StreamController<PhotoState> streamController;

    setUp(() {
      streamController = StreamController<PhotoState>.broadcast();
      mockPhotoBloc = MockPhotoBloc();

      // Stub the stream property of the bloc
      when(mockPhotoBloc.stream).thenAnswer((_) => streamController.stream);

      // Stub the state property of the bloc with an initial state
      when(mockPhotoBloc.state)
          .thenReturn(PhotoInitial()); // Replace with your actual initial state

      // Optionally, emit initial state to the stream
      streamController
          .add(PhotoInitial()); // Replace with your actual initial state
    });

    tearDown(() {
      streamController.close();
      mockPhotoBloc.close();
    });

    testWidgets('on click Play emits StartFetchingPhotos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PhotoBloc>.value(
            value: mockPhotoBloc,
            child: const PhotoViewerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, "Play");
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final capturedEvents = verify(mockPhotoBloc.add(captureAny));
      expect(capturedEvents.captured.first, isA<StartFetchingPhotos>());
    });

    testWidgets('on click Pause emits StopFetchingPhotos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PhotoBloc>.value(
            value: mockPhotoBloc,
            child: const PhotoViewerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, "Pause");
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final capturedEvents = verify(mockPhotoBloc.add(captureAny));
      expect(capturedEvents.captured.first, isA<StopFetchingPhotos>());
    });

    testWidgets('on click Rewind emits StartFetchingPhotos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PhotoBloc>.value(
            value: mockPhotoBloc,
            child: const PhotoViewerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, "Rewind");
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      final capturedEvents = verify(mockPhotoBloc.add(captureAny));
      expect(capturedEvents.captured.first, isA<RewindPhotos>());
    });
  });
}
