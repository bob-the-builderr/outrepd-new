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
    required this.border,
    required this.muted,
    required this.faint,
    required this.rival,
    required this.text,
  });

  final Color brand;

  /// Page background.
  final Color background;

  /// Cards and sheets.
  final Color surface;

  /// Inputs, chips, avatars, track fills.
  final Color surfaceRaised;

  /// Hairlines. Drawn at half a pixel, so it reads as an edge rather than a
  /// line — on a warm dark ground a full pixel looks drawn on.
  final Color border;

  /// Secondary text.
  final Color muted;

  /// Third-rank text: the description under a locked achievement, a caption
  /// that must be present without competing.
  final Color faint;

  /// The opponent. Deliberately the one warm-but-not-yours colour in the set,
  /// so a loss is legible at a glance without shouting.
  final Color rival;

  /// Primary text and icons.
  final Color text;

  @override
  AppPalette copyWith({
    Color? brand,
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? muted,
    Color? faint,
    Color? rival,
    Color? text,
  }) {
    return AppPalette(
      brand: brand ?? this.brand,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      muted: muted ?? this.muted,
      faint: faint ?? this.faint,
      rival: rival ?? this.rival,
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
      border: Color.lerp(border, other.border, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      faint: Color.lerp(faint, other.faint, t)!,
      rival: Color.lerp(rival, other.rival, t)!,
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
/// Warm dark. Every value is from the build spec and none of them are
/// negotiable: a screen that mixes these with the old cool blues reads as two
/// apps stitched together.
const kDarkPalette = AppPalette(
  brand: Color(0xFFE8DCC8), // "you" — the user, and every primary action
  background: Color(0xFF121110),
  surface: Color(0xFF1C1A18), // cards and list rows
  surfaceRaised: Color(0xFF262320), // avatars, track fills, chips
  border: Color(0xFF2C2926), // hairlines, drawn at half a pixel
  muted: Color(0xFF8F8880),
  faint: Color(0xFF5A544E),
  rival: Color(0xFFE8846B), // the opponent
  text: Color(0xFFF5EFE4),
);

/// The signature blue is too light to read as text on white, so the light
/// theme uses a deeper version of the same hue. Everything else inverts.
/// The same warmth inverted. The spec covers the dark theme only, so this is
/// derived from it rather than invented: the same hues at the other end of the
/// lightness range, with the accent darkened until it holds its own as text on
/// a pale ground.
const kLightPalette = AppPalette(
  brand: Color(0xFF8A6D3B),
  background: Color(0xFFF7F3EC),
  surface: Color(0xFFFFFFFF),
  surfaceRaised: Color(0xFFEDE7DC),
  border: Color(0xFFDDD5C7),
  muted: Color(0xFF6E665C),
  faint: Color(0xFF9C948A),
  rival: Color(0xFFC25B3F),
  text: Color(0xFF1A1714),
);

AppPalette paletteFor(Brightness brightness) =>
    brightness == Brightness.dark ? kDarkPalette : kLightPalette;

/// Colours that mean the same thing on either theme, so they need no context.
abstract final class AppColors {
  static const win = Color(0xFF22C55E);
  static const loss = Color(0xFFFF4444);
  static const white = Colors.white;

  /// Podium metals, for the top three places on a board.
  static const gold = Color(0xFFD9A94A);
  static const silver = Color(0xFFA39C93);
  static const bronze = Color(0xFFB4744A);

  /// The online dot on a friend row.
  ///
  /// The spec calls for `success` and does not give it a value, so it is
  /// derived: the same green as [win], pulled warmer and darker to sit in this
  /// palette rather than on top of it. Worth confirming.
  static const success = Color(0xFF6FA35C);
}

/// Rank ladder. Index maps to `tierIdx` on a profile.
class Tier {
  const Tier(this.name, this.color, this.crest);
  final String name;
  final Color color;

  /// How the crest is drawn, for the preview-only tier gallery. English on
  /// purpose: nobody but a developer checking the drawing ever sees it.
  final String crest;
}

/// The ladder: seven tiers, Iron to Master.
///
/// Each colour is its crest's shield — the body of the badge in
/// `tier_badge.dart`, not a token from anywhere else — so a tier's name
/// written in text and its badge drawn beside it are the same colour.
///
/// There were nine. Mythic and Legend sat above Master as this app's own
/// additions, and the crest artwork stops at seven: the wings run out at five
/// feathers and a crown, and two more rungs past that had nothing left to say.
const kTiers = <Tier>[
  Tier('Iron', Color(0xFF5E5E5B), 'Iron crest'),
  Tier('Bronze', Color(0xFFA8663A), 'Bronze crest, one feather'),
  Tier('Silver', Color(0xFF8894A0), 'Silver crest, two feathers'),
  Tier('Gold', Color(0xFFB8912F), 'Gold crest, three feathers'),
  Tier('Platinum', Color(0xFF8794A0), 'Platinum crest, four feathers, a gem'),
  Tier('Diamond', Color(0xFF2F8F88), 'Diamond crest, five feathers and a gem'),
  Tier('Master', Color(0xFFCFC3B0), 'Master crest, crowned'),
];

ThemeData buildTheme(Brightness brightness) {
  final p = paletteFor(brightness);
  final dark = brightness == Brightness.dark;
  // Text on a brand fill. The dark palette's brand is a pale cream, which
  // white text disappears into; the light palette's is a deep gold that
  // carries white.
  final onBrand = dark ? p.background : Colors.white;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.brand,
    onPrimary: onBrand,
    secondary: p.brand,
    onSecondary: onBrand,
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
    // No font family is pinned on purpose. The app ships in fourteen
    // languages, and naming one family stops the engine reaching for a font
    // that has Arabic, Devanagari or CJK glyphs — those scripts come out as
    // empty boxes. The platform default already covers all of them.
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
        foregroundColor: onBrand,
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.text,
        minimumSize: const Size.fromHeight(56),
        side: BorderSide(color: p.text.withValues(alpha: 0.2), width: 2),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    listTileTheme: ListTileThemeData(textColor: p.text, iconColor: p.muted),
    dividerTheme: DividerThemeData(color: p.surfaceRaised),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: dark ? const Color(0xFF1A1A1A) : p.surface,
      indicatorColor: p.brand.withValues(alpha: 0.15),
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected) ? p.brand : p.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? p.brand : p.muted,
        ),
      ),
    ),
  );
}
