import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineCacheService {
  static const String _complaintsKey = 'offline_complaints';
  static const String _languageKey = 'app_language';

  static Future<void> saveComplaintLocally(Map<String, dynamic> complaintJson) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_complaintsKey) ?? [];
    existing.add(jsonEncode(complaintJson));
    await prefs.setStringList(_complaintsKey, existing);
  }

  static Future<List<Map<String, dynamic>>> getLocalComplaints() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_complaintsKey) ?? [];
    return existing.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  static Future<void> saveLanguagePreference(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, langCode);
  }

  static Future<String> getLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'hi';
  }
}
