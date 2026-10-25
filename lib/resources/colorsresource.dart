

import 'package:flutter/material.dart';

class AppColors {
  // Private constructor – this class is not meant to be instantiated.
  AppColors._();


  
  static const Color primary = Color(0xFF92A3FD);

  static const Color primaryLight = Color(0xFF9DCEFF);

  /// Soft 
  static const Color primaryBlob = Color(0xFFB6C4FF);

  
  /// Near-black for primary headings and body text.
  static const Color textDark = Color(0xFF1D1617);

  /// Medium grey for secondary text and labels.
  static const Color textGrey = Color(0xFF7B6F72);

  /// Light grey for hint text and placeholders inside text fields.
  static const Color textHint = Color(0xFFADA4A5);

  
  /// Off-white surface color – used as scaffold and card backgrounds.
  static const Color bgLight = Color(0xFFF7F8F8);

  /// Light blue-tinted card background.
  /// Used inside exercise/workout cards throughout the app.
  static const Color cardBg = Color(0xFFE8F0FE);

  
  /// Light pinkish-grey border and divider color.
  static const Color border = Color(0xFFDDDADA);


  /// Success / completed state green.
  static const Color success = Color(0xFF4CAF50);

  ///  intermediate difficulty orange.
  static const Color warning = Color(0xFFFFA07A);

  ///  difficulty red.
  static const Color error = Color(0xFFFF7676);

  
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
  );

  ///  top-left → bottom-right (used on large cards).
  static const LinearGradient primaryGradientDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
}
