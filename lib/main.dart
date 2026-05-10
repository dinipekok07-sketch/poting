import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pemilihan_ketua_kelas_informatika/config/app_config.dart';
import 'package:pemilihan_ketua_kelas_informatika/config/routes.dart';
import 'package:pemilihan_ketua_kelas_informatika/config/themes.dart';
import 'package:pemilihan_ketua_kelas_informatika/providers/auth_provider.dart';
import 'package:pemilihan_ketua_kelas_informatika/providers/candidate_provider.dart';
import 'package:pemilihan_ketua_kelas_informatika/providers/schedule_provider.dart';
import 'package:pemilihan_ketua_kelas_informatika/providers/theme_provider.dart';
import 'package:pemilihan_ketua_kelas_informatika/providers/vote_provider.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/local_storage.dart';
import 'package:pemilihan_ketua_kelas_informatika/services/persistent_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  // Initialize local storage
  await LocalStorage.init();
  
  // Initialize persistent storage service (more robust for web)
  await PersistentStorageService.init();

  // Preload candidates data to ensure persistence
  final candidateProvider = CandidateProvider();
  await candidateProvider.preloadCandidates();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CandidateProvider()),
        ChangeNotifierProvider(create: (_) => VoteProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme(),
            darkTheme: AppThemes.darkTheme(),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routes: AppRoutes.getRoutes(),
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}

