import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config_loader.dart';
import 'core/service_locator.dart';
import 'features/photo_viewer/presentation/bloc/photo_bloc.dart';
import 'features/photo_viewer/presentation/pages/photo_viewer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await loadConfig();

  setupLocator(config);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider(
        create: (context) => locator<PhotoBloc>(),
        child: const PhotoViewerPage(),
      ),
    );
  }
}
