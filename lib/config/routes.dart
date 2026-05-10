import 'package:flutter/material.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/splash_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/login_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/home_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/candidate_list_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/voting_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/result_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/profile_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/admin_dashboard_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/manage_candidates_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/manage_voters_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/manage_schedule_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/data_recovery_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/manage_voting_students_screen.dart';
import 'package:pemilihan_ketua_kelas_informatika/screens/admin/manage_votes_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String candidateList = '/candidate-list';
  static const String voting = '/voting';
  static const String result = '/result';
  static const String profile = '/profile';
  static const String adminDashboard = '/admin-dashboard';
  static const String manageCandidates = '/manage-candidates';
  static const String manageVoters = '/manage-voters';
  static const String manageSchedule = '/manage-schedule';
  static const String reports = '/reports';
  static const String dataRecovery = '/data-recovery';
  static const String manageVotingStudents = '/manage-voting-students';
  static const String manageVotes = '/manage-votes';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      candidateList: (context) => const CandidateListScreen(),
      voting: (context) => const VotingScreen(),
      result: (context) => const ResultScreen(),
      profile: (context) => const ProfileScreen(),
      adminDashboard: (context) => const AdminDashboardScreen(),
      manageCandidates: (context) => const ManageCandidatesScreen(),
      manageVoters: (context) => const ManageVotersScreen(),
      manageSchedule: (context) => const ManageScheduleScreen(),
      // reports: (context) => const ReportsScreen(), // TODO: Implement ReportsScreen
      dataRecovery: (context) => const DataRecoveryScreen(),
      manageVotingStudents: (context) => const ManageVotingStudentsScreen(),
      manageVotes: (context) => const ManageVotesScreen(),
    };
  }

  static String getInitialRoute(bool isLoggedIn) {
    return isLoggedIn ? home : login;
  }
}

