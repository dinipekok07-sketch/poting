import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pemilihan_ketua_kelas_informatika/models/candidate_model.dart';

/// Service untuk mengelola persistent storage yang lebih robust
/// Menangani compression dan chunking untuk data besar seperti foto base64
class PersistentStorageService {
  static const String _mainKey = 'candidates_v2';
  static const String _backupKey = 'candidates_backup';
  static const String _metadataKey = 'candidates_metadata';
  static const int _chunkSizeLimit = 800000; // 800KB per chunk untuk safety
  
  static late SharedPreferences _prefs;
  static bool _isInitialized = false;

  /// Initialize storage service
  static Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    debugPrint('[PersistentStorage] Storage initialized');
  }

  /// Save candidates dengan compression dan backup
  static Future<bool> saveCandidates(List<CandidateModel> candidates) async {
    try {
      debugPrint('[PersistentStorage] Saving ${candidates.length} candidates...');
      
      // Convert to JSON
      final jsonList = candidates.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      
      debugPrint('[PersistentStorage] JSON size: ${jsonString.length} bytes');

      // Try to save as-is first
      bool success = await _prefs.setString(_mainKey, jsonString);
      
      if (success) {
        // Save backup
        await _prefs.setString(_backupKey, jsonString);
        
        // Save metadata
        await _prefs.setString(_metadataKey, jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'count': candidates.length,
          'size': jsonString.length,
          'platform': defaultTargetPlatform.toString(),
        }));
        
        debugPrint('[PersistentStorage] ✓ Successfully saved candidates (${jsonString.length} bytes)');
        return true;
      }
      
      // If too large and not web, try to compress photos
      debugPrint('[PersistentStorage] Data too large (${jsonString.length} bytes), attempting chunking...');
      return await _saveChunked(jsonString);
      
    } catch (e) {
      debugPrint('[PersistentStorage] ✗ Error saving candidates: $e');
      // Try one more time with chunking as fallback
      try {
        final jsonList = candidates.map((c) => c.toJson()).toList();
        final jsonString = jsonEncode(jsonList);
        return await _saveChunked(jsonString);
      } catch (e2) {
        debugPrint('[PersistentStorage] ✗ Chunking also failed: $e2');
        return false;
      }
    }
  }

  /// Load candidates dengan fallback ke backup
  static Future<List<CandidateModel>?> loadCandidates() async {
    try {
      debugPrint('[PersistentStorage] Loading candidates...');
      
      // Try main storage first
      String? data = _prefs.getString(_mainKey);
      
      if (data == null) {
        debugPrint('[PersistentStorage] Main storage empty, trying backup...');
        data = _prefs.getString(_backupKey);
      }
      
      if (data == null) {
        debugPrint('[PersistentStorage] No saved data found');
        return null;
      }

      // Check if chunked
      if (data.startsWith('__CHUNKED__')) {
        debugPrint('[PersistentStorage] Loading chunked data...');
        data = await _loadChunked();
        if (data == null) return null;
      }

      final jsonList = jsonDecode(data) as List<dynamic>;
      final candidates = jsonList
          .map((json) => CandidateModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      debugPrint('[PersistentStorage] ✓ Successfully loaded ${candidates.length} candidates');
      return candidates;
      
    } catch (e) {
      debugPrint('[PersistentStorage] ✗ Error loading candidates: $e');
      return null;
    }
  }

  /// Compress candidate photos untuk mengurangi ukuran
  static Future<List<Map<String, dynamic>>> _compressCandidates(
      List<CandidateModel> candidates) async {
    final compressed = <Map<String, dynamic>>[];
    
    for (var candidate in candidates) {
      final candidateJson = candidate.toJson();
      
      // Compress photoUrl1
      if (candidateJson['photoUrl1'] != null) {
        candidateJson['photoUrl1'] = 
            await _compressBase64Image(candidateJson['photoUrl1'] as String);
      }
      
      // Compress photoUrl2
      if (candidateJson['photoUrl2'] != null) {
        candidateJson['photoUrl2'] = 
            await _compressBase64Image(candidateJson['photoUrl2'] as String);
      }
      
      compressed.add(candidateJson);
    }
    
    return compressed;
  }

  /// Compress base64 image dengan quality reduction
  static Future<String> _compressBase64Image(String base64String) async {
    try {
      // Jika bukan base64 (URL), return as-is
      if (!base64String.startsWith('/9j/') && 
          !base64String.startsWith('iVBORw0KGgo') && 
          !base64String.contains('base64')) {
        return base64String;
      }

      // Decode base64
      Uint8List imageBytes;
      try {
        imageBytes = base64Decode(base64String);
      } catch (e) {
        debugPrint('[PersistentStorage] Failed to decode base64: $e');
        return base64String;
      }

      // Decode image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        return base64String;
      }

      // Resize jika terlalu besar
      if (image.width > 600) {
        image = img.copyResize(image, width: 600);
        debugPrint('[PersistentStorage] Resized image to 600px');
      }

      // Encode with lower quality untuk JPEG
      final compressed = img.encodeJpg(image, quality: 70);
      final compressedBase64 = base64Encode(compressed);
      
      final ratio = ((1 - compressedBase64.length / base64String.length) * 100).toStringAsFixed(1);
      debugPrint('[PersistentStorage] Image compressed by $ratio%');
      
      return compressedBase64;
      
    } catch (e) {
      debugPrint('[PersistentStorage] Error compressing image: $e');
      return base64String;
    }
  }

  /// Save data dengan chunking jika terlalu besar
  static Future<bool> _saveChunked(String data) async {
    try {
      final chunks = <String>[];
      for (int i = 0; i < data.length; i += _chunkSizeLimit) {
        chunks.add(data.substring(
          i,
          i + _chunkSizeLimit > data.length ? data.length : i + _chunkSizeLimit,
        ));
      }

      debugPrint('[PersistentStorage] Saving ${chunks.length} chunks...');

      bool success = await _prefs.setString(
        _mainKey,
        '__CHUNKED__:${chunks.length}',
      );

      if (!success) {
        debugPrint('[PersistentStorage] ✗ Failed to save chunk metadata');
        return false;
      }

      // Save each chunk
      for (int i = 0; i < chunks.length; i++) {
        success = await _prefs.setString('candidates_chunk_$i', chunks[i]);
        if (!success) {
          debugPrint('[PersistentStorage] ✗ Failed to save chunk $i');
          return false;
        }
      }

      debugPrint('[PersistentStorage] ✓ Successfully saved ${chunks.length} chunks');
      return true;
      
    } catch (e) {
      debugPrint('[PersistentStorage] ✗ Error in chunking: $e');
      return false;
    }
  }

  /// Load chunked data
  static Future<String?> _loadChunked() async {
    try {
      final metadata = _prefs.getString(_mainKey);
      if (metadata == null) return null;

      final parts = metadata.split(':');
      if (parts.length < 2) return null;

      final chunkCount = int.parse(parts[1]);
      debugPrint('[PersistentStorage] Loading $chunkCount chunks...');

      final chunks = <String>[];
      for (int i = 0; i < chunkCount; i++) {
        final chunk = _prefs.getString('candidates_chunk_$i');
        if (chunk == null) {
          debugPrint('[PersistentStorage] ✗ Missing chunk $i');
          return null;
        }
        chunks.add(chunk);
      }

      final data = chunks.join();
      debugPrint('[PersistentStorage] ✓ Successfully loaded all chunks');
      return data;
      
    } catch (e) {
      debugPrint('[PersistentStorage] ✗ Error loading chunks: $e');
      return null;
    }
  }

  /// Get storage info untuk debugging
  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final metadata = _prefs.getString(_metadataKey);
      final mainSize = _prefs.getString(_mainKey)?.length ?? 0;
      final backupSize = _prefs.getString(_backupKey)?.length ?? 0;
      
      return {
        'hasMainStorage': _prefs.containsKey(_mainKey),
        'hasBackup': _prefs.containsKey(_backupKey),
        'mainSize': mainSize,
        'backupSize': backupSize,
        'metadata': metadata != null ? jsonDecode(metadata) : null,
        'isChunked': _prefs.getString(_mainKey)?.startsWith('__CHUNKED__') ?? false,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Clear all candidate data
  static Future<bool> clearCandidates() async {
    try {
      // Clear main and backup
      await _prefs.remove(_mainKey);
      await _prefs.remove(_backupKey);
      await _prefs.remove(_metadataKey);

      // Clear chunks if any
      final allKeys = _prefs.getKeys();
      for (final key in allKeys) {
        if (key.startsWith('candidates_chunk_')) {
          await _prefs.remove(key);
        }
      }

      debugPrint('[PersistentStorage] ✓ Cleared all candidate data');
      return true;
    } catch (e) {
      debugPrint('[PersistentStorage] ✗ Error clearing data: $e');
      return false;
    }
  }
}
