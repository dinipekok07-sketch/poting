class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.ketua-kelas-informatika.example.com';
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Theme Colors
  static const String primaryColor = '#1A365D';
  static const String secondaryColor = '#3182CE';
  static const String accentColor = '#F6E05E';
  static const String errorColor = '#E74C3C';
  static const String successColor = '#27AE60';

  // Storage Keys
  static const String userKey = 'user';
  static const String tokenKey = 'token';
  static const String hasVotedKey = 'has_voted';
  static const String darkModeKey = 'dark_mode';
  static const String votedCandidateKey = 'voted_candidate';

  // Dummy Data NIM & Password
  static const List<String> dummyNIM = ['20241001', '20241002'];
  static const List<String> dummyPassword = ['123456', '123456'];

  // Messages
  static const String loginSuccess = 'Login berhasil';
  static const String loginFailed = 'Login gagal';
  static const String invalidCredentials = 'NIM atau password salah';
  static const String networkError = 'Terjadi kesalahan jaringan';
  static const String voteSuccess = 'Vote berhasil disimpan';
  static const String alreadyVoted = 'Anda sudah melakukan voting sebelumnya';
  static const String logoutSuccess = 'Logout berhasil';

  // Durations
  static const int animationDuration = 300;
  static const int splashScreenDuration = 3;
}
