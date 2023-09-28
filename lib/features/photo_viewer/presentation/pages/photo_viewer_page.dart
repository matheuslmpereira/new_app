import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/photo_bloc.dart';
import '../bloc/photo_event.dart';
import '../bloc/photo_state.dart';
import '../widget/photo_widget.dart';

class PhotoViewerPage extends StatelessWidget {
  const PhotoViewerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dolphin Photos'),
      ),
      body: BlocConsumer<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state is PhotoInitial && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
          if (state is PhotoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: PhotoWidget(imageUrl: state is LoadedPhotoState ? state.photo.url : null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 64.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.read<PhotoBloc>().add(StartFetchingPhotos()),
                        child: const Text('Play'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.read<PhotoBloc>().add(StopFetchingPhotos()),
                        child: const Text('Pause'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.read<PhotoBloc>().add(RewindPhotos()),
                        child: const Text('Rewind'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
