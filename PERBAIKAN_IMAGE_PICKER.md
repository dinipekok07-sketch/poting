# Perbaikan Image Picker - MissingPluginException

## Masalah yang Dihadapi
```
MissingPluginException(No implementation found for method pickImage on channel plugins.flutter.io/image_picker)
```

## Penyebab
Plugin `image_picker` belum ter-register di native layer Android karena:
1. Cache build yang lama
2. Plugin belum ter-compile di native layer
3. Perlu rebuild aplikasi dari scratch

## Solusi - Langkah Demi Langkah

### Step 1: Bersihkan Semua Cache
```bash
cd c:\aplikasi_voting

# Hapus cache build
flutter clean

# Hapus pubspec.lock
Remove-Item pubspec.lock -Force

# Hapus .dart_tool
Remove-Item .dart_tool -Recurse -Force
```

### Step 2: Update Dependencies
```bash
flutter pub get
```

### Step 3: Rebuild Aplikasi
**Untuk Android Emulator:**
```bash
# Pastikan emulator sudah running
flutter emulators --launch <emulator_name>

# Jalankan aplikasi
flutter run
```

**Untuk Android Device (USB)**
```bash
# Nyalakan USB Debugging di device
# Hubungkan device via USB

flutter run
```

### Step 4: Alternatif - Build APK
```bash
flutter build apk --debug

# Kemudian install ke device:
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Apa yang Dilakukan Rebuild?
- ✅ Mengkompilasi plugin `image_picker` dengan native code Android
- ✅ Meregister image_picker channel ke GeneratedPluginRegistrant
- ✅ Menambahkan permissions ke APK manifest
- ✅ Menginisialisasi native bridge untuk platform communication

## Perubahan Kode yang Sudah Dibuat

### 1. Simplified Image Picker Logic
- **File**: `lib/screens/admin/manage_candidates_screen.dart`
- **Perubahan**: 
  - Menghapus `permission_handler` yang kompleks
  - ImagePicker sekarang handle permission otomatis
  - Menambahkan error handling yang lebih baik untuk PlatformException

### 2. Updated Permissions
- **File**: `android/app/src/main/AndroidManifest.xml`
- **Permissions yang ditambahkan**:
  - `CAMERA`
  - `READ_EXTERNAL_STORAGE`
  - `WRITE_EXTERNAL_STORAGE`
  - `READ_MEDIA_IMAGES` (Android 13+)

### 3. Clean Dependencies
- **File**: `pubspec.yaml`
- **Perubahan**: Menghapus `permission_handler` yang tidak perlu

## Troubleshooting

### Jika Masih Error Setelah Rebuild:

**Error: Plugin masih tidak ter-detect**
```bash
# Clear Android cache
rm -Recurse android/.gradle/
rm -Recurse android/app/.gradle/

# Rebuild
flutter clean
flutter pub get
flutter run
```

**Error: USB Debugging tidak terdeteksi**
```bash
# List connected devices
adb devices

# Jika kosong, pastikan:
# 1. USB cable tersambung dengan baik
# 2. USB Debugging diaktifkan di device (Developer Options)
# 3. Authorize akses di device
```

**Error: Emulator tidak bisa connect**
```bash
# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_name>

# Tunggu emulator fully boot, kemudian
flutter run
```

## Testing Image Picker

Setelah rebuild berhasil:

1. Buka aplikasi
2. Pergi ke "Kelola Pasangan Kandidat"
3. Klik tombol "Tap untuk pilih foto"
4. Pilih "Galeri" atau "Kamera"
5. Foto seharusnya bisa dipilih tanpa error

## Catatan Penting

⚠️ **JANGAN LUPA**: Setiap kali ada perubahan plugin di `pubspec.yaml`, perlu rebuild aplikasi agar native layer ter-update.

Jika menggunakan Android Studio atau Xcode, bisa juga klik "Rebuild" atau "Run" di IDE untuk hasil yang sama.
