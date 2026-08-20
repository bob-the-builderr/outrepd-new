// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LEs extends L {
  LEs([String locale = 'es']) : super(locale);

  @override
  String get tabFriends => 'Amigos';

  @override
  String get tabRanks => 'Rangos';

  @override
  String get tabMatch => 'Duelo';

  @override
  String get tabCrew => 'Equipo';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get searchOpponent => 'Buscar rival';

  @override
  String get searchOpponentHint => 'Te emparejamos con alguien de tu rango';

  @override
  String get challengeFriend => 'Retar a un amigo';

  @override
  String get trainWithCamera => 'Entrenar con la cámara';

  @override
  String get viewRoadmap => 'Ver el camino';

  @override
  String lpProgress(String lp, String left) {
    return '$lp / 100 PL · $left para ascender';
  }

  @override
  String winStreak(String count) {
    return '$count victorias seguidas';
  }

  @override
  String get matchHistory => 'Historial de duelos';

  @override
  String get allMatches => 'Todos los duelos';

  @override
  String get wins => 'Victorias';

  @override
  String get losses => 'Derrotas';

  @override
  String get winRate => '% de victorias';

  @override
  String get streak => 'Racha';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get stats => 'Estadísticas';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get skip => 'Omitir';

  @override
  String get totalMatches => 'Duelos totales';

  @override
  String get bestWinStreak => 'Mejor racha';

  @override
  String get totalVolume => 'Volumen total levantado';

  @override
  String get height => 'Altura';

  @override
  String get bodyweight => 'Peso corporal';

  @override
  String get age => 'Edad';

  @override
  String get editYourStats => 'Editar tus datos';

  @override
  String get editStatsHint =>
      'Las victorias, el volumen y el rango se ganan: no se editan.';

  @override
  String get changeName => 'Cambiar tu nombre';

  @override
  String get changeNameLast =>
      'Este es tu último cambio. No se puede deshacer.';

  @override
  String changeNameLeft(String total, String left) {
    return 'Tienes $total cambios en total. Te quedará $left después de este.';
  }

  @override
  String get changeNameUsedUp => 'Ya has usado tus dos cambios de nombre';

  @override
  String get yourPicture => 'Tu foto';

  @override
  String get yourPictureHint =>
      'El marco viene de tu rango y cambia según subes.';

  @override
  String get gallery => 'Galería';

  @override
  String get camera => 'Cámara';

  @override
  String get orPickOurs => 'O elige uno de los nuestros';

  @override
  String get awards => 'Logros';

  @override
  String get yourTitles => 'Tus títulos';

  @override
  String get stillToEarn => 'Por conseguir';

  @override
  String get noTitlesYet => 'Ninguno aún. El primero solo cuesta un duelo.';

  @override
  String get wearHint =>
      'Toca uno para llevarlo. Aparecerá junto a tu nombre allá donde te vean.';

  @override
  String get worn => 'puesto';

  @override
  String get titleUnlocked => 'Título desbloqueado';

  @override
  String get wearIt => 'Ponérselo';

  @override
  String get wearItLater => 'Más tarde';

  @override
  String get dayStreak => 'días seguidos';

  @override
  String get bestEver => 'Mejor marca';

  @override
  String get restDaysLeft => 'Días de descanso';

  @override
  String get restIsTraining =>
      'Descansar es parte del entrenamiento. Dos días libres a la semana no rompen tu racha.';

  @override
  String titlesAndStreak(String owned, String total, String streak) {
    return '$owned de $total títulos · racha de $streak días';
  }

  @override
  String get crew => 'Equipo';

  @override
  String get myCrew => 'Mi equipo';

  @override
  String get rankings => 'Clasificación';

  @override
  String get trainWithCrew => 'Entrena con un equipo';

  @override
  String get trainWithCrewHint =>
      'Hasta 20 atletas bajo un mismo nombre, persiguiendo una meta semanal y subiendo en la tabla.';

  @override
  String get createCrew => 'Crear un equipo';

  @override
  String get createCrewHint =>
      'Ponle nombre, elige un escudo e invita a tu gente';

  @override
  String get joinOpenCrew => 'Unirse a un equipo abierto';

  @override
  String get joinOpenCrewHint => 'Equipos abiertos a cualquiera';

  @override
  String get yourInvites => 'Tus invitaciones';

  @override
  String get yourInvitesHint => 'Equipos que te han pedido';

  @override
  String get joinWithCode => 'Unirse con un código';

  @override
  String get joinWithCodeHint => 'Seis caracteres de un miembro';

  @override
  String get topCrewsThisWeek => 'Mejores equipos de la semana';

  @override
  String get members => 'Miembros';

  @override
  String get repsEach => 'Reps por persona';

  @override
  String get rank => 'Puesto';

  @override
  String get weeklyGoal => 'Meta semanal';

  @override
  String get weeklyGoalDone => 'Meta semanal conseguida';

  @override
  String goalRemaining(String reps, String days) {
    return 'Faltan $reps reps · quedan $days días';
  }

  @override
  String get goalDoneHint => 'Todos reciben la insignia al cerrar la semana.';

  @override
  String get startCrewWar => 'Empezar una guerra de equipos';

  @override
  String get startCrewWarHint =>
      'Siete días, los dos equipos contando. Gana quien más reps haga por persona.';

  @override
  String get whoIsPulling => 'Quién sostiene al equipo';

  @override
  String get thisWeek => 'esta semana';

  @override
  String get inviteLifters => 'Invitar atletas';

  @override
  String get referralCode => 'Código de invitación';

  @override
  String get inviteLink => 'Enlace de invitación';

  @override
  String get leaveCrew => 'Salir del equipo';

  @override
  String get owner => 'Propietario';

  @override
  String get crewTable => 'Tabla de equipos';

  @override
  String get repsPerMember => 'reps por miembro';

  @override
  String seasonResets(String days) {
    return 'Se reinicia en $days días: todos empiezan iguales';
  }

  @override
  String get rankingExplained =>
      'Los equipos se clasifican por reps por miembro, no por el total; si no, gana el más grande solo por tamaño.';

  @override
  String get leaderboard => 'Clasificación';

  @override
  String get global => 'Global';

  @override
  String get myCountry => 'Mi país';

  @override
  String yourFriends(String count) {
    return 'Tus amigos ($count)';
  }

  @override
  String get challenge => 'Retar';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get pickMovement => 'Elige un movimiento';

  @override
  String get anyExercise => 'Cualquier ejercicio';

  @override
  String get anyExerciseHint =>
      'Empieza tu serie: el movimiento se reconoce mientras lo realizas';

  @override
  String get start => 'Empezar';

  @override
  String get finish => 'Terminar';

  @override
  String get reps => 'reps';

  @override
  String get secondsHeld => 'segundos aguantados';

  @override
  String get learningMovement =>
      'Aprendiendo tu movimiento: tus reps aparecen en un momento';

  @override
  String get recalibrate => 'Recalibrar';

  @override
  String get resetCount => 'Poner a cero';

  @override
  String get checksForm => 'revisa la técnica';

  @override
  String get counts => 'cuenta';

  @override
  String get time => 'tiempo';

  @override
  String get howManyReally => '¿Cuántas hiciste de verdad?';

  @override
  String get howManyReallyHint =>
      'Indica tu propio recuento, no el de la aplicación. Es la referencia con la que se medirá el contador.';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get units => 'Unidades';

  @override
  String get weight => 'Peso';

  @override
  String get notificationsSection => 'Notificaciones';

  @override
  String get privacy => 'Privacidad';

  @override
  String get matches => 'Duelos';

  @override
  String get data => 'Datos';

  @override
  String get about => 'Acerca de';

  @override
  String get dangerZone => 'Zona de riesgo';

  @override
  String get themeSystem => 'Como el dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get openCrews => 'Equipos abiertos';

  @override
  String get openCrewsHint =>
      'Estos dejan entrar a cualquiera. Elige uno y ya estás dentro.';

  @override
  String get yourInvitesSubtitle => 'Equipos que te han pedido por tu nombre.';

  @override
  String get pickOpponent => 'Elige a tu rival';

  @override
  String get accept => 'Aceptar';

  @override
  String get join => 'Unirse';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Enlace de invitación copiado';

  @override
  String season(String name) {
    return 'Temporada $name';
  }

  @override
  String challengeSent(String name) {
    return 'Reto enviado a $name';
  }

  @override
  String get inviteFriendPrivate => 'Invita a un amigo a un duelo privado';

  @override
  String get joinWithCodePaste =>
      'Pega los seis caracteres que te envió un miembro.';

  @override
  String get enterTheCode => 'Escribe el código de 6 caracteres';

  @override
  String get followingDevice => 'Ahora sigue a tu dispositivo';

  @override
  String get weightUnitTitle => 'Unidad de peso';

  @override
  String get heightUnitTitle => 'Unidad de altura';

  @override
  String get unitKg => 'Kilogramos (kg)';

  @override
  String get unitLb => 'Libras (lb)';

  @override
  String get unitCm => 'Centímetros (cm)';

  @override
  String get unitFt => 'Pies y pulgadas';

  @override
  String get visEveryone => 'Todos';

  @override
  String get visFriends => 'Solo amigos';

  @override
  String get visNobody => 'Nadie';

  @override
  String get visEveryoneHint => 'Cualquiera puede abrir tu perfil';

  @override
  String get visFriendsHint => 'Solo quienes has añadido';

  @override
  String get visNobodyHint => 'Tu perfil queda privado';

  @override
  String get matchInvites => 'Invitaciones a duelos';

  @override
  String get matchResults => 'Resultados de duelos';

  @override
  String get friendRequestsLabel => 'Solicitudes de amistad';

  @override
  String get crewActivity => 'Actividad del equipo';

  @override
  String get rankChanges => 'Cambios de rango';

  @override
  String get weeklySummary => 'Resumen semanal';

  @override
  String get soundLabel => 'Sonido';

  @override
  String get vibration => 'Vibración';

  @override
  String get whoCanSeeProfile => 'Quién puede ver mi perfil';

  @override
  String get profileVisibility => 'Visibilidad del perfil';

  @override
  String get showOnLeaderboards => 'Mostrarme en las clasificaciones';

  @override
  String get allowMatchInvites => 'Permitir invitaciones a duelos';

  @override
  String get allowFriendRequests => 'Permitir solicitudes de amistad';

  @override
  String get showHeightWeight => 'Mostrar altura y peso';

  @override
  String get showHeightWeightHint =>
      'Desactivado, tus medidas quedan solo para ti';

  @override
  String get autoAcceptFriends => 'Aceptar automáticamente de amigos';

  @override
  String get restTimerBetweenSets => 'Temporizador de descanso entre series';

  @override
  String get exportData => 'Exportar mis datos';

  @override
  String get clearCache => 'Borrar caché';

  @override
  String get cacheCleared => 'Caché borrada';

  @override
  String get version => 'Versión';

  @override
  String get rateApp => 'Valorar OUTREPD';

  @override
  String get contactSupport => 'Contactar con soporte';

  @override
  String get termsOfService => 'Términos del servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get openSourceLicences => 'Licencias de código abierto';

  @override
  String get resetProgress => 'Reiniciar mi progreso';

  @override
  String get resetProgressTitle => '¿Reiniciar tu progreso?';

  @override
  String get resetProgressBody =>
      'El rango, los PL y el historial vuelven a cero. Esto no se puede deshacer.';

  @override
  String get actionReset => 'Reiniciar';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountBody =>
      'Tu perfil, tus equipos y todos los duelos que has levantado se borran para siempre.';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get needsServer =>
      'Esta función requiere un servidor y aún no está conectada';

  @override
  String get getStarted => 'Empezar';

  @override
  String get skipToApp => 'Ir directo a la app';

  @override
  String get achievements => 'Logros';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get roadTitle => 'Camino a la Leyenda';

  @override
  String get allTiers => 'Todos los rangos';

  @override
  String get topTier => 'Rango máximo';

  @override
  String lpToGo(String lp) {
    return '$lp PL';
  }

  @override
  String get unlockedEverything => 'Ya lo has desbloqueado todo';

  @override
  String unlocksAt(String tier) {
    return 'Se desbloquea en $tier';
  }

  @override
  String get matchedSameGroup =>
      'Te emparejaremos con alguien que entrene el mismo grupo.';

  @override
  String get roomFriendly =>
      'Los duelos de sala son amistosos: no afectan a tu rango.';

  @override
  String get createRoom => 'Crear una sala';

  @override
  String get enterCode => 'ESCRIBE EL CÓDIGO';

  @override
  String get joinRoom => 'Entrar en la sala';

  @override
  String get shareThisCode => 'Comparte este código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get pickMuscleAndStart => 'Elige músculo y empieza';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Piedra';

  @override
  String get tierBronze => 'Bronce';

  @override
  String get tierSilver => 'Plata';

  @override
  String get tierGold => 'Oro';

  @override
  String get tierPlatinum => 'Platino';

  @override
  String get tierDiamond => 'Diamante';

  @override
  String get tierMaster => 'Maestro';

  @override
  String get tierMythic => 'Mítico';

  @override
  String get tierLegend => 'Leyenda';

  @override
  String get rewardStone => 'Marco de piedra';

  @override
  String get rewardBronze => 'Insignia de bronce';

  @override
  String get rewardSilver => 'Insignia de plata';

  @override
  String get rewardGold => 'Insignia de oro';

  @override
  String get rewardPlatinum => 'Insignia de platino';

  @override
  String get rewardDiamond => 'Insignia de diamante';

  @override
  String get rewardMaster => 'Insignia de maestro';

  @override
  String get rewardMythic => 'Insignia mítica';

  @override
  String get rewardLegend => 'Insignia de leyenda';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'ft';

  @override
  String winLoss(String w, String l) {
    return '${w}V ${l}D';
  }

  @override
  String get yearsSuffix => 'años';

  @override
  String get yourCrew => 'Tu equipo';

  @override
  String get crewName => 'Nombre del equipo';

  @override
  String get motto => 'Lema';

  @override
  String get mottoHint => '¿Qué representa este equipo?';

  @override
  String get country => 'País';

  @override
  String get whoCanJoin => 'Quién puede unirse';

  @override
  String get minimumRank => 'Rango mínimo';

  @override
  String get anyone => 'Cualquiera';

  @override
  String get emblem => 'Emblema';

  @override
  String get colour => 'Color';

  @override
  String get createCrewButton => 'Crear equipo';

  @override
  String get ownerNote =>
      'Serás el propietario. Los equipos admiten hasta 20 atletas.';

  @override
  String get searchCountries => 'Buscar países';

  @override
  String get noCountryMatch => 'Ningún país coincide';

  @override
  String get nameTooShort =>
      'Dale al equipo un nombre de al menos 3 caracteres';

  @override
  String get privOpen => 'Abierto';

  @override
  String get privRequest => 'Solicitud de ingreso';

  @override
  String get privInviteOnly => 'Solo por invitación';

  @override
  String get privOpenHint => 'Cualquiera con el código entra directamente';

  @override
  String get privRequestHint =>
      'El interesado lo pide y un responsable lo aprueba';

  @override
  String get privInviteOnlyHint => 'Solo se entra por invitación directa';

  @override
  String get embStrength => 'Fuerza';

  @override
  String get embCombat => 'Combate';

  @override
  String get embBeasts => 'Bestias';

  @override
  String get embElements => 'Elementos';

  @override
  String get embHonours => 'Honores';

  @override
  String get embSymbols => 'Símbolos';

  @override
  String get ob1Title => 'Convierte cada sesión\nen un duelo';

  @override
  String get ob1Body =>
      'Registra tu entrenamiento y enfréntate a quien trabaja el mismo grupo muscular.';

  @override
  String get ob2Title => 'Reta a tus\namigos';

  @override
  String get ob2Body =>
      'Envía una invitación privada y resuelve quién entrena más duro.';

  @override
  String get ob3Title => 'Sube de rango';

  @override
  String get ob3Body => 'Cada victoria da PL. Avanza de Piedra hasta Leyenda.';

  @override
  String get ob4Title => 'El esfuerzo solo\nes duro';

  @override
  String get ob4Body =>
      'Entrenar sin que nadie mire facilita acortar la última serie.';

  @override
  String get ob5Title => 'Conviértete en\nLeyenda';

  @override
  String get ob5Body =>
      'La constancia se acumula. Preséntate, supera, asciende.';

  @override
  String get letsGo => 'Vamos';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get ttl_first_blood => 'Primera Sangre';

  @override
  String get tdesc_first_blood => 'Termina tu primer duelo';

  @override
  String get ttl_found_footing => 'Pie Firme';

  @override
  String get tdesc_found_footing => 'Termina cinco duelos';

  @override
  String get ttl_regular => 'Habitual';

  @override
  String get tdesc_regular => 'Veinte duelos';

  @override
  String get ttl_fifty => 'Los Cincuenta';

  @override
  String get tdesc_fifty => 'Cincuenta duelos';

  @override
  String get ttl_century => 'Centenario';

  @override
  String get tdesc_century => 'Cien duelos';

  @override
  String get ttl_veteran => 'Veterano';

  @override
  String get tdesc_veteran => 'Doscientos cincuenta duelos';

  @override
  String get ttl_thousand_matches => 'Vieja Guardia';

  @override
  String get tdesc_thousand_matches => 'Mil duelos';

  @override
  String get ttl_first_win => 'Ganador';

  @override
  String get tdesc_first_win => 'Gana un duelo';

  @override
  String get ttl_on_a_roll => 'En Racha';

  @override
  String get tdesc_on_a_roll => 'Gana tres seguidos';

  @override
  String get ttl_five_straight => 'Cinco Seguidos';

  @override
  String get tdesc_five_straight => 'Gana cinco seguidos';

  @override
  String get ttl_unstoppable => 'Imparable';

  @override
  String get tdesc_unstoppable => 'Gana diez seguidos';

  @override
  String get ttl_untouchable => 'Intocable';

  @override
  String get tdesc_untouchable => 'Gana veinte seguidos';

  @override
  String get ttl_giant_slayer => 'Mataga Gigantes';

  @override
  String get tdesc_giant_slayer => 'Vence a alguien dos rangos por encima';

  @override
  String get ttl_comeback => 'Remontada';

  @override
  String get tdesc_comeback => 'Gana justo tras tres derrotas';

  @override
  String get ttl_nemesis => 'Némesis';

  @override
  String get tdesc_nemesis => 'Vence al mismo atleta cinco veces';

  @override
  String get ttl_hundred_reps => 'Arrancando';

  @override
  String get tdesc_hundred_reps => 'Cien repeticiones contadas';

  @override
  String get ttl_five_hundred => 'En Calor';

  @override
  String get tdesc_five_hundred => 'Quinientas repeticiones contadas';

  @override
  String get ttl_the_machine => 'La Máquina';

  @override
  String get tdesc_the_machine => 'Mil repeticiones contadas';

  @override
  String get ttl_five_thousand => 'Implacable';

  @override
  String get tdesc_five_thousand => 'Cinco mil repeticiones contadas';

  @override
  String get ttl_ten_thousand => 'Diez Mil';

  @override
  String get tdesc_ten_thousand => 'Diez mil repeticiones contadas';

  @override
  String get ttl_fifty_thousand => 'Más Allá de la Cuenta';

  @override
  String get tdesc_fifty_thousand => 'Cincuenta mil repeticiones contadas';

  @override
  String get ttl_first_tonne => 'Una Tonelada';

  @override
  String get tdesc_first_tonne => 'Mueve mil kilos en total';

  @override
  String get ttl_ten_tonnes => 'Diez Toneladas';

  @override
  String get tdesc_ten_tonnes => 'Mueve diez mil kilos';

  @override
  String get ttl_six_figures => 'Seis Cifras';

  @override
  String get tdesc_six_figures => 'Mueve cien mil kilos';

  @override
  String get ttl_half_million => 'Medio Millón';

  @override
  String get tdesc_half_million => 'Mueve quinientos mil kilos';

  @override
  String get ttl_million_kg => 'Club del Millón';

  @override
  String get tdesc_million_kg => 'Mueve un millón de kilos';

  @override
  String get ttl_two_days => 'De Vuelta';

  @override
  String get tdesc_two_days => 'Entrena dos días seguidos';

  @override
  String get ttl_no_days_off => 'Sin Descanso';

  @override
  String get tdesc_no_days_off => 'Entrena siete días seguidos';

  @override
  String get ttl_fortnight => 'Quincena';

  @override
  String get tdesc_fortnight => 'Racha de catorce días';

  @override
  String get ttl_unbroken => 'Sin Romper';

  @override
  String get tdesc_unbroken => 'Racha de treinta días';

  @override
  String get ttl_sixty_days => 'Hábito';

  @override
  String get tdesc_sixty_days => 'Racha de sesenta días';

  @override
  String get ttl_hundred_days => 'Cien Días';

  @override
  String get tdesc_hundred_days => 'Racha de cien días';

  @override
  String get ttl_year_round => 'Todo el Año';

  @override
  String get tdesc_year_round => 'Racha de trescientos sesenta y cinco días';

  @override
  String get ttl_perfect_week => 'Semana Perfecta';

  @override
  String get tdesc_perfect_week => 'Entrena todos los días de una semana';

  @override
  String get ttl_perfect_month => 'Mes Perfecto';

  @override
  String get tdesc_perfect_month => 'Cuatro semanas perfectas';

  @override
  String get ttl_bronze_tier => 'Fuera de la Piedra';

  @override
  String get tdesc_bronze_tier => 'Alcanza Bronce';

  @override
  String get ttl_silver_tier => 'Plateado';

  @override
  String get tdesc_silver_tier => 'Alcanza Plata';

  @override
  String get ttl_golden_era => 'Era Dorada';

  @override
  String get tdesc_golden_era => 'Alcanza Oro';

  @override
  String get ttl_platinum_tier => 'Platino';

  @override
  String get tdesc_platinum_tier => 'Alcanza Platino';

  @override
  String get ttl_diamond_tier => 'Manos de Diamante';

  @override
  String get tdesc_diamond_tier => 'Alcanza Diamante';

  @override
  String get ttl_master_tier => 'Maestro';

  @override
  String get tdesc_master_tier => 'Alcanza Maestro';

  @override
  String get ttl_mythic_tier => 'Mítico';

  @override
  String get tdesc_mythic_tier => 'Alcanza Mítico';

  @override
  String get ttl_legend_tier => 'Leyenda';

  @override
  String get tdesc_legend_tier => 'Alcanza Leyenda';

  @override
  String get ttl_clean_hands => 'Manos Limpias';

  @override
  String get tdesc_clean_hands =>
      'Una serie entera con todas las repeticiones contadas';

  @override
  String get ttl_spotless => 'Impecable';

  @override
  String get tdesc_spotless => 'Diez series limpias';

  @override
  String get ttl_textbook => 'De Manual';

  @override
  String get tdesc_textbook => 'Cincuenta series limpias';

  @override
  String get ttl_iron_hold => 'Agarre de Hierro';

  @override
  String get tdesc_iron_hold => 'Aguanta una plancha dos minutos';

  @override
  String get ttl_statue => 'Estatua';

  @override
  String get tdesc_statue => 'Aguanta una plancha cinco minutos';

  @override
  String get ttl_all_rounder => 'Todoterreno';

  @override
  String get tdesc_all_rounder => 'Cuenta cinco ejercicios distintos';

  @override
  String get ttl_explorer => 'Explorador';

  @override
  String get tdesc_explorer => 'Cuenta quince ejercicios distintos';

  @override
  String get ttl_encyclopedia => 'Enciclopedia';

  @override
  String get tdesc_encyclopedia => 'Cuenta cuarenta ejercicios distintos';

  @override
  String get ttl_early_bird => 'Turno de Mañana';

  @override
  String get tdesc_early_bird => 'Diez sesiones antes de las siete';

  @override
  String get ttl_sunrise_club => 'Club del Amanecer';

  @override
  String get tdesc_sunrise_club => 'Cincuenta sesiones antes de las siete';

  @override
  String get ttl_night_owl => 'Turno de Noche';

  @override
  String get tdesc_night_owl => 'Diez sesiones después de las diez';

  @override
  String get ttl_graveyard => 'Turno de Madrugada';

  @override
  String get tdesc_graveyard => 'Cincuenta sesiones después de las diez';

  @override
  String get ttl_joined_up => 'Con los Tuyos';

  @override
  String get tdesc_joined_up => 'Pertenece a un equipo';

  @override
  String get ttl_backbone => 'Columna Vertebral';

  @override
  String get tdesc_backbone => 'Lidera tu equipo cuatro semanas seguidas';

  @override
  String get ttl_cornerstone => 'Piedra Angular';

  @override
  String get tdesc_cornerstone => 'Lidera tu equipo doce semanas seguidas';

  @override
  String get ttl_not_alone => 'No Estás Solo';

  @override
  String get tdesc_not_alone => 'Añade a tu primer amigo';

  @override
  String get ttl_well_connected => 'Bien Conectado';

  @override
  String get tdesc_well_connected => 'Diez amigos';

  @override
  String get ttl_the_gym_knows => 'El Gimnasio Te Conoce';

  @override
  String get tdesc_the_gym_knows => 'Cincuenta amigos';

  @override
  String get finish2 => 'Terminar';

  @override
  String get qExperience => '¿Cuánta experiencia tienes\nentrenando?';

  @override
  String get expBeginner => 'Principiante – Lo he probado';

  @override
  String get expIntermediate => 'Intermedio – Entreno con regularidad';

  @override
  String get expAdvanced => 'Avanzado – Años de experiencia';

  @override
  String get qGoal => '¿Cuál es tu principal\nobjetivo?';

  @override
  String get goalStronger => 'Ser más fuerte';

  @override
  String get goalConsistent => 'Ser más constante';

  @override
  String get goalLean => 'Perder peso y definir';

  @override
  String get goalMass => 'Ganar masa muscular';

  @override
  String get aboutYou => 'Este camino trata sobre ti...';

  @override
  String get qThinkAbout => '¿Con qué frecuencia piensas\nen ponerte en forma?';

  @override
  String get freqNever => 'Nunca';

  @override
  String get freqSometimes => 'A veces';

  @override
  String get freqOften => 'A menudo';

  @override
  String get freqAllTime => 'Todo el tiempo';

  @override
  String get qEnergy => '¿Cómo es tu energía\ndurante los entrenamientos?';

  @override
  String get energyLow => 'Baja, me siento agotado todo el día';

  @override
  String get energyDrops => 'El rendimiento cae a mitad de sesión';

  @override
  String get energyHard => 'Cuesta terminar la última serie';

  @override
  String get energyHigh => 'Alta y constante de principio a fin';

  @override
  String get stProgress => 'A veces cuesta notar el progreso cuando entreno';

  @override
  String get stEffortTitle => 'El esfuerzo que nadie ve\nes fácil de abandonar';

  @override
  String get stEffortBody =>
      'Cuando no hay nadie ante quien demostrar nada, el progreso parece lento y el esfuerzo inútil';

  @override
  String get stAloneTitle => 'Entrenar solo\nes aburrido';

  @override
  String get stAloneBody =>
      'Nadie mira. Nadie cuenta. Es fácil saltarse una repetición, o la serie entera';

  @override
  String get qName => '¿Cómo te\nllamamos?';

  @override
  String get nameHint => 'Al menos 3 caracteres. Es lo que verán tus rivales.';

  @override
  String get basicInfo => '¡Bien! Vamos con\nunos datos básicos';

  @override
  String get qAge => '¿Qué edad tienes?';

  @override
  String get qWeight => '¿Cuál es tu\npeso actual?';

  @override
  String get weightWhy =>
      'El peso corporal es esencial para calcular tu rango.';

  @override
  String get privateNote =>
      'Tu información es privada y no se compartirá con nadie.';

  @override
  String get qHeight => '¿Cuánto mides?';

  @override
  String get qRelate => '¿Te identificas con\nla siguiente frase?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get grindTitle => 'El esfuerzo sabe distinto\ncon un rival';

  @override
  String get grindBody =>
      'Cada duelo te pone frente a un oponente real: haz el trabajo y demuestra quién entrenó más duro.';

  @override
  String get allSet => '¡Todo listo!';

  @override
  String welcomeLifter(String name) {
    return 'Bienvenido, $name. Es hora de encontrar tu primer rival.';
  }

  @override
  String get lifter => 'atleta';

  @override
  String get enterApp => 'Entrar en OUTREPD';

  @override
  String get commitTitle => 'Ahora comprometámonos\ncon tu camino';

  @override
  String get holdLogo =>
      'Mantén pulsado el logo para confirmar que estás listo';

  @override
  String get expNone => 'Nunca he entrenado';

  @override
  String get iAm => 'Soy...';

  @override
  String get finishMatchQ => '¿Terminar el duelo?';

  @override
  String get finishMatchBody =>
      'Tu volumen quedará fijado y se comparará con el de tu rival.';

  @override
  String get keepGoing => 'Seguir';

  @override
  String get forfeitQ => '¿Abandonar el duelo?';

  @override
  String get forfeitBody => 'Perderás PL si te vas ahora.';

  @override
  String get stay => 'Quedarme';

  @override
  String get forfeit => 'Abandonar';

  @override
  String get pickExercises => 'Elige los ejercicios que vas a entrenar';

  @override
  String matchingWith(String muscle) {
    return 'Buscando a alguien de tu rango · $muscle';
  }

  @override
  String get getReady => 'PREPÁRATE';

  @override
  String get timeLeft => 'TIEMPO RESTANTE';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit de volumen total';
  }

  @override
  String get finishMatch => 'TERMINAR DUELO';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'REPS';

  @override
  String get addSet => 'AÑADIR SERIE';

  @override
  String get matchComplete => 'DUELO COMPLETADO';

  @override
  String get you => 'TÚ';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'VOLVER AL INICIO';

  @override
  String get mgChest => 'Pecho';

  @override
  String get mgBack => 'Espalda';

  @override
  String get mgLegs => 'Piernas';

  @override
  String get mgShoulders => 'Hombros';

  @override
  String get mgArms => 'Brazos';

  @override
  String get mgCore => 'Core';

  @override
  String get achRivalry => 'Rivalidad';

  @override
  String get achRivalryHint => 'Vence al mismo rival 3 veces';

  @override
  String get nWonTitle => '¡Has ganado!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Venciste a $name en el día de $muscle';
  }

  @override
  String get nFriendTitle => 'Nueva solicitud de amistad';

  @override
  String nFriendBody(String name) {
    return '$name quiere conectar contigo';
  }

  @override
  String get nAchTitle => 'Logro desbloqueado';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => '¡Has subido de rango!';

  @override
  String nRankBody(String rank) {
    return 'Has alcanzado $rank';
  }

  @override
  String get nameTooShortInline => 'Elige un nombre de al menos 3 caracteres';

  @override
  String get whyName => 'Tus rivales lo verán junto a cada resultado';

  @override
  String get whyExperience => 'Te emparejamos con gente de tu nivel';

  @override
  String get whyGoal => 'De aquí salen tus primeros ejercicios sugeridos';

  @override
  String get whyAge =>
      'La edad influye en los estándares de fuerza con los que te medimos';

  @override
  String get whyWeight =>
      'El rango compara lo levantado en relación al peso corporal, no en kilos brutos';

  @override
  String get whyHeight => 'Se usa junto a tu peso para fijar estándares justos';

  @override
  String get whyHabits =>
      'Define los recordatorios y el objetivo semanal que te proponemos';

  @override
  String get transitionPartOfIt =>
      '...así que asegurémonos de que formas parte de verdad.';

  @override
  String get male => 'Hombre';

  @override
  String get female => 'Mujer';

  @override
  String get usernamePlaceholder => 'nombre';

  @override
  String get stRoutine =>
      'No sé qué parte del cuerpo necesita trabajo de verdad, así que suelo repetir la misma rutina';

  @override
  String get shortIn => 'in';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(String n) {
    return 'hace $n días';
  }

  @override
  String weeksAgo(String n) {
    return 'hace $n semanas';
  }

  @override
  String membersCount(String n) {
    return '$n miembros';
  }

  @override
  String eachCount(String n) {
    return '$n por persona';
  }

  @override
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get countWithCamera => 'Contar con la cámara';

  @override
  String get youWin => '¡GANASTE!';

  @override
  String get defeated => 'DERROTA';

  @override
  String get fillWholeNumbers => 'Rellena los tres con números enteros';

  @override
  String heightRange(String min, String max, String unit) {
    return 'La altura debe estar entre $min y $max $unit';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'El peso debe estar entre $min y $max $unit';
  }

  @override
  String ageRange(String min, String max) {
    return 'La edad debe estar entre $min y $max';
  }

  @override
  String get discPush => 'Push';

  @override
  String get discPull => 'Pull';

  @override
  String get discLegs => 'Legs';

  @override
  String get discPushHint => 'Chest, shoulders and triceps';

  @override
  String get discPullHint => 'Back and biceps';

  @override
  String get discLegsHint => 'Quads, hamstrings and core';

  @override
  String get pickYourThree => 'Pick your three';

  @override
  String get pickThreeHint =>
      'Both of you lift all six — your three and theirs';

  @override
  String roundOf(String n, String total) {
    return 'Round $n of $total';
  }

  @override
  String get rest => 'Rest';

  @override
  String get work => 'Work';

  @override
  String get nextUp => 'Next up';

  @override
  String picksLeft(String n) {
    return '$n left to pick';
  }

  @override
  String get yourPick => 'Your pick';

  @override
  String get theirPick => 'Their pick';

  @override
  String secondsOfWork(String n) {
    return '$n seconds of work';
  }

  @override
  String lpOutOf(String total) {
    return '/ $total PL';
  }

  @override
  String toPromotion(String n) {
    return '$n para ascender';
  }

  @override
  String get noFriendsTitle => 'Aún no tienes amigos';

  @override
  String get noFriendsBody =>
      'Añade a alguien y podrás retarle a un duelo privado cuando quieras.';

  @override
  String get noMatchesTitle => 'Aún no hay duelos';

  @override
  String get noMatchesBody => 'El primero aparecerá aquí, ganes o pierdas.';

  @override
  String get noNotificationsTitle => 'Nada nuevo';

  @override
  String get noNotificationsBody =>
      'Aquí llegan las invitaciones, los resultados y las solicitudes de amistad.';

  @override
  String roundDone(String n) {
    return 'Ronda $n completada';
  }

  @override
  String get bestRoundYet => 'Tu mejor ronda hasta ahora';
}
