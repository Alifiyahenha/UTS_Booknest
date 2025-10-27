import 'package:flutter/material.dart';

import '../models/story.dart';
import '../services/data_service.dart';
import '../widgets/story_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ds = DataService.instance;
  bool _isLoading = true;

  // 🔍 kontrol search dan kategori
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    await ds.loadStories();
    setState(() {
      _isLoading = false;
    });
  }

  List<Story> get _filteredStories {
    var list = ds.stories;

    // filter kategori
    if (_selectedCategory != 'Semua') {
      list = list
          .where((s) => s.kategori.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // filter pencarian
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((s) =>
              s.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.asal.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.kategori.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final allStories = _filteredStories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookNest', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explore', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const Text('BookNest', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),

                  // 🔍 Search bar responsif
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Cari Kisah Inspiratif...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 🏷️ kategori filter
                  _buildCategoryChips(),
                  const SizedBox(height: 24),

                  // jika search aktif / kategori bukan "Semua"
                  if (_searchQuery.isNotEmpty || _selectedCategory != 'Semua') ...[
                    _buildSectionTitle('Hasil Pencarian'),
                    _buildStoryList(allStories),
                  ] else ...[
                    _buildSectionTitle('🔥 Cerita Populer'),
                    _buildStoryList(ds.getPopularStories()),
                    const SizedBox(height: 24),
                    _buildSectionTitle('✨ Rekomendasi Untuk Anda'),
                    _buildStoryList(ds.getRandomStories()),
                    const SizedBox(height: 24),
                    _buildSectionTitle('📖 Untuk Anda'),
                    _buildStoryList(ds.getForYouStories()),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/category');
              break;
            case 2:
              Navigator.pushNamed(context, '/favorites');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['Semua', 'Legenda', 'Dongeng', 'Fabel', 'Cerita Moral'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            selectedColor: Colors.blue.shade100,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStoryList(List<Story> stories) {
    if (stories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('Tidak ada cerita ditemukan.'),
      );
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StoryCard(story: story),
          );
        },
      ),
    );
  }
}
