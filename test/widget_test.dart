// import entrypoint aplikasi — sesuaikan path jika berbeda
import 'package:booknest/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows splash and navigates to home when Explore pressed', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const BookNestApp()); // pastikan class root memang BookNestApp

    // Splash screen should show "Welcome to BookNest" text
    expect(find.textContaining('Welcome to BookNest', findRichText: true), findsOneWidget);

    // Find the Explore button and tap it
    final exploreButton = find.widgetWithText(ElevatedButton, 'Explore');
    expect(exploreButton, findsOneWidget);

    await tester.tap(exploreButton);
    await tester.pumpAndSettle(); // tunggu navigasi selesai

    // Setelah tekan Explore, halaman Home harus tampil; cek ada teks "Explore" / "BookNest"
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('BookNest'), findsOneWidget);
  });
}
