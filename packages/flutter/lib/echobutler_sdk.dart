/// EchoButler SDK for Flutter.
///
/// Embed mood intelligence, Stellar payments, and social wellness
/// into any Flutter app in minutes.
///
/// ```dart
/// import 'package:echobutler_sdk/echobutler_sdk.dart';
///
/// void main() async {
///   await EchoButler.initialize(apiKey: 'your_api_key');
///   runApp(const MyApp());
/// }
/// ```
library echobutler_sdk;

export 'src/echo_butler.dart';
export 'src/mood/mood_client.dart';
export 'src/mood/mood_models.dart';
export 'src/stellar/stellar_client.dart';
export 'src/stellar/stellar_models.dart';
export 'src/social/social_client.dart';
export 'src/social/social_models.dart';
export 'src/errors.dart';
