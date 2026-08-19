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
  String lpProgress(int lp, int left) {
    return '$lp / 100 PL · $left para ascender';
  }

  @override
  String winStreak(int count) {
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
  String changeNameLeft(int total, int left) {
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
  String titlesAndStreak(int owned, int total, int streak) {
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
  String goalRemaining(int reps, int days) {
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
  String seasonResets(int days) {
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
  String yourFriends(int count) {
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
  String lpToGo(int lp) {
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
  String xOfY(int a, int b) {
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
  String winLoss(int w, int l) {
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
}
