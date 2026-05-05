import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/config.dart';
import '../services/app_logger.dart';

class SupabaseInit {
  static bool _initialized = false;

  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      final url = AppConfig.instance.supabaseUrl;
      final key = AppConfig.instance.supabaseAnonKey;

      if (url.isNotEmpty && key.isNotEmpty) {
        await Supabase.initialize(url: url, anonKey: key);
        _initialized = true;
        return true;
      } else {
        AppLogger.warning(
          'Supabase init failed: url or key is empty in config.json',
          tag: 'SupabaseInit',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Supabase init failed', tag: 'SupabaseInit', error: e);
      return false;
    }
  }
}
