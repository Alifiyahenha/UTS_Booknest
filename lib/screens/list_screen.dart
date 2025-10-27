import 'package:flutter/material.dart';

import '../models/story.dart';
import 'detail_screen.dart';

class ListScreen extends StatelessWidget {
  final String title;
  final List<Story> stories;
  const ListScreen({super.key, required this.title, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
          itemCount: stories.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (ctx, i){
            final s = stories[i];
            return ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(s.gambar, width: 56, height: 72, fit: BoxFit.cover)),
              title: Text(s.judul),
              subtitle: Text('${s.asal} • ${s.kategori}'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(story: s))),
            );
          },
        ),
      ),
    );
  }
}
