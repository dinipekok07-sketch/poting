# Dokumentasi: Persistent Photo Storage untuk Admin

**Tanggal Update**: May 10, 2026  
**Status**: ✅ COMPLETED & TESTED

## 🎯 Tujuan
Memastikan foto kandidat yang diupdate admin **TETAP PERMANEN** bahkan setelah membuka web ulang.

## 📋 Masalah Lama
- Foto kandidat yang diupdate admin hilang saat reload web
- Tidak ada backup mechanism
- Storage terbatas untuk base64 images

## ✨ Solusi Baru

### Fitur-Fitur Utama

#### 1. **Smart Image Compression**
```
Foto Asli (2MB)
    ↓
Auto-resize to 600px + Quality 70 JPEG
    ↓
Compressed (~400-600KB)
    ↓
Base64 Encoded (~600KB-900KB)
    ↓
Saved to Storage ✓
```
- Otomatis mengecilkan foto jika > 600px
- JPEG quality 70 = cukup untuk thumbnail
- Hemat ruang hingga 60-70%

#### 2. **Intelligent Data Chunking**
Jika data masih terlalu besar setelah compression:
```
Large Data (>800KB)
    ↓
Split ke Multiple Chunks (max 800KB per chunk)
    ↓
Simpan ke:
  - candidates_chunk_0
  - candidates_chunk_1
  - candidates_chunk_2
    ↓
Load & Reconstruct otomatis ✓
```

#### 3. **Dual Backup Storage**
```
Main Storage: candidates_v2
    ↓
[✓ Automatic Backup to candidates_backup]
```
- Jika data corrupt, backup otomatis tersedia
- Metadata tersimpan di candidates_metadata

#### 4. **Robust Error Handling**
```
Save Attempt 1: Normal Storage
    ↓ (Gagal jika terlalu besar)
Save Attempt 2: After Compression
    ↓ (Gagal jika masih besar)
Save Attempt 3: With Chunking
    ↓ (Gagal jarang)
Final Fallback: LocalStorage (old format)
```

## 🔧 Cara Kerja

### Saat Admin Update Foto Kandidat:

1. **Upload Foto**
   - Admin pilih foto dari galeri/kamera
   - Preview ditampilkan

2. **Edit Data**
   - Admin ubah nama, visi, misi, dll
   - Foto di-convert ke Base64 string

3. **Save ke Database**
   ```
   CandidateModel(
     id: 123,
     name1: "Zaharani Putri",
     name2: "Dini Aprilianti",
     photoUrl1: "/9j/4AAQSkZJRg...",  ← Base64 foto
     photoUrl2: "/9j/4AAQSkZJRg...",  ← Base64 foto
     visionUrl: "...",
   )
   ```

4. **Automatic Storage Process**
   ```
   updateCandidate(candidate)
       ↓
   VotingService._saveCandidates()
       ↓
   PersistentStorageService.saveCandidates()
       ├─ Compress foto if needed
       ├─ Chunk data if too large
       ├─ Save main + backup
       └─ Log ke console ✓
   ```

5. **Visual Feedback**
   - SnackBar muncul: "✓ Pasangan kandidat berhasil diperbarui dan disimpan"
   - Status: Warna **HIJAU** = Data tersimpan

### Saat Reload Web:

1. **App Startup**
   ```
   main.dart
       ↓
   PersistentStorageService.init()
       ↓
   Load candidates dari storage
   ```

2. **Load Candidates**
   ```
   VotingService.getCandidates()
       ├─ Cek PersistentStorage (utama)
       ├─ Cek LocalStorage (backup)
       └─ Return candidates dengan foto ✓
   ```

3. **Display Foto**
   - Foto Base64 sudah tersedia
   - Ditampilkan di candidate list
   - Sama seperti sebelum reload ✓

## 📊 Storage Info

### Lokasi Penyimpanan:
- **Browser LocalStorage**
  - Available offline
  - Persists across sessions
  - ~5-10MB limit per domain

### Keys:
| Key | Tujuan | Size |
|-----|--------|------|
| `candidates_v2` | Main storage | ~800KB-2MB |
| `candidates_backup` | Backup | ~800KB-2MB |
| `candidates_metadata` | Debug info | <1KB |
| `candidates_chunk_*` | Chunked data | 800KB each |

## 🧪 Testing

### Test 1: Update Single Candidate
1. Open web → Admin dashboard
2. Click "Kelola Kandidat"
3. Edit candidate → Upload foto baru
4. Click "Simpan"
5. Verify: SnackBar menampilkan "✓ ... disimpan"

### Test 2: Reload Web
1. After Test 1, reload browser (F5)
2. Go back ke Admin → Kelola Kandidat
3. Expected: Foto tetap sama seperti sebelum reload ✓

### Test 3: Check Browser Storage
1. Open DevTools (F12)
2. Go to Application → Storage → LocalStorage
3. Find `pemilihan_ketua_kelas_informatika`
4. Check `candidates_v2` ada datanya
5. Size biasanya: 800KB-2MB (tergantung jumlah foto)

### Test 4: Multiple Updates
1. Update 3-4 candidates dengan foto
2. Each time verify: "✓ ... disimpan"
3. Reload web
4. All photos tetap ada ✓

## 🔍 Debug Console Logs

Saat save data, check console untuk:
```
[PersistentStorage] Saving 16 candidates...
[PersistentStorage] JSON size: 2847392 bytes
[PersistentStorage] Image compressed by 65.4%
[PersistentStorage] ✓ Successfully saved candidates (984521 bytes)

[ManageCandidate] Storage info after save: {
  hasMainStorage: true,
  hasBackup: true,
  mainSize: 984521,
  backupSize: 984521,
  isChunked: false
}
```

Saat load data:
```
[VotingService] Loaded 16 candidates from PersistentStorage
```

## ⚙️ Files Modified

### Created:
- `lib/services/persistent_storage_service.dart` (NEW)

### Modified:
- `lib/services/voting_service.dart` - Use PersistentStorage
- `lib/screens/admin/manage_candidates_screen.dart` - Enhanced logging
- `lib/main.dart` - Init PersistentStorage

## 🚨 Troubleshooting

### Foto tidak persist:
1. **Check Console Logs**
   - F12 → Console tab
   - Look for [PersistentStorage] messages
   - Look for errors

2. **Check Browser Storage**
   - F12 → Application → LocalStorage
   - Search for `candidates_v2`
   - If empty: Storage not initialized

3. **Clear & Retry**
   - F12 → Application → LocalStorage → Delete candidates_v2
   - Reload page
   - Try update again
   - Verify save success

4. **Check File Size**
   - If photo >10MB: Will be rejected
   - Try compress first, or smaller resolution
   - Max recommended: 2-3MB per photo

### Storage Quota Exceeded:
- Check DevTools → Storage → Quota usage
- Clean old data jika diperlukan
- Contact admin for data cleanup

## 📝 Summary

| Fitur | Before | After |
|-------|--------|-------|
| Photo Persistence | ❌ Hilang saat reload | ✅ Permanen |
| Compression | Manual | ✅ Automatic |
| Backup | Tidak ada | ✅ Dual backup |
| Error Handling | Basic | ✅ Robust |
| Logging | Minimal | ✅ Detailed |
| Storage Limit | ~5MB | ✅ ~10MB dengan compression |

## 📞 Support

Untuk pertanyaan atau issues:
1. Check console logs (F12)
2. Check storage info (F12 → Application)
3. Try clear cache & reload
4. Contact admin dengan screenshot console logs

---

**Version**: 2.0  
**Last Updated**: May 10, 2026  
**Status**: ✅ Production Ready
