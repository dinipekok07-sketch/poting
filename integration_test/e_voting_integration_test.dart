import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pemilihan_ketua_kelas_informatika/main.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/local_storage.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/persistent_storage_service.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/voting_service.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/auth_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await LocalStorage.init();
    await Hive.initFlutter();
    await PersistentStorageService.init();
    await VotingService.resetData();
  });

  testWidgets('Integration Test E-Voting: Input pemilih -> voting -> hasil akhir',
      (WidgetTester tester) async {
    try {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), AuthService.dummyNIM.first);
      await tester.enterText(find.byType(TextFormField).at(1), AuthService.defaultPassword);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Dashboard'), findsOneWidget);

      await tester.tap(find.text('Vote Sekarang'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pilih Kandidat').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit Vote'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yakin'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Lihat Hasil'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Hasil Voting'), findsOneWidget);
      print('Integration Test E-Voting: PASS');
    } catch (e) {
      print('Integration Test E-Voting: FAIL');
      rethrow;
    }
  });
}
