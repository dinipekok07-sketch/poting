class AppHelpers {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String maskNIM(String nim) {
    if (nim.length < 4) return nim;
    return nim.replaceRange(2, nim.length - 2, '****');
  }

  static Duration parseMillisecondsToHHMMSS(int milliseconds) {
    return Duration(milliseconds: milliseconds);
  }

  static bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (var n in names) {
      if (n.isNotEmpty) {
        initials += n[0].toUpperCase();
      }
    }
    return initials;
  }
}
