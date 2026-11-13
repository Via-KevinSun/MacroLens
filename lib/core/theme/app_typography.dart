import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(TextTheme base) =>
      GoogleFonts.interTextTheme(base).copyWith(
        headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: GoogleFonts.inter(fontSize: 14),
        labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
      );
}
