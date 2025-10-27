import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';
import '../services/data_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ds = DataService.instance;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ds.username.value);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favs = ds.getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFF174EA6),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🔹 Mode Gelap
            ValueListenableBuilder<bool>(
              valueListenable: ds.isDark,
              builder: (_, dark, __) => SwitchListTile(
                title: const Text('Mode Gelap'),
                value: dark,
                activeColor: const Color(0xFF174EA6),
                onChanged: (v) => ds.setDarkMode(v),
              ),
            ),

            // 🔹 Ukuran Teks
            ValueListenableBuilder<double>(
              valueListenable: ds.fontSize,
              builder: (_, fs, __) => ListTile(
                title: const Text('Ukuran Teks'),
                subtitle: Slider(
                  min: 12,
                  max: 24,
                  divisions: 6,
                  activeColor: const Color(0xFF174EA6),
                  value: fs,
                  onChanged: (v) => ds.setFontSize(v),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.black54),
              title: const Text(
                'Favorit Saya',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Favorit Saya'),
                      backgroundColor: const Color(0xFF174EA6),
                      foregroundColor: Colors.white,
                    ),
                    body: favs.isEmpty
                        ? const Center(child: Text('Belum ada cerita favorit'))
                        : ListView.builder(
                            itemCount: favs.length,
                            itemBuilder: (_, i) {
                              final s = favs[i];
                              return ListTile(
                                leading: Image.asset(
                                  s.gambar,
                                  width: 56,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(s.judul),
                                subtitle: Text(s.kategori),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(story: s),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  ds.updateUsername(newName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perubahan disimpan!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF174EA6),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
