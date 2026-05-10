import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pemilihan_ketua_kelas_informatika/models/voting_session_model.dart';

class ScheduleProvider extends ChangeNotifier {
  VotingSessionModel? _currentSession;
  bool _isLoading = false;
  String? _errorMessage;

  VotingSessionModel? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ScheduleProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = prefs.getString('voting_session');
      if (sessionData != null) {
        _currentSession = VotingSessionModel.fromJson(jsonDecode(sessionData));
      } else {
        // Default session
        _currentSession = VotingSessionModel(
          id: 1,
          title: 'Pemilihan Ketua Kelas Informatika 4A',
          description: 'Pemilihan ketua kelas untuk periode 2024',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          isActive: false,
          totalVotes: 0,
        );
        await _saveSession();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSession({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) async {
    if (_currentSession == null) return;

    _currentSession = _currentSession!.copyWith(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
    );

    await _saveSession();
    notifyListeners();
  }

  Future<void> _saveSession() async {
    if (_currentSession != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('voting_session', jsonEncode(_currentSession!.toJson()));
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
