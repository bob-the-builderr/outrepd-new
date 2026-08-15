import 'package:flutter/material.dart';

/// Colours lifted from the existing OUTREPD app so the two look like the
/// same product.
abstract final class AppColors {
  static const brand = Color(0xFF4BB8FA); // signature blue
  static const background = Color(0xFF010308); // near-black page background
  static const surface = Color(0xFF0D1218); // cards
  static const surfaceRaised = Color(0xFF1A2630); // inputs, chips, borders
  static const muted = Color(0xFF556070); // secondary text
  static const win = Color(0xFF22C55E);
  static const loss = Color(0xFFFF4444);
  static const gold = Color(0xFFFFD700);
  static const white = Colors.white;
}

/// Rank ladder. Index maps to `tierIdx` on a profile.
class Tier {
  const Tier(this.name, this.color, this.asset, this.reward);
  final String name;
  final Color color;
  final String? asset;

  /// What reaching this tier unlocks, shown on the roadmap.
  final String reward;
}

const kTiers = <Tier>[
  Tier('Stone', Color(0xFF6B6B6B), 'assets/images/stone.png',
      'Stone border frame'),
  Tier('Bronze', Color(0xFFCD7F32), 'assets/images/bronze.png', 'Bronze badge'),
  Tier('Silver', Color(0xFFC0C0C0), 'assets/images/silver.png', 'Silver badge'),
  Tier('Gold', Color(0xFFFFD700), 'assets/images/gold.png', 'Gold badge'),
  Tier('Platinum', Color(0xFFA8D8EA), 'assets/images/platinum.png',
      'Platinum badge'),
  Tier('Diamond', Color(0xFF00FFFF), 'assets/images/diamond.png',
      'Diamond badge'),
  Tier('Master', Color(0xFFCC2200), 'assets/images/master.png', 'Master badge'),
  Tier('Mythic', Color(0xFFFF8C00), 'assets/images/mythic.png', 'Mythic badge'),
  Tier('Legend', Color(0xFF6A0DAD), 'assets/images/legend.png', 'Legend badge'),
];

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.brand,
    onPrimary: Colors.white,
    secondary: AppColors.brand,
    surface: AppColors.surface,
    onSurface: Colors.white,
    error: AppColors.loss,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Inter',
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: Color(0x33FFFFFF), width: 2),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1A1A1A),
      indicatorColor: AppColors.brand.withValues(alpha: 0.15),
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? AppColors.brand
              : const Color(0xFF888888),
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.brand
              : const Color(0xFF888888),
        ),
      ),
    ),
  );
}
