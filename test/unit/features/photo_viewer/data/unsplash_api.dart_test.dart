import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:new_app/features/photo_viewer/data/datasource/remote/unsplash_api.dart';
import 'package:new_app/features/photo_viewer/data/model/photo_model.dart';
import 'package:test/test.dart';
import 'unsplash_api.dart_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late UnsplashApi unsplashApi;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    unsplashApi = UnsplashApi(
      baseUrl: 'https://api.unsplash.com',
      clientId: 'your_client_id',
      httpClient: mockHttpClient,
    );
  });

  test('returns a PhotoModel when the http call completes successfully', () async {
    const jsonPhoto = {
      "id": "hKURiUaSGsc",
      "urls": {
        "small": "small_url",
      },
      "description": "a group of dolphins swimming over a coral reef"
    };

    when(mockHttpClient.get(any))
        .thenAnswer((_) async => http.Response(jsonEncode(jsonPhoto), 200));

    expect(await unsplashApi.getPhoto(), isA<PhotoModel>());
  });

  test('throws an exception when the http call completes with an error', () async {
    when(mockHttpClient.get(any))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    expect(unsplashApi.getPhoto(), throwsA(isA<Exception>()));
  });
}
