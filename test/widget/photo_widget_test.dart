import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_app/features/photo_viewer/presentation/widget/photo_widget.dart';

void main() {
  testWidgets('PhotoWidget displays image from network when imageUrl is provided', (WidgetTester tester) async {
    const imageUrl = 'https://example.com/my-image.jpg';

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PhotoWidget(imageUrl: imageUrl),
      ),
    ));

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('PhotoWidget displays placeholder image when imageUrl is null', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PhotoWidget(),
      ),
    ));

    expect(find.byType(Image), findsOneWidget);
  });
}
