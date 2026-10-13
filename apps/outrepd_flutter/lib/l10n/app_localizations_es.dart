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
  String get tabProfile => 'Perfil';

  @override
  String get challengeFriend => 'Retar a un amigo';

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
  String get settings => 'Ajustes';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get duelSection => 'Duelo';

  @override
  String get hapticsEachRep => 'Vibración en cada repetición';

  @override
  String get showSkeleton => 'Mostrar el esqueleto';

  @override
  String get showSkeletonHint => 'Así ves que la cámara te detecta';

  @override
  String get manageNotifications => 'Gestionar notificaciones';

  @override
  String switchesOn(String on, String all) {
    return '$on de $all activadas';
  }

  @override
  String get whoCanChallenge => 'Quién puede retarme';

  @override
  String get blockedAccounts => 'Cuentas bloqueadas';

  @override
  String get reportProblem => 'Informar de un problema';

  @override
  String get onDeviceNote =>
      'La detección de postura ocurre en este teléfono. No se sube ningún vídeo ni dato de postura.';

  @override
  String get visibilitySection => 'Visibilidad';

  @override
  String get showMyCountry => 'Mostrar mi país';

  @override
  String get showMyCountryHint =>
      'Al desactivarlo sales del tablero de tu país';

  @override
  String get safetySection => 'Seguridad';

  @override
  String get socialSection => 'Social';

  @override
  String get noticeRaced => 'Alguien retó mi serie';

  @override
  String get noticeRacedHint =>
      'La única forma de enterarte de que hubo un duelo';

  @override
  String get noticeFriendOk => 'Aceptaron mi solicitud';

  @override
  String get noticesStoredNote =>
      'Desactivar significa que no se guarda, no que se oculte.';

  @override
  String get notSaved => 'No se guardó';

  @override
  String get blockedIntro =>
      'Una cuenta bloqueada no puede retarte, encontrarte ni enviarte solicitudes. No se le avisa.';

  @override
  String blockedWhen(String when) {
    return 'Bloqueado $when';
  }

  @override
  String get unblock => 'Desbloquear';

  @override
  String get noBlockedTitle => 'Nadie bloqueado';

  @override
  String get noBlockedBody =>
      'Puedes bloquear a alguien desde su perfil o desde un informe.';

  @override
  String get whatHappened => 'Qué pasó';

  @override
  String get reasonCheating => 'Trampas o repeticiones falsas';

  @override
  String get reasonHarassment => 'Acoso o abuso';

  @override
  String get reasonContent => 'Contenido inapropiado';

  @override
  String get reasonImpersonation => 'Suplantación';

  @override
  String get reasonOther => 'Otra cosa';

  @override
  String get addDetails => 'Añadir detalles (opcional)';

  @override
  String get alsoBlock => 'Bloquear también esta cuenta';

  @override
  String get sendReport => 'Enviar informe';

  @override
  String get reportSent => 'Informe enviado';

  @override
  String get reportingThisAccount => 'Informando sobre esta cuenta';

  @override
  String get exportIntro =>
      'Te enviamos por correo un archivo con todo lo que el servidor guarda sobre ti. Suele tardar un minuto.';

  @override
  String get whatsIncluded => 'Qué incluye';

  @override
  String get incProfile => 'Tu perfil y rango';

  @override
  String get incSets => 'Cada serie y repetición';

  @override
  String get incDuels => 'Historial de duelos y cambios de LP';

  @override
  String get incFriends => 'Amigos y cuentas bloqueadas';

  @override
  String get incNotices => 'Notificaciones que recibiste';

  @override
  String get noLandmarksNote =>
      'Los puntos de postura no están ahí, ni lo estuvieron. La cámara los lee en tu teléfono y no se envían a ninguna parte.';

  @override
  String get sendItTo => 'Enviar a';

  @override
  String get emailHint => 'tu@ejemplo.com';

  @override
  String get createAccountTitle => 'Crear cuenta';

  @override
  String get createAccountBody =>
      'Añade un correo y una contraseña para que esta cuenta no dependa solo de este teléfono.';

  @override
  String get createAccountAction => 'Crear cuenta';

  @override
  String get emailTakenSwitchToSignIn =>
      'Ese correo ya tiene una cuenta — inicia sesión en su lugar.';

  @override
  String get emailSignUpInvalid =>
      'Revisa el correo y la contraseña — mínimo seis caracteres.';

  @override
  String get tooManyCodes =>
      'Se enviaron demasiados códigos — espera unos minutos e inténtalo de nuevo.';

  @override
  String get sendCodeAction => 'Enviar código';

  @override
  String get noAccountForEmail =>
      'No encontramos ninguna cuenta con ese correo.';

  @override
  String get authEntryTagline => 'Empuja. Compite. Sube de nivel.';

  @override
  String get signUpWithEmail => 'Regístrate con correo';

  @override
  String get alreadyHaveAccountQuestion => '¿Ya tienes cuenta?';

  @override
  String get logInAction => 'Iniciar sesión';

  @override
  String get createYourAccountTitle => 'Crea tu cuenta';

  @override
  String get createAccountSubtitle => 'Tarda menos de un minuto.';

  @override
  String get usernameLabel => 'Usuario';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get logInSubtitle => 'Inicia sesión para conservar tu rango.';

  @override
  String get checkYourEmailTitle => 'Revisa tu correo';

  @override
  String codeSentTo(String email) {
    return 'Enviamos un código de 6 dígitos a $email.';
  }

  @override
  String get didntGetIt => '¿No lo recibiste?';

  @override
  String resendInSeconds(String time) {
    return 'Reenviar en $time';
  }

  @override
  String get wrongEmailGoBack => '¿Correo incorrecto? Volver';

  @override
  String get usernameTaken => 'Ese nombre de usuario ya está en uso.';

  @override
  String get wrongCode => 'Ese código es incorrecto o ha caducado.';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get codeResent => 'Enviamos un código nuevo.';

  @override
  String signedInAs(String email) {
    return 'Sesión iniciada como $email';
  }

  @override
  String get addressNotKept =>
      'La dirección se usa una vez y no se guarda: esta cuenta no tiene correo.';

  @override
  String get requestMyData => 'Enviarme mis datos';

  @override
  String exportSent(String address) {
    return 'Enviado a $address';
  }

  @override
  String get deleteIntro =>
      'Esto borra todo de forma permanente. No se puede deshacer ni restaurar.';

  @override
  String get rankLabel => 'Rango';

  @override
  String get wantCopyFirst => '¿Quieres una copia antes?';

  @override
  String get wantCopyBody =>
      'Descarga tus datos antes de borrar. Después ya no estarán.';

  @override
  String typeToConfirm(String word) {
    return 'Escribe $word para confirmar';
  }

  @override
  String get deleteWord => 'BORRAR';

  @override
  String get deletePermanently => 'Borrar para siempre';

  @override
  String get keepMyAccount => 'Conservar mi cuenta';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get skip => 'Omitir';

  @override
  String get yourPicture => 'Tu foto';

  @override
  String get yourPictureHint =>
      'El marco viene de tu rango y cambia según subes.';

  @override
  String get couldNotUsePicture => 'No se pudo usar esa imagen';

  @override
  String get couldNotSyncAvatar =>
      'Tu foto se guardó, pero aún no se ha sincronizado';

  @override
  String get couldNotShareCard => 'No se pudo compartir esta tarjeta';

  @override
  String get couldNotOpenLink => 'No se pudo abrir ese enlace';

  @override
  String get couldNotCheckUsername =>
      'No se pudo comprobar ese nombre: inténtalo de nuevo';

  @override
  String get changeUsername => 'Cambiar nombre de usuario';

  @override
  String get usernameInvalidLength =>
      'Debe tener de 4 a 20 caracteres, solo letras, números y _';

  @override
  String get usernameChanged => 'Nombre de usuario cambiado';

  @override
  String get usernameAlreadyChangedBody =>
      'Ya has usado tu único cambio de nombre de usuario — cada cuenta recibe exactamente uno.';

  @override
  String get gallery => 'Galería';

  @override
  String get camera => 'Cámara';

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
  String get global => 'Global';

  @override
  String get topPlayers => 'Mejores jugadores';

  @override
  String get yourTier => 'Tu nivel';

  @override
  String get challenge => 'Retar';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get start => 'Empezar';

  @override
  String get finish => 'Terminar';

  @override
  String get reps => 'reps';

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
  String get language => 'Idioma';

  @override
  String get privacy => 'Privacidad';

  @override
  String get data => 'Datos';

  @override
  String get about => 'Acerca de';

  @override
  String get themeSystem => 'Como el dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get accept => 'Aceptar';

  @override
  String get visEveryone => 'Todos';

  @override
  String get visFriends => 'Solo amigos';

  @override
  String get visNobody => 'Nadie';

  @override
  String get friendRequestsLabel => 'Solicitudes de amistad';

  @override
  String get showOnLeaderboards => 'Mostrarme en las clasificaciones';

  @override
  String get exportData => 'Exportar mis datos';

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
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get needsServer =>
      'No se pudo conectar. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get roomFriendly =>
      'Los duelos de sala son amistosos: no afectan a tu rango.';

  @override
  String get shareThisCode => 'Comparte este código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Hierro';

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
  String winLoss(String w, String l) {
    return '${w}V ${l}D';
  }

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
  String get ttl_bronze_tier => 'Fuera del Hierro';

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
  String get forfeitQ => '¿Abandonar el duelo?';

  @override
  String get forfeitBody => 'Perderás PL si te vas ahora.';

  @override
  String get stay => 'Quedarme';

  @override
  String get forfeit => 'Abandonar';

  @override
  String get getReady => 'PREPÁRATE';

  @override
  String get you => 'TÚ';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'VOLVER AL INICIO';

  @override
  String get mgChest => 'Pecho';

  @override
  String get nWonTitle => '¡Has ganado!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Venciste a $name en el día de $muscle';
  }

  @override
  String get nFriendTitle => 'Nueva solicitud de amistad';

  @override
  String get nRacedTitle => 'Retaron tu serie';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name retó tu serie y no llegó, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name retó tu serie y ganó, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Solicitud aceptada';

  @override
  String nFriendOkBody(String name) {
    return '$name aceptó tu solicitud';
  }

  @override
  String nFriendBody(String name) {
    return '$name quiere conectar contigo';
  }

  @override
  String get nChallengedTitle => 'Revancha';

  @override
  String nChallengedBody(String name) {
    return '$name quiere la revancha';
  }

  @override
  String get challengeSentTitle => 'Desafío enviado';

  @override
  String challengeSentBody(String name) {
    return 'Avisaremos a $name. Vuelve cuando lo haya corrido.';
  }

  @override
  String get challengeNotSentTitle => 'No se pudo enviar';

  @override
  String get challengeNotSentBody =>
      'Comprueba tu conexión e inténtalo de nuevo desde la pestaña de partidas.';

  @override
  String get challengeGoneTitle => 'El desafío ya no está';

  @override
  String get challengeGoneBody => 'Ya se ha corrido, o fue retirado.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps repeticiones registradas';
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
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get lpUnit => 'PL';

  @override
  String get trueCountHint => 'p. ej. 12';

  @override
  String get couldNotSaveSession => 'No se pudo guardar la sesión';

  @override
  String lpOutOf(String total) {
    return '/ $total PL';
  }

  @override
  String get noFriendsTitle => 'Aún no tienes amigos';

  @override
  String get noFriendsBody =>
      'Un duelo contra alguien que conoces se siente distinto.';

  @override
  String get decline => 'Rechazar';

  @override
  String requestSent(String name) {
    return 'Solicitud enviada a $name';
  }

  @override
  String nowFriends(String name) {
    return 'Ahora $name y tú sois amigos';
  }

  @override
  String get noOneFound => 'Nadie se llama así';

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
  String get countedThat => 'Contado en esta ronda';

  @override
  String get thatIsRight => 'Correcto';

  @override
  String get useMyCount => 'Usar mi cuenta';

  @override
  String get confirmHint => 'Cámbialo si la cámara se equivocó.';

  @override
  String get unsureMovement =>
      'No estoy seguro de que fuera el movimiento correcto: revisa el número.';

  @override
  String get noRanksYet => 'Aún no hay clasificación';

  @override
  String get noRanksYetBody => 'Juega un duelo y la tabla se llena.';

  @override
  String get ranksTitle => 'Rangos';

  @override
  String get totalReps => 'Repeticiones totales';

  @override
  String get recent => 'Recientes';

  @override
  String wonVs(String name) {
    return 'Victoria contra ${name}';
  }

  @override
  String lostVs(String name) {
    return 'Derrota contra ${name}';
  }

  @override
  String hoursAgo(String n) {
    return 'hace ${n} h';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${n} para ${tier}';
  }

  @override
  String get noMatchesYet => 'Aún no hay duelos';

  @override
  String get noMatchesYetBody => 'El primero aparecerá aquí, ganes o pierdas.';

  @override
  String get searchByUsername => 'Buscar por nombre de usuario';

  @override
  String get incomingRequests => 'Solicitudes recibidas';

  @override
  String get noRequestsWaiting => 'No hay solicitudes pendientes ahora mismo';

  @override
  String get addFriendAction => 'Añadir amigo';

  @override
  String get addFriendHint =>
      'Escribe su nombre de usuario o el código # de su perfil.';

  @override
  String get usernameOrCode => 'Usuario o código #';

  @override
  String get sendRequest => 'Enviar solicitud';

  @override
  String onlineNowCount(String count) {
    return 'En línea · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Desconectados · $count';
  }

  @override
  String get invite => 'Invitar';

  @override
  String get headToHeadTitle => 'Cara a cara';

  @override
  String get vsYouCaption => 'contra ti';

  @override
  String get h2hYou => 'tú';

  @override
  String get h2hThem => 'él';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}V ${losses}D contra ti';
  }

  @override
  String get neverPlayedYou => 'Nunca ha jugado contigo';

  @override
  String noHistoryWithThem(String username) {
    return 'Aún no has competido contra $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Última vez: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Tu mejor marca contra ellos es $reps.';
  }

  @override
  String get viewFullProfile => 'Ver perfil completo';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String get block => 'Bloquear';

  @override
  String get blockRowBody => 'No podrá retarte ni ver tu perfil';

  @override
  String get report => 'Reportar';

  @override
  String get reportRowBody => 'Se revisa en 24 horas';

  @override
  String muteChallenges(String username) {
    return 'Silenciar retos de $username';
  }

  @override
  String blockedLifter(String username) {
    return 'Bloqueaste a $username';
  }

  @override
  String mutedLifter(String username) {
    return 'Silenciaste a $username';
  }

  @override
  String get addFriendButton => 'Añadir amigo';

  @override
  String get alreadyFriends => 'Amigos';

  @override
  String get couldNotLoadProfile => 'No se pudo cargar este perfil';

  @override
  String get noFriendsMatch => 'Nadie con ese nombre';

  @override
  String get yourClimb => 'Tu ascenso';

  @override
  String floorKept(String tier, String rank) {
    return '$tier es tuyo. Ya no bajas de $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count días seguidos';
  }

  @override
  String get findMatch => 'Buscar partida';

  @override
  String rankedTerms(String seconds) {
    return '$seconds segundos · clasificatoria';
  }

  @override
  String get practiceTerms => 'Practicar — sin rango, sin rival';

  @override
  String get practiceComplete => 'PRÁCTICA COMPLETA';

  @override
  String get noRankYet => 'Aún sin rango';

  @override
  String placementsForFirstTier(String count) {
    return 'Termina $count duelos de colocación para ganar tu primer rango.';
  }

  @override
  String get startPlacements => 'Empezar colocación';

  @override
  String get unranked => 'Sin rango';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done de $total · $seconds segundos cada uno';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done de $total · $left más para tu rango';
  }

  @override
  String placementsForTier(String count) {
    return 'Termina $count duelos de colocación para ver dónde quedas.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done de $total colocaciones completadas';
  }

  @override
  String get practiceFirst => 'Practicar primero';

  @override
  String get nextPlacement => 'Siguiente colocación';

  @override
  String get noConnection => 'Sin conexión';

  @override
  String get practiceOffline => 'Practicar sin conexión';

  @override
  String get retry => 'Reintentar';

  @override
  String get youWonPlain => 'Ganaste';

  @override
  String get cameraNeededTitle => 'Se necesita la cámara';

  @override
  String get cameraNeededBody =>
      'outrepd cuenta tus repeticiones mirando cómo se mueve tu cuerpo. La detección ocurre en tu dispositivo y no se sube nada.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get allowCamera => 'Permitir cámara';

  @override
  String get notNow => 'Ahora no';

  @override
  String get noCameraTitle => 'No hay cámara';

  @override
  String get noCameraBody =>
      'Las repeticiones se cuentan con la cámara, así que este dispositivo no puede puntuar un duelo. Lo demás sigue funcionando.';

  @override
  String get noConnectionBody =>
      'Necesitas conexión para competir. Practicar funciona sin conexión y tus repeticiones se sincronizarán luego.';

  @override
  String get getBackInFrame => 'Vuelve al encuadre';

  @override
  String get clockStillRunning =>
      'El reloj sigue corriendo. No se está contando.';

  @override
  String get giveUp => 'Rendirse';

  @override
  String get lpMovesWithGap =>
      'Los PL se mueven según la diferencia de repeticiones: gana por más, suma más';

  @override
  String get searchingForOpponent => 'Buscando rival';

  @override
  String get getIntoPosition => 'Ponte en posición';

  @override
  String get framingHint => 'Muñecas y tobillos deben verse';

  @override
  String get goUp => 'Sube';

  @override
  String get goDown => 'Baja';

  @override
  String get bestSet => 'Mejor serie';

  @override
  String get record => 'Registro';

  @override
  String get last7Days => 'Últimos 7 días';

  @override
  String repsCount(String count) {
    return '$count reps';
  }

  @override
  String get viewAll => 'Ver todo';

  @override
  String get shareProfile => 'Compartir perfil';

  @override
  String get share => 'Compartir';

  @override
  String get duelMeOnOutrepd => 'Retame en outrepd';

  @override
  String get shareStory => 'Historia';

  @override
  String get sharePost => 'Publicación';

  @override
  String get copyLink => 'Copiar';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String get currentRankLabel => 'Rango actual';

  @override
  String get winInitial => 'V';

  @override
  String get lossInitial => 'D';

  @override
  String get dayInitial => 'd';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Duelos de flexiones. Tu móvil cuenta. Alguien más también está contando.';

  @override
  String get obGetStarted => 'Empezar';

  @override
  String get obHaveAccount => 'Ya tengo cuenta';

  @override
  String get obTwoThings => 'Dos cosas rápidas.';

  @override
  String get obAgeQuestion => '¿Cuántos años tienes?';

  @override
  String get obUnder16 => 'Menos de 16';

  @override
  String get obOver16 => '16 o más';

  @override
  String get obHealthConsent =>
      'Entiendo que outrepd cuenta repeticiones y no da consejos médicos ni de entrenamiento. Pararé si algo me duele.';

  @override
  String get obTermsIntro => 'Al continuar aceptas los';

  @override
  String get obTerms => 'Términos';

  @override
  String get obAnd => 'y la';

  @override
  String get obPrivacy => 'Política de Privacidad';

  @override
  String get obUnder16Blocked =>
      'outrepd es para mayores de 16. Vuelve cuando llegues — las flexiones seguirán aquí.';

  @override
  String get obCameraTitle => 'outrepd necesita tu cámara';

  @override
  String get obCameraBody =>
      'Mira cómo se mueve tu cuerpo para contar. No hay otra forma.';

  @override
  String get obCameraPrivateTitle => 'Nada sale de tu móvil';

  @override
  String get obCameraPrivateBody =>
      'El seguimiento corporal se hace en este dispositivo. Nunca se guarda ni se sube ningún vídeo.';

  @override
  String get obWhyNeeded => '¿Por qué hace falta?';

  @override
  String get obPlacementTitle => 'Pon el móvil en el suelo';

  @override
  String get obPlacementBody =>
      'Recuéstalo contra una pared, a un metro de ti más o menos.';

  @override
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'todo el cuerpo en el encuadre';

  @override
  String get obCheckHandsFeet => 'Manos y pies visibles';

  @override
  String get obCheckFacing => 'De frente al móvil, no de lado';

  @override
  String get obCheckLight => 'Luz encendida';

  @override
  String get obImSetUp => 'Ya está listo';

  @override
  String get obFramingTitle => 'Ponte en posición de flexión';

  @override
  String get obFramingShoulders => 'Hombros y cadera';

  @override
  String get obFramingWrists => 'Muñecas';

  @override
  String get obFramingAnkles => 'Tobillos';

  @override
  String get obLooksGood => 'Se ve bien';

  @override
  String get obCalibrating => 'Calibrando';

  @override
  String get obOneMoreRep => 'Una más para conocer tu recorrido';

  @override
  String get obCalibrationHint =>
      'Haz tres flexiones con tu profundidad normal';

  @override
  String get obCalibrated => 'Calibrado.';

  @override
  String get obCalibratedBody =>
      'outrepd ya conoce tu recorrido. La profundidad se mide contigo, no con un número fijo.';

  @override
  String get obRepsCounted => 'Repeticiones contadas';

  @override
  String get obAverageDepth => 'Profundidad media';

  @override
  String get obForm => 'Técnica';

  @override
  String get obFormClean => 'Limpia';

  @override
  String get obAvailable => 'Disponible';

  @override
  String get obTaken => 'Ocupado';

  @override
  String get obGotIt => 'Entendido';

  @override
  String get obFormMixed => 'Irregular';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String get counterAccuracy => 'Precisión del contador';

  @override
  String get counterAccuracyCaption => 'Cuánto se acerca la cámara';

  @override
  String measuredOverSets(String count) {
    return 'Medido en $count series';
  }

  @override
  String get accExact => 'Exacto';

  @override
  String get accWithinOne => '±1 repetición';

  @override
  String get accAverageMiss => 'Error medio';

  @override
  String get accTendsTo => 'Tiende a';

  @override
  String get accCountsHigh => 'contar de más';

  @override
  String get accCountsLow => 'contar de menos';

  @override
  String get accCountsEven => 'ni de más ni de menos';

  @override
  String get accWorstMiss => 'Mayor error';

  @override
  String get accNothingYet => 'Aún no hay medidas';

  @override
  String get accNothingYetBody =>
      'Cada vez que confirmas el conteo tras un duelo, esa serie se compara con lo que dijiste. El número aparece aquí.';

  @override
  String accNeedMore(String count) {
    return 'Es pronto. Unas $count series más para que este número diga algo.';
  }

  @override
  String get accRecentSets => 'Últimas series';

  @override
  String get accCameraSaid => 'Cámara';

  @override
  String get accYouSaid => 'Tú';

  @override
  String get accHowItWorks =>
      'Esto viene de ti, en este móvil. No se envía nada a ningún sitio.';

  @override
  String levelNumber(String n) {
    return 'Nivel $n';
  }

  @override
  String get youLostPlain => 'Perdiste';

  @override
  String get rematch => 'Revancha';

  @override
  String get shareAction => 'Compartir';

  @override
  String get doneAction => 'Listo';

  @override
  String get continueAction => 'Continuar';

  @override
  String get promotedLabel => 'Ascendido';

  @override
  String get highestReached => 'Lo más alto que has llegado';

  @override
  String repsOff(String n) {
    return 'A $n repeticiones.';
  }

  @override
  String get closestYet => 'El duelo más ajustado hasta ahora.';

  @override
  String repsAhead(String n) {
    return '$n repeticiones de ventaja.';
  }

  @override
  String get winnerLabel => 'Ganador';

  @override
  String get newPersonalBest => 'Nuevo récord personal';

  @override
  String get cantReachServer =>
      'No se pudo conectar con el servidor. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Flexiones en $seconds segundos';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Le gané a $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Perdí contra $name $score';
  }

  @override
  String get thinkYouCanBeatMe => '¿Crees que puedes ganarme?';

  @override
  String get usernameNotAllowed =>
      'Ese nombre no está permitido. Prueba con otro.';

  @override
  String get yourBest => 'Tu récord';

  @override
  String get theClock => 'El reloj';

  @override
  String get nobodyFreeRaceBest =>
      'Ahora no hay nadie libre cerca de tu rango. Compite contra tu récord. Esta ronda no cambia tu rango.';

  @override
  String get nobodyFreeFirstScore =>
      'Ahora no hay nadie libre cerca de tu rango. Marca tu primer récord. Esta ronda no cambia tu rango.';

  @override
  String bestStillIs(String count) {
    return 'Tu récord sigue siendo $count';
  }

  @override
  String get setInPoolTitle => 'Tu serie está en la cola';

  @override
  String get setInPoolBody =>
      'El próximo atleta cerca de tu rango competirá contra ella. Verás quién ganó en Notificaciones y entonces cambiará tu rango.';

  @override
  String get obWhyNeededBody =>
      'Cada repetición se valora por cuánto bajan y suben tus hombros, y solo la cámara puede verlo. Sin ella no hay conteo, y sin conteo no hay duelo. La cámara solo se enciende durante una serie.';

  @override
  String get obWelcomeBack => 'Bienvenido de nuevo';

  @override
  String obTitlesHeading(String count) {
    return '$count títulos por ganar';
  }

  @override
  String get obTitlesBody =>
      'Por victorias, rachas, series limpias, madrugones y más. Lleva uno bajo tu nombre.';

  @override
  String get obFriendsHeading => 'Resuélvelo con tus amigos';

  @override
  String get obFriendsBody =>
      'Tus amigos te añaden con este código. Rétalos cuando quieras y el marcador entre vosotros queda guardado.';

  @override
  String get obLetsGo => 'Vamos';

  @override
  String get paywallTitle => 'Sube de Hierro a Maestro';

  @override
  String get paywallPerkDuels => 'Duelos arbitrados por la cámara';

  @override
  String get paywallPerkLadder => 'Clasificación en vivo';

  @override
  String get paywallPerkFriends => 'Amigos y desafíos';

  @override
  String get paywallPerkHistory => 'Cada repetición de cada combate';

  @override
  String get paywallYearly => 'Anual';

  @override
  String get paywallWeekly => 'Semanal';

  @override
  String paywallPerWeek(String price) {
    return '${price}/semana';
  }

  @override
  String get paywallEveryWeek => 'por semana';

  @override
  String paywallSave(String percent) {
    return 'Ahorra ${percent}%';
  }

  @override
  String get paywallStart => 'Empieza a subir';

  @override
  String get paywallRenewsPlay => 'Se renueva automáticamente hasta que canceles. Cancela cuando quieras en Google Play.';

  @override
  String get paywallRenewsApple => 'Se renueva automáticamente hasta que canceles. Cancela cuando quieras en los ajustes de tu cuenta de Apple.';

  @override
  String get paywallRestore => 'Restaurar';

  @override
  String get paywallTerms => 'Términos';

  @override
  String get paywallPrivacy => 'Privacidad';

  @override
  String get paywallLoadFailed => 'No se pudieron cargar los planes. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get paywallBuyFailed => 'La compra no se completó. Inténtalo de nuevo.';

  @override
  String get paywallPending => 'Tu pago está pendiente. Todo se desbloquea en cuanto la tienda lo confirme.';

  @override
  String get paywallNothingToRestore => 'No se encontró ninguna suscripción para restaurar.';

  @override
  String get paywallRestored => 'Suscripción restaurada';

  @override
  String paywallSignedInAs(String email) {
    return 'Sesión iniciada como ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Eliminar tu cuenta no cancela tu suscripción: la cobra la tienda, no outrepd. Cancélala antes en Google Play o en los ajustes de tu cuenta de Apple.';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutQuestion => '¿Cerrar sesión?';

  @override
  String get signOutBody => 'Tu cuenta queda como está, con su rango, su historial y su suscripción. Vuelve a entrar cuando quieras con tu correo.';

  @override
  String get shareVictory => 'VICTORIA';

  @override
  String get shareRematch => '¿REVANCHA?';

  @override
  String friendCodeInvite(String code) {
    return 'Rétame en outrepd. Agrégame con mi código de amigo ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Sonidos';

  @override
  String get soundsHint => 'Un pitido en 3, 2, 1, un tic por cada repetición y el final de la ronda. Suena sobre tu música.';

  @override
  String get phoneSection => 'En este teléfono';

  @override
  String get allowNotifications => 'Permitir notificaciones';

  @override
  String get allowNotificationsHint => 'Están desactivadas para OUTREPD en los ajustes del teléfono, así que nada de lo de abajo te llegará.';

  @override
  String get remindersSection => 'Recordatorio';

  @override
  String get dailyReminder => 'Recordatorio diario';

  @override
  String get dailyReminderHint => 'Solo los días en que aún no has cumplido tu meta.';

  @override
  String get reminderTime => 'Hora';

  @override
  String get reminderTitle => 'Hora de las flexiones de hoy';

  @override
  String reminderStreakBody(String count) {
    return 'Mantén tu racha de ${count} días. Basta con una serie.';
  }

  @override
  String get channelMatches => 'Partidas y amigos';

  @override
  String get channelReminders => 'Recordatorio diario';

  @override
  String get liveTag => 'En vivo';

  @override
  String get reconnecting => 'Reconectando';

  @override
  String get rankedLive => 'Clasificatoria · en vivo';

  @override
  String get lookingForLive => 'Buscando un rival en vivo';

  @override
  String ofTime(String time) {
    return 'de ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'A los ${time} competirás contra una serie guardada';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} está frente a la cámara ahora. Mismo reloj, misma salida.';
  }

  @override
  String get nobodyLiveTitle => 'Nadie está en vivo ahora';

  @override
  String get nobodyLiveBody => 'Competirás contra una serie guardada';

  @override
  String didRepsIn(String reps) {
    return 'Hizo ${reps} en 60 segundos';
  }

  @override
  String get sameRankPoints => 'Los mismos puntos de rango que en vivo';

  @override
  String get raceIt => 'Competir';

  @override
  String get onlineNow => 'En línea ahora';

  @override
  String get friendlyNoRank => 'Amistoso · sin rango';

  @override
  String waitingForName(String name) {
    return 'Esperando a ${name}';
  }

  @override
  String get weSentThemANotice => 'Le enviamos una notificación';

  @override
  String get untilInviteRunsOut => 'hasta que caduque la invitación';

  @override
  String get cancelInvite => 'Cancelar invitación';

  @override
  String inviteDeclined(String name) {
    return '${name} dijo que ahora no';
  }

  @override
  String get inviteRanOut => 'La invitación caducó';

  @override
  String get inviteAgain => 'Invitar de nuevo';

  @override
  String liveInviteFrom(String name) {
    return '${name} está en vivo';
  }

  @override
  String timeLeft(String time) {
    return 'Quedan ${time}';
  }

  @override
  String get joinLive => 'Unirme';

  @override
  String get nLiveTitle => 'Invitación en vivo';

  @override
  String nLiveBody(String name) {
    return '${name} quiere competir en vivo';
  }

  @override
  String get inviteGone => 'Esa invitación ya caducó';

  @override
  String opponentDropped(String name) {
    return 'La conexión de ${name} se cayó. Sigue: la ronda termina con el reloj.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} se rindió. Termina la ronda para llevarte la victoria.';
  }

  @override
  String get calledOffTitle => 'Partida cancelada';

  @override
  String calledOffBody(String name) {
    return '${name} no se puso en posición a tiempo. No se registró nada.';
  }

  @override
  String waitingForFinal(String name) {
    return 'Esperando el conteo final de ${name}…';
  }

  @override
  String get wantsToBeFriends => 'quiere ser tu amigo';

  @override
  String get giveUpQuestion => '¿Rendirte en esta ronda?';

  @override
  String get giveUpBody => 'Cuenta como derrota, sea cual sea tu conteo ahora.';

  @override
  String waitingToJoin(String name) {
    return 'Esperando a que ${name} entre';
  }

  @override
  String get removeFriend => 'Eliminar amigo';

  @override
  String get removeFriendBody => 'No se le avisa, y podrán volver a agregarse';

  @override
  String removeFriendQuestion(String username) {
    return '¿Eliminar a ${username} de tus amigos?';
  }

  @override
  String get removeAction => 'Eliminar';

  @override
  String removedFriend(String username) {
    return 'Eliminaste a ${username} de tus amigos';
  }

  @override
  String get noticeChallenged => 'Alguien me retó a una revancha';

  @override
  String get noticeLiveInvite => 'Un amigo me invitó a un duelo en vivo';

  @override
  String trialHeadline(String days) {
    return 'Tus primeros ${days} días son *gratis*';
  }

  @override
  String get trialToday => 'Hoy';

  @override
  String get trialTodayBody => 'Todos los duelos, en vivo y clasificatorios, desbloqueados.';

  @override
  String trialDay(String day) {
    return 'Día ${day}';
  }

  @override
  String get trialReminderBody => 'Te avisaremos el día antes de que termine tu prueba.';

  @override
  String get trialEndBody => 'Empieza tu plan. Cancela antes y no pagas nada.';

  @override
  String trialTag(String days) {
    return '${days} días gratis';
  }

  @override
  String trialCta(String days) {
    return 'Empezar mi prueba gratis de ${days} días';
  }

  @override
  String trialThenYearly(String price) {
    return 'Sin pago ahora · luego ${price}/año';
  }

  @override
  String trialThenWeekly(String price) {
    return 'Sin pago ahora · luego ${price}/semana';
  }

  @override
  String get trialEndsTitle => 'Tu prueba gratis termina mañana';

  @override
  String get trialEndsBody => 'Sigue subiendo, o cancela antes en los ajustes de tu suscripción.';

  @override
  String get obIdeaTitle => '60 segundos. Un rival.';

  @override
  String get obIdeaRival => 'Una persona real, en directo o su serie grabada';

  @override
  String get obIdeaCamera => 'Tu cámara cuenta cada repetición, en tu móvil';

  @override
  String get thisMonth => 'Este mes';

  @override
  String shortDays(String n) {
    return '${n} d';
  }

  @override
  String shortHours(String n) {
    return '${n} h';
  }

  @override
  String get awardChampion => 'Campeón';

  @override
  String get awardPodium => 'Podio';

  @override
  String get awardTop10 => 'Top 10';

  @override
  String get awardRegular => 'Club 20';

  @override
  String monthToTop10(String lp) {
    return 'A ${lp} LP del top 10';
  }

  @override
  String monthIfEndedNow(String award) {
    return '${award} si el mes acabara ahora';
  }

  @override
  String get monthJoinHint => 'Juega un duelo clasificatorio para entrar en la tabla del mes';

  @override
  String monthRegularProgress(String progress) {
    return 'Insignia Club 20 · ${progress} duelos clasificatorios';
  }

  @override
  String get monthRegularEarned => 'Insignia Club 20 ganada este mes';

  @override
  String get monthEmptyTitle => 'Un mes nuevo';

  @override
  String get monthEmptyBody => 'Nadie ha ganado LP este mes todavía. Gana el primer duelo clasificatorio y vas primero.';

  @override
  String rankedDuelsCount(String n) {
    return '${n} duelos clasificatorios';
  }

  @override
  String get monthlyAwards => 'Premios mensuales';

  @override
  String get seasonOver => 'Temporada terminada';

  @override
  String get seasonOverBody => 'Ya está en tu perfil. El nuevo mes empieza de cero.';

  @override
  String get seasonPlayCta => 'Jugar el nuevo mes';

  @override
  String get rematchLive => 'Revancha en vivo';

  @override
  String rematchWaiting(String name) {
    return 'Esperando a ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} quiere la revancha';
  }

  @override
  String get rematchGone => 'Esta vez no hay revancha';

  @override
  String get twoRankedADay => 'Amistoso · 2 clasificatorios al día con el mismo rival';

  @override
  String monthMove(String move) {
    return 'Este mes · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return 'desde ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} en línea ahora';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} buscando';
  }

  @override
  String get inviteCodeLabel => 'Código de un amigo (opcional)';

  @override
  String get inviteClaimed => 'Código añadido · tienes 7 días gratis';

  @override
  String get inviteUnknownCode => 'Ningún usuario tiene ese código';

  @override
  String get inviteNotYearly => 'Ese código no puede dar días gratis ahora';

  @override
  String get inviteOwnCode => 'Ese es tu propio código';

  @override
  String get inviteTooLate => 'Los códigos funcionan la primera semana de la cuenta';

  @override
  String get inviteFull => 'Ese código se ha usado mucho este mes. Prueba otro';

  @override
  String get inviteTitle => 'Regala a un amigo 7 días gratis';

  @override
  String get inviteBody => 'Tu código viene con el plan anual. Tu amigo lo escribe al registrarse.';

  @override
  String get inviteYourCode => 'Tu código';

  @override
  String inviteJoined(String n) {
    return '${n} se unieron';
  }

  @override
  String get inviteSend => 'Enviar invitación';

  @override
  String inviteShareText(String code) {
    return 'Rétame en OUTREPD: 60 segundos de flexiones, en vivo. Usa mi código ${code} al registrarte y consigue 7 días gratis.';
  }

  @override
  String get dailyGoalTitle => 'Objetivo de hoy';

  @override
  String get dailyGoalDone => 'Listo por hoy';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} flexiones';
  }

  @override
  String dailyGoalLeft(String n) {
    return 'faltan ${n}';
  }

  @override
  String get dailyGoalChange => 'Cambiar';

  @override
  String get dailyGoalPick => 'Tu objetivo diario';

  @override
  String dailyGoalOption(String n) {
    return '${n} flexiones al día';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'de ${goal} hoy';
  }

  @override
  String get saveToAppleHealth => 'Guardar entrenamientos en Salud de Apple';

  @override
  String get saveToHealthConnect => 'Guardar entrenamientos en Health Connect';

  @override
  String get saveToHealthHint => 'Cada serie se añade como entrenamiento de fuerza. No se lee nada.';

  @override
  String get healthNotAllowed => 'Aún no está permitido. Puedes permitirlo en los ajustes de salud del teléfono.';

  @override
  String reminderLeft(String count) {
    return 'Te faltan ${count} flexiones para tu meta de hoy.';
  }

  @override
  String get liveInviteHint => 'Los amigos en línea pueden unirse al momento. Los demás reciben un aviso y un minuto para unirse.';

  @override
  String get requestSentShort => 'Solicitud enviada';
}
