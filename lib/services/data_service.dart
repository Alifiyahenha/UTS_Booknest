import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/story.dart';

class DataService {
  DataService._privateConstructor();
  static final DataService instance = DataService._privateConstructor();

  List<Story> stories = [];
  final ValueNotifier<Set<int>> favorites = ValueNotifier({});
  final ValueNotifier<bool> isDark = ValueNotifier(false);
  final ValueNotifier<double> fontSize = ValueNotifier(16.0);
  final ValueNotifier<String> username = ValueNotifier('Ayu Pramesti');

  Future<void> loadStories() async {
    try {
      final raw = await rootBundle.loadString('assets/cerita.json');
      final List parsed = jsonDecode(raw);
      stories = parsed.map((e) => Story.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading stories: $e');
      stories = [];
    }
  }

  // 🔹 Ambil semua data preferensi pengguna
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'Ayu Pramesti';
    isDark.value = prefs.getBool('isDark') ?? false;
    fontSize.value = prefs.getDouble('fontSize') ?? 16.0;
    final favList = prefs.getStringList('favorites') ?? [];
    favorites.value = favList.map(int.parse).toSet();
  }

  // 🔹 Simpan perubahan ke SharedPreferences
  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username.value);
    await prefs.setBool('isDark', isDark.value);
    await prefs.setDouble('fontSize', fontSize.value);
    await prefs.setStringList(
      'favorites',
      favorites.value.map((id) => id.toString()).toList(),
    );
  }

  // 🔹 Update nama dan simpan otomatis
  void updateUsername(String newName) {
    username.value = newName;
    savePreferences();
  }

  // 🔹 Mode & ukuran teks disimpan otomatis saat berubah
  void setDarkMode(bool value) {
    isDark.value = value;
    savePreferences();
  }

  void setFontSize(double value) {
    fontSize.value = value;
    savePreferences();
  }

  // ===================== Cerita & Favorit =====================

  List<Story> storiesByCategory(String category) {
    return stories
        .where((s) => s.kategori.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<Story> getForYouStories([int count = 5]) {
    if (stories.isEmpty) return [];
    final shuffled = [...stories]..shuffle();
    return shuffled.take(count).toList();
  }

  List<Story> getPopularStories([int count = 5]) {
    if (stories.isEmpty) return [];
    final sorted = [...stories];
    sorted.sort((a, b) {
      final aFav = favorites.value.contains(a.id);
      final bFav = favorites.value.contains(b.id);
      return (bFav ? 1 : 0).compareTo(aFav ? 1 : 0);
    });
    return sorted.take(count).toList();
  }

  List<Story> getRandomStories([int count = 5]) {
    if (stories.isEmpty) return [];
    final shuffled = [...stories]..shuffle();
    return shuffled.take(count).toList();
  }

  List<Story> getFavorites() =>
      stories.where((s) => favorites.value.contains(s.id)).toList();

  void toggleFavorite(int id) {
    final current = favorites.value;
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    favorites.value = {...current};
    savePreferences(); // simpan perubahan favorit
  }

  bool isFavorite(int id) => favorites.value.contains(id);
}
