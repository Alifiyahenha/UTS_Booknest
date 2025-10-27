import 'package:flutter/material.dart';

import '../models/story.dart';
import '../services/data_service.dart';

class ReadScreen extends StatefulWidget {
  final Story story;
  const ReadScreen({Key? key, required this.story}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final ds = DataService.instance;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          story.judul,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ValueListenableBuilder<double>(
        valueListenable: ds.fontSize,
        builder: (context, fontSize, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: ds.isDark,
            builder: (context, isDark, _) {
              return Container(
                color: isDark ? Colors.grey[900] : Colors.white,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Gambar utama
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        story.gambar,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Judul & kategori
                    Text(
                      story.judul,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.category, size: 16, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          story.kategori,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Isi cerita
                    Text(
                      story.isi,
                      style: TextStyle(
                        fontSize: fontSize,
                        height: 1.6,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          );
        },
      ),

      // Tombol pengaturan tampilan
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptions(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.text_fields),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final ds = DataService.instance;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan Tampilan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Mode gelap / terang
              ValueListenableBuilder<bool>(
                valueListenable: ds.isDark,
                builder: (context, isDark, _) {
                  return SwitchListTile(
                    title: const Text('Mode Gelap'),
                    value: isDark,
                    onChanged: (val) => ds.isDark.value = val,
                  );
                },
              ),

              // Ukuran font
              const SizedBox(height: 10),
              ValueListenableBuilder<double>(
                valueListenable: ds.fontSize,
                builder: (context, size, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ukuran Teks'),
                      Slider(
                        min: 12,
                        max: 24,
                        divisions: 6,
                        value: size,
                        label: size.toStringAsFixed(0),
                        onChanged: (val) => ds.fontSize.value = val,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
