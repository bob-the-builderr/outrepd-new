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
  String lpProgress(int lp, int left) {
    return '$lp / 100 PL · faltam $left para subir';
  }

  @override
  String winStreak(int count) {
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
  String changeNameLeft(int total, int left) {
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
  String titlesAndStreak(int owned, int total, int streak) {
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
  String goalRemaining(int reps, int days) {
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
  String seasonResets(int days) {
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
  String yourFriends(int count) {
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
  String lpToGo(int lp) {
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
  String xOfY(int a, int b) {
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
  String winLoss(int w, int l) {
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
}
