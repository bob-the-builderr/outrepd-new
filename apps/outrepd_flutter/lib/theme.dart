import 'package:flutter/material.dart';

/// The colours that change with the theme. Semantic colours (win, loss, gold)
/// mean the same thing on either background, so they live on [AppColors] as
/// plain constants instead.
///
/// This rides on the [ThemeData] rather than a global so that reading a colour
/// registers a dependency on the theme. Without that, a screen already sitting
/// on the navigator keeps its old colours when the theme flips — Flutter caches
/// route subtrees and only rebuilds widgets that depend on an inherited widget.
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brand,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.muted,
    required this.text,
  });

  final Color brand;

  /// Page background.
  final Color background;

  /// Cards and sheets.
  final Color surface;

  /// Inputs, chips, dividers.
  final Color surfaceRaised;

  /// Secondary text.
  final Color muted;

  /// Primary text and icons.
  final Color text;

  @override
  AppPalette copyWith({
    Color? brand,
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? muted,
    Color? text,
  }) {
    return AppPalette(
      brand: brand ?? this.brand,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      muted: muted ?? this.muted,
      text: text ?? this.text,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      brand: Color.lerp(brand, other.brand, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      text: Color.lerp(text, other.text, t)!,
    );
  }
}

/// `context.colors.surface` — the way every widget reads a themed colour.
extension AppPaletteAccess on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;
}

/// Colours lifted from the existing OUTREPD app so the two look like the
/// same product.
const kDarkPalette = AppPalette(
  brand: Color(0xFF4BB8FA), // signature blue
  background: Color(0xFF010308), // near-black page background
  surface: Color(0xFF0D1218),
  surfaceRaised: Color(0xFF1A2630),
  muted: Color(0xFF556070),
  text: Colors.white,
);

/// The signature blue is too light to read as text on white, so the light
/// theme uses a deeper version of the same hue. Everything else inverts.
const kLightPalette = AppPalette(
  brand: Color(0xFF0B7FC7),
  background: Color(0xFFF2F5F9),
  surface: Color(0xFFFFFFFF),
  surfaceRaised: Color(0xFFE2E8F0),
  muted: Color(0xFF6B7684),
  text: Color(0xFF0B1017),
);

AppPalette paletteFor(Brightness brightness) =>
    brightness == Brightness.dark ? kDarkPalette : kLightPalette;

/// Colours that mean the same thing on either theme, so they need no context.
abstract final class AppColors {
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

  /// The ring that goes round a profile picture at this tier. Named from the
  /// tier so a promotion changes it without anything being wired up.
  String get frame => 'assets/images/frames/${name.toLowerCase()}.png';

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

ThemeData buildTheme(Brightness brightness) {
  final p = paletteFor(brightness);
  final dark = brightness == Brightness.dark;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.brand,
    onPrimary: Colors.white,
    secondary: p.brand,
    onSecondary: Colors.white,
    surface: p.surface,
    onSurface: p.text,
    error: AppColors.loss,
    onError: Colors.white,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    fontFamily: 'Inter',
    extensions: <ThemeExtension<dynamic>>[p],
  );

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      foregroundColor: p.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: p.text,
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: p.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.brand,
        // The brand blue is dark enough in both palettes to carry white text.
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
        foregroundColor: p.text,
        minimumSize: const Size.fromHeight(56),
        side: BorderSide(
          color: p.text.withValues(alpha: 0.2),
          width: 2,
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: p.text,
      iconColor: p.muted,
    ),
    dividerTheme: DividerThemeData(color: p.surfaceRaised),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? const Color(0xFF1A1A1A) : p.surface,
      indicatorColor: p.brand.withValues(alpha: 0.15),
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? p.brand
              : p.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? p.brand
              : p.muted,
        ),
      ),
    ),
  );
}
