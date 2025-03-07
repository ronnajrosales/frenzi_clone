import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _openCountKey = 'previous_trips_open_count';

  // Increment and return new count
  static Future<int> incrementPreviousTripsOpenCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt(_openCountKey) ?? 0;
      final newCount = currentCount + 1;
      await prefs.setInt(_openCountKey, newCount);
      return newCount;
    } catch (e) {
      print('Error incrementing open count: $e');
      return 0;
    }
  }

  // Get current count
  static Future<int> getPreviousTripsOpenCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_openCountKey) ?? 0;
    } catch (e) {
      print('Error getting open count: $e');
      return 0;
    }
  }

  // Reset count
  static Future<void> resetPreviousTripsOpenCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_openCountKey, 0);
    } catch (e) {
      print('Error resetting open count: $e');
    }
  }
} 