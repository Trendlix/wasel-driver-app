// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY')
  static final String googleMapsApiKey = _Env.googleMapsApiKey;
}
