import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fuentes de la app. Si cambia el diseño, solo se cambian aquí.
///
/// Uso:
/// ```dart
/// Text('Título', style: AppFonts.primary(fontSize: 28, fontWeight: FontWeight.w600));
/// Text('CATEGORÍA', style: AppFonts.label(fontSize: 12));
/// ```
class AppFonts {
  AppFonts._();

  /// Fuente principal (Inter): títulos y texto.
  static TextStyle primary({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) => GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );

  /// Fuente secundaria (DM Sans): etiquetas en mayúsculas y chips.
  static TextStyle label({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double letterSpacing = 1.2,
  }) => GoogleFonts.dmSans(
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.w500,
    color: color,
    letterSpacing: letterSpacing,
  );

  /// Nombre de la fuente principal, para aplicarla a toda la app:
  ///
  /// ```dart
  /// ThemeData(fontFamily: AppFonts.primaryFamily)
  /// ```
  static String? get primaryFamily => GoogleFonts.inter().fontFamily;

  /// Nombre de la fuente secundaria.
  static String? get labelFamily => GoogleFonts.dmSans().fontFamily;
}
