import 'dart:convert';
import 'dart:io';

class Config {
  final String baseUrl;
  final String clientId;

  Config({
    required this.baseUrl,
    required this.clientId,
  });
}

Future<Config> loadConfig() async {
  final configFile = File('path_to_config_file/config.json');

  if (!await configFile.exists()) {
    throw Exception('Config file not found!');
  }

  final configData = json.decode(await configFile.readAsString());

  return Config(
    baseUrl: configData['baseUrl'],
    clientId: configData['clientId'],
  );
}
