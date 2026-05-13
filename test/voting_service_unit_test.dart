import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/local_storage.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/persistent_storage_service.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/voting_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
    await Hive.initFlutter();
    await PersistentStorageService.init();
  });

  setUp(() async {
    await VotingService.resetData();
  });

  test('Unit Test Voting: submit vote and prevent duplicate voting', () async {
    try {
      const userId = '1';
      const candidateId = 1;

      final vote = await VotingService.submitVote(userId, candidateId);
      expect(vote.userId, equals(userId));
      expect(vote.candidateId, equals(candidateId));
      expect(await VotingService.hasUserVoted(userId), isTrue);
      expect(await VotingService.getTotalVotes(), equals(1));

      expect(
        VotingService.submitVote(userId, candidateId),
        throwsA(isA<Exception>()),
      );

      print('Unit Test Voting: PASS');
    } catch (e) {
      print('Unit Test Voting: FAIL');
      rethrow;
    }
  });

  test('Unit Test Hitung Suara: hasil vote dihitung dengan benar', () async {
    try {
      const firstUserId = '1';
      const secondUserId = '2';

      await VotingService.submitVote(firstUserId, 1);
      await VotingService.submitVote(secondUserId, 2);

      final results = await VotingService.getVoteResults();
      final totalVotes = await VotingService.getTotalVotes();

      expect(results[1], equals(1));
      expect(results[2], equals(1));
      expect(totalVotes, equals(2));

      print('Unit Test Hitung Suara: PASS');
    } catch (e) {
      print('Unit Test Hitung Suara: FAIL');
      rethrow;
    }
  });
}
