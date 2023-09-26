import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  final String baseUrl;
  final String clientId;
  final bool isMockupMode;

  Config({
    required this.isMockupMode,
    required this.baseUrl,
    required this.clientId,
  });
}

Future<Config> loadConfig() async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final configData = json.decode(jsonString);

  return Config(
    isMockupMode: configData['mockup'],
    baseUrl: configData['baseUrl'],
    clientId: configData['clientId'],
  );
}
