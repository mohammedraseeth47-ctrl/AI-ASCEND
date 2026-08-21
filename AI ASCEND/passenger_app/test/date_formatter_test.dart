import 'package:flutter_test/flutter_test.dart';
import 'package:trackgo_passenger/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter Tests', () {
    test('formatEta formats minutes accurately', () {
      expect(DateFormatter.formatEta(0), 'Arriving now');
      expect(DateFormatter.formatEta(-1), 'Arriving now');
      expect(DateFormatter.formatEta(1), '1 min');
      expect(DateFormatter.formatEta(15), '15 mins');
      expect(DateFormatter.formatEta(60), '1 hr');
      expect(DateFormatter.formatEta(75), '1h 15m');
      expect(DateFormatter.formatEta(120), '2 hrs');
    });

    test('formatDate formats date nicely', () {
      final date = DateTime(2026, 8, 20);
      expect(DateFormatter.formatDate(date), 'Aug 20, 2026');
    });

    test('formatDuration formats seconds nicely', () {
      expect(DateFormatter.formatDuration(45), '45s');
      expect(DateFormatter.formatDuration(125), '2m 5s');
    });
  });
}
