class Story {
  final int id;
  final String judul;
  final String kategori;
  final String asal;       // ditambahkan
  final String ringkasan;  // ditambahkan
  final String gambar;
  final String isi;

  Story({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.asal,
    required this.ringkasan,
    required this.gambar,
    required this.isi,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      asal: json['asal'] ?? '',          // bisa kosong kalau di JSON belum ada
      ringkasan: json['ringkasan'] ?? '',// bisa kosong juga
      gambar: json['gambar'] ?? '',
      isi: json['isi'] ?? '',
    );
  }
}
