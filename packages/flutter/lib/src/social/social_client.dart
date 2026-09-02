import 'dart:convert';
import '../echo_butler.dart';
import 'social_models.dart';
import '../errors.dart';

class SocialClient {
  final SDKConfig config;

  SocialClient(this.config);

  Map<String, String> get _headers => {
        'x-api-key': config.apiKey,
        'x-echobutler-network': config.network.name,
        if (config.authToken != null)
          'authorization': 'Bearer ${config.authToken}',
      };

  /// Get the global mood feed — anonymized entries from across the EchoButler network.
  Future<List<GlobalFeedEntry>> getGlobalFeed({int limit = 50}) async {
    final res = await config.httpClient.get(
      Uri.parse('${config.baseUrl}/social/feed?limit=$limit'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw EchoButlerError('HTTP ${res.statusCode}');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['entries'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(GlobalFeedEntry.fromJson)
        .toList();
  }

  /// Get the weekly leaderboard.
  Future<List<LeaderboardEntry>> getLeaderboard({int limit = 100}) async {
    final res = await config.httpClient.get(
      Uri.parse('${config.baseUrl}/social/leaderboard?limit=$limit'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw EchoButlerError('HTTP ${res.statusCode}');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return (body['entries'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(LeaderboardEntry.fromJson)
        .toList();
  }
}
