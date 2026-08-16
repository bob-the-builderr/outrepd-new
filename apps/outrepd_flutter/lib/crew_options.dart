import 'package:flutter/material.dart';


/// Emblems a crew can wear. Kept to a curated set so every badge sits in the
/// same visual family, but wide enough that crews do not all look alike.
/// Grouped by feel: strength, combat, beasts, elements, honours, symbols.
class CrewEmblemGroup {
  const CrewEmblemGroup(this.label, this.icons);
  final String label;
  final List<IconData> icons;
}

const kCrewEmblemGroups = <CrewEmblemGroup>[
  CrewEmblemGroup('Strength', [
    Icons.fitness_center,
    Icons.sports_gymnastics,
    Icons.sports_handball,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.accessibility_new,
    Icons.rowing,
    Icons.hiking,
    Icons.sports_score,
    Icons.speed,
  ]),
  CrewEmblemGroup('Combat', [
    Icons.sports_mma,
    Icons.sports_martial_arts,
    Icons.sports_kabaddi,
    Icons.shield,
    Icons.security,
    Icons.gpp_good,
    Icons.gavel,
    Icons.local_police,
  ]),
  CrewEmblemGroup('Beasts', [
    Icons.pets,
    Icons.cruelty_free,
    Icons.bug_report,
    Icons.flutter_dash,
    Icons.savings,
    Icons.emoji_nature,
  ]),
  CrewEmblemGroup('Elements', [
    Icons.local_fire_department,
    Icons.whatshot,
    Icons.bolt,
    Icons.flash_on,
    Icons.electric_bolt,
    Icons.ac_unit,
    Icons.water_drop,
    Icons.waves,
    Icons.thunderstorm,
    Icons.tsunami,
    Icons.wb_sunny,
    Icons.dark_mode,
    Icons.terrain,
    Icons.landscape,
    Icons.volcano,
  ]),
  CrewEmblemGroup('Honours', [
    Icons.military_tech,
    Icons.workspace_premium,
    Icons.emoji_events,
    Icons.star,
    Icons.grade,
    Icons.verified,
    Icons.diamond,
    Icons.auto_awesome,
    Icons.local_activity,
  ]),
  CrewEmblemGroup('Symbols', [
    Icons.anchor,
    Icons.rocket_launch,
    Icons.hexagon,
    Icons.pentagon,
    Icons.change_history,
    Icons.blur_on,
    Icons.all_inclusive,
    Icons.favorite,
    Icons.psychology,
    Icons.visibility,
    Icons.key,
    Icons.castle,
  ]),
];

/// Flattened list — the index stored on a crew points into this.
final List<IconData> kCrewIcons = [
  for (final g in kCrewEmblemGroups) ...g.icons,
];

const kCrewColors = <Color>[
  // A crew's colour is its identity, so these stay fixed across themes.
  Color(0xFF4BB8FA),
  Color(0xFF2E7DFF),
  Color(0xFF00E5FF),
  Color(0xFF22C55E),
  Color(0xFF7CFF3E),
  Color(0xFFFFD700),
  Color(0xFFFF8C00),
  Color(0xFFFF4444),
  Color(0xFFB3001B),
  Color(0xFFFF5FA2),
  Color(0xFF9B59B6),
  Color(0xFF6A0DAD),
  Color(0xFFC0C0C0),
  Color(0xFF8B5A2B),
  Color(0xFF2F4858),
  Color(0xFFEDEDED),
];

/// Who may come in.
enum CrewPrivacy { open, request, inviteOnly }

extension CrewPrivacyLabel on CrewPrivacy {
  String get label => switch (this) {
        CrewPrivacy.open => 'Open',
        CrewPrivacy.request => 'Request to join',
        CrewPrivacy.inviteOnly => 'Invite only',
      };

  String get description => switch (this) {
        CrewPrivacy.open => 'Anyone with the code can walk straight in',
        CrewPrivacy.request => 'People ask, an officer approves',
        CrewPrivacy.inviteOnly => 'Members must be invited directly',
      };

  IconData get icon => switch (this) {
        CrewPrivacy.open => Icons.lock_open,
        CrewPrivacy.request => Icons.how_to_reg,
        CrewPrivacy.inviteOnly => Icons.lock,
      };
}

/// Every country, so nobody has to pick "Other".
const kCountries = <String>[
  'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola',
  'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria',
  'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus',
  'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia',
  'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria',
  'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon', 'Canada', 'Cape Verde',
  'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia',
  'Comoros', 'Congo', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czechia',
  'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Ecuador',
  'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia',
  'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia',
  'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea',
  'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Hungary', 'Iceland',
  'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy',
  'Ivory Coast', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya',
  'Kiribati', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon',
  'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
  'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta',
  'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia',
  'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique',
  'Myanmar', 'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand',
  'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia',
  'Norway', 'Oman', 'Pakistan', 'Palau', 'Palestine', 'Panama',
  'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland',
  'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis',
  'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino',
  'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles',
  'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands',
  'Somalia', 'South Africa', 'South Korea', 'South Sudan', 'Spain',
  'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria',
  'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo',
  'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan',
  'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
  'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City',
  'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe',
];
