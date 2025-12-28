import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SearchLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearch(String query);
  Future<void> deleteSearch(String query);
  Future<void> clearHistory();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _historyKey = 'SEARCH_HISTORY';
  static const int _maxHistoryItems = 10;

  final SharedPreferences sharedPreferences;

  SearchLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getSearchHistory() async {
    final historyJson = sharedPreferences.getString(_historyKey);
    if (historyJson == null) return [];

    final List<dynamic> decoded = json.decode(historyJson);
    return decoded.map((e) => e.toString()).toList();
  }

  @override
  Future<void> saveSearch(String query) async {
    if (query.trim().isEmpty) return;

    final history = await getSearchHistory();

    // Remove if already exists (to move to top)
    history.remove(query);

    // Add to beginning
    history.insert(0, query);

    // Keep only last N items
    final trimmed = history.take(_maxHistoryItems).toList();

    await sharedPreferences.setString(_historyKey, json.encode(trimmed));
  }

  @override
  Future<void> deleteSearch(String query) async {
    final history = await getSearchHistory();
    history.remove(query);
    await sharedPreferences.setString(_historyKey, json.encode(history));
  }

  @override
  Future<void> clearHistory() async {
    await sharedPreferences.remove(_historyKey);
  }
}
