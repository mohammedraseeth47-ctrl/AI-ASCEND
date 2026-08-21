import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// App theme entry points for MaterialApp.
class TrackGoTheme {
  TrackGoTheme._();

  static ThemeData get light => AppTheme.lightTheme;
  static ThemeData get dark => AppTheme.darkTheme;
}
