// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LPt extends L {
  LPt([String locale = 'pt']) : super(locale);

  @override
  String get tabFriends => 'Amigos';

  @override
  String get tabRanks => 'Ranques';

  @override
  String get tabMatch => 'Duelo';

  @override
  String get tabCrew => 'Equipa';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get searchOpponent => 'Procurar adversário';

  @override
  String get searchOpponentHint => 'Encontramos alguém do teu ranque';

  @override
  String get challengeFriend => 'Desafiar um amigo';

  @override
  String get trainWithCamera => 'Treinar com a câmara';

  @override
  String get viewRoadmap => 'Ver o percurso';

  @override
  String lpProgress(String lp, String left) {
    return '$lp / 100 PL · faltam $left para subir';
  }

  @override
  String winStreak(String count) {
    return '$count vitórias seguidas';
  }

  @override
  String get matchHistory => 'Histórico de duelos';

  @override
  String get allMatches => 'Todos os duelos';

  @override
  String get wins => 'Vitórias';

  @override
  String get losses => 'Derrotas';

  @override
  String get winRate => 'Taxa de vitórias';

  @override
  String get streak => 'Sequência';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Definições';

  @override
  String get stats => 'Estatísticas';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get skip => 'Ignorar';

  @override
  String get totalMatches => 'Duelos no total';

  @override
  String get bestWinStreak => 'Melhor sequência';

  @override
  String get totalVolume => 'Volume total levantado';

  @override
  String get height => 'Altura';

  @override
  String get bodyweight => 'Peso corporal';

  @override
  String get age => 'Idade';

  @override
  String get editYourStats => 'Editar os teus dados';

  @override
  String get editStatsHint =>
      'Vitórias, volume e ranque conquistam-se — não se escrevem.';

  @override
  String get changeName => 'Mudar o nome';

  @override
  String get changeNameLast =>
      'Esta é a tua última mudança. Não dá para voltar atrás.';

  @override
  String changeNameLeft(String total, String left) {
    return 'Tens $total mudanças no total. Ficam $left depois desta.';
  }

  @override
  String get changeNameUsedUp => 'Já usaste as tuas duas mudanças de nome';

  @override
  String get yourPicture => 'A tua foto';

  @override
  String get yourPictureHint =>
      'A moldura vem do teu ranque e muda à medida que sobes.';

  @override
  String get gallery => 'Galeria';

  @override
  String get camera => 'Câmara';

  @override
  String get orPickOurs => 'Ou escolhe um dos nossos';

  @override
  String get awards => 'Prémios';

  @override
  String get yourTitles => 'Os teus títulos';

  @override
  String get stillToEarn => 'Ainda por conquistar';

  @override
  String get noTitlesYet => 'Nenhum ainda. O primeiro só precisa de um duelo.';

  @override
  String get wearHint =>
      'Toca num para o usar. Aparece ao lado do teu nome em todo o lado onde te vejam.';

  @override
  String get worn => 'em uso';

  @override
  String get titleUnlocked => 'Título desbloqueado';

  @override
  String get wearIt => 'Usar';

  @override
  String get wearItLater => 'Mais tarde';

  @override
  String get dayStreak => 'dias seguidos';

  @override
  String get bestEver => 'Melhor de sempre';

  @override
  String get restDaysLeft => 'Dias de descanso';

  @override
  String get restIsTraining =>
      'Descansar faz parte do treino. Dois dias de folga por semana não quebram a tua sequência.';

  @override
  String titlesAndStreak(String owned, String total, String streak) {
    return '$owned de $total títulos · sequência de $streak dias';
  }

  @override
  String get crew => 'Equipa';

  @override
  String get myCrew => 'A minha equipa';

  @override
  String get rankings => 'Classificação';

  @override
  String get trainWithCrew => 'Treina com uma equipa';

  @override
  String get trainWithCrewHint =>
      'Até 20 atletas sob o mesmo nome, com uma meta semanal em comum e um lugar a subir na tabela.';

  @override
  String get createCrew => 'Criar uma equipa';

  @override
  String get createCrewHint =>
      'Dá-lhe um nome, escolhe um emblema e convida os teus';

  @override
  String get joinOpenCrew => 'Entrar numa equipa aberta';

  @override
  String get joinOpenCrewHint => 'Equipas abertas a qualquer pessoa';

  @override
  String get yourInvites => 'Os teus convites';

  @override
  String get yourInvitesHint => 'Equipas que te pediram';

  @override
  String get joinWithCode => 'Entrar com código';

  @override
  String get joinWithCodeHint => 'Seis caracteres de um membro';

  @override
  String get topCrewsThisWeek => 'Melhores equipas da semana';

  @override
  String get members => 'Membros';

  @override
  String get repsEach => 'Reps por pessoa';

  @override
  String get rank => 'Lugar';

  @override
  String get weeklyGoal => 'Meta da semana';

  @override
  String get weeklyGoalDone => 'Meta da semana batida';

  @override
  String goalRemaining(String reps, String days) {
    return 'Faltam $reps reps · $days dias';
  }

  @override
  String get goalDoneHint =>
      'Toda a gente recebe o emblema quando a semana fechar.';

  @override
  String get startCrewWar => 'Começar uma guerra de equipas';

  @override
  String get startCrewWarHint =>
      'Sete dias, as duas equipas a contar. Ganha quem fizer mais reps por pessoa.';

  @override
  String get whoIsPulling => 'Quem sustenta a equipa';

  @override
  String get thisWeek => 'esta semana';

  @override
  String get inviteLifters => 'Convidar atletas';

  @override
  String get referralCode => 'Código de convite';

  @override
  String get inviteLink => 'Ligação de convite';

  @override
  String get leaveCrew => 'Sair da equipa';

  @override
  String get owner => 'Dono';

  @override
  String get crewTable => 'Tabela de equipas';

  @override
  String get repsPerMember => 'reps por membro';

  @override
  String seasonResets(String days) {
    return 'Reinicia em $days dias — toda a gente começa igual';
  }

  @override
  String get rankingExplained =>
      'As equipas são ordenadas por reps por membro, não pelo total — senão a maior ganha só pelo tamanho.';

  @override
  String get leaderboard => 'Classificação';

  @override
  String get global => 'Global';

  @override
  String get myCountry => 'O meu país';

  @override
  String yourFriends(String count) {
    return 'Os teus amigos ($count)';
  }

  @override
  String get challenge => 'Desafiar';

  @override
  String get notifications => 'Notificações';

  @override
  String get pickMovement => 'Escolhe um movimento';

  @override
  String get anyExercise => 'Qualquer exercício';

  @override
  String get anyExerciseHint =>
      'Começa a tua série: o movimento é reconhecido durante a execução';

  @override
  String get start => 'Começar';

  @override
  String get finish => 'Terminar';

  @override
  String get reps => 'reps';

  @override
  String get secondsHeld => 'segundos aguentados';

  @override
  String get learningMovement =>
      'A aprender o teu movimento — as tuas reps aparecem já';

  @override
  String get recalibrate => 'Recalibrar';

  @override
  String get resetCount => 'Pôr a zero';

  @override
  String get checksForm => 'verifica a execução';

  @override
  String get counts => 'conta';

  @override
  String get time => 'tempo';

  @override
  String get howManyReally => 'Quantas fizeste mesmo?';

  @override
  String get howManyReallyHint =>
      'Indica a tua própria contagem, não a da aplicação. É a referência com que o contador será medido.';

  @override
  String get appearance => 'Aspeto';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get language => 'Idioma';

  @override
  String get units => 'Unidades';

  @override
  String get weight => 'Peso';

  @override
  String get notificationsSection => 'Notificações';

  @override
  String get privacy => 'Privacidade';

  @override
  String get matches => 'Duelos';

  @override
  String get data => 'Dados';

  @override
  String get about => 'Sobre';

  @override
  String get dangerZone => 'Zona de risco';

  @override
  String get themeSystem => 'Como o dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get openCrews => 'Equipas abertas';

  @override
  String get openCrewsHint =>
      'Estas deixam entrar qualquer um. Escolhe uma e estás dentro.';

  @override
  String get yourInvitesSubtitle => 'Equipas que te pediram pelo nome.';

  @override
  String get pickOpponent => 'Escolhe o teu adversário';

  @override
  String get accept => 'Aceitar';

  @override
  String get join => 'Entrar';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Ligação de convite copiada';

  @override
  String season(String name) {
    return 'Época $name';
  }

  @override
  String challengeSent(String name) {
    return 'Desafio enviado a $name';
  }

  @override
  String get inviteFriendPrivate => 'Convida um amigo para um duelo privado';

  @override
  String get joinWithCodePaste =>
      'Cola os seis caracteres que um membro te enviou.';

  @override
  String get enterTheCode => 'Escreve o código de 6 caracteres';

  @override
  String get followingDevice => 'Neste momento segue o teu dispositivo';

  @override
  String get weightUnitTitle => 'Unidade de peso';

  @override
  String get heightUnitTitle => 'Unidade de altura';

  @override
  String get unitKg => 'Quilogramas (kg)';

  @override
  String get unitLb => 'Libras (lb)';

  @override
  String get unitCm => 'Centímetros (cm)';

  @override
  String get unitFt => 'Pés e polegadas';

  @override
  String get visEveryone => 'Toda a gente';

  @override
  String get visFriends => 'Só amigos';

  @override
  String get visNobody => 'Ninguém';

  @override
  String get visEveryoneHint => 'Qualquer um pode abrir o teu perfil';

  @override
  String get visFriendsHint => 'Só quem já adicionaste';

  @override
  String get visNobodyHint => 'O teu perfil fica privado';

  @override
  String get matchInvites => 'Convites para duelos';

  @override
  String get matchResults => 'Resultados dos duelos';

  @override
  String get friendRequestsLabel => 'Pedidos de amizade';

  @override
  String get crewActivity => 'Atividade da equipa';

  @override
  String get rankChanges => 'Mudanças de ranque';

  @override
  String get weeklySummary => 'Resumo semanal';

  @override
  String get soundLabel => 'Som';

  @override
  String get vibration => 'Vibração';

  @override
  String get whoCanSeeProfile => 'Quem pode ver o meu perfil';

  @override
  String get profileVisibility => 'Visibilidade do perfil';

  @override
  String get showOnLeaderboards => 'Mostrar-me nas classificações';

  @override
  String get allowMatchInvites => 'Permitir convites para duelos';

  @override
  String get allowFriendRequests => 'Permitir pedidos de amizade';

  @override
  String get showHeightWeight => 'Mostrar altura e peso';

  @override
  String get showHeightWeightHint =>
      'Desligado, as tuas medidas ficam só para ti';

  @override
  String get autoAcceptFriends => 'Aceitar automaticamente de amigos';

  @override
  String get restTimerBetweenSets => 'Cronómetro de descanso entre séries';

  @override
  String get exportData => 'Exportar os meus dados';

  @override
  String get clearCache => 'Limpar cache';

  @override
  String get cacheCleared => 'Cache limpa';

  @override
  String get version => 'Versão';

  @override
  String get rateApp => 'Avaliar o OUTREPD';

  @override
  String get contactSupport => 'Contactar o suporte';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get openSourceLicences => 'Licenças de código aberto';

  @override
  String get resetProgress => 'Repor o meu progresso';

  @override
  String get resetProgressTitle => 'Repor o teu progresso?';

  @override
  String get resetProgressBody =>
      'Ranque, PL e histórico voltam a zero. Isto não dá para desfazer.';

  @override
  String get actionReset => 'Repor';

  @override
  String get deleteAccount => 'Apagar conta';

  @override
  String get deleteAccountTitle => 'Apagar a tua conta?';

  @override
  String get deleteAccountBody =>
      'O teu perfil, as equipas e todos os duelos são removidos de vez.';

  @override
  String get actionDelete => 'Apagar';

  @override
  String get needsServer =>
      'Esta funcionalidade precisa de um servidor e ainda não está ligada';

  @override
  String get getStarted => 'Começar';

  @override
  String get skipToApp => 'Ir direto para a app';

  @override
  String get achievements => 'Conquistas';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get roadTitle => 'Caminho para a Lenda';

  @override
  String get allTiers => 'Todos os ranques';

  @override
  String get topTier => 'Ranque máximo';

  @override
  String lpToGo(String lp) {
    return '$lp PL';
  }

  @override
  String get unlockedEverything => 'Já desbloqueaste tudo';

  @override
  String unlocksAt(String tier) {
    return 'Desbloqueia em $tier';
  }

  @override
  String get matchedSameGroup =>
      'Vais ser emparelhado com alguém a treinar o mesmo grupo.';

  @override
  String get roomFriendly =>
      'Os duelos de sala são amigáveis — não afetam o teu ranque.';

  @override
  String get createRoom => 'Criar uma sala';

  @override
  String get enterCode => 'ESCREVE O CÓDIGO';

  @override
  String get joinRoom => 'Entrar na sala';

  @override
  String get shareThisCode => 'Partilha este código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get pickMuscleAndStart => 'Escolhe o músculo e começa';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Pedra';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get tierSilver => 'Prata';

  @override
  String get tierGold => 'Ouro';

  @override
  String get tierPlatinum => 'Platina';

  @override
  String get tierDiamond => 'Diamante';

  @override
  String get tierMaster => 'Mestre';

  @override
  String get tierMythic => 'Mítico';

  @override
  String get tierLegend => 'Lenda';

  @override
  String get rewardStone => 'Moldura de pedra';

  @override
  String get rewardBronze => 'Emblema de bronze';

  @override
  String get rewardSilver => 'Emblema de prata';

  @override
  String get rewardGold => 'Emblema de ouro';

  @override
  String get rewardPlatinum => 'Emblema de platina';

  @override
  String get rewardDiamond => 'Emblema de diamante';

  @override
  String get rewardMaster => 'Emblema de mestre';

  @override
  String get rewardMythic => 'Emblema mítico';

  @override
  String get rewardLegend => 'Emblema de lenda';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'pés';

  @override
  String winLoss(String w, String l) {
    return '${w}V ${l}D';
  }

  @override
  String get yearsSuffix => 'anos';

  @override
  String get yourCrew => 'A tua equipa';

  @override
  String get crewName => 'Nome da equipa';

  @override
  String get motto => 'Lema';

  @override
  String get mottoHint => 'O que representa esta equipa?';

  @override
  String get country => 'País';

  @override
  String get whoCanJoin => 'Quem pode entrar';

  @override
  String get minimumRank => 'Ranque mínimo';

  @override
  String get anyone => 'Qualquer pessoa';

  @override
  String get emblem => 'Emblema';

  @override
  String get colour => 'Cor';

  @override
  String get createCrewButton => 'Criar equipa';

  @override
  String get ownerNote => 'Serás o dono. Uma equipa comporta até 20 atletas.';

  @override
  String get searchCountries => 'Procurar países';

  @override
  String get noCountryMatch => 'Nenhum país corresponde';

  @override
  String get nameTooShort => 'Dá à equipa um nome com pelo menos 3 caracteres';

  @override
  String get privOpen => 'Aberta';

  @override
  String get privRequest => 'Pedido de entrada';

  @override
  String get privInviteOnly => 'Apenas por convite';

  @override
  String get privOpenHint => 'Quem tiver o código entra de imediato';

  @override
  String get privRequestHint => 'A pessoa pede e um responsável aprova';

  @override
  String get privInviteOnlyHint => 'Só se entra por convite direto';

  @override
  String get embStrength => 'Força';

  @override
  String get embCombat => 'Combate';

  @override
  String get embBeasts => 'Feras';

  @override
  String get embElements => 'Elementos';

  @override
  String get embHonours => 'Honras';

  @override
  String get embSymbols => 'Símbolos';

  @override
  String get ob1Title => 'Transforma cada treino\nnum duelo';

  @override
  String get ob1Body =>
      'Regista o teu treino e enfrenta quem trabalha o mesmo grupo muscular.';

  @override
  String get ob2Title => 'Desafia os teus\namigos';

  @override
  String get ob2Body =>
      'Envia um convite privado e resolve quem treina mais a sério.';

  @override
  String get ob3Title => 'Sobe de ranque';

  @override
  String get ob3Body => 'Cada vitória dá PL. Sobe da Pedra até à Lenda.';

  @override
  String get ob4Title => 'O esforço sozinho\né difícil';

  @override
  String get ob4Body =>
      'Treinar sem ninguém a ver torna fácil encurtar a última série.';

  @override
  String get ob5Title => 'Torna-te uma\nLenda';

  @override
  String get ob5Body => 'A consistência acumula-se. Aparece, supera, sobe.';

  @override
  String get letsGo => 'Vamos';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get ttl_first_blood => 'Primeiro Sangue';

  @override
  String get tdesc_first_blood => 'Termina o teu primeiro duelo';

  @override
  String get ttl_found_footing => 'Pé Firme';

  @override
  String get tdesc_found_footing => 'Termina cinco duelos';

  @override
  String get ttl_regular => 'Habitual';

  @override
  String get tdesc_regular => 'Vinte duelos';

  @override
  String get ttl_fifty => 'Os Cinquenta';

  @override
  String get tdesc_fifty => 'Cinquenta duelos';

  @override
  String get ttl_century => 'Centenário';

  @override
  String get tdesc_century => 'Cem duelos';

  @override
  String get ttl_veteran => 'Veterano';

  @override
  String get tdesc_veteran => 'Duzentos e cinquenta duelos';

  @override
  String get ttl_thousand_matches => 'Velha Guarda';

  @override
  String get tdesc_thousand_matches => 'Mil duelos';

  @override
  String get ttl_first_win => 'Vencedor';

  @override
  String get tdesc_first_win => 'Ganha um duelo';

  @override
  String get ttl_on_a_roll => 'Em Série';

  @override
  String get tdesc_on_a_roll => 'Ganha três seguidos';

  @override
  String get ttl_five_straight => 'Cinco Seguidos';

  @override
  String get tdesc_five_straight => 'Ganha cinco seguidos';

  @override
  String get ttl_unstoppable => 'Imparável';

  @override
  String get tdesc_unstoppable => 'Ganha dez seguidos';

  @override
  String get ttl_untouchable => 'Intocável';

  @override
  String get tdesc_untouchable => 'Ganha vinte seguidos';

  @override
  String get ttl_giant_slayer => 'Mata-Gigantes';

  @override
  String get tdesc_giant_slayer => 'Vence alguém dois ranques acima';

  @override
  String get ttl_comeback => 'Reviravolta';

  @override
  String get tdesc_comeback => 'Ganha logo após três derrotas';

  @override
  String get ttl_nemesis => 'Nêmesis';

  @override
  String get tdesc_nemesis => 'Vence o mesmo atleta cinco vezes';

  @override
  String get ttl_hundred_reps => 'Arrancada';

  @override
  String get tdesc_hundred_reps => 'Cem repetições contadas';

  @override
  String get ttl_five_hundred => 'Aquecido';

  @override
  String get tdesc_five_hundred => 'Quinhentas repetições contadas';

  @override
  String get ttl_the_machine => 'A Máquina';

  @override
  String get tdesc_the_machine => 'Mil repetições contadas';

  @override
  String get ttl_five_thousand => 'Implacável';

  @override
  String get tdesc_five_thousand => 'Cinco mil repetições contadas';

  @override
  String get ttl_ten_thousand => 'Dez Mil';

  @override
  String get tdesc_ten_thousand => 'Dez mil repetições contadas';

  @override
  String get ttl_fifty_thousand => 'Para Além da Conta';

  @override
  String get tdesc_fifty_thousand => 'Cinquenta mil repetições contadas';

  @override
  String get ttl_first_tonne => 'Uma Tonelada';

  @override
  String get tdesc_first_tonne => 'Move mil quilos no total';

  @override
  String get ttl_ten_tonnes => 'Dez Toneladas';

  @override
  String get tdesc_ten_tonnes => 'Move dez mil quilos';

  @override
  String get ttl_six_figures => 'Seis Dígitos';

  @override
  String get tdesc_six_figures => 'Move cem mil quilos';

  @override
  String get ttl_half_million => 'Meio Milhão';

  @override
  String get tdesc_half_million => 'Move quinhentos mil quilos';

  @override
  String get ttl_million_kg => 'Clube do Milhão';

  @override
  String get tdesc_million_kg => 'Move um milhão de quilos';

  @override
  String get ttl_two_days => 'De Volta';

  @override
  String get tdesc_two_days => 'Treina dois dias seguidos';

  @override
  String get ttl_no_days_off => 'Sem Folgas';

  @override
  String get tdesc_no_days_off => 'Treina sete dias seguidos';

  @override
  String get ttl_fortnight => 'Quinzena';

  @override
  String get tdesc_fortnight => 'Uma sequência de catorze dias';

  @override
  String get ttl_unbroken => 'Inquebrável';

  @override
  String get tdesc_unbroken => 'Uma sequência de trinta dias';

  @override
  String get ttl_sixty_days => 'Hábito';

  @override
  String get tdesc_sixty_days => 'Uma sequência de sessenta dias';

  @override
  String get ttl_hundred_days => 'Cem Dias';

  @override
  String get tdesc_hundred_days => 'Uma sequência de cem dias';

  @override
  String get ttl_year_round => 'O Ano Inteiro';

  @override
  String get tdesc_year_round =>
      'Uma sequência de trezentos e sessenta e cinco dias';

  @override
  String get ttl_perfect_week => 'Semana Perfeita';

  @override
  String get tdesc_perfect_week => 'Treina todos os dias de uma semana';

  @override
  String get ttl_perfect_month => 'Mês Perfeito';

  @override
  String get tdesc_perfect_month => 'Quatro semanas perfeitas';

  @override
  String get ttl_bronze_tier => 'Fora da Pedra';

  @override
  String get tdesc_bronze_tier => 'Alcança Bronze';

  @override
  String get ttl_silver_tier => 'Prateado';

  @override
  String get tdesc_silver_tier => 'Alcança Prata';

  @override
  String get ttl_golden_era => 'Era Dourada';

  @override
  String get tdesc_golden_era => 'Alcança Ouro';

  @override
  String get ttl_platinum_tier => 'Platina';

  @override
  String get tdesc_platinum_tier => 'Alcança Platina';

  @override
  String get ttl_diamond_tier => 'Mãos de Diamante';

  @override
  String get tdesc_diamond_tier => 'Alcança Diamante';

  @override
  String get ttl_master_tier => 'Mestre';

  @override
  String get tdesc_master_tier => 'Alcança Mestre';

  @override
  String get ttl_mythic_tier => 'Mítico';

  @override
  String get tdesc_mythic_tier => 'Alcança Mítico';

  @override
  String get ttl_legend_tier => 'Lenda';

  @override
  String get tdesc_legend_tier => 'Alcança Lenda';

  @override
  String get ttl_clean_hands => 'Mãos Limpas';

  @override
  String get tdesc_clean_hands =>
      'Uma série inteira com todas as repetições contadas';

  @override
  String get ttl_spotless => 'Impecável';

  @override
  String get tdesc_spotless => 'Dez séries limpas';

  @override
  String get ttl_textbook => 'Manual';

  @override
  String get tdesc_textbook => 'Cinquenta séries limpas';

  @override
  String get ttl_iron_hold => 'Pega de Ferro';

  @override
  String get tdesc_iron_hold => 'Aguenta uma prancha dois minutos';

  @override
  String get ttl_statue => 'Estátua';

  @override
  String get tdesc_statue => 'Aguenta uma prancha cinco minutos';

  @override
  String get ttl_all_rounder => 'Polivalente';

  @override
  String get tdesc_all_rounder => 'Conta cinco exercícios diferentes';

  @override
  String get ttl_explorer => 'Explorador';

  @override
  String get tdesc_explorer => 'Conta quinze exercícios diferentes';

  @override
  String get ttl_encyclopedia => 'Enciclopédia';

  @override
  String get tdesc_encyclopedia => 'Conta quarenta exercícios diferentes';

  @override
  String get ttl_early_bird => 'Turno da Manhã';

  @override
  String get tdesc_early_bird => 'Dez sessões antes das sete';

  @override
  String get ttl_sunrise_club => 'Clube do Amanhecer';

  @override
  String get tdesc_sunrise_club => 'Cinquenta sessões antes das sete';

  @override
  String get ttl_night_owl => 'Turno da Noite';

  @override
  String get tdesc_night_owl => 'Dez sessões depois das dez';

  @override
  String get ttl_graveyard => 'Turno da Madrugada';

  @override
  String get tdesc_graveyard => 'Cinquenta sessões depois das dez';

  @override
  String get ttl_joined_up => 'Integrado';

  @override
  String get tdesc_joined_up => 'Pertence a uma equipa';

  @override
  String get ttl_backbone => 'Espinha Dorsal';

  @override
  String get tdesc_backbone => 'Lidera a tua equipa quatro semanas seguidas';

  @override
  String get ttl_cornerstone => 'Pedra Angular';

  @override
  String get tdesc_cornerstone => 'Lidera a tua equipa doze semanas seguidas';

  @override
  String get ttl_not_alone => 'Não Estás Só';

  @override
  String get tdesc_not_alone => 'Adiciona o teu primeiro amigo';

  @override
  String get ttl_well_connected => 'Bem Relacionado';

  @override
  String get tdesc_well_connected => 'Dez amigos';

  @override
  String get ttl_the_gym_knows => 'O Ginásio Conhece-te';

  @override
  String get tdesc_the_gym_knows => 'Cinquenta amigos';

  @override
  String get finish2 => 'Terminar';

  @override
  String get qExperience => 'Que experiência tens\na treinar?';

  @override
  String get expBeginner => 'Iniciante – Já experimentei';

  @override
  String get expIntermediate => 'Intermédio – Treino com regularidade';

  @override
  String get expAdvanced => 'Avançado – Anos de experiência';

  @override
  String get qGoal => 'Qual é o teu principal\nobjetivo?';

  @override
  String get goalStronger => 'Ficar mais forte';

  @override
  String get goalConsistent => 'Ser mais consistente';

  @override
  String get goalLean => 'Perder peso e definir';

  @override
  String get goalMass => 'Ganhar massa muscular';

  @override
  String get aboutYou => 'Este caminho é todo sobre ti...';

  @override
  String get qThinkAbout => 'Com que frequência pensas\nem entrar em forma?';

  @override
  String get freqNever => 'Nunca';

  @override
  String get freqSometimes => 'Às vezes';

  @override
  String get freqOften => 'Muitas vezes';

  @override
  String get freqAllTime => 'A toda a hora';

  @override
  String get qEnergy => 'Como está a tua energia\ndurante os treinos?';

  @override
  String get energyLow => 'Baixa, sinto-me esgotado o dia todo';

  @override
  String get energyDrops => 'O desempenho cai a meio do treino';

  @override
  String get energyHard => 'Custa aguentar a última série';

  @override
  String get energyHigh => 'Alta e estável do início ao fim';

  @override
  String get stProgress => 'Às vezes é difícil notar progresso quando treino';

  @override
  String get stEffortTitle => 'O esforço que ninguém vê\né fácil de largar';

  @override
  String get stEffortBody =>
      'Quando não há ninguém a quem provar nada, o progresso parece lento e o esforço inútil';

  @override
  String get stAloneTitle => 'Treinar sozinho\né aborrecido';

  @override
  String get stAloneBody =>
      'Ninguém está a ver. Ninguém está a contar. É fácil saltar uma repetição, ou a série inteira';

  @override
  String get qName => 'Como te devemos\nchamar?';

  @override
  String get nameHint => 'Pelo menos 3 caracteres. É o que os rivais vão ver.';

  @override
  String get basicInfo => 'Boa! Vamos aos\ndados básicos';

  @override
  String get qAge => 'Que idade tens?';

  @override
  String get qWeight => 'Qual é o teu\npeso atual?';

  @override
  String get weightWhy =>
      'O peso corporal é essencial para calcular o teu ranque.';

  @override
  String get privateNote =>
      'Os teus dados são privados e não serão partilhados com ninguém.';

  @override
  String get qHeight => 'Qual é a tua altura?';

  @override
  String get qRelate => 'Identificas-te com\na frase abaixo?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get grindTitle => 'O esforço sabe diferente\ncom um rival';

  @override
  String get grindBody =>
      'Cada duelo põe-te frente a um adversário real: faz o trabalho e prova quem treinou mais.';

  @override
  String get allSet => 'Está tudo pronto!';

  @override
  String welcomeLifter(String name) {
    return 'Bem-vindo, $name. Hora de encontrar o teu primeiro rival.';
  }

  @override
  String get lifter => 'atleta';

  @override
  String get enterApp => 'Entrar no OUTREPD';

  @override
  String get commitTitle =>
      'Agora vamos assumir um compromisso\ncom o teu percurso';

  @override
  String get holdLogo =>
      'Mantém o logótipo premido para confirmar que estás pronto';

  @override
  String get expNone => 'Nunca treinei';

  @override
  String get iAm => 'Eu sou...';

  @override
  String get finishMatchQ => 'Terminar o duelo?';

  @override
  String get finishMatchBody =>
      'O teu volume fica fixado e será comparado com o do teu adversário.';

  @override
  String get keepGoing => 'Continuar';

  @override
  String get forfeitQ => 'Desistir do duelo?';

  @override
  String get forfeitBody => 'Vais perder PL se saíres agora.';

  @override
  String get stay => 'Ficar';

  @override
  String get forfeit => 'Desistir';

  @override
  String get pickExercises => 'Escolhe os exercícios que vais treinar';

  @override
  String matchingWith(String muscle) {
    return 'À procura de alguém do teu ranque · $muscle';
  }

  @override
  String get getReady => 'PREPARA-TE';

  @override
  String get timeLeft => 'TEMPO RESTANTE';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit de volume total';
  }

  @override
  String get finishMatch => 'TERMINAR DUELO';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'REPS';

  @override
  String get addSet => 'ADICIONAR SÉRIE';

  @override
  String get matchComplete => 'DUELO CONCLUÍDO';

  @override
  String get you => 'TU';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'VOLTAR AO INÍCIO';

  @override
  String get mgChest => 'Peito';

  @override
  String get mgBack => 'Costas';

  @override
  String get mgLegs => 'Pernas';

  @override
  String get mgShoulders => 'Ombros';

  @override
  String get mgArms => 'Braços';

  @override
  String get mgCore => 'Core';

  @override
  String get achRivalry => 'Rivalidade';

  @override
  String get achRivalryHint => 'Vence o mesmo adversário 3 vezes';

  @override
  String get nWonTitle => 'Ganhaste!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Venceste $name no dia de $muscle';
  }

  @override
  String get nFriendTitle => 'Novo pedido de amizade';

  @override
  String nFriendBody(String name) {
    return '$name quer ligar-se a ti';
  }

  @override
  String get nAchTitle => 'Conquista desbloqueada';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Subiste de ranque!';

  @override
  String nRankBody(String rank) {
    return 'Chegaste a $rank';
  }

  @override
  String get nameTooShortInline =>
      'Escolhe um nome com pelo menos 3 caracteres';

  @override
  String get whyName => 'Os rivais vão vê-lo ao lado de cada resultado';

  @override
  String get whyExperience => 'Emparelhamos-te com gente do teu nível';

  @override
  String get whyGoal => 'Daqui saem os teus primeiros exercícios sugeridos';

  @override
  String get whyAge =>
      'A idade influencia os padrões de força com que és comparado';

  @override
  String get whyWeight =>
      'O ranque compara as cargas em relação ao peso corporal, não em quilos brutos';

  @override
  String get whyHeight => 'Usada com o teu peso para definir padrões justos';

  @override
  String get whyHabits => 'Define os lembretes e a meta semanal que sugerimos';

  @override
  String get transitionPartOfIt =>
      '...então vamos garantir que fazes mesmo parte dela.';

  @override
  String get male => 'Homem';

  @override
  String get female => 'Mulher';

  @override
  String get usernamePlaceholder => 'nome';

  @override
  String get stRoutine =>
      'Não sei que parte do corpo precisa mesmo de trabalho, por isso repito quase sempre a mesma rotina';

  @override
  String get shortIn => 'pol';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String daysAgo(String n) {
    return 'há $n dias';
  }

  @override
  String weeksAgo(String n) {
    return 'há $n semanas';
  }

  @override
  String membersCount(String n) {
    return '$n membros';
  }

  @override
  String eachCount(String n) {
    return '$n por pessoa';
  }

  @override
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get countWithCamera => 'Contar com a câmara';

  @override
  String get youWin => 'GANHASTE!';

  @override
  String get defeated => 'DERROTA';

  @override
  String get fillWholeNumbers => 'Preenche os três com números inteiros';

  @override
  String heightRange(String min, String max, String unit) {
    return 'A altura deve estar entre $min e $max $unit';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'O peso deve estar entre $min e $max $unit';
  }

  @override
  String ageRange(String min, String max) {
    return 'A idade deve estar entre $min e $max';
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
    return 'faltam $n para subir';
  }

  @override
  String get noFriendsTitle => 'Ainda sem amigos';

  @override
  String get noFriendsBody =>
      'Adiciona alguém e podes desafiá-lo para um duelo privado quando quiseres.';

  @override
  String get noMatchesTitle => 'Ainda sem duelos';

  @override
  String get noMatchesBody => 'O primeiro aparece aqui, ganhes ou percas.';

  @override
  String get noNotificationsTitle => 'Nada de novo';

  @override
  String get noNotificationsBody =>
      'Convites, resultados e pedidos de amizade chegam aqui.';

  @override
  String roundDone(String n) {
    return 'Ronda $n concluída';
  }

  @override
  String get bestRoundYet => 'A tua melhor ronda até agora';
}
