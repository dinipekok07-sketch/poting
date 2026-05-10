class Validators {
  static String? validateNIM(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    }
    if (value == 'admin') {
      return null;
    }
    if (value.length != 10) {
      return 'NIM harus 10 digit';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'NIM harus berupa angka';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^\d{10,13}$').hasMatch(value)) {
      return 'Nomor telepon harus 10-13 digit';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }
}

