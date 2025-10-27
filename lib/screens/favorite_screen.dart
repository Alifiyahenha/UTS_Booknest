import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';
import '../services/data_service.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = DataService.instance;
    final favs = ds.getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerita Favorit'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: favs.isEmpty
          ? const Center(child: Text('Belum ada cerita favorit.'))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (_, i) {
                final s = favs[i];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(s.gambar,
                        width: 56, height: 72, fit: BoxFit.cover),
                  ),
                  title: Text(s.judul),
                  subtitle: Text(s.kategori),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(story: s)),
                  ),
                );
              },
            ),
    );
  }
}
