import 'package:http/http.dart' as http;
import 'mood/mood_client.dart';
import 'stellar/stellar_client.dart';
import 'social/social_client.dart';

/// Main entry point for the EchoButler SDK.
///
/// Call [EchoButler.initialize] once at app startup, then access
/// sub-clients via [EchoButler.mood], [EchoButler.stellar], etc.
class EchoButler {
  EchoButler._();

  static EchoButler? _instance;

  late final MoodClient mood;
  late final StellarClient stellar;
  late final SocialClient social;

  static EchoButler get instance {
    assert(_instance != null, 'Call EchoButler.initialize() first.');
    return _instance!;
  }

  /// Initialize the SDK. Call once in main() before runApp().
  ///
  /// ```dart
  /// await EchoButler.initialize(
  ///   apiKey: 'your_api_key',
  ///   network: StellarNetwork.testnet,
  /// );
  /// ```
  static Future<void> initialize({
    required String apiKey,
    String baseUrl = 'https://api.echobutler.dev/v1',
    StellarNetwork network = StellarNetwork.mainnet,
    http.Client? httpClient,
  }) async {
    final client = httpClient ?? http.Client();
    final config = _SDKConfig(
      apiKey: apiKey,
      baseUrl: baseUrl,
      network: network,
      httpClient: client,
    );

    _instance = EchoButler._()
      ..mood = MoodClient(config)
      ..stellar = StellarClient(config)
      ..social = SocialClient(config);
  }

  /// Set the auth token for authenticated API calls.
  void setAuthToken(String? token) {
    mood.config.authToken = token;
    stellar.config.authToken = token;
    social.config.authToken = token;
  }
}

enum StellarNetwork { mainnet, testnet }

class _SDKConfig {
  final String apiKey;
  final String baseUrl;
  final StellarNetwork network;
  final http.Client httpClient;
  String? authToken;

  _SDKConfig({
    required this.apiKey,
    required this.baseUrl,
    required this.network,
    required this.httpClient,
  });
}

// Make config accessible to sub-clients
typedef SDKConfig = _SDKConfig;
