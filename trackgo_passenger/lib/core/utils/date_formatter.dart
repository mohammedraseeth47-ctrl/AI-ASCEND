/// Formatting helpers for transit ETA and dates without external package requirements.
class DateFormatter {
  DateFormatter._();

  /// Formats minutes into human-readable transit ETA (e.g. "2 min", "In 15 mins", "Arriving now")
  static String formatEta(int minutesRemaining) {
    if (minutesRemaining <= 0) {
      return 'Arriving now';
    } else if (minutesRemaining == 1) {
      return '1 min';
    } else if (minutesRemaining < 60) {
      return '$minutesRemaining mins';
    } else {
      final hours = minutesRemaining ~/ 60;
      final mins = minutesRemaining % 60;
      if (mins == 0) {
        return '$hours hr${hours > 1 ? 's' : ''}';
      }
      return '${hours}h ${mins}m';
    }
  }

  /// Formats a 24h or DateTime string into "HH:mm a" (e.g. "08:30 AM")
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$formattedHour:$minute $period';
  }

  /// Formats date to a human readable format (e.g. "Aug 20, 2026")
  static String formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  /// Formats duration in seconds to "Xm Ys" or "Xs"
  static String formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins}m ${secs}s';
  }
}
