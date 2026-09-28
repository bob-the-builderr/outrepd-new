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
  String get tabProfile => 'Perfil';

  @override
  String get challengeFriend => 'Desafiar um amigo';

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
  String get settings => 'Definições';

  @override
  String get accountSection => 'Conta';

  @override
  String get duelSection => 'Duelo';

  @override
  String get hapticsEachRep => 'Vibração a cada repetição';

  @override
  String get showSkeleton => 'Mostrar o esqueleto';

  @override
  String get showSkeletonHint => 'Assim vês que a câmara te deteta';

  @override
  String get manageNotifications => 'Gerir notificações';

  @override
  String switchesOn(String on, String all) {
    return '$on de $all ativadas';
  }

  @override
  String get whoCanChallenge => 'Quem me pode desafiar';

  @override
  String get blockedAccounts => 'Contas bloqueadas';

  @override
  String get reportProblem => 'Reportar um problema';

  @override
  String get onDeviceNote =>
      'A deteção de pose corre neste telemóvel. Nenhum vídeo ou dado de pose é enviado.';

  @override
  String get visibilitySection => 'Visibilidade';

  @override
  String get showMyCountry => 'Mostrar o meu país';

  @override
  String get showMyCountryHint => 'Desligado, sais do quadro do teu país';

  @override
  String get safetySection => 'Segurança';

  @override
  String get socialSection => 'Social';

  @override
  String get noticeRaced => 'Alguém desafiou a minha série';

  @override
  String get noticeRacedHint => 'A única forma de saber que houve um duelo';

  @override
  String get noticeFriendOk => 'O meu pedido foi aceite';

  @override
  String get noticesStoredNote =>
      'Desligar significa que nunca é guardado, não escondido.';

  @override
  String get notSaved => 'Não guardado';

  @override
  String get blockedIntro =>
      'Uma conta bloqueada não te pode desafiar, encontrar nem enviar pedidos. Não é avisada.';

  @override
  String blockedWhen(String when) {
    return 'Bloqueado $when';
  }

  @override
  String get unblock => 'Desbloquear';

  @override
  String get noBlockedTitle => 'Ninguém bloqueado';

  @override
  String get noBlockedBody =>
      'Podes bloquear alguém a partir do perfil ou de um relatório.';

  @override
  String get whatHappened => 'O que aconteceu';

  @override
  String get reasonCheating => 'Batota ou repetições falsas';

  @override
  String get reasonHarassment => 'Assédio ou abuso';

  @override
  String get reasonContent => 'Conteúdo impróprio';

  @override
  String get reasonImpersonation => 'Falsidade de identidade';

  @override
  String get reasonOther => 'Outra coisa';

  @override
  String get addDetails => 'Adicionar detalhes (opcional)';

  @override
  String get alsoBlock => 'Bloquear também esta conta';

  @override
  String get sendReport => 'Enviar relatório';

  @override
  String get reportSent => 'Relatório enviado';

  @override
  String get reportingThisAccount => 'A reportar esta conta';

  @override
  String get exportIntro =>
      'Enviamos por email um ficheiro com tudo o que o servidor tem sobre ti. Costuma demorar um minuto.';

  @override
  String get whatsIncluded => 'O que inclui';

  @override
  String get incProfile => 'O teu perfil e rank';

  @override
  String get incSets => 'Todas as séries e contagens';

  @override
  String get incDuels => 'Histórico de duelos e alterações de LP';

  @override
  String get incFriends => 'Amigos e contas bloqueadas';

  @override
  String get incNotices => 'Notificações que recebeste';

  @override
  String get noLandmarksNote =>
      'Os pontos de pose não estão lá, nem nunca estiveram. A câmara lê-os no teu telemóvel e não são enviados para lado nenhum.';

  @override
  String get sendItTo => 'Enviar para';

  @override
  String get emailHint => 'tu@exemplo.com';

  @override
  String get passwordHint => 'Palavra-passe';

  @override
  String get codeHint => 'Código de verificação';

  @override
  String get createAccountTitle => 'Criar conta';

  @override
  String get createAccountBody =>
      'Adiciona um email e uma palavra-passe para que esta conta não dependa só deste telemóvel.';

  @override
  String get createAccountAction => 'Criar conta';

  @override
  String get signInTitle => 'Iniciar sessão';

  @override
  String get signInBody =>
      'Inicia sessão com o email e a palavra-passe da tua conta.';

  @override
  String get signInAction => 'Iniciar sessão';

  @override
  String get switchToSignIn => 'Já tens conta? Inicia sessão';

  @override
  String get switchToSignUp => 'Novo por aqui? Cria uma conta';

  @override
  String get emailTakenSwitchToSignIn =>
      'Este email já tem uma conta — inicia sessão em vez disso.';

  @override
  String get emailSignUpInvalid =>
      'Verifica o email e a palavra-passe — mínimo seis caracteres.';

  @override
  String get tooManyCodes =>
      'Demasiados códigos enviados — espera alguns minutos e tenta novamente.';

  @override
  String get sendCodeAction => 'Enviar código';

  @override
  String get noAccountForEmail =>
      'Não encontrámos nenhuma conta com esse email.';

  @override
  String get authEntryTagline => 'Empurra. Compete. Sobe de nível.';

  @override
  String get orDivider => 'ou';

  @override
  String get signUpWithEmail => 'Regista-te com email';

  @override
  String get alreadyHaveAccountQuestion => 'Já tens conta?';

  @override
  String get logInAction => 'Iniciar sessão';

  @override
  String get createYourAccountTitle => 'Cria a tua conta';

  @override
  String get createAccountSubtitle => 'Demora menos de um minuto.';

  @override
  String get usernameHint => 'Nome de utilizador';

  @override
  String get usernameLabel => 'Usuário';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get passwordMinLength => 'Pelo menos 8 caracteres';

  @override
  String get logInSubtitle => 'Inicia sessão para manteres o teu rank.';

  @override
  String get forgotPassword => 'Esqueceste-te da palavra-passe?';

  @override
  String resetPasswordSent(String email) {
    return 'Se existir uma conta para $email, um link de reposição está a caminho.';
  }

  @override
  String get checkYourEmailTitle => 'Verifica o teu email';

  @override
  String codeSentTo(String email) {
    return 'Enviámos um código de 6 dígitos para $email.';
  }

  @override
  String get didntGetIt => 'Não recebeste?';

  @override
  String resendInSeconds(String time) {
    return 'Reenviar em $time';
  }

  @override
  String get wrongEmailGoBack => 'Email errado? Voltar';

  @override
  String get usernameTaken => 'Esse nome de utilizador já está em uso.';

  @override
  String get socialLinkFailed =>
      'Não foi possível concluir o início de sessão. Tenta novamente.';

  @override
  String get showLabel => 'Mostrar';

  @override
  String get hideLabel => 'Ocultar';

  @override
  String get resetPasswordTitle => 'Define uma nova palavra-passe';

  @override
  String get resetPasswordBody =>
      'Escolhe uma nova palavra-passe para a tua conta.';

  @override
  String get setPasswordAction => 'Definir palavra-passe';

  @override
  String get wrongEmailOrPassword => 'Email ou palavra-passe incorretos.';

  @override
  String get enterCodeTitle => 'Introduzir código';

  @override
  String codeInstructions(String email) {
    return 'Introduz o código que enviámos para $email.';
  }

  @override
  String get verifyAction => 'Verificar';

  @override
  String get wrongCode => 'Esse código está errado ou expirou.';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get codeResent => 'Enviámos um novo código.';

  @override
  String signedInAs(String email) {
    return 'Sessão iniciada como $email';
  }

  @override
  String get addressNotKept =>
      'O endereço é usado uma vez e não é guardado — esta conta não tem email.';

  @override
  String get requestMyData => 'Enviar os meus dados';

  @override
  String exportSent(String address) {
    return 'Enviado para $address';
  }

  @override
  String get deleteIntro =>
      'Isto apaga tudo permanentemente. Não pode ser desfeito nem restaurado.';

  @override
  String get rankLabel => 'Rank';

  @override
  String get wantCopyFirst => 'Queres uma cópia primeiro?';

  @override
  String get wantCopyBody =>
      'Descarrega os teus dados antes de apagar. Depois disto, desaparecem.';

  @override
  String typeToConfirm(String word) {
    return 'Escreve $word para confirmar';
  }

  @override
  String get deleteWord => 'APAGAR';

  @override
  String get deletePermanently => 'Apagar definitivamente';

  @override
  String get keepMyAccount => 'Manter a minha conta';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get skip => 'Ignorar';

  @override
  String get height => 'Altura';

  @override
  String get yourPicture => 'A tua foto';

  @override
  String get yourPictureHint =>
      'A moldura vem do teu ranque e muda à medida que sobes.';

  @override
  String get couldNotUsePicture => 'Não foi possível usar essa foto';

  @override
  String get couldNotSyncAvatar =>
      'Sua foto foi salva, mas ainda não sincronizou';

  @override
  String get couldNotShareCard => 'Não foi possível compartilhar este cartão';

  @override
  String get couldNotOpenLink => 'Não foi possível abrir esse link';

  @override
  String get couldNotCheckUsername =>
      'Não foi possível verificar esse nome — tente novamente';

  @override
  String get changeUsername => 'Alterar nome de usuário';

  @override
  String get usernameInvalidLength =>
      'Deve ter de 4 a 20 caracteres, apenas letras e números';

  @override
  String get usernameChanged => 'Nome de usuário alterado';

  @override
  String get usernameAlreadyChangedBody =>
      'Já usaste a tua única alteração de nome de utilizador — cada conta recebe exatamente uma.';

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
  String get global => 'Global';

  @override
  String get topPlayers => 'Melhores jogadores';

  @override
  String get yourTier => 'Seu nível';

  @override
  String get challenge => 'Desafiar';

  @override
  String get notifications => 'Notificações';

  @override
  String get start => 'Começar';

  @override
  String get finish => 'Terminar';

  @override
  String get reps => 'reps';

  @override
  String get recalibrate => 'Recalibrar';

  @override
  String get resetCount => 'Pôr a zero';

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
  String get language => 'Idioma';

  @override
  String get units => 'Unidades';

  @override
  String get weight => 'Peso';

  @override
  String get privacy => 'Privacidade';

  @override
  String get data => 'Dados';

  @override
  String get about => 'Sobre';

  @override
  String get themeSystem => 'Como o dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get accept => 'Aceitar';

  @override
  String challengeSent(String name) {
    return 'Desafio enviado a $name';
  }

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
  String get friendRequestsLabel => 'Pedidos de amizade';

  @override
  String get showOnLeaderboards => 'Mostrar-me nas classificações';

  @override
  String get exportData => 'Exportar os meus dados';

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
  String get deleteAccount => 'Apagar conta';

  @override
  String get needsServer =>
      'Esta funcionalidade precisa de um servidor e ainda não está ligada';

  @override
  String get achievements => 'Conquistas';

  @override
  String get roadTitle => 'Caminho para Mestre';

  @override
  String get allTiers => 'Todos os ranques';

  @override
  String get topTier => 'Ranque máximo';

  @override
  String lpToGo(String lp) {
    return '$lp PL';
  }

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
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Ferro';

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
  String get ttl_bronze_tier => 'Fora do Ferro';

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
  String get forfeitQ => 'Desistir do duelo?';

  @override
  String get forfeitBody => 'Vais perder PL se saíres agora.';

  @override
  String get stay => 'Ficar';

  @override
  String get forfeit => 'Desistir';

  @override
  String get getReady => 'PREPARA-TE';

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
  String get nWonTitle => 'Ganhaste!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Venceste $name no dia de $muscle';
  }

  @override
  String get nFriendTitle => 'Novo pedido de amizade';

  @override
  String get nRacedTitle => 'A tua série foi desafiada';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name desafiou a tua série e não chegou lá, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name desafiou a tua série e ganhou, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Pedido de amizade aceite';

  @override
  String nFriendOkBody(String name) {
    return '$name aceitou o teu pedido';
  }

  @override
  String nFriendBody(String name) {
    return '$name quer ligar-se a ti';
  }

  @override
  String get nChallengedTitle => 'Desforra';

  @override
  String nChallengedBody(String name) {
    return '$name quer a desforra';
  }

  @override
  String get challengeSentTitle => 'Desafio enviado';

  @override
  String challengeSentBody(String name) {
    return 'Avisaremos $name. Volta depois de ele/ela competir.';
  }

  @override
  String get challengeNotSentTitle => 'Não foi possível enviar';

  @override
  String get challengeNotSentBody =>
      'Verifica a tua ligação e tenta novamente no separador Match.';

  @override
  String get challengeGoneTitle => 'O desafio já não existe';

  @override
  String get challengeGoneBody => 'Já foi disputado, ou foi retirado.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps repetições registadas';
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
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get lpUnit => 'PL';

  @override
  String get trueCountHint => 'ex.: 12';

  @override
  String get couldNotSaveSession => 'Não foi possível guardar a sessão';

  @override
  String lpOutOf(String total) {
    return '/ $total PL';
  }

  @override
  String get noFriendsTitle => 'Ainda sem amigos';

  @override
  String get noFriendsBody =>
      'Duelar com alguém que você conhece é outra coisa.';

  @override
  String get addFriend => 'Adicionar';

  @override
  String get decline => 'Recusar';

  @override
  String requestSent(String name) {
    return 'Pedido enviado para $name';
  }

  @override
  String nowFriends(String name) {
    return 'Agora você e $name são amigos';
  }

  @override
  String get noOneFound => 'Ninguém usa esse nome';

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
  String get countedThat => 'Contado nesta ronda';

  @override
  String get thatIsRight => 'Está certo';

  @override
  String get useMyCount => 'Usar a minha contagem';

  @override
  String get confirmHint => 'Muda se a câmara se enganou.';

  @override
  String get unsureMovement =>
      'Não tenho a certeza de que foi o movimento certo — confere o número.';

  @override
  String get local => 'Local';

  @override
  String get weekly => 'Weekly';

  @override
  String get seasonTab => 'Season';

  @override
  String get allTime => 'All-time';

  @override
  String get daily => 'Daily';

  @override
  String get noRanksYet => 'No ranks yet';

  @override
  String get noRanksYetBody => 'Play a duel and the board fills in.';

  @override
  String get ranksTitle => 'Ranks';

  @override
  String get totalReps => 'Total reps';

  @override
  String get recent => 'Recent';

  @override
  String wonVs(String name) {
    return 'Won vs $name';
  }

  @override
  String lostVs(String name) {
    return 'Lost vs $name';
  }

  @override
  String hoursAgo(String n) {
    return '${n}h ago';
  }

  @override
  String toNextTier(String n, String tier) {
    return '$n to $tier';
  }

  @override
  String get noMatchesYet => 'No duels yet';

  @override
  String get noMatchesYetBody => 'Your first one shows up here, win or lose.';

  @override
  String get searchByUsername => 'Buscar por nome de usuário';

  @override
  String get incomingRequests => 'Pedidos recebidos';

  @override
  String get noRequestsWaiting => 'Nenhum pedido pendente no momento';

  @override
  String get addFriendAction => 'Adicionar amigo';

  @override
  String get addFriendHint =>
      'Digite o nome de usuário deles, ou o código # do perfil.';

  @override
  String get usernameOrCode => 'Usuário ou código #';

  @override
  String get sendRequest => 'Enviar pedido';

  @override
  String onlineNowCount(String count) {
    return 'Online agora · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Offline · $count';
  }

  @override
  String get invite => 'Convidar';

  @override
  String get headToHeadTitle => 'Confronto direto';

  @override
  String get vsYouCaption => 'contra você';

  @override
  String get h2hYou => 'você';

  @override
  String get h2hThem => 'ele';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}V ${losses}D contra você';
  }

  @override
  String get neverPlayedYou => 'Nunca jogou contra você';

  @override
  String noHistoryWithThem(String username) {
    return 'Você ainda não enfrentou $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Última vez: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Seu melhor contra ele é $reps.';
  }

  @override
  String get viewFullProfile => 'Ver perfil completo';

  @override
  String get moreOptions => 'Mais opções';

  @override
  String get block => 'Bloquear';

  @override
  String get blockRowBody => 'Ele não poderá te desafiar nem ver seu perfil';

  @override
  String get report => 'Denunciar';

  @override
  String get reportRowBody => 'Analisado em até 24 horas';

  @override
  String muteChallenges(String username) {
    return 'Silenciar desafios de $username';
  }

  @override
  String blockedLifter(String username) {
    return '$username bloqueado';
  }

  @override
  String mutedLifter(String username) {
    return '$username silenciado';
  }

  @override
  String get addFriendButton => 'Adicionar amigo';

  @override
  String get alreadyFriends => 'Amigos';

  @override
  String get couldNotLoadProfile => 'Não foi possível carregar este perfil';

  @override
  String get noFriendsMatch => 'Ninguém com esse nome';

  @override
  String get yourClimb => 'Sua escalada';

  @override
  String floorKept(String tier, String rank) {
    return '$tier é seu. Você não cai abaixo de $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count dias seguidos';
  }

  @override
  String get findMatch => 'Procurar partida';

  @override
  String rankedTerms(String seconds) {
    return '$seconds segundos · ranqueada';
  }

  @override
  String get practiceTerms => 'Treinar — sem rank, sem adversário';

  @override
  String get practiceComplete => 'TREINO CONCLUÍDO';

  @override
  String get findPeople => 'Encontrar pessoas';

  @override
  String get noRankYet => 'Ainda sem rank';

  @override
  String placementsForFirstTier(String count) {
    return 'Conclua $count duelos de colocação para ganhar seu primeiro rank.';
  }

  @override
  String get startPlacements => 'Começar colocação';

  @override
  String get unranked => 'Sem rank';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done de $total · $seconds segundos cada';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done de $total · mais $left para o seu rank';
  }

  @override
  String placementsForTier(String count) {
    return 'Conclua $count duelos de colocação para ver seu rank.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done de $total colocações concluídas';
  }

  @override
  String get practiceFirst => 'Treinar primeiro';

  @override
  String get nextPlacement => 'Próxima colocação';

  @override
  String get noConnection => 'Sem conexão';

  @override
  String get practiceOffline => 'Treinar offline';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get youWonPlain => 'Você venceu';

  @override
  String opponentDisconnected(String name) {
    return '$name desconectou';
  }

  @override
  String get forfeitNoMargin => 'Desistência · a diferença não conta';

  @override
  String get findAnotherMatch => 'Procurar outra partida';

  @override
  String get cameraNeededTitle => 'Precisa de acesso à câmera';

  @override
  String get cameraNeededBody =>
      'o outrepd conta suas repetições observando seu corpo se mover. A detecção roda no seu aparelho e nada é enviado.';

  @override
  String get openSettings => 'Abrir ajustes';

  @override
  String get allowCamera => 'Permitir câmera';

  @override
  String get notNow => 'Agora não';

  @override
  String get noCameraTitle => 'Nenhuma câmera';

  @override
  String get noCameraBody =>
      'As repetições são contadas pela câmera, então este aparelho não pode pontuar um duelo. O resto continua funcionando.';

  @override
  String get noConnectionBody =>
      'Você precisa de conexão para duelar. Treinar funciona offline e suas repetições sincronizam depois.';

  @override
  String get getBackInFrame => 'Volte para o enquadramento';

  @override
  String get clockStillRunning =>
      'O relógio continua correndo. Nada está sendo contado.';

  @override
  String get giveUp => 'Desistir';

  @override
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

  @override
  String get lpMovesWithGap =>
      'O LP muda conforme a diferença de repetições — vença por mais, ganhe mais';

  @override
  String get searchingForOpponent => 'Procurando adversário';

  @override
  String get getIntoPosition => 'Fique em posição';

  @override
  String get framingHint => 'Pulsos e tornozelos precisam aparecer';

  @override
  String get goUp => 'Sobe';

  @override
  String get goDown => 'Desce';

  @override
  String get bestSet => 'Melhor série';

  @override
  String get record => 'Histórico';

  @override
  String get last7Days => 'Últimos 7 dias';

  @override
  String repsCount(String count) {
    return '$count reps';
  }

  @override
  String get viewAll => 'Ver tudo';

  @override
  String get shareProfile => 'Compartilhar perfil';

  @override
  String get share => 'Compartilhar';

  @override
  String get duelMeOnOutrepd => 'Desafie-me no outrepd';

  @override
  String get yourRankCard => 'Seu cartão de rank';

  @override
  String get shareStory => 'Story';

  @override
  String get sharePost => 'Post';

  @override
  String get copyLink => 'Copiar';

  @override
  String get linkCopied => 'Link copiado';

  @override
  String get currentRankLabel => 'Rank atual';

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
      'Duelos de flexões. O teu telemóvel conta. Alguém do outro lado também está a contar.';

  @override
  String get obGetStarted => 'Começar';

  @override
  String get obHaveAccount => 'Já tenho conta';

  @override
  String get obHowTitle => 'Três coisas e estás pronto.';

  @override
  String get obHow1 => 'Põe o telemóvel no chão';

  @override
  String get obHow1Body => 'Encosta-o a uma parede, a um metro à tua frente.';

  @override
  String get obHow2 => 'A câmara conta as tuas repetições';

  @override
  String get obHow2Body =>
      'A profundidade de cada uma é verificada. Meias repetições não contam.';

  @override
  String get obHow3 => 'Sessenta segundos contra alguém';

  @override
  String get obHow3Body =>
      'Ganhas e sobes. Perdes e desces. As mesmas regras para todos.';

  @override
  String get obTwoThings => 'Duas coisas rápidas.';

  @override
  String get obAgeQuestion => 'Que idade tens?';

  @override
  String get obUnder16 => 'Menos de 16';

  @override
  String get obOver16 => '16 ou mais';

  @override
  String get obHealthConsent =>
      'Percebo que o outrepd conta repetições e não dá conselhos médicos nem de treino. Paro se alguma coisa doer.';

  @override
  String get obTermsIntro => 'Ao continuares aceitas os';

  @override
  String get obTerms => 'Termos';

  @override
  String get obAnd => 'e a';

  @override
  String get obPrivacy => 'Política de Privacidade';

  @override
  String get obUnder16Blocked =>
      'O outrepd é para maiores de 16. Volta quando lá chegares — as flexões não vão a lado nenhum.';

  @override
  String get obCameraTitle => 'O outrepd precisa da tua câmara';

  @override
  String get obCameraBody =>
      'Segue o movimento do teu corpo para contar. Não há outra forma.';

  @override
  String get obCameraPrivateTitle => 'Nada sai do teu telemóvel';

  @override
  String get obCameraPrivateBody =>
      'O rastreamento do corpo acontece neste aparelho. Nenhum vídeo é salvo ou enviado.';

  @override
  String get obWhyNeeded => 'Porque é preciso?';

  @override
  String get obPlacementTitle => 'Põe o telemóvel no chão';

  @override
  String get obPlacementBody =>
      'Encosta-o a uma parede, cerca de um metro à tua frente.';

  @override
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'corpo inteiro no enquadramento';

  @override
  String get obCheckHandsFeet => 'Mãos e pés visíveis';

  @override
  String get obCheckFacing => 'Virado para o telemóvel, não de lado';

  @override
  String get obCheckLight => 'Luz acesa';

  @override
  String get obImSetUp => 'Está tudo pronto';

  @override
  String get obFramingTitle => 'Põe-te em posição de flexão';

  @override
  String get obFramingShoulders => 'Ombros e ancas';

  @override
  String get obFramingWrists => 'Pulsos';

  @override
  String get obFramingAnkles => 'Tornozelos';

  @override
  String get obLooksGood => 'Está bom';

  @override
  String get obCalibrating => 'A calibrar';

  @override
  String get obOneMoreRep => 'Mais uma para aprender a tua amplitude';

  @override
  String get obCalibrationHint => 'Faz três flexões na tua profundidade normal';

  @override
  String get obCalibrated => 'Calibrado.';

  @override
  String get obCalibratedBody =>
      'O outrepd já conhece a tua amplitude. A profundidade é medida em ti, não num número fixo.';

  @override
  String get obRepsCounted => 'Repetições contadas';

  @override
  String get obAverageDepth => 'Profundidade média';

  @override
  String get obForm => 'Execução';

  @override
  String get obFormClean => 'Limpa';

  @override
  String get obAvailable => 'Disponível';

  @override
  String get obTaken => 'Já usado';

  @override
  String get obPlacementsBody =>
      'Cinco duelos decidem o teu nível inicial. Ainda não conta nada contra ti.';

  @override
  String get obFindFirstOpponent => 'Encontrar o meu primeiro adversário';

  @override
  String get obGotIt => 'Percebi';

  @override
  String get obFormMixed => 'Irregular';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String get counterAccuracy => 'Precisão do contador';

  @override
  String get counterAccuracyCaption => 'O quanto a câmara acerta';

  @override
  String measuredOverSets(String count) {
    return 'Medido em $count séries';
  }

  @override
  String get accExact => 'Exato';

  @override
  String get accWithinOne => '±1 repetição';

  @override
  String get accAverageMiss => 'Erro médio';

  @override
  String get accTendsTo => 'Tende a';

  @override
  String get accCountsHigh => 'contar a mais';

  @override
  String get accCountsLow => 'contar a menos';

  @override
  String get accCountsEven => 'nem a mais nem a menos';

  @override
  String get accWorstMiss => 'Pior erro';

  @override
  String get accNothingYet => 'Ainda nada medido';

  @override
  String get accNothingYetBody =>
      'Sempre que confirmas a contagem depois de um duelo, essa série é comparada com o que disseste. O número aparece aqui.';

  @override
  String accNeedMore(String count) {
    return 'Ainda é cedo. Faltam cerca de $count séries para este número dizer alguma coisa.';
  }

  @override
  String get accRecentSets => 'Séries recentes';

  @override
  String get accCameraSaid => 'Câmara';

  @override
  String get accYouSaid => 'Tu';

  @override
  String get accHowItWorks =>
      'Isto vem de ti, neste telemóvel. Nada é enviado para lado nenhum.';

  @override
  String levelNumber(String n) {
    return 'Nível $n';
  }

  @override
  String get youLostPlain => 'Perdeste';

  @override
  String get rematch => 'Desforra';

  @override
  String get shareAction => 'Partilhar';

  @override
  String get doneAction => 'Concluído';

  @override
  String get continueAction => 'Continuar';

  @override
  String get lpRowWin => 'Vitória';

  @override
  String get lpRowLoss => 'Derrota';

  @override
  String get lpRowOpponent => 'Divisão do adversário';

  @override
  String get lpRowMargin => 'Diferença';

  @override
  String get lpRowDepth => 'Profundidade';

  @override
  String get promotedLabel => 'Subiste';

  @override
  String get highestReached => 'O mais alto que já chegaste';

  @override
  String repsOff(String n) {
    return 'A $n repetições.';
  }

  @override
  String get closestYet => 'O duelo mais renhido até agora.';

  @override
  String repsAhead(String n) {
    return '$n repetições à frente.';
  }

  @override
  String get winnerLabel => 'Vencedor';

  @override
  String get newPersonalBest => 'Novo recorde pessoal';

  @override
  String get cantReachServer =>
      'Não foi possível conectar ao servidor. Verifique sua conexão e tente de novo.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Flexões em $seconds segundos';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Venci $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Perdi para $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Acha que consegue me vencer?';

  @override
  String get usernameNotAllowed => 'Esse nome não é permitido. Tente outro.';

  @override
  String get yourBest => 'Seu recorde';

  @override
  String get theClock => 'O relógio';

  @override
  String get nobodyFreeRaceBest =>
      'Ninguém perto do seu rank está livre agora. Dispute contra o seu recorde. Esta rodada não muda seu rank.';

  @override
  String get nobodyFreeFirstScore =>
      'Ninguém perto do seu rank está livre agora. Marque seu primeiro placar. Esta rodada não muda seu rank.';

  @override
  String bestStillIs(String count) {
    return 'Seu recorde continua $count';
  }

  @override
  String get setInPoolTitle => 'Sua série está na fila';

  @override
  String get setInPoolBody =>
      'O próximo atleta perto do seu rank vai disputar contra ela. Você verá quem venceu em Notificações, e seu rank muda nessa hora.';

  @override
  String get obWhyNeededBody =>
      'Cada repetição é avaliada por quanto seus ombros descem e sobem, e só a câmera consegue ver isso. Sem ela não há contagem, e sem contagem não há duelo. A câmera só fica ligada durante uma série.';

  @override
  String get obWelcomeBack => 'Bem-vindo de volta';
}
